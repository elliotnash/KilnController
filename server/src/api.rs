use actix_web::{get, web, App, HttpServer, Responder, Result};
use crate::{LoginResponse, CONFIG, db};
use crate::request::get_view;

#[get("/info")]
async fn info(cred: web::Data<LoginResponse>) -> Result<impl Responder> {
    if let Ok(vr) = get_view(&cred, cred.controller_ids[0].clone()).await {
        Ok(web::Json(vr.kilns[0].clone()))
    } else {
        Err(actix_web::error::ErrorInternalServerError("Internal server error"))
    }
}

#[get("/firings")]
async fn firings() -> Result<impl Responder> {
    if let Ok(firings) = db::get_firings() {
        Ok(web::Json(firings))
    } else {
        Err(actix_web::error::ErrorInternalServerError("Internal server error"))
    }
}

#[get("/firing/{uuid}")]
async fn firing(uuid: web::Path<String>) -> Result<impl Responder> {
    if let Ok(kv) = db::get_updates(uuid.to_string()) {
        Ok(web::Json(kv))
    } else {
        Err(actix_web::error::ErrorInternalServerError("Internal server error"))
    }
}

pub async fn run(cred: LoginResponse) -> Result<(), std::io::Error> {
    HttpServer::new(move || {
        App::new()
            .app_data(web::Data::new(cred.clone()))
            .service(info)
            .service(firings)
            .service(firing)
    })
    .bind(("0.0.0.0", CONFIG.http.port))?
    .run()
    .await
}
