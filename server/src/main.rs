use std::env;
use reqwest::{StatusCode, header::HeaderMap};

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
        "slim" => {
            let res = login(args[2].clone(), args[3].clone()).await;
            if let Some(res) = res {
                get_slim(&res, res.controller_ids[0].clone()).await;
            } else {

            }
        },
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

async fn get_slim(cred: &model::LoginResponse, controller_id: String) {
    // set headers
    let mut headers = HeaderMap::new();
    headers.insert("x-app-name-token", "kiln-aid".parse().unwrap());
    headers.insert("accept", "application/json".parse().unwrap());
    headers.insert("content-type", "application/json".parse().unwrap());
    headers.insert("origin", "http://localhost".parse().unwrap());
    headers.insert("x-requested-with", "com.bartinst.kilnaid".parse().unwrap());
    headers.insert("sec-fetch-site", "cross-site".parse().unwrap());
    headers.insert("sec-fetch-mode", "cors".parse().unwrap());
    headers.insert("sec-fetch-dest", "empty".parse().unwrap());
    headers.insert("referer", "http://localhost/".parse().unwrap());
    headers.insert("accept-encoding", "gzip, deflate".parse().unwrap());
    headers.insert("accept-language", "en-US,en;q=0.9".parse().unwrap());

    let client = reqwest::Client::builder()
        .default_headers(headers)
        .user_agent("Mozilla/5.0 (Linux; Android 11; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/92.0.4515.159 Mobile Safari/537.36")
        .gzip(true)
        .build().unwrap();
    let slim_req = model::SlimRequest::new(controller_id);
    let res = client.post(format!("https://kiln.bartinst.com/kilns/slim?token=${}&user_email=${}",
        cred.authentication_token, cred.email))
        .json(&slim_req)
        .send().await.unwrap();
    dbg!(&res);
    let body = res.text().await.unwrap();
    dbg!(body);
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
