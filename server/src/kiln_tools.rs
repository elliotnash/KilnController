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
            if let Some(res) = res {
                println!("Logged in successfully! token: {}, kiln: {}", res.authentication_token, res.controller_ids[0]);
            } else {
                println!("Invalid credentials!");
            }
        },
        "slim" => {
            let res = login(args[2].clone(), args[3].clone()).await;
            if let Some(res) = res {
                let slim_res = get_slim(&res, res.controller_ids[0].clone()).await;
                dbg!(slim_res);
            } else {
                println!("Invalid credentials!");
            }
        },
        "view" => {
            let res = login(args[2].clone(), args[3].clone()).await;
            if let Some(res) = res {
                let view_res = get_view(&res, res.controller_ids[0].clone()).await;
                dbg!(view_res);
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

async fn get_slim(cred: &model::LoginResponse, controller_id: String) -> model::SlimResponse {
    // set headers
    let mut headers = HeaderMap::new();
    headers.insert("x-app-name-token", "kiln-aid".parse().unwrap());

    let client = reqwest::Client::builder()
        .default_headers(headers)
        .build().unwrap();
    let slim_req = model::SlimRequest::new(controller_id);

    let url = format!("https://kiln.bartinst.com/kilns/slim?token={}&user_email={}",
        cred.authentication_token, cred.email);
    let res = client.post(url)
        .json(&slim_req)
        .send().await.unwrap();
    res.json::<model::SlimResponse>().await.unwrap()
}

async fn get_view(cred: &model::LoginResponse, controller_id: String) -> model::ViewResponse {
    // set headers
    let mut headers = HeaderMap::new();
    headers.insert("x-app-name-token", "kiln-aid".parse().unwrap());

    let client = reqwest::Client::builder()
        .default_headers(headers)
        .build().unwrap();
    let slim_req = model::SlimRequest::new(controller_id);

    let url = format!("https://kiln.bartinst.com/kilns/view?token={}&user_email={}",
        cred.authentication_token, cred.email);
    let res = client.post(url)
        .json(&slim_req)
        .send().await.unwrap();
    let text = res.text().await.unwrap();
    dbg!(&text);
    serde_json::from_str::<model::ViewResponse>(&text).unwrap()
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
