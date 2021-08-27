use std::env;
use reqwest::StatusCode;

mod model;

#[actix_web::main]
async fn main() {
    env::set_var("RUST_LOG", "actix_web=warn,kiln_server=debug");
    env_logger::init();
    let args: Vec<String> = env::args().collect();
    match args[1].as_str() {
        "test-account" => {
            let res = login(args[2].clone(), args[3].clone()).await;
            if res.is_some() {
                println!("Logged in successfully!");
            } else {
                println!("Invalid credentials!");
            }
        },
        "slim" => {},
        "view" => {},
        command => {
            println!("\nThe command `{}` does not exist", command);
            send_help();
        }
    }
}

async fn login(email: String, password: String) -> Option<model::LoginResponse> {
    let client = reqwest::Client::new();
    let login_cred = model::LoginRequest::new(email, password);
    let res = client.post("https://www.bartinst.com/users/login.json")
        .json(&login_cred)
        .send().await.unwrap();
    if res.status() == StatusCode::OK {
        let res = res.json::<model::LoginResponse>().await.unwrap();
        Some(res)
    } else {
        None
    }
}

fn send_help() {
    println!(
r#"
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
