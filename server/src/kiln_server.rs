use std::time::Duration;

use actix_web::rt::time::sleep;

mod model;
mod error;
mod request;

#[actix_web::main]
async fn main() {
    let fetch_handle = actix_web::rt::spawn(fetch_task());
    actix_web::rt::signal::ctrl_c().await.expect("Could not register ctrl+c handler");
    fetch_handle.abort();
}

async fn fetch_task() {
    loop {
        println!("Pretend we're updating data rn");
        // update data once per minute
        sleep(Duration::from_secs(60)).await;
    }
}