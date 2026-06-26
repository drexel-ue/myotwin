use serde::Deserialize;
use std::error::Error;

#[derive(Clone, Debug)]
pub struct Book {
    pub title: String,
    pub author: String,
    pub publish_year: Option<String>,
    pub edition: Option<String>,
    pub md5: String,
    pub format: String,
    pub size: String,
}

#[derive(Deserialize)]
struct FastDownloadResponse {
    download_url: Option<String>,
    error: Option<String>,
}

pub async fn search_books(query: &str) -> Result<Vec<Book>, Box<dyn Error>> {
    let url = format!("https://annas-archive.gd/search?q={}", urlencoding::encode(query));
    
    let client = reqwest::Client::builder()
        .user_agent("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36")
        .build()?;
        
    let res = client.get(&url).send().await?;
    if !res.status().is_success() {
        return Err(format!("Search failed with status: {}", res.status()).into());
    }
    
    let html = res.text().await?;
    
    // We split by `href="/md5/` to reliably segment the HTML into individual book blocks
    let parts: Vec<&str> = html.split("href=\"/md5/").collect();
    
    let re_title = regex::Regex::new(r#"^([a-fA-F0-9]{32})"[^>]*>(.*?)</a>"#)?;
    let re_author = regex::Regex::new(r#"<a href="/search\?q=[^"]*"[^>]*>(?:<span[^>]*></span>)?\s*(.*?)</a>"#)?;
    let re_meta = regex::Regex::new(r#"·\s*([a-zA-Z0-9]+)\s*·\s*([0-9.]+(?:MB|KB|GB))(?:\s*·\s*([0-9]{4}))?"#)?;

    let mut books = Vec::new();
    for part in parts.iter().skip(1) {
        if books.len() >= 10 {
            break;
        }

        let cap_title = if let Some(c) = re_title.captures(part) { c } else { continue; };
        
        let md5 = cap_title.get(1).map_or("", |m| m.as_str()).to_string();
        let raw_title = cap_title.get(2).map_or("Unknown Title", |m| m.as_str());
        
        let mut author = "Unknown Author".to_string();
        let mut edition = None;
        
        let mut author_matches = re_author.captures_iter(part);
        if let Some(cap) = author_matches.next() {
            author = cap.get(1).map_or("Unknown Author", |m| m.as_str()).to_string();
        }
        if let Some(cap) = author_matches.next() {
            let publisher_str = cap.get(1).map_or("", |m| m.as_str());
            // Naively look for "edition", "ed.", or ordinal numbers like "5th", "6th"
            if publisher_str.to_lowercase().contains("edition") || publisher_str.to_lowercase().contains("ed.") || publisher_str.contains("th") || publisher_str.contains("nd") || publisher_str.contains("rd") || publisher_str.contains("st") {
                // To keep it clean, we just take the whole publisher string, clean it, and use it if it's short, or try to extract just the edition part.
                // Let's just use the publisher string since it often contains "Publisher, 5th edition, 2006".
                edition = Some(publisher_str.to_string());
            }
        }
        
        let format = if let Some(cap) = re_meta.captures(part) {
            cap.get(1).map_or("unknown", |m| m.as_str()).to_lowercase()
        } else { "unknown".to_string() };
        
        let size = if let Some(cap) = re_meta.captures(part) {
            cap.get(2).map_or("unknown", |m| m.as_str()).to_string()
        } else { "unknown".to_string() };

        let publish_year = if let Some(cap) = re_meta.captures(part) {
            cap.get(3).map(|m| m.as_str().to_string())
        } else { None };

        // Strip HTML tags from title and author
        let strip_html = regex::Regex::new(r#"<[^>]*>"#)?;
        let title_no_html = strip_html.replace_all(raw_title, "").to_string();
        let author_no_html = strip_html.replace_all(&author, "").to_string();
        let edition_no_html = edition.map(|e| strip_html.replace_all(&e, "").to_string());
        
        let title = html_escape::decode_html_entities(&title_no_html).into_owned();
        let author = html_escape::decode_html_entities(&author_no_html).into_owned();
        let edition = edition_no_html.map(|e| html_escape::decode_html_entities(&e).into_owned());
        
        books.push(Book {
            title,
            author,
            publish_year,
            edition,
            md5,
            format,
            size,
        });
    }
    
    if books.is_empty() {
        return Err("No books found or could not parse HTML.".into());
    }
    
    Ok(books)
}

pub async fn download_book(book: &Book, api_key: &str) -> Result<String, Box<dyn Error>> {
    let url = format!(
        "https://annas-archive.gd/dyn/api/fast_download.json?md5={}&key={}",
        book.md5, api_key
    );

    let client = reqwest::Client::new();
    let res = client.get(&url).send().await?;

    if !res.status().is_success() {
        return Err(format!("API Error: {}", res.status()).into());
    }

    let json: FastDownloadResponse = res.json().await?;

    if let Some(err) = json.error {
        return Err(format!("API returned error: {}", err).into());
    }

    let download_url = json
        .download_url
        .ok_or("No download URL returned from API")?;

    let response = client.get(&download_url).send().await?;
    if !response.status().is_success() {
        return Err(format!("Download failed with status: {}", response.status()).into());
    }

    let bytes = response.bytes().await?;
    let ext = if book.format.is_empty() || book.format == "unknown" { "pdf" } else { &book.format };
    
    // Make sure directory exists
    std::fs::create_dir_all("data/books")?;
    
    let path = format!("data/books/{}.{}", book.md5, ext);
    std::fs::write(&path, bytes)?;

    Ok(path)
}
