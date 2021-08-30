use lazy_static::lazy_static;
use reqwest::{StatusCode, header::HeaderMap};

use crate::{error::{Error, Result}, model};

lazy_static!{
    static ref CLIENT: reqwest::Client = {
        // create headers
        let mut headers = HeaderMap::new();
        headers.insert("x-app-name-token", "kiln-aid".parse().unwrap());
        // build client
        reqwest::Client::builder()
            .default_headers(headers)
            .build().unwrap()
    };
}

pub async fn login(email: String, password: String) -> Result<model::LoginResponse> {
    let login_cred = model::LoginRequest::new(email, password);
    let res = CLIENT.post("https://www.bartinst.com/users/login.json")
        .json(&login_cred)
        .send().await.unwrap();
    if res.status() == StatusCode::OK {
        Ok(res.json::<model::LoginResponse>().await?)
    } else {
        Err(Error::LoginError)
    }
}

#[allow(dead_code)]
pub async fn get_slim(cred: &model::LoginResponse, controller_id: String) -> Result<model::SlimResponse> {
    let slim_req = model::SlimRequest::new(controller_id);

    let url = format!("https://kiln.bartinst.com/kilns/slim?token={}&user_email={}",
        cred.authentication_token, cred.email);
    let res = CLIENT.post(url)
        .json(&slim_req)
        .send().await?;
    Ok(res.json::<model::SlimResponse>().await?)
}

pub async fn get_view(cred: &model::LoginResponse, controller_id: String) -> Result<model::ViewResponse> {
    let slim_req = model::SlimRequest::new(controller_id);

    let url = format!("https://kiln.bartinst.com/kilns/view?token={}&user_email={}",
        cred.authentication_token, cred.email);
    let res = CLIENT.post(url)
        .json(&slim_req)
        .send().await?;
        Ok(res.json::<model::ViewResponse>().await?)
}