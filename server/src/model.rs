use std::collections::HashMap;
use chrono::{DateTime, Utc};
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
#[derive(Debug, Deserialize, Serialize, Clone)]
pub struct User {
    pub email: String,
    pub password: String
}


#[derive(Debug, Deserialize, Serialize, Clone)]
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
pub struct LoginError {
    message: String
}

#[derive(Debug, Deserialize, Serialize)]

pub struct Firing {
    pub uuid: String,
    #[serde(with = "epoch_date")]
    pub time: DateTime<Utc>,
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
    pub serial_number: String,
    pub status: SlimStatus,
    //TODO maybe enum?
    pub t_scale: char,
    //TODO parse into date
    #[serde(rename = "updatedAt")]
    pub updated_at: DateTime<Utc>,
    pub num_zones: u16,
    #[serde(flatten)]
    pub zones: HashMap<String, u16>
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


#[derive(Debug, Deserialize, Serialize)]
pub struct ViewResponse {
    pub kilns: Vec<ViewKiln>
}
#[derive(Debug, Deserialize, Serialize, Clone)]
pub struct ViewKiln {
    pub name: String,
    pub users: Vec<String>,
    pub is_premium: bool,
    pub status: ViewStatus,
    pub config: ViewConfig,
    pub program: ViewProgram,
    pub log_request: bool,
    pub mac_address: String,
    pub serial_number: String,
    pub firmware_version: String,
    pub product: String,
    pub external_id: String,
    #[serde(rename = "createdAt")]
    pub created_at: DateTime<Utc>,
    #[serde(rename = "updatedAt")]
    pub updated_at: DateTime<Utc>,
    pub firings_count: u16,
    pub is_premium_updated: DateTime<Utc>,
    #[serde(with = "epoch_date")]
    pub latest_firing_start_time: DateTime<Utc>,
    pub latest_firing: ViewLastFiring
}
#[derive(Debug, Deserialize, Serialize, Clone)]
pub struct ViewStatus {
    pub _id: String,
    pub fw: String,
    pub mode: String,
    //TODO Enum
    pub alarm: String,
    pub num_fire: u16,
    pub firing: ViewFiring,
    pub diag: ViewDiag,
    pub error: ViewError,
    #[serde(flatten)]
    pub zones: HashMap<String, u16>
}
#[derive(Debug, Deserialize, Serialize, Clone)]
pub struct ViewFiring {
    pub set_pt: u16,
    pub step: String,
    pub fire_min: u16,
    pub fire_hour: u16,
    pub hold_min: u16,
    pub hold_hour: u16,
    pub start_min: u16,
    pub start_hour: u16,
    pub cost: u16,
    pub etr: String
}
#[derive(Debug, Deserialize, Serialize, Clone)]
pub struct ViewDiag {
    pub a1: u16,
    pub a2: u16,
    pub a3: u16,
    pub nl: u16,
    pub fl: u16,
    pub v1: u16,
    pub v2: u16,
    pub v3: u16,
    pub vs: u16,
    pub board_t: u16,
    pub last_err: u16,
    pub date: DateTime<Utc>
}
#[derive(Debug, Deserialize, Serialize, Clone)]
pub struct ViewError {
    err_text: String,
    err_num: u16
}

#[derive(Debug, Deserialize, Serialize, Clone)]
pub struct ViewConfig {
    pub _id: String,
    pub err_codes: String,
    pub t_scale: char,
    pub no_load: u16,
    pub full_load: u16,
    pub num_zones: u16
}

#[derive(Debug, Deserialize, Serialize, Clone)]
pub struct ViewProgram {
    pub _id: String,
    pub name: String,
    //TODO maybe enum
    #[serde(rename = "type")]
    pub program_type: String,
    pub alarm_t: u16,
    //TODO also enum :
    pub speed: String,
    pub cone: String,
    pub num_steps: u16,
    pub steps: Vec<ViewSteps>
}
#[derive(Debug, Deserialize, Serialize, Clone)]
pub struct ViewSteps {
    _id: String,
    t: u16,
    hr: u16,
    mn: u16,
    rt: u16,
    num: u16
}

#[derive(Debug, Deserialize, Serialize, Clone)]
pub struct ViewLastFiring {
    #[serde(with = "epoch_date")]
    pub start_time: DateTime<Utc>,
    #[serde(with = "epoch_date")]
    pub update_time: DateTime<Utc>,
    pub just_ended: bool,
    pub ended: bool,
    #[serde(with = "epoch_date_option")]
    pub ended_time: Option<DateTime<Utc>>
}

mod epoch_date {
    use chrono::{DateTime, Utc, TimeZone};
    use serde::{self, Deserialize, Serializer, Deserializer};

    pub fn serialize<S>(
        date: &DateTime<Utc>,
        serializer: S,
    ) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        serializer.serialize_str(date.timestamp_millis().to_string().as_str())
    }

    pub fn deserialize<'de, D>(
        deserializer: D,
    ) -> Result<DateTime<Utc>, D::Error>
    where
        D: Deserializer<'de>,
    {
        let s = String::deserialize(deserializer)?;
        Ok(Utc.timestamp_millis(s.parse().map_err(serde::de::Error::custom)?))
    }
}
mod epoch_date_option {
    use chrono::{DateTime, Utc, TimeZone};
    use serde::{self, Deserialize, Serializer, Deserializer};

    pub fn serialize<S>(
        opt: &Option<DateTime<Utc>>,
        serializer: S,
    ) -> Result<S::Ok, S::Error>
    where
        S: Serializer,
    {
        match *opt {
            Some(ref date) => serializer.serialize_str(date.timestamp_millis().to_string().as_str()),
            None => serializer.serialize_none()
        }
    }

    pub fn deserialize<'de, D>(
        deserializer: D,
    ) -> Result<Option<DateTime<Utc>>, D::Error>
    where
        D: Deserializer<'de>,
    {
        let opt: Option<String> = Option::deserialize(deserializer)?;
        if let Some(s) = opt {
            Ok(Some(Utc.timestamp_millis(s.parse().map_err(serde::de::Error::custom)?)))
        } else {
            Ok(None)
        }
    }
}
