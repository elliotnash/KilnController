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

#[derive(Debug, Deserialize, Serialize)]
pub struct SlimResponse {
    pub kilns: Vec<SlimKiln>
}
#[derive(Debug, Deserialize, Serialize)]
pub struct SlimKiln {
    pub _id: String,
    pub mac_address: String,
    //TODO should be enum, need to discover all variants
    pub mode: String,
    pub name: String,
    pub num_zones: u16,
    pub serial_number: String,
    pub status: SlimStatus,
    pub t1: u16,
    pub t2: u16,
    pub t3: u16,
    pub t_scale: char,
    #[serde(rename = "updatedAt")]
    pub updated_at: String
}
#[derive(Debug, Deserialize, Serialize)]
pub struct SlimStatus {
    pub firing: SlimFiring
}
#[derive(Debug, Deserialize, Serialize)]
pub struct SlimFiring {
    pub hold_hour: u16,
    pub hold_min: u16
}
