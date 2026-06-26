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
    SearchDone(Result<Vec<crate::annas_archive::Book>, String>),
    DownloadDone(Result<String, String>),
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
            tokio::spawn(async move {
                let res = crate::annas_archive::search_books(&query).await;
                let _ = tx.send(AppAction::SearchDone(res.map_err(|e| e.to_string()))).await;
            });
        }

        if app.pending_download {
            app.pending_download = false;
            let tx = tx.clone();
            let book = app.selected_book.clone().unwrap();
            let api_key = app.api_key_input.clone();
            tokio::spawn(async move {
                let res = crate::annas_archive::download_book(&book, &api_key).await;
                let _ = tx.send(AppAction::DownloadDone(res.map_err(|e| e.to_string()))).await;
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
                    AppAction::DownloadDone(Ok(path)) => {
                        app.download_path = Some(path);
                        app.current_screen = crate::app::CurrentScreen::AnnasArchiveDone;
                    }
                    AppAction::DownloadDone(Err(e)) => {
                        app.error_message = Some(e);
                        app.current_screen = crate::app::CurrentScreen::AnnasArchiveError;
                    }
                }
            }
        }

        if app.should_quit {
            return Ok(());
        }
    }
}
