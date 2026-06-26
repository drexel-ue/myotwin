fn main() {
    let html = std::fs::read_to_string("/Users/ikkeshpack/.gemini/antigravity-ide/brain/57cd08db-c32f-4aea-ad75-eeea2c692c91/scratch/anna_search.html").unwrap();
    let parts: Vec<&str> = html.split("href=\"/md5/").collect();
    
    let re_title = regex::Regex::new(r#"^([a-fA-F0-9]{32})"[^>]*>(.*?)</a>"#).unwrap();
    let re_author = regex::Regex::new(r#"<a href="/search\?q=[^"]*"[^>]*>(?:<span[^>]*></span>)?\s*(.*?)</a>"#).unwrap();
    let re_meta = regex::Regex::new(r#"·\s*([a-zA-Z0-9]+)\s*·\s*([0-9.]+(?:MB|KB|GB))"#).unwrap();
    
    for (i, part) in parts.iter().skip(1).enumerate() {
        if i >= 10 { break; }
        
        let md5 = if let Some(cap) = re_title.captures(part) {
            cap.get(1).map_or("", |m| m.as_str())
        } else { "" };
        
        let title = if let Some(cap) = re_title.captures(part) {
            cap.get(2).map_or("", |m| m.as_str())
        } else { "" };
        
        let author = if let Some(cap) = re_author.captures(part) {
            cap.get(1).map_or("", |m| m.as_str())
        } else { "" };
        
        let format = if let Some(cap) = re_meta.captures(part) {
            cap.get(1).map_or("", |m| m.as_str())
        } else { "unknown" };
        
        let size = if let Some(cap) = re_meta.captures(part) {
            cap.get(2).map_or("", |m| m.as_str())
        } else { "unknown" };
        
        println!("{} | {} | {} | {} | {}", md5, title, author, format, size);
    }
}
