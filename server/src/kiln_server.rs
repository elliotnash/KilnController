use std::time::Duration;
use actix_web::rt::time::sleep;
use lazy_static::lazy_static;
use uuid::Uuid;
use std::convert::TryFrom;

use config::Config;
use log::{info, warn, debug};
use model::LoginResponse;
use request::{get_view, login};

mod api;
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
        let fetch_handle = actix_web::rt::spawn(fetch_task(res.clone()));
        let api_handle = actix_web::rt::spawn(api::run(res));
        actix_web::rt::signal::ctrl_c().await.expect("Could not register ctrl+c handler");
        fetch_handle.abort();
        api_handle.abort();
    } else {
        warn!("Invalid Bartinst credentials! Exiting.");
    }
}

async fn fetch_task(cred: LoginResponse) {
    let mut uuid = Uuid::new_v4();
    loop {
        match get_view(&cred, cred.controller_ids[0].clone()).await {
            Ok(view_res) => {
                let view_kiln = &view_res.kilns[0];
                debug!("recieved kiln update \n{:#?}", view_kiln);
                let average_temp: u16 = view_kiln.status.zones.values().sum::<u16>() / u16::try_from(view_kiln.status.zones.len()).unwrap();
                // if the temp is greater than 100 then we're in a firing and data should be logged, else discard data
                if average_temp > 100 {
                    info!("adding update to database");
                    db::add_firing(&uuid, view_kiln.updated_at.timestamp_millis()).unwrap();
                    db::add_update(view_kiln, &uuid).unwrap();
                } else {
                    info!("not a firing, ignoring data");
                    uuid = Uuid::new_v4()
                }
            },
            Err(err) => {
                warn!("Error requesting kiln data: \n{:#?}", err);
            }
        }
        // update data once per minute
        sleep(Duration::from_secs(60)).await;
    }
}
