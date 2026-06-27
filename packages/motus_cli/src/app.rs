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
    DatasetGenTagInput,
    DatasetGenProcessing,
    DatasetGenDone,
    DatasetGenError,
    LoraTrainSelect,
    LoraTrainNameInput,
    LoraTrainProcessing,
    LoraTrainDone,
    LoraTrainError,
    ModalAuth,
}

#[derive(serde::Serialize, serde::Deserialize, Default, Clone)]
pub struct DatasetMetadata {
    pub tags: Vec<String>,
}

#[derive(Clone, PartialEq)]
pub struct DatasetInfo {
    pub name: String,
    pub tags: Vec<String>,
}

#[derive(Clone, PartialEq)]
pub enum DatasetStatus {
    None,
    Partial,
    Complete,
}

#[derive(Clone, PartialEq)]
pub struct BookFileInfo {
    pub name: String,
    pub dataset_status: DatasetStatus,
}

#[derive(PartialEq)]
pub enum LoraSelectFocus {
    Search,
    Tags,
    AvailableList,
    SelectedList,
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
    pub dataset_files: Vec<BookFileInfo>,
    pub dataset_list_state: ListState,
    pub dataset_path_input: String,
    pub is_inputting_path: bool,
    pub dataset_tags_input: String,
    pub is_fetching_tags: bool,
    pub pending_tag_recommendation: bool,
    pub pending_dataset_gen: bool,
    pub dataset_progress: f64,
    pub dataset_logs: Vec<String>,
    pub dataset_logs_state: ListState,
    pub dataset_auto_scroll: bool,
    pub dataset_error_scroll: u16,
    
    // LoRA Training
    pub available_datasets: Vec<DatasetInfo>,
    pub filtered_available_datasets: Vec<DatasetInfo>,
    pub available_datasets_state: ListState,
    pub selected_datasets: Vec<DatasetInfo>,
    pub selected_datasets_state: ListState,
    pub lora_search_input: String,
    pub lora_select_focus: LoraSelectFocus,
    pub lora_available_tags: Vec<(String, usize)>,
    pub lora_selected_tag: Option<String>,
    pub lora_tag_state: ListState,
    pub lora_name_input: String,
    pub pending_lora_train: bool,
    pub lora_logs: Vec<String>,
    pub lora_logs_state: ListState,
    pub lora_auto_scroll: bool,
    pub lora_output_gguf: String,
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
            dataset_tags_input: String::new(),
            is_fetching_tags: false,
            pending_tag_recommendation: false,
            pending_dataset_gen: false,
            dataset_progress: 0.0,
            dataset_logs: Vec::new(),
            dataset_logs_state: ListState::default(),
            dataset_auto_scroll: true,
            dataset_error_scroll: 0,
            
            available_datasets: Vec::new(),
            filtered_available_datasets: Vec::new(),
            available_datasets_state: ListState::default(),
            selected_datasets: Vec::new(),
            selected_datasets_state: ListState::default(),
            lora_search_input: String::new(),
            lora_select_focus: LoraSelectFocus::Search,
            lora_available_tags: Vec::new(),
            lora_selected_tag: None,
            lora_tag_state: ListState::default(),
            lora_name_input: String::new(),
            pending_lora_train: false,
            lora_logs: Vec::new(),
            lora_logs_state: ListState::default(),
            lora_auto_scroll: true,
            lora_output_gguf: String::new(),
        }
    }

    pub fn quit(&mut self) {
        self.should_quit = true;
    }

    pub fn handle_key_event(&mut self, key_event: KeyEvent) {
        match self.current_screen {
            CurrentScreen::MainMenu => self.handle_main_menu_key(key_event),
            CurrentScreen::AnnasArchiveKey => self.handle_annas_key_input(key_event),
            CurrentScreen::DatasetGen => {
                self.handle_dataset_gen_key(key_event);
            }
            CurrentScreen::DatasetGenTagInput => {
                match key_event.code {
                    KeyCode::Esc => {
                        self.current_screen = CurrentScreen::DatasetGen;
                    }
                    KeyCode::Enter => {
                        self.pending_dataset_gen = true;
                        self.current_screen = CurrentScreen::DatasetGenProcessing;
                    }
                    KeyCode::Char('g') if key_event.modifiers.contains(crossterm::event::KeyModifiers::CONTROL) => {
                        if !self.is_fetching_tags {
                            self.is_fetching_tags = true;
                            self.pending_tag_recommendation = true;
                        }
                    }
                    KeyCode::Char(c) => {
                        if !self.is_fetching_tags && !key_event.modifiers.contains(crossterm::event::KeyModifiers::CONTROL) {
                            self.dataset_tags_input.push(c);
                        }
                    }
                    KeyCode::Backspace => {
                        if !self.is_fetching_tags {
                            self.dataset_tags_input.pop();
                        }
                    }
                    _ => {}
                }
            }
            CurrentScreen::DatasetGenProcessing => {
                match key_event.code {
                    KeyCode::Up => {
                        self.dataset_auto_scroll = false;
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
                        if i >= self.dataset_logs.len().saturating_sub(1) {
                            self.dataset_auto_scroll = true;
                        }
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
            CurrentScreen::AnnasArchiveDone | CurrentScreen::AnnasArchiveError | CurrentScreen::ModalAuth => {
                if key_event.code == KeyCode::Enter || key_event.code == KeyCode::Esc {
                    self.current_screen = CurrentScreen::MainMenu;
                }
            }
            CurrentScreen::LoraTrainSelect => self.handle_lora_select_key(key_event),
            CurrentScreen::LoraTrainNameInput => self.handle_lora_name_key(key_event),
            CurrentScreen::LoraTrainProcessing => {
                match key_event.code {
                    KeyCode::Up => {
                        self.lora_auto_scroll = false;
                        let i = match self.lora_logs_state.selected() {
                            Some(i) => if i == 0 { 0 } else { i - 1 },
                            None => self.lora_logs.len().saturating_sub(1),
                        };
                        self.lora_logs_state.select(Some(i));
                    }
                    KeyCode::Down => {
                        let i = match self.lora_logs_state.selected() {
                            Some(i) => if i >= self.lora_logs.len().saturating_sub(1) { self.lora_logs.len().saturating_sub(1) } else { i + 1 },
                            None => 0,
                        };
                        self.lora_logs_state.select(Some(i));
                        if i >= self.lora_logs.len().saturating_sub(1) {
                            self.lora_auto_scroll = true;
                        }
                    }
                    KeyCode::Char('q') => {
                        self.should_quit = true;
                    }
                    KeyCode::Esc => {
                        self.current_screen = CurrentScreen::LoraTrainSelect;
                    }
                    KeyCode::Char('c') if key_event.modifiers.contains(crossterm::event::KeyModifiers::CONTROL) => {
                        self.should_quit = true;
                    }
                    _ => {}
                }
            }
            CurrentScreen::LoraTrainDone => {
                if key_event.code == KeyCode::Enter {
                    self.current_screen = CurrentScreen::MainMenu;
                }
            }
            CurrentScreen::LoraTrainError => {
                match key_event.code {
                    KeyCode::Enter | KeyCode::Esc => {
                        self.current_screen = CurrentScreen::LoraTrainSelect;
                    }
                    KeyCode::Up => {
                        self.lora_auto_scroll = false;
                        let i = match self.lora_logs_state.selected() {
                            Some(i) => if i == 0 { 0 } else { i - 1 },
                            None => 0,
                        };
                        self.lora_logs_state.select(Some(i));
                    }
                    KeyCode::Down => {
                        self.lora_auto_scroll = false;
                        let i = match self.lora_logs_state.selected() {
                            Some(i) => if i >= self.lora_logs.len().saturating_sub(1) {
                                self.lora_logs.len().saturating_sub(1)
                            } else {
                                i + 1
                            },
                            None => 0,
                        };
                        self.lora_logs_state.select(Some(i));
                    }
                    KeyCode::Char('c') => {
                        let mut all_logs = String::new();
                        if let Some(err) = &self.error_message {
                            all_logs.push_str(&format!("Training Error: {}\n\n", err));
                        }
                        all_logs.push_str(&self.lora_logs.join("\n"));
                        
                        // Strip ANSI escape codes so copied text is clean
                        let re = regex::Regex::new(r"\x1b\[[0-9;?]*[a-zA-Z]").unwrap();
                        let clean_logs = re.replace_all(&all_logs, "").into_owned();
                        
                        let _ = std::process::Command::new("pbcopy")
                            .stdin(std::process::Stdio::piped())
                            .spawn()
                            .and_then(|mut child| {
                                use std::io::Write;
                                if let Some(mut stdin) = child.stdin.take() {
                                    let _ = stdin.write_all(clean_logs.as_bytes());
                                }
                                child.wait()
                            });
                    }
                    _ => {}
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
                        2 => {
                            self.refresh_datasets();
                            self.current_screen = CurrentScreen::LoraTrainSelect;
                        }
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
        match key_event.code {
            KeyCode::Esc => self.current_screen = CurrentScreen::MainMenu,
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
                    let file = self.dataset_files[selected].name.clone();
                    self.dataset_path_input = format!("data/books/{}", file);
                    self.dataset_tags_input.clear();
                    self.current_screen = CurrentScreen::DatasetGenTagInput;
                }
            }
            _ => {}
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
        let mut files = Vec::new();
        if let Ok(entries) = std::fs::read_dir("data/books") {
            for entry in entries.flatten() {
                if let Ok(file_type) = entry.file_type() {
                    if file_type.is_file() {
                        let path = entry.path();
                        if let Some(ext) = path.extension() {
                            if ext == "pdf" || ext == "epub" {
                                if let Some(name) = path.file_name() {
                                    let modified = entry.metadata().and_then(|m| m.modified()).unwrap_or(std::time::SystemTime::UNIX_EPOCH);
                                    files.push((name.to_string_lossy().into_owned(), modified));
                                }
                            }
                        }
                    }
                }
            }
        }
        files.sort_by(|a, b| b.1.cmp(&a.1));
        self.dataset_files = files.into_iter().map(|(n, _)| {
            let base_name = std::path::Path::new(&n).file_stem().unwrap_or_default().to_string_lossy();
            let dataset_path = format!("data/datasets/{}_dataset.jsonl", base_name);
            let meta_path = format!("data/datasets/{}_dataset.jsonl.meta", base_name);
            let progress_path = format!("data/datasets/{}_dataset.progress.json", base_name);
            
            let dataset_status = if std::path::Path::new(&meta_path).exists() {
                DatasetStatus::Complete
            } else if std::path::Path::new(&progress_path).exists() || std::path::Path::new(&dataset_path).exists() {
                DatasetStatus::Partial
            } else {
                DatasetStatus::None
            };

            BookFileInfo {
                name: n,
                dataset_status,
            }
        }).collect();
        if !self.dataset_files.is_empty() {
            self.dataset_list_state.select(Some(0));
        }
    }

    pub fn refresh_datasets(&mut self) {
        self.available_datasets.clear();
        self.filtered_available_datasets.clear();
        if let Ok(entries) = std::fs::read_dir("data/datasets") {
            for entry in entries.flatten() {
                if let Ok(file_type) = entry.file_type() {
                    if file_type.is_file() {
                        let path = entry.path();
                        if path.extension().and_then(|e| e.to_str()) == Some("jsonl") {
                            if let Some(name) = path.file_name().and_then(|n| n.to_str()) {
                                let mut tags = Vec::new();
                                // Try to read sidecar file
                                let meta_path = path.with_extension("jsonl.meta");
                                if let Ok(meta_json) = std::fs::read_to_string(&meta_path) {
                                    if let Ok(meta) = serde_json::from_str::<DatasetMetadata>(&meta_json) {
                                        tags = meta.tags;
                                    }
                                }
                                self.available_datasets.push(DatasetInfo {
                                    name: name.to_string(),
                                    tags,
                                });
                            }
                        }
                    }
                }
            }
        }
        self.available_datasets.sort_by(|a, b| a.name.cmp(&b.name));
        
        let mut tag_counts: std::collections::HashMap<String, usize> = std::collections::HashMap::new();
        for dataset in &self.available_datasets {
            for tag in &dataset.tags {
                *tag_counts.entry(tag.clone()).or_insert(0) += 1;
            }
        }
        let mut tags_vec: Vec<(String, usize)> = tag_counts.into_iter().collect();
        tags_vec.sort_by(|a, b| b.1.cmp(&a.1).then_with(|| a.0.cmp(&b.0)));
        self.lora_available_tags = tags_vec;
        
        self.update_lora_filter();
    }

    pub fn update_lora_filter(&mut self) {
        let query = self.lora_search_input.to_lowercase();
        self.filtered_available_datasets = self.available_datasets
            .iter()
            .filter(|d| {
                let name_matches = d.name.to_lowercase().contains(&query);
                let tag_matches = d.tags.iter().any(|t| t.to_lowercase().contains(&query));
                
                let filter_matches = match &self.lora_selected_tag {
                    Some(tag) => d.tags.contains(tag),
                    None => true,
                };
                
                (name_matches || tag_matches) && filter_matches && !self.selected_datasets.contains(d)
            })
            .cloned()
            .collect();
        
        if !self.filtered_available_datasets.is_empty() {
            self.available_datasets_state.select(Some(0));
        } else {
            self.available_datasets_state.select(None);
        }
    }
    
    fn handle_lora_select_key(&mut self, key_event: KeyEvent) {
        match key_event.code {
            KeyCode::Esc => self.current_screen = CurrentScreen::MainMenu,
            KeyCode::Tab => {
                self.lora_select_focus = match self.lora_select_focus {
                    LoraSelectFocus::Search => LoraSelectFocus::Tags,
                    LoraSelectFocus::Tags => LoraSelectFocus::AvailableList,
                    LoraSelectFocus::AvailableList => LoraSelectFocus::SelectedList,
                    LoraSelectFocus::SelectedList => LoraSelectFocus::Search,
                };
            }
            KeyCode::Char('s') if key_event.modifiers.contains(crossterm::event::KeyModifiers::CONTROL) => {
                if !self.selected_datasets.is_empty() {
                    self.current_screen = CurrentScreen::LoraTrainNameInput;
                }
            }
            _ => {
                match self.lora_select_focus {
                    LoraSelectFocus::Search => {
                        match key_event.code {
                            KeyCode::Char(c) => {
                                self.lora_search_input.push(c);
                                self.update_lora_filter();
                            }
                            KeyCode::Backspace => {
                                self.lora_search_input.pop();
                                self.update_lora_filter();
                            }
                            KeyCode::Down => {
                                self.lora_select_focus = LoraSelectFocus::Tags;
                            }
                            _ => {}
                        }
                    }
                    LoraSelectFocus::Tags => {
                        match key_event.code {
                            KeyCode::Left => {
                                let i = match self.lora_tag_state.selected() {
                                    Some(i) => if i == 0 { 0 } else { i - 1 },
                                    None => 0,
                                };
                                self.lora_tag_state.select(Some(i));
                            }
                            KeyCode::Right => {
                                let len = self.lora_available_tags.len();
                                if len > 0 {
                                    let i = match self.lora_tag_state.selected() {
                                        Some(i) => if i >= len - 1 { len - 1 } else { i + 1 },
                                        None => 0,
                                    };
                                    self.lora_tag_state.select(Some(i));
                                }
                            }
                            KeyCode::Enter => {
                                if let Some(i) = self.lora_tag_state.selected() {
                                    if i < self.lora_available_tags.len() {
                                        let selected = self.lora_available_tags[i].0.clone();
                                        if Some(selected.clone()) == self.lora_selected_tag {
                                            self.lora_selected_tag = None;
                                        } else {
                                            self.lora_selected_tag = Some(selected);
                                        }
                                        self.update_lora_filter();
                                    }
                                }
                            }
                            KeyCode::Down => {
                                self.lora_select_focus = LoraSelectFocus::AvailableList;
                            }
                            KeyCode::Up => {
                                self.lora_select_focus = LoraSelectFocus::Search;
                            }
                            _ => {}
                        }
                    }
                    LoraSelectFocus::AvailableList => {
                        match key_event.code {
                            KeyCode::Up => {
                                let i = match self.available_datasets_state.selected() {
                                    Some(i) => if i == 0 { 0 } else { i - 1 },
                                    None => 0,
                                };
                                if i == 0 && self.available_datasets_state.selected() == Some(0) {
                                    self.lora_select_focus = LoraSelectFocus::Tags;
                                } else {
                                    self.available_datasets_state.select(Some(i));
                                }
                            }
                            KeyCode::Down => {
                                let i = match self.available_datasets_state.selected() {
                                    Some(i) => if i >= self.filtered_available_datasets.len().saturating_sub(1) { self.filtered_available_datasets.len().saturating_sub(1) } else { i + 1 },
                                    None => 0,
                                };
                                self.available_datasets_state.select(Some(i));
                            }
                            KeyCode::Enter => {
                                if let Some(i) = self.available_datasets_state.selected() {
                                    if i < self.filtered_available_datasets.len() {
                                        let selected = self.filtered_available_datasets[i].clone();
                                        self.selected_datasets.push(selected);
                                        self.update_lora_filter();
                                        if self.selected_datasets_state.selected().is_none() && !self.selected_datasets.is_empty() {
                                            self.selected_datasets_state.select(Some(0));
                                        }
                                    }
                                }
                            }
                            _ => {}
                        }
                    }
                    LoraSelectFocus::SelectedList => {
                        match key_event.code {
                            KeyCode::Up => {
                                let i = match self.selected_datasets_state.selected() {
                                    Some(i) => if i == 0 { 0 } else { i - 1 },
                                    None => 0,
                                };
                                self.selected_datasets_state.select(Some(i));
                            }
                            KeyCode::Down => {
                                let i = match self.selected_datasets_state.selected() {
                                    Some(i) => if i >= self.selected_datasets.len().saturating_sub(1) { self.selected_datasets.len().saturating_sub(1) } else { i + 1 },
                                    None => 0,
                                };
                                self.selected_datasets_state.select(Some(i));
                            }
                            KeyCode::Enter => {
                                if let Some(i) = self.selected_datasets_state.selected() {
                                    if i < self.selected_datasets.len() {
                                        self.selected_datasets.remove(i);
                                        if i >= self.selected_datasets.len() && !self.selected_datasets.is_empty() {
                                            self.selected_datasets_state.select(Some(self.selected_datasets.len() - 1));
                                        } else if self.selected_datasets.is_empty() {
                                            self.selected_datasets_state.select(None);
                                        }
                                        self.update_lora_filter();
                                    }
                                }
                            }
                            _ => {}
                        }
                    }
                }
            }
        }
    }
    
    fn handle_lora_name_key(&mut self, key_event: KeyEvent) {
        match key_event.code {
            KeyCode::Esc => self.current_screen = CurrentScreen::LoraTrainSelect,
            KeyCode::Enter => {
                if !self.lora_name_input.is_empty() {
                    self.pending_lora_train = true;
                    self.lora_logs.clear();
                    self.lora_output_gguf.clear();
                    self.current_screen = CurrentScreen::LoraTrainProcessing;
                }
            }
            KeyCode::Char(c) => {
                if c.is_alphanumeric() || c == '_' || c == '-' {
                    self.lora_name_input.push(c);
                }
            }
            KeyCode::Backspace => {
                self.lora_name_input.pop();
            }
            _ => {}
        }
    }
}
