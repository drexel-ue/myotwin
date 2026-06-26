use ratatui::{
    layout::{Constraint, Direction, Layout},
    style::{Color, Modifier, Style},
    text::{Line, Span},
    widgets::{Block, Borders, List, ListItem, Paragraph},
    Frame,
};

use crate::app::{App, CurrentScreen};

pub fn draw(f: &mut Frame, app: &mut App) {
    let chunks = Layout::default()
        .direction(Direction::Vertical)
        .constraints([
            Constraint::Length(3),
            Constraint::Min(1),
            Constraint::Length(3),
        ])
        .split(f.area());

    let title = Paragraph::new(Line::from(vec![
        Span::styled("Motus CLI", Style::default().fg(Color::Cyan).add_modifier(Modifier::BOLD)),
    ]))
    .block(Block::default().borders(Borders::ALL));
    f.render_widget(title, chunks[0]);

    match app.current_screen {
        CurrentScreen::MainMenu => {
            let items: Vec<ListItem> = app.main_menu_items
                .iter()
                .map(|i| ListItem::new(*i))
                .collect();
            
            let list = List::new(items)
                .block(Block::default().title("Main Menu").borders(Borders::ALL))
                .highlight_style(Style::default().fg(Color::Yellow).add_modifier(Modifier::BOLD))
                .highlight_symbol(">> ");
            
            f.render_stateful_widget(list, chunks[1], &mut app.main_menu_state);
        }
        CurrentScreen::AnnasArchiveKey => {
            let text = format!("Anna's Archive API Key required.\nEnter Key: {}\n\n(Press Enter to save)", app.api_key_input);
            let p = Paragraph::new(text).block(Block::default().title("API Key").borders(Borders::ALL));
            f.render_widget(p, chunks[1]);
        }
        CurrentScreen::AnnasArchiveSearch => {
            let text = format!("Enter book title or author: {}\n\n(Press Enter to search)", app.search_input);
            let p = Paragraph::new(text).block(Block::default().title("Search Anna's Archive").borders(Borders::ALL));
            f.render_widget(p, chunks[1]);
        }
        CurrentScreen::AnnasArchiveResults => {
            let items: Vec<ListItem> = app.search_results
                .iter()
                .map(|b| {
                    ListItem::new(format!("{} by {} [{}, {}]", b.title, b.author, b.format, b.size))
                })
                .collect();
            
            let list = List::new(items)
                .block(Block::default().title("Search Results").borders(Borders::ALL))
                .highlight_style(Style::default().fg(Color::Yellow).add_modifier(Modifier::BOLD))
                .highlight_symbol(">> ");
            
            f.render_stateful_widget(list, chunks[1], &mut app.search_results_state);
        }
        CurrentScreen::AnnasArchiveDownloading => {
            let title = app.selected_book.as_ref().map(|b| b.title.as_str()).unwrap_or("Book");
            let text = format!("Downloading '{}'...\nThis may take a moment...", title);
            let p = Paragraph::new(text).block(Block::default().title("Downloading").borders(Borders::ALL));
            f.render_widget(p, chunks[1]);
        }
        CurrentScreen::AnnasArchiveDone => {
            let path = app.download_path.as_ref().map(|s| s.as_str()).unwrap_or("Unknown");
            let text = format!("Download complete!\nSaved to: {}\n\nPress Enter to return", path);
            let p = Paragraph::new(text).block(Block::default().title("Done").borders(Borders::ALL));
            f.render_widget(p, chunks[1]);
        }
        CurrentScreen::AnnasArchiveError => {
            let err = app.error_message.as_ref().map(|s| s.as_str()).unwrap_or("Unknown Error");
            let text = format!("Error: {}\n\nPress Enter to return", err);
            let p = Paragraph::new(text).block(Block::default().title("Error").borders(Borders::ALL).style(Style::default().fg(Color::Red)));
            f.render_widget(p, chunks[1]);
        }
        CurrentScreen::DatasetGen => {
            let p = Paragraph::new("Dataset Generation flow coming soon...\nPress Enter to return")
                .block(Block::default().title("Dataset Generation").borders(Borders::ALL));
            f.render_widget(p, chunks[1]);
        }
        CurrentScreen::LoraTrain => {
            let p = Paragraph::new("LoRA Training flow coming soon...\nPress Enter to return")
                .block(Block::default().title("LoRA Training").borders(Borders::ALL));
            f.render_widget(p, chunks[1]);
        }
        CurrentScreen::ModalAuth => {
            let p = Paragraph::new("Modal Auth flow coming soon...\nPress Enter to return")
                .block(Block::default().title("Modal Auth").borders(Borders::ALL));
            f.render_widget(p, chunks[1]);
        }
    }

    let footer = Paragraph::new(Line::from(vec![
        Span::raw("Press "),
        Span::styled("Esc", Style::default().add_modifier(Modifier::BOLD)),
        Span::raw(" or "),
        Span::styled("q", Style::default().add_modifier(Modifier::BOLD)),
        Span::raw(" to exit."),
    ]))
    .block(Block::default().borders(Borders::ALL));
    f.render_widget(footer, chunks[2]);
}
