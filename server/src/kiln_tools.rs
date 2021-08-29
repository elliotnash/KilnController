use std::{env, time::Duration};

use actix_web::rt::time::sleep;
use chrono::Utc;
use model::LoginResponse;
use requests::{login, get_slim, get_view};

mod model;
mod requests;

#[actix_web::main]
async fn main() {
    env::set_var("RUST_LOG", "actix_web=warn,kiln_server=debug");
    env_logger::init();
    let args: Vec<String> = env::args().collect();
    match args[1].as_str() {
        "test-account" => {
            let res = login(args[2].clone(), args[3].clone()).await;
            if let Some(res) = res {
                println!("Logged in successfully! token: {}, kiln: {}", res.authentication_token, res.controller_ids[0]);
            } else {
                println!("Invalid credentials!");
            }
        },
        "slim" => {
            let res = login(args[2].clone(), args[3].clone()).await;
            if let Some(res) = res {
                let slim_kiln = &get_slim(&res, res.controller_ids[0].clone()).await.kilns[0];
                println!("{:#?}", slim_kiln);
            } else {
                println!("Invalid credentials!");
            }
        },
        "view" => {
            let res = login(args[2].clone(), args[3].clone()).await;
            if let Some(res) = res {
                let view_kiln = &get_view(&res, res.controller_ids[0].clone()).await.kilns[0];
                println!("{:#?}", view_kiln);
            } else {
                println!("Invalid credentials!");
            }
        },
        "test-interval" => {
            let res = login(args[2].clone(), args[3].clone()).await;
            if let Some(res) = res {
                test_interval(&res).await;
            } else {
                println!("Invalid credentials!");
            }
        },
        command => {
            println!("\nThe command `{}` does not exist", command);
            send_help();
        }
    }
}

async fn test_interval(cred: &LoginResponse) {
    let mut last_time = Utc::now();
    loop {
        let slim_kiln = &get_slim(cred, cred.controller_ids[0].clone()).await.kilns[0];
        if slim_kiln.updated_at > last_time {
            let interval = slim_kiln.updated_at - last_time;
            println!("Data was updated. Interval: {}:{:02}.{:04}", interval.num_minutes(), interval.num_seconds()%60, interval.num_milliseconds()%1000);
        }
        last_time = slim_kiln.updated_at;
        sleep(Duration::from_secs(5)).await;
    }
}

fn send_help() {
    println!(r#"
Avaliable commands:
    test-account:
        usage: kiln_server test-account <email> <password>
        description: Tests an email/password combination
    slim:
        usage: kiln_server slim <email> <password> [controller serial number]
        description: Fetches basic info about a users kiln
    view:
        usage: kiln_server view <email> <password> [controller serial number]
        description: Fetches all info about a users kiln
    test-interval:
        usage: kiln_server test-interval <email> <password>
        description: Tests how frequently kiln data is updated server side
"#);
}
