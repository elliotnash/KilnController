use std::time::Duration;
use actix_web::rt::time::sleep;
use lazy_static::lazy_static;

use config::Config;
use log::{info, warn};
use model::LoginResponse;
use request::{get_view, login};

mod config;
mod db;
mod model;
mod error;
mod request;

lazy_static!{
    static ref CONFIG: Config = Config::load();
}

#[actix_web::main]
async fn main() {
    // init logger
    std::env::set_var("RUST_LOG", "actix_web=warn,kiln_server=debug");
    env_logger::init();

    // login and start fetch loop
    let res = login(CONFIG.bartinst.email.clone(), CONFIG.bartinst.password.clone()).await;
    if let Ok(res) = res {
        info!("Successfuly logged into Bartinst");
        let fetch_handle = actix_web::rt::spawn(fetch_task(res));
        actix_web::rt::signal::ctrl_c().await.expect("Could not register ctrl+c handler");
        fetch_handle.abort();
    } else {
        warn!("Invalid Bartinst credentials! Exiting.");
    }
}

async fn fetch_task(cred: LoginResponse) {
    loop {
        match get_view(&cred, cred.controller_ids[0].clone()).await {
            Ok(view_res) => {
                let view_kiln = &view_res.kilns[0];
                info!("recieved kiln update \n{:#?}", view_kiln);
                info!("Adding update");
                db::add_update(view_kiln).unwrap();
            },
            Err(err) => {
                warn!("Error requesting kiln data: \n{:#?}", err);
            }
        }
        // update data once per minute
        sleep(Duration::from_secs(60)).await;
    }
}
