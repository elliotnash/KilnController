use std::collections::HashMap;

use serde::{Deserialize, Serialize};

#[derive(Debug, Deserialize, Serialize)]
pub struct LoginRequest {
    user: User
}
impl LoginRequest {
    pub fn new(email: String, password: String) -> Self {
        Self{user: User{email, password}}
    }
}
#[derive(Debug, Deserialize, Serialize)]
pub struct User {
    email: String,
    password: String
}

#[derive(Debug, Deserialize, Serialize)]
pub struct LoginResponse {
    authentication_token: String,
    controller_ids: Vec<String>,
    controller_names: HashMap<String, String>,
    email: String,
    needs_to_accept_new_terms_and_conditions: bool,
    new_terms_and_conditions: String,
    redirect_url: String,
    role: Option<String>,
    status: String
}
