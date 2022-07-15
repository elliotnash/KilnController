use actix_cors::Cors;
use actix_web::{get, post, web, App, HttpServer, Responder, Result};
use crate::{LoginResponse, CONFIG, db};
use crate::model::User;
use crate::request::get_view;

#[post("/login")]
async fn login(req: web::Json<User>, cred: web::Data<LoginResponse>) -> Result<impl Responder> {
    if let Ok(res) = crate::request::login(req.email.clone(), req.password.clone()).await {
        if res.controller_ids.contains(&cred.controller_ids[0]) {
            // then we should provider kiln sn as token
            Ok(cred.controller_ids[0].clone())
        } else {
            Err(actix_web::error::ErrorForbidden("User does not have access to the tracked kiln"))
        }
    } else {
        Err(actix_web::error::ErrorUnauthorized("Invalid username or password."))
    }
}

#[get("/{sn}/info")]
async fn info(sn: web::Path<String>, cred: web::Data<LoginResponse>) -> Result<impl Responder> {
    if sn.to_string() == cred.controller_ids[0] {
        if let Ok(vr) = get_view(&cred, cred.controller_ids[0].clone()).await {
            Ok(web::Json(vr.kilns[0].clone()))
        } else {
            Err(actix_web::error::ErrorInternalServerError("Internal server error"))
        }
    } else {
        Err(actix_web::error::ErrorNotFound("Kiln is not tracked"))
    }
}

#[get("/{sn}/firings")]
async fn firings(sn: web::Path<String>, cred: web::Data<LoginResponse>) -> Result<impl Responder> {
    if sn.to_string() == cred.controller_ids[0] {
        if let Ok(firings) = db::get_firings() {
            Ok(web::Json(firings))
        } else {
            Err(actix_web::error::ErrorInternalServerError("Internal server error"))
        }
    } else {
        Err(actix_web::error::ErrorNotFound("Kiln is not tracked"))
    }
}

#[get("/{sn}/firing/{uuid}")]
async fn firing(params: web::Path<(String, String)>, cred: web::Data<LoginResponse>) -> Result<impl Responder> {
    let (sn, uuid) = params.into_inner();
    if sn.to_string() == cred.controller_ids[0] {
        if let Ok(kv) = db::get_updates(uuid.to_string()) {
            Ok(web::Json(kv))
        } else {
            Err(actix_web::error::ErrorInternalServerError("Internal server error"))
        }
    } else {
        Err(actix_web::error::ErrorNotFound("Kiln is not tracked"))
    }
}

pub async fn run(cred: LoginResponse) -> Result<(), std::io::Error> {
    HttpServer::new(move || {
        let cors = Cors::permissive();
        App::new()
            .wrap(cors)
            .app_data(web::Data::new(cred.clone()))
            .service(login)
            .service(info)
            .service(firings)
            .service(firing)
    })
    .bind(("0.0.0.0", CONFIG.http.port))?
    .run()
    .await
}
