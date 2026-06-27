use crossterm::event::{KeyCode, KeyEvent};
use ratatui::widgets::ListState;
use dotenvy::dotenv;
use std::env;

use crate::annas_archive::{self, Book};

#[derive(Clone, Copy, PartialEq, Eq)]
pub enum SortMode {
    Year,
    Title,
    Author,
    Format,
    Size,
}

impl SortMode {
    pub fn next(self) -> Self {
        match self {
            SortMode::Year => SortMode::Title,
            SortMode::Title => SortMode::Author,
            SortMode::Author => SortMode::Format,
            SortMode::Format => SortMode::Size,
            SortMode::Size => SortMode::Year,
        }
    }
    
    pub fn prev(self) -> Self {
        match self {
            SortMode::Year => SortMode::Size,
            SortMode::Title => SortMode::Year,
            SortMode::Author => SortMode::Title,
            SortMode::Format => SortMode::Author,
            SortMode::Size => SortMode::Format,
        }
    }
}

#[derive(Clone, Copy, PartialEq, Eq)]
pub enum CurrentScreen {
    MainMenu,
    AnnasArchiveKey,
    AnnasArchiveSearch,
    AnnasArchiveSearching,
    AnnasArchiveResults,
    AnnasArchiveDownloading,
    AnnasArchiveDone,
    AnnasArchiveError,
    DatasetGen,
    DatasetGenProcessing,
    DatasetGenDone,
    DatasetGenError,
    LoraTrain,
    ModalAuth,
}

pub struct App {
    pub current_screen: CurrentScreen,
    pub should_quit: bool,
    
    // Main Menu
    pub main_menu_state: ListState,
    pub main_menu_items: Vec<&'static str>,

    // Anna's Archive
    pub api_key_input: String,
    pub search_input: String,
    pub search_results: Vec<Book>,
    pub search_results_state: ListState,
    pub sort_mode: SortMode,
    pub selected_book: Option<Book>,
    pub download_path: Option<String>,
    pub error_message: Option<String>,
    
    pub pending_search: bool,
    pub pending_download: bool,
    pub search_progress: f64,
    pub download_progress: f64,

    // Dataset Gen
    pub dataset_files: Vec<String>,
    pub dataset_list_state: ListState,
    pub dataset_path_input: String,
    pub is_inputting_path: bool,
    pub pending_dataset_gen: bool,
    pub dataset_progress: f64,
    pub dataset_logs: Vec<String>,
    pub dataset_logs_state: ListState,
    pub dataset_error_scroll: u16,
}

impl Default for App {
    fn default() -> Self {
        Self::new()
    }
}

impl App {
    pub fn new() -> Self {
        let mut main_menu_state = ListState::default();
        main_menu_state.select(Some(0));

        Self {
            current_screen: CurrentScreen::MainMenu,
            should_quit: false,
            
            main_menu_state,
            main_menu_items: vec![
                "Search & Download Book (Anna's Archive)",
                "Create Dataset from PDF/EPUB",
                "Create LoRA Adapter (Modal)",
                "Authenticate with Modal",
                "Update API Keys",
                "Exit",
            ],

            api_key_input: String::new(),
            search_input: String::new(),
            search_results: Vec::new(),
            search_results_state: ListState::default(),
            sort_mode: SortMode::Year,
            selected_book: None,
            download_path: None,
            error_message: None,
            pending_search: false,
            pending_download: false,
            search_progress: 0.0,
            download_progress: 0.0,
            dataset_files: Vec::new(),
            dataset_list_state: ListState::default(),
            dataset_path_input: String::new(),
            is_inputting_path: false,
            pending_dataset_gen: false,
            dataset_progress: 0.0,
            dataset_logs: Vec::new(),
            dataset_logs_state: ListState::default(),
            dataset_error_scroll: 0,
        }
    }

    pub fn quit(&mut self) {
        self.should_quit = true;
    }

    pub fn handle_key_event(&mut self, key_event: KeyEvent) {
        match self.current_screen {
            CurrentScreen::MainMenu => self.handle_main_menu_key(key_event),
            CurrentScreen::AnnasArchiveKey => self.handle_annas_key_input(key_event),
            CurrentScreen::DatasetGen => self.handle_dataset_gen_key(key_event),
            CurrentScreen::DatasetGenProcessing => {
                match key_event.code {
                    KeyCode::Up => {
                        let i = match self.dataset_logs_state.selected() {
                            Some(i) => if i == 0 { 0 } else { i - 1 },
                            None => self.dataset_logs.len().saturating_sub(1),
                        };
                        self.dataset_logs_state.select(Some(i));
                    }
                    KeyCode::Down => {
                        let i = match self.dataset_logs_state.selected() {
                            Some(i) => if i >= self.dataset_logs.len().saturating_sub(1) { self.dataset_logs.len().saturating_sub(1) } else { i + 1 },
                            None => 0,
                        };
                        self.dataset_logs_state.select(Some(i));
                    }
                    KeyCode::Char('q') => {
                        self.should_quit = true;
                    }
                    KeyCode::Esc => {
                        self.current_screen = CurrentScreen::DatasetGen;
                    }
                    KeyCode::Char('c') if key_event.modifiers.contains(crossterm::event::KeyModifiers::CONTROL) => {
                        self.should_quit = true;
                    }
                    _ => {}
                }
            }
            CurrentScreen::DatasetGenDone => {
                if key_event.code == KeyCode::Enter {
                    self.current_screen = CurrentScreen::MainMenu;
                }
            }
            CurrentScreen::DatasetGenError => {
                match key_event.code {
                    KeyCode::Enter | KeyCode::Esc => {
                        self.current_screen = CurrentScreen::DatasetGen;
                        self.dataset_error_scroll = 0;
                    }
                    KeyCode::Up => {
                        self.dataset_error_scroll = self.dataset_error_scroll.saturating_sub(1);
                    }
                    KeyCode::Down => {
                        self.dataset_error_scroll = self.dataset_error_scroll.saturating_add(1);
                    }
                    _ => {}
                }
            }
            CurrentScreen::AnnasArchiveSearch => self.handle_annas_search_input(key_event),
            CurrentScreen::AnnasArchiveResults => self.handle_annas_results_key(key_event),
            CurrentScreen::AnnasArchiveSearching | CurrentScreen::AnnasArchiveDownloading => {
                // Downloading blocks until done for now, or we can just let UI poll
            }
            CurrentScreen::AnnasArchiveDone | CurrentScreen::AnnasArchiveError | CurrentScreen::LoraTrain | CurrentScreen::ModalAuth => {
                if key_event.code == KeyCode::Enter || key_event.code == KeyCode::Esc {
                    self.current_screen = CurrentScreen::MainMenu;
                }
            }
        }
    }

    fn handle_main_menu_key(&mut self, key_event: KeyEvent) {
        match key_event.code {
            KeyCode::Char('q') | KeyCode::Esc => self.quit(),
            KeyCode::Up => {
                if let Some(selected) = self.main_menu_state.selected() {
                    let next = if selected > 0 { selected - 1 } else { self.main_menu_items.len() - 1 };
                    self.main_menu_state.select(Some(next));
                }
            }
            KeyCode::Down => {
                if let Some(selected) = self.main_menu_state.selected() {
                    let next = if selected < self.main_menu_items.len() - 1 { selected + 1 } else { 0 };
                    self.main_menu_state.select(Some(next));
                }
            }
            KeyCode::Enter => {
                if let Some(selected) = self.main_menu_state.selected() {
                    match selected {
                        0 => {
                            self.init_annas_archive();
                        }
                        1 => {
                            self.refresh_dataset_files();
                            self.current_screen = CurrentScreen::DatasetGen;
                        }
                        2 => self.current_screen = CurrentScreen::LoraTrain,
                        3 => self.current_screen = CurrentScreen::ModalAuth,
                        4 => {
                            // Update API Keys
                            dotenv().ok();
                            self.api_key_input = env::var("ANNAS_ARCHIVE_KEY").unwrap_or_default();
                            self.current_screen = CurrentScreen::AnnasArchiveKey;
                        }
                        5 => self.quit(),
                        _ => {}
                    }
                }
            }
            _ => {}
        }
    }

    fn init_annas_archive(&mut self) {
        dotenv().ok();
        if let Ok(key) = env::var("ANNAS_ARCHIVE_KEY") {
            if !key.is_empty() && key != "your_api_key_here" {
                self.api_key_input = key;
                self.current_screen = CurrentScreen::AnnasArchiveSearch;
                return;
            }
        }
        self.current_screen = CurrentScreen::AnnasArchiveKey;
    }

    fn handle_annas_key_input(&mut self, key_event: KeyEvent) {
        match key_event.code {
            KeyCode::Esc => self.current_screen = CurrentScreen::MainMenu,
            KeyCode::Enter => {
                if !self.api_key_input.is_empty() {
                    // Save this to .env
                    let env_path = std::path::Path::new(".env");
                    let mut contents = std::fs::read_to_string(env_path).unwrap_or_default();
                    
                    if contents.contains("ANNAS_ARCHIVE_KEY=") {
                        let re = regex::Regex::new(r"(?m)^ANNAS_ARCHIVE_KEY=.*$").unwrap();
                        contents = re.replace(&contents, format!("ANNAS_ARCHIVE_KEY=\"{}\"", self.api_key_input)).to_string();
                    } else {
                        contents.push_str(&format!("\nANNAS_ARCHIVE_KEY=\"{}\"\n", self.api_key_input));
                    }
                    let _ = std::fs::write(env_path, contents);
                    
                    self.current_screen = CurrentScreen::AnnasArchiveSearch;
                }
            }
            KeyCode::Char(c) => self.api_key_input.push(c),
            KeyCode::Backspace => { self.api_key_input.pop(); }
            _ => {}
        }
    }

    fn handle_annas_search_input(&mut self, key_event: KeyEvent) {
        match key_event.code {
            KeyCode::Esc => self.current_screen = CurrentScreen::MainMenu,
            KeyCode::Enter => {
                if !self.search_input.is_empty() {
                    self.current_screen = CurrentScreen::AnnasArchiveSearching;
                    self.pending_search = true;
                }
            }
            KeyCode::Char(c) => self.search_input.push(c),
            KeyCode::Backspace => { self.search_input.pop(); }
            _ => {}
        }
    }


    fn handle_annas_results_key(&mut self, key_event: KeyEvent) {
        match key_event.code {
            KeyCode::Esc => self.current_screen = CurrentScreen::AnnasArchiveSearch,
            KeyCode::Tab | KeyCode::Right => {
                self.sort_mode = self.sort_mode.next();
                self.sort_results();
            }
            KeyCode::Left => {
                self.sort_mode = self.sort_mode.prev();
                self.sort_results();
            }
            KeyCode::Up => {
                if let Some(selected) = self.search_results_state.selected() {
                    let next = if selected > 0 { selected - 1 } else { self.search_results.len() - 1 };
                    self.search_results_state.select(Some(next));
                }
            }
            KeyCode::Down => {
                if let Some(selected) = self.search_results_state.selected() {
                    let next = if selected < self.search_results.len() - 1 { selected + 1 } else { 0 };
                    self.search_results_state.select(Some(next));
                }
            }
            KeyCode::Enter => {
                if let Some(selected) = self.search_results_state.selected() {
                    let book = self.search_results[selected].clone();
                    self.selected_book = Some(book.clone());
                    self.current_screen = CurrentScreen::AnnasArchiveDownloading;
                    self.pending_download = true;
                }
            }
            _ => {}
        }
    }

    fn handle_dataset_gen_key(&mut self, key_event: KeyEvent) {
        if self.is_inputting_path {
            match key_event.code {
                KeyCode::Esc => {
                    self.is_inputting_path = false;
                }
                KeyCode::Enter => {
                    self.is_inputting_path = false;
                    
                    let mut path = self.dataset_path_input.trim().to_string();
                    
                    // Mac OS drag and drop wraps in single quotes and adds trailing space
                    if path.starts_with('\'') && path.ends_with('\'') && path.len() >= 2 {
                        path = path[1..path.len()-1].to_string();
                    } else if path.starts_with('"') && path.ends_with('"') && path.len() >= 2 {
                        path = path[1..path.len()-1].to_string();
                    }
                    
                    // Some terminals use backslash escaping for spaces
                    path = path.replace("\\ ", " ");
                    
                    self.dataset_path_input = path;
                    
                    self.pending_dataset_gen = true;
                    self.current_screen = CurrentScreen::DatasetGenProcessing;
                }
                KeyCode::Char(c) => {
                    self.dataset_path_input.push(c);
                }
                KeyCode::Backspace => {
                    self.dataset_path_input.pop();
                }
                _ => {}
            }
        } else {
            match key_event.code {
                KeyCode::Esc => self.current_screen = CurrentScreen::MainMenu,
                KeyCode::Char('p') | KeyCode::Char('P') => {
                    self.is_inputting_path = true;
                    self.dataset_path_input.clear();
                }
                KeyCode::Up => {
                    if let Some(selected) = self.dataset_list_state.selected() {
                        let next = if selected > 0 { selected - 1 } else { self.dataset_files.len().saturating_sub(1) };
                        self.dataset_list_state.select(Some(next));
                    }
                }
                KeyCode::Down => {
                    if let Some(selected) = self.dataset_list_state.selected() {
                        let next = if selected < self.dataset_files.len().saturating_sub(1) { selected + 1 } else { 0 };
                        self.dataset_list_state.select(Some(next));
                    }
                }
                KeyCode::Enter => {
                    if let Some(selected) = self.dataset_list_state.selected() {
                        if selected < self.dataset_files.len() {
                            let file = &self.dataset_files[selected];
                            // The path inside the data/books/ directory
                            self.dataset_path_input = format!("data/books/{}", file);
                            self.pending_dataset_gen = true;
                            self.current_screen = CurrentScreen::DatasetGenProcessing;
                        }
                    }
                }
                _ => {}
            }
        }
    }

    pub fn sort_results(&mut self) {
        match self.sort_mode {
            SortMode::Year => {
                // Parse year as u32, default to 0 for descending order (no year at bottom)
                self.search_results.sort_by(|a, b| {
                    let a_year = a.publish_year.as_deref().unwrap_or("0").parse::<u32>().unwrap_or(0);
                    let b_year = b.publish_year.as_deref().unwrap_or("0").parse::<u32>().unwrap_or(0);
                    b_year.cmp(&a_year)
                });
            }
            SortMode::Title => {
                self.search_results.sort_by(|a, b| a.title.cmp(&b.title));
            }
            SortMode::Author => {
                self.search_results.sort_by(|a, b| a.author.cmp(&b.author));
            }
            SortMode::Format => {
                self.search_results.sort_by(|a, b| a.format.cmp(&b.format));
            }
            SortMode::Size => {
                // Very basic size sorting (alphanumeric). A proper size parser would parse MB/KB to bytes.
                // For simplicity, we just sort alphabetically which isn't perfect for sizes but works okay for now.
                self.search_results.sort_by(|a, b| {
                    // Try to extract numerical value for better sorting
                    let parse_size = |s: &str| -> f64 {
                        let num_str: String = s.chars().filter(|c| c.is_numeric() || *c == '.').collect();
                        let mult = if s.to_uppercase().contains("MB") { 1024.0 } 
                                   else if s.to_uppercase().contains("GB") { 1024.0 * 1024.0 } 
                                   else { 1.0 };
                        num_str.parse::<f64>().unwrap_or(0.0) * mult
                    };
                    let a_val = parse_size(&a.size);
                    let b_val = parse_size(&b.size);
                    b_val.partial_cmp(&a_val).unwrap_or(std::cmp::Ordering::Equal)
                });
            }
        }
        // Reset selection to top
        if !self.search_results.is_empty() {
            self.search_results_state.select(Some(0));
        }
    }

    pub fn refresh_dataset_files(&mut self) {
        self.dataset_files.clear();
        if let Ok(entries) = std::fs::read_dir("data/books") {
            for entry in entries.flatten() {
                if let Ok(file_type) = entry.file_type() {
                    if file_type.is_file() {
                        let path = entry.path();
                        if let Some(ext) = path.extension() {
                            if ext == "pdf" || ext == "epub" {
                                if let Some(name) = path.file_name() {
                                    self.dataset_files.push(name.to_string_lossy().into_owned());
                                }
                            }
                        }
                    }
                }
            }
        }
        self.dataset_files.sort();
        if !self.dataset_files.is_empty() {
            self.dataset_list_state.select(Some(0));
        }
    }
}
