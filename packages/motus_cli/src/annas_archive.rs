use serde::Deserialize;
use std::error::Error;

#[derive(Clone, Debug)]
pub struct Book {
    pub title: String,
    pub author: String,
    pub md5: String,
    pub format: String,
    pub size: String,
}

#[derive(Deserialize)]
struct FastDownloadResponse {
    download_url: Option<String>,
    error: Option<String>,
}

pub async fn search_books(_query: &str) -> Result<Vec<Book>, Box<dyn Error>> {
    // TODO: Implement full HTML scraping of annas-archive.org/search?q={query}
    // For now, return a mock result to demonstrate the TUI flow
    Ok(vec![
        Book {
            title: "Gray's Anatomy".to_string(),
            author: "Henry Gray".to_string(),
            md5: "dummy_md5_1234567890".to_string(),
            format: "pdf".to_string(),
            size: "150MB".to_string(),
        },
        Book {
            title: "Atlas of Human Anatomy".to_string(),
            author: "Frank H. Netter".to_string(),
            md5: "dummy_md5_0987654321".to_string(),
            format: "epub".to_string(),
            size: "85MB".to_string(),
        },
    ])
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

    let _download_url = json
        .download_url
        .ok_or("No download URL returned from API")?;

    // In a real app we'd download the bytes here using reqwest
    // let mut response = client.get(&download_url).send().await?;
    // std::fs::write("...", response.bytes().await?)?;

    Ok(format!("packages/motus_cli/data/books/{}.{}", book.md5, book.format))
}
