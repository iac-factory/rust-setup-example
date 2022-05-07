use std::env;

use hyper::{Client};
use hyper::body::{Buf, HttpBody};
use hyper_tls::HttpsConnector;

use tokio::fs::File;
use tokio::io::{AsyncWriteExt};

extern { fn runtime(); }

// A simple type alias so as to DRY.
type Result<T> = std::result::Result<T, Box<dyn std::error::Error + Send + Sync>>;

#[tokio::main]
async fn main() -> Result<()> {
    unsafe { runtime(); }

    let https = HttpsConnector::new();
    let client = Client::builder().build::<_, hyper::Body>(https);

    let mut response = client.get("https://nodejs.org/dist/latest".parse().unwrap()).await?;
    assert_eq!(response.status(), 200);

    let mut file = File::create("buffer.stream").await?;
    while let Some(chunk) = response.body_mut().data().await {
        file.write_all(chunk.expect("Error Reading Buffer Stream").chunk()).await?;
    }

    Ok(())
}
