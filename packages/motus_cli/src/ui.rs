use ratatui::{
    layout::{Constraint, Direction, Layout},
    style::{Color, Modifier, Style},
    text::{Line, Span},
    widgets::{Block, Borders, List, ListItem, Paragraph, Tabs, Gauge},
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
            
            #[allow(deprecated)]
            f.set_cursor(
                chunks[1].x + 12 + app.api_key_input.len() as u16,
                chunks[1].y + 2,
            );
        }
        CurrentScreen::AnnasArchiveSearch => {
            let text = format!("Enter book title or author: {}\n\n(Press Enter to search)", app.search_input);
            let p = Paragraph::new(text).block(Block::default().title("Search Anna's Archive").borders(Borders::ALL));
            f.render_widget(p, chunks[1]);
            
            #[allow(deprecated)]
            f.set_cursor(
                chunks[1].x + 29 + app.search_input.len() as u16,
                chunks[1].y + 1,
            );
        }
        CurrentScreen::AnnasArchiveSearching => {
            let p = Paragraph::new(format!("Searching Anna's Archive for '{}'...\nThis may take a moment...", app.search_input))
                .block(Block::default().title("Searching").borders(Borders::ALL));
                
            let search_chunks = Layout::default()
                .direction(Direction::Vertical)
                .constraints([Constraint::Length(4), Constraint::Length(3), Constraint::Min(1)])
                .split(chunks[1]);
                
            f.render_widget(p, search_chunks[0]);
            
            let gauge = Gauge::default()
                .block(Block::default().title("Downloading Search Results").borders(Borders::ALL))
                .gauge_style(Style::default().fg(Color::Cyan).bg(Color::Black).add_modifier(Modifier::ITALIC))
                .ratio(app.search_progress.clamp(0.0, 1.0));
            f.render_widget(gauge, search_chunks[1]);
        }
        CurrentScreen::AnnasArchiveResults => {
            let result_chunks = Layout::default()
                .direction(Direction::Vertical)
                .constraints([Constraint::Length(3), Constraint::Min(1)])
                .split(chunks[1]);

            let sort_titles = vec!["Year", "Title", "Author", "Format", "Size"];
            let sort_idx = match app.sort_mode {
                crate::app::SortMode::Year => 0,
                crate::app::SortMode::Title => 1,
                crate::app::SortMode::Author => 2,
                crate::app::SortMode::Format => 3,
                crate::app::SortMode::Size => 4,
            };

            let tabs = Tabs::new(sort_titles.into_iter().map(Line::from).collect::<Vec<_>>())
                .block(Block::default().title("Sort By (Tab / <Left> <Right>)").borders(Borders::ALL))
                .select(sort_idx)
                .highlight_style(Style::default().fg(Color::Yellow).add_modifier(Modifier::BOLD))
                .divider("|");
            
            f.render_widget(tabs, result_chunks[0]);

            let width = result_chunks[1].width.saturating_sub(4) as usize; // account for borders and list highlight symbol
            let items: Vec<ListItem> = app.search_results
                .iter()
                .map(|b| {
                    let year_str = if let Some(y) = &b.publish_year { format!(" ({})", y) } else { "".to_string() };
                    let edition_str = if let Some(e) = &b.edition { format!(" ({})", e) } else { "".to_string() };
                    let content = format!("{} by {}{}{} [{}, {}]", b.title, b.author, year_str, edition_str, b.format.to_uppercase(), b.size);
                    let wrapped = textwrap::wrap(&content, width);
                    let lines: Vec<Line> = wrapped.into_iter().map(|s| Line::from(s.into_owned())).collect();
                    ListItem::new(lines)
                })
                .collect();
            
            let list = List::new(items)
                .block(Block::default().title("Search Results").borders(Borders::ALL))
                .highlight_style(Style::default().fg(Color::Yellow).add_modifier(Modifier::BOLD))
                .highlight_symbol(">> ");
            
            f.render_stateful_widget(list, result_chunks[1], &mut app.search_results_state);
        }
        CurrentScreen::AnnasArchiveDownloading => {
            let title = app.selected_book.as_ref().map(|b| b.title.as_str()).unwrap_or("Book");
            let text = format!("Downloading '{}'...\nThis may take a moment...", title);
            
            let download_chunks = Layout::default()
                .direction(Direction::Vertical)
                .constraints([Constraint::Length(4), Constraint::Length(3), Constraint::Min(1)])
                .split(chunks[1]);
                
            let p = Paragraph::new(text).block(Block::default().title("Downloading").borders(Borders::ALL));
            f.render_widget(p, download_chunks[0]);
            
            let gauge = Gauge::default()
                .block(Block::default().title("Progress").borders(Borders::ALL))
                .gauge_style(Style::default().fg(Color::Green).bg(Color::Black).add_modifier(Modifier::ITALIC))
                .ratio(app.download_progress.clamp(0.0, 1.0));
            f.render_widget(gauge, download_chunks[1]);
        }
        CurrentScreen::AnnasArchiveDone => {
            let path = app.download_path.as_ref().map(|s| s.as_str()).unwrap_or("Unknown");
            let text = format!("Download complete!\nSaved to: {}\n\nPress Enter to return", path);
            let p = Paragraph::new(text)
                .block(Block::default().title("Done").borders(Borders::ALL))
                .wrap(ratatui::widgets::Wrap { trim: true });
            f.render_widget(p, chunks[1]);
        }
        CurrentScreen::AnnasArchiveError => {
            let err = app.error_message.as_ref().map(|s| s.as_str()).unwrap_or("Unknown Error");
            let p = Paragraph::new(format!("Error:\n{}\n\nPress Esc or Enter to return", err))
                .block(Block::default().title("Error").borders(Borders::ALL))
                .wrap(ratatui::widgets::Wrap { trim: true });
            f.render_widget(p, chunks[1]);
        }
        CurrentScreen::DatasetGen => {
            let chunks_ds = Layout::default()
                .direction(Direction::Vertical)
                .constraints([Constraint::Length(3), Constraint::Min(1)])
                .split(chunks[1]);

            if app.is_inputting_path {
                let p = Paragraph::new(app.dataset_path_input.as_str())
                    .block(Block::default().title("Paste Absolute Path to PDF/EPUB (Press Enter to confirm, Esc to cancel)").borders(Borders::ALL));
                f.render_widget(p, chunks_ds[0]);
                f.set_cursor(
                    chunks_ds[0].x + 1 + app.dataset_path_input.len() as u16,
                    chunks_ds[0].y + 1,
                );
            } else {
                let p = Paragraph::new("Select a book from data/books/ or press 'p' to paste a custom path")
                    .block(Block::default().title("Dataset Generation").borders(Borders::ALL));
                f.render_widget(p, chunks_ds[0]);
                
                let width = chunks_ds[1].width.saturating_sub(4) as usize;
                let items: Vec<ListItem> = app.dataset_files.iter().map(|item| {
                    let text = match item.dataset_status {
                        crate::app::DatasetStatus::Complete => format!("[✓] {}", item.name),
                        crate::app::DatasetStatus::Partial => format!("[-] {}", item.name),
                        crate::app::DatasetStatus::None => format!("[ ] {}", item.name),
                    };
                    let wrapped = textwrap::wrap(&text, width);
                    let lines: Vec<Line> = wrapped.into_iter().map(|w| Line::from(w.into_owned())).collect();
                    ListItem::new(lines)
                }).collect();
                
                let list = List::new(items)
                    .block(Block::default().borders(Borders::ALL).title("Available Books"))
                    .highlight_style(Style::default().bg(Color::Cyan).fg(Color::Black))
                    .highlight_symbol(">> ");
                f.render_stateful_widget(list, chunks_ds[1], &mut app.dataset_list_state);
            }
        }
        CurrentScreen::DatasetGenTagInput => {
            let text = if app.is_fetching_tags {
                format!("Enter comma-separated tags for this dataset (e.g. anatomy, clinical, basics):\nLeave empty for no tags.\n\n> {}\n\n[Gemini is analyzing title...]", app.dataset_tags_input)
            } else {
                format!("Enter comma-separated tags for this dataset (e.g. anatomy, clinical, basics):\nLeave empty for no tags.\n\n> {}\n\n(Press Enter to start generation, Esc to back out, Ctrl+G to auto-generate tags)", app.dataset_tags_input)
            };
            let p = Paragraph::new(text)
                .block(Block::default().title("Dataset Tags").borders(Borders::ALL))
                .wrap(ratatui::widgets::Wrap { trim: true });
            f.render_widget(p, chunks[1]);
        }
        CurrentScreen::DatasetGenProcessing => {
            let processing_chunks = Layout::default()
                .direction(Direction::Vertical)
                .constraints([Constraint::Length(4), Constraint::Length(3), Constraint::Min(1)])
                .split(chunks[1]);
                
            let p = Paragraph::new("Processing chunks and calling Gemini API to generate synthetic conversations...\nThis can take several minutes.")
                .block(Block::default().title("Generating Dataset").borders(Borders::ALL));
            f.render_widget(p, processing_chunks[0]);
            
            let gauge = Gauge::default()
                .block(Block::default().title("Progress").borders(Borders::ALL))
                .gauge_style(Style::default().fg(Color::Magenta).bg(Color::Black).add_modifier(Modifier::ITALIC))
                .ratio(app.dataset_progress.clamp(0.0, 1.0));
            f.render_widget(gauge, processing_chunks[1]);
            
            let width = processing_chunks[2].width.saturating_sub(2) as usize;
            let log_items: Vec<ListItem> = app.dataset_logs.iter().map(|log| {
                let wrapped = textwrap::wrap(log.as_str(), width);
                let lines: Vec<Line> = wrapped.into_iter().map(|w| Line::from(w.into_owned())).collect();
                ListItem::new(lines)
            }).collect();
            
            let log_list = List::new(log_items)
                .block(Block::default().borders(Borders::ALL).title("Logs"))
                .highlight_style(Style::default().bg(Color::DarkGray).fg(Color::White));
            f.render_stateful_widget(log_list, processing_chunks[2], &mut app.dataset_logs_state);
        }
        CurrentScreen::DatasetGenDone => {
            let path = app.dataset_path_input.as_str();
            let text = format!("Dataset generated successfully!\nSaved to: {}\n\nPress Enter to return to menu", path);
            let p = Paragraph::new(text)
                .block(Block::default().title("Success").borders(Borders::ALL))
                .wrap(ratatui::widgets::Wrap { trim: true });
            f.render_widget(p, chunks[1]);
        }
        CurrentScreen::DatasetGenError => {
            let err = app.error_message.as_ref().map(|s| s.as_str()).unwrap_or("Unknown Error");
            let p = Paragraph::new(format!("Dataset Generation Error:\n{}\n\nPress Esc or Enter to return (Use Up/Down to scroll)", err))
                .block(Block::default().title("Error").borders(Borders::ALL))
                .wrap(ratatui::widgets::Wrap { trim: true })
                .scroll((app.dataset_error_scroll, 0));
            f.render_widget(p, chunks[1]);
        }
        CurrentScreen::LoraTrainSelect => {
            let lora_chunks = ratatui::layout::Layout::default()
                .direction(ratatui::layout::Direction::Vertical)
                .constraints([
                    ratatui::layout::Constraint::Length(3),
                    ratatui::layout::Constraint::Length(3),
                    ratatui::layout::Constraint::Min(1),
                ].as_ref())
                .split(chunks[1]);

            let list_chunks = ratatui::layout::Layout::default()
                .direction(ratatui::layout::Direction::Horizontal)
                .constraints([
                    ratatui::layout::Constraint::Percentage(50),
                    ratatui::layout::Constraint::Percentage(50),
                ].as_ref())
                .split(lora_chunks[2]);

            let search_border_style = if app.lora_select_focus == crate::app::LoraSelectFocus::Search {
                Style::default().fg(Color::Yellow)
            } else {
                Style::default()
            };
            
            let search_text = format!("> {}", app.lora_search_input);
            let search_p = Paragraph::new(search_text)
                .block(Block::default().borders(Borders::ALL).title("Fuzzy Search").border_style(search_border_style));
            f.render_widget(search_p, lora_chunks[0]);
            
            if app.lora_select_focus == crate::app::LoraSelectFocus::Search {
                f.set_cursor_position((
                    lora_chunks[0].x + 3 + app.lora_search_input.len() as u16,
                    lora_chunks[0].y + 1,
                ));
            }

            let tags_border_style = if app.lora_select_focus == crate::app::LoraSelectFocus::Tags {
                Style::default().fg(Color::Yellow)
            } else {
                Style::default()
            };
            
            let mut tag_spans = Vec::new();
            for (i, (tag, count)) in app.lora_available_tags.iter().enumerate() {
                let display = format!("{} ({})", tag, count);
                let is_active_filter = Some(tag.clone()) == app.lora_selected_tag;
                let is_focused = app.lora_tag_state.selected() == Some(i) && app.lora_select_focus == crate::app::LoraSelectFocus::Tags;
                
                let mut style = Style::default();
                if is_active_filter {
                    style = style.fg(Color::Green).add_modifier(ratatui::style::Modifier::BOLD);
                }
                if is_focused {
                    style = style.bg(Color::DarkGray).fg(Color::White);
                }
                
                tag_spans.push(ratatui::text::Span::styled(format!(" {} ", display), style));
                tag_spans.push(ratatui::text::Span::raw(" "));
            }
            if tag_spans.is_empty() {
                tag_spans.push(ratatui::text::Span::raw("No tags available"));
            }
            
            let tags_p = Paragraph::new(ratatui::text::Line::from(tag_spans))
                .block(Block::default().borders(Borders::ALL).title("Filter by Tag (Left/Right to navigate, Enter to toggle)").border_style(tags_border_style))
                .wrap(ratatui::widgets::Wrap { trim: true });
            f.render_widget(tags_p, lora_chunks[1]);

            let left_border_style = if app.lora_select_focus == crate::app::LoraSelectFocus::AvailableList {
                Style::default().fg(Color::Yellow)
            } else {
                Style::default()
            };

            let avail_width = list_chunks[0].width.saturating_sub(4) as usize;
            let avail_items: Vec<ListItem> = app.filtered_available_datasets.iter().map(|item| {
                let text = if item.tags.is_empty() {
                    item.name.clone()
                } else {
                    format!("{} [{}]", item.name, item.tags.join(", "))
                };
                let wrapped = textwrap::wrap(&text, avail_width.max(10));
                let lines: Vec<ratatui::text::Line> = wrapped.into_iter().map(|w| ratatui::text::Line::from(w.into_owned())).collect();
                ListItem::new(lines)
            }).collect();
            let avail_list = List::new(avail_items)
                .block(Block::default().borders(Borders::ALL).title("Available Datasets (Press Enter to Add)").border_style(left_border_style))
                .highlight_style(Style::default().bg(Color::DarkGray).fg(Color::White))
                .highlight_symbol(">> ");
            f.render_stateful_widget(avail_list, list_chunks[0], &mut app.available_datasets_state);

            let right_border_style = if app.lora_select_focus == crate::app::LoraSelectFocus::SelectedList {
                Style::default().fg(Color::Yellow)
            } else {
                Style::default()
            };

            let sel_width = list_chunks[1].width.saturating_sub(4) as usize;
            let sel_items: Vec<ListItem> = app.selected_datasets.iter().map(|item| {
                let text = if item.tags.is_empty() {
                    item.name.clone()
                } else {
                    format!("{} [{}]", item.name, item.tags.join(", "))
                };
                let wrapped = textwrap::wrap(&text, sel_width.max(10));
                let lines: Vec<ratatui::text::Line> = wrapped.into_iter().map(|w| ratatui::text::Line::from(w.into_owned())).collect();
                ListItem::new(lines)
            }).collect();
            let sel_list = List::new(sel_items)
                .block(Block::default().borders(Borders::ALL).title("Selected Datasets (Press Ctrl+S to Train)").border_style(right_border_style))
                .highlight_style(Style::default().bg(Color::DarkGray).fg(Color::White))
                .highlight_symbol(">> ");
            f.render_stateful_widget(sel_list, list_chunks[1], &mut app.selected_datasets_state);
        }
        CurrentScreen::LoraTrainNameInput => {
            let text = format!("Enter a name for your LoRA Adapter (e.g. anatomy_expert):\n\n> {}\n\n(Press Enter to start training, Esc to back out)", app.lora_name_input);
            let p = Paragraph::new(text)
                .block(Block::default().title("Name LoRA Adapter").borders(Borders::ALL))
                .wrap(ratatui::widgets::Wrap { trim: true });
            f.render_widget(p, chunks[1]);
            f.set_cursor_position((
                chunks[1].x + 3 + app.lora_name_input.len() as u16,
                chunks[1].y + 3,
            ));
        }
        CurrentScreen::LoraTrainProcessing => {
            let log_items: Vec<ListItem> = app.lora_logs.iter().map(|log| {
                let width = chunks[1].width.saturating_sub(2) as usize;
                let wrapped = textwrap::wrap(log.as_str(), width);
                let lines: Vec<Line> = wrapped.into_iter().map(|w| Line::from(w.into_owned())).collect();
                ListItem::new(lines)
            }).collect();
            
            let log_list = List::new(log_items)
                .block(Block::default().borders(Borders::ALL).title(format!("Training LoRA: {} (via Modal)", app.lora_name_input)))
                .highlight_style(Style::default().bg(Color::DarkGray).fg(Color::White));
            f.render_stateful_widget(log_list, chunks[1], &mut app.lora_logs_state);
        }
        CurrentScreen::LoraTrainDone => {
            let text = format!("Training Complete!\n\nYour GGUF has been successfully trained and downloaded to:\n{}\n\nPress Enter to return", app.lora_output_gguf);
            let p = Paragraph::new(text)
                .block(Block::default().title("Success").borders(Borders::ALL))
                .wrap(ratatui::widgets::Wrap { trim: true });
            f.render_widget(p, chunks[1]);
        }
        CurrentScreen::LoraTrainError => {
            let err = app.error_message.as_ref().map(|s| s.as_str()).unwrap_or("Unknown Error");
            let title = format!("Training Failed (Press Esc or Enter to return): {}", err);
            
            let mut log_items: Vec<ListItem> = app.lora_logs.iter().map(|log| {
                let width = chunks[1].width.saturating_sub(2) as usize;
                let wrapped = textwrap::wrap(log.as_str(), width);
                let lines: Vec<Line> = wrapped.into_iter().map(|w| Line::from(w.into_owned())).collect();
                ListItem::new(lines)
            }).collect();
            
            if log_items.is_empty() {
                log_items.push(ListItem::new("No logs captured before error occurred."));
            }
            
            let log_list = List::new(log_items)
                .block(Block::default().borders(Borders::ALL).title(title).border_style(Style::default().fg(Color::Red)))
                .highlight_style(Style::default().bg(Color::Red).fg(Color::White));
            f.render_stateful_widget(log_list, chunks[1], &mut app.lora_logs_state);
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
