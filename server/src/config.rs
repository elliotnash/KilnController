use std::path::PathBuf;
use std::fs;

use serde::{Deserialize, Serialize};

#[derive(Debug, Deserialize, Serialize)]
pub struct Config {
    pub bartinst: Bartinst
}

#[derive(Debug, Deserialize, Serialize)]
pub struct Bartinst {
    pub email: String,
    pub password: String
}

impl Config {
    pub fn load() -> Self {
        let mut home_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
        home_dir.push("config.toml");
        let config_file = fs::read_to_string(home_dir).unwrap();
        toml::from_str(&config_file).unwrap()
    }
}
