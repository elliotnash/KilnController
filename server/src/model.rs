use std::collections::HashMap;

use serde::{Deserialize, Serialize};

#[derive(Debug, Deserialize, Serialize)]
pub struct LoginRequest {
    pub user: User
}
impl LoginRequest {
    pub fn new(email: String, password: String) -> Self {
        Self{user: User{email, password}}
    }
}
#[derive(Debug, Deserialize, Serialize)]
pub struct User {
    pub email: String,
    pub password: String
}

#[derive(Debug, Deserialize, Serialize)]
pub struct LoginResponse {
    pub authentication_token: String,
    pub controller_ids: Vec<String>,
    pub controller_names: HashMap<String, String>,
    pub email: String,
    pub needs_to_accept_new_terms_and_conditions: bool,
    pub new_terms_and_conditions: String,
    pub redirect_url: String,
    pub role: Option<String>,
    pub status: String
}

#[derive(Debug, Deserialize, Serialize)]
pub struct SlimRequest {
    pub ids: Vec<String>
}
impl SlimRequest {
    pub fn new(id: String) -> Self {
        Self {ids: vec![id]}
    }
}