use crossterm::event::{KeyCode, KeyEvent};
use ratatui::widgets::ListState;
use dotenvy::dotenv;
use std::env;

use crate::annas_archive::{self, Book};



#[derive(Clone, Copy, PartialEq, Eq)]
pub enum CurrentScreen {
    MainMenu,
    AnnasArchiveKey,
    AnnasArchiveSearch,
    AnnasArchiveResults,
    AnnasArchiveDownloading,
    AnnasArchiveDone,
    AnnasArchiveError,
    DatasetGen,
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
    pub selected_book: Option<Book>,
    pub download_path: Option<String>,
    pub error_message: Option<String>,
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
                "Exit",
            ],

            api_key_input: String::new(),
            search_input: String::new(),
            search_results: Vec::new(),
            search_results_state: ListState::default(),
            selected_book: None,
            download_path: None,
            error_message: None,
        }
    }

    pub fn quit(&mut self) {
        self.should_quit = true;
    }

    pub async fn handle_key_event(&mut self, key_event: KeyEvent) {
        match self.current_screen {
            CurrentScreen::MainMenu => self.handle_main_menu_key(key_event),
            CurrentScreen::AnnasArchiveKey => self.handle_annas_key_input(key_event),
            CurrentScreen::AnnasArchiveSearch => self.handle_annas_search_input(key_event).await,
            CurrentScreen::AnnasArchiveResults => self.handle_annas_results_key(key_event).await,
            CurrentScreen::AnnasArchiveDownloading => {
                // Downloading blocks until done for now, or we can just let UI poll
            }
            CurrentScreen::AnnasArchiveDone | CurrentScreen::AnnasArchiveError | CurrentScreen::DatasetGen | CurrentScreen::LoraTrain | CurrentScreen::ModalAuth => {
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
                        1 => self.current_screen = CurrentScreen::DatasetGen,
                        2 => self.current_screen = CurrentScreen::LoraTrain,
                        3 => self.current_screen = CurrentScreen::ModalAuth,
                        4 => self.quit(),
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
                    // We should save this to .env (skipped for brevity, assuming loaded later)
                    self.current_screen = CurrentScreen::AnnasArchiveSearch;
                }
            }
            KeyCode::Char(c) => self.api_key_input.push(c),
            KeyCode::Backspace => { self.api_key_input.pop(); }
            _ => {}
        }
    }

    async fn handle_annas_search_input(&mut self, key_event: KeyEvent) {
        match key_event.code {
            KeyCode::Esc => self.current_screen = CurrentScreen::MainMenu,
            KeyCode::Enter => {
                if !self.search_input.is_empty() {
                    // Blocking search for simplicity. In prod, we'd use a background tokio task and poll.
                    match annas_archive::search_books(&self.search_input).await {
                        Ok(books) => {
                            self.search_results = books;
                            self.search_results_state.select(Some(0));
                            if self.search_results.is_empty() {
                                self.error_message = Some("No books found.".to_string());
                                self.current_screen = CurrentScreen::AnnasArchiveError;
                            } else {
                                self.current_screen = CurrentScreen::AnnasArchiveResults;
                            }
                        }
                        Err(e) => {
                            self.error_message = Some(e.to_string());
                            self.current_screen = CurrentScreen::AnnasArchiveError;
                        }
                    }
                }
            }
            KeyCode::Char(c) => self.search_input.push(c),
            KeyCode::Backspace => { self.search_input.pop(); }
            _ => {}
        }
    }

    async fn handle_annas_results_key(&mut self, key_event: KeyEvent) {
        match key_event.code {
            KeyCode::Esc => self.current_screen = CurrentScreen::AnnasArchiveSearch,
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
                    
                    match annas_archive::download_book(&book, &self.api_key_input).await {
                        Ok(path) => {
                            self.download_path = Some(path);
                            self.current_screen = CurrentScreen::AnnasArchiveDone;
                        }
                        Err(e) => {
                            self.error_message = Some(e.to_string());
                            self.current_screen = CurrentScreen::AnnasArchiveError;
                        }
                    }
                }
            }
            _ => {}
        }
    }
}
