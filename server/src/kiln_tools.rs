use std::env;

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
                dbg!(slim_kiln);
            } else {
                println!("Invalid credentials!");
            }
        },
        "view" => {
            let res = login(args[2].clone(), args[3].clone()).await;
            if let Some(res) = res {
                let view_kiln = &get_view(&res, res.controller_ids[0].clone()).await.kilns[0];
                dbg!(view_kiln);
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
"#);
}
