use crossterm::{
    event::{self, Event},
    execute,
    terminal::{disable_raw_mode, enable_raw_mode, EnterAlternateScreen, LeaveAlternateScreen},
};
use ratatui::{
    backend::{Backend, CrosstermBackend},
    Terminal,
};
use std::{error::Error, io};

mod app;
mod ui;
mod dataset_gen;
mod annas_archive;

use app::App;

#[tokio::main]
async fn main() -> Result<(), Box<dyn Error>> {
    // Setup terminal
    enable_raw_mode()?;
    let mut stdout = io::stdout();
    execute!(stdout, EnterAlternateScreen)?;
    let backend = CrosstermBackend::new(stdout);
    let mut terminal = Terminal::new(backend)?;

    // Create app state and run loop
    let mut app = App::new();
    let res = run_app(&mut terminal, &mut app).await;

    // Restore terminal
    disable_raw_mode()?;
    execute!(
        terminal.backend_mut(),
        LeaveAlternateScreen
    )?;
    terminal.show_cursor()?;

    if let Err(err) = res {
        println!("{:?}", err);
    }

    Ok(())
}

use crossterm::event::{EventStream, KeyCode, KeyModifiers};
use tokio_stream::StreamExt;
use tokio::sync::mpsc;

enum AppAction {
    SearchProgress(f64),
    SearchDone(Result<Vec<crate::annas_archive::Book>, String>),
    DownloadProgress(f64),
    DownloadDone(Result<String, String>),
    DatasetProgress(f64),
    DatasetDone(Result<String, String>),
}

async fn run_app<B: Backend>(terminal: &mut Terminal<B>, app: &mut App) -> io::Result<()> {
    let mut reader = EventStream::new();
    let (tx, mut rx) = mpsc::channel(32);

    loop {
        terminal.draw(|f| ui::draw(f, app)).unwrap();

        if app.pending_search {
            app.pending_search = false;
            let tx = tx.clone();
            let query = app.search_input.clone();
            
            let (prog_tx, mut prog_rx) = tokio::sync::mpsc::channel(32);
            let tx2 = tx.clone();
            tokio::spawn(async move {
                while let Some(prog) = prog_rx.recv().await {
                    let _ = tx2.send(AppAction::SearchProgress(prog)).await;
                }
            });

            tokio::spawn(async move {
                let res = crate::annas_archive::search_books(&query, Some(prog_tx)).await;
                let _ = tx.send(AppAction::SearchDone(res.map_err(|e| e.to_string()))).await;
            });
        }

        if app.pending_download {
            app.pending_download = false;
            let tx = tx.clone();
            let book = app.selected_book.clone().unwrap();
            let api_key = app.api_key_input.clone();
            
            let (prog_tx, mut prog_rx) = tokio::sync::mpsc::channel(32);
            let tx2 = tx.clone();
            tokio::spawn(async move {
                while let Some(prog) = prog_rx.recv().await {
                    let _ = tx2.send(AppAction::DownloadProgress(prog)).await;
                }
            });

            tokio::spawn(async move {
                let res = crate::annas_archive::download_book(&book, &api_key, Some(prog_tx)).await;
                let _ = tx.send(AppAction::DownloadDone(res.map_err(|e| e.to_string()))).await;
            });
        }

        if app.pending_dataset_gen {
            app.pending_dataset_gen = false;
            let tx = tx.clone();
            let file_path = app.dataset_path_input.clone();
            // Read GEMINI_API_KEY from environment
            let api_key = std::env::var("GEMINI_API_KEY").unwrap_or_default();
            
            let (prog_tx, mut prog_rx) = tokio::sync::mpsc::channel(32);
            let tx2 = tx.clone();
            tokio::spawn(async move {
                while let Some(prog) = prog_rx.recv().await {
                    let _ = tx2.send(AppAction::DatasetProgress(prog)).await;
                }
            });

            tokio::spawn(async move {
                let res = crate::dataset_gen::generate_dataset(&file_path, &api_key, Some(prog_tx)).await;
                let _ = tx.send(AppAction::DatasetDone(res.map_err(|e| e.to_string()))).await;
            });
        }

        tokio::select! {
            Some(Ok(event)) = reader.next() => {
                match event {
                    Event::Key(key) => {
                        if key.code == KeyCode::Char('c') && key.modifiers.contains(KeyModifiers::CONTROL) {
                            return Ok(());
                        }
                        app.handle_key_event(key);
                    }
                    Event::Resize(_, _) => {
                        // Let the loop tick to redraw immediately
                    }
                    _ => {}
                }
            }
            Some(action) = rx.recv() => {
                match action {
                    AppAction::SearchProgress(progress) => {
                        app.search_progress = progress;
                    }
                    AppAction::SearchDone(Ok(books)) => {
                        app.search_results = books;
                        app.sort_results();
                        if app.search_results.is_empty() {
                            app.error_message = Some("No books found.".to_string());
                            app.current_screen = crate::app::CurrentScreen::AnnasArchiveError;
                        } else {
                            app.current_screen = crate::app::CurrentScreen::AnnasArchiveResults;
                        }
                    }
                    AppAction::SearchDone(Err(e)) => {
                        app.error_message = Some(e);
                        app.current_screen = crate::app::CurrentScreen::AnnasArchiveError;
                    }
                    AppAction::DownloadProgress(progress) => {
                        app.download_progress = progress;
                    }
                    AppAction::DownloadDone(Ok(path)) => {
                        app.download_path = Some(path);
                        app.current_screen = crate::app::CurrentScreen::AnnasArchiveDone;
                    }
                    AppAction::DownloadDone(Err(e)) => {
                        app.error_message = Some(e);
                        app.current_screen = crate::app::CurrentScreen::AnnasArchiveError;
                    }
                    AppAction::DatasetProgress(progress) => {
                        app.dataset_progress = progress;
                    }
                    AppAction::DatasetDone(Ok(path)) => {
                        app.dataset_path_input = path; // Reuse this field to store output path for success screen
                        app.current_screen = crate::app::CurrentScreen::DatasetGenDone;
                    }
                    AppAction::DatasetDone(Err(e)) => {
                        app.error_message = Some(e);
                        app.current_screen = crate::app::CurrentScreen::DatasetGenError;
                    }
                }
            }
        }

        if app.should_quit {
            return Ok(());
        }
    }
}
