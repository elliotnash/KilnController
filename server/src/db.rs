use std::path::PathBuf;
use std::error::Error;
use chrono::{Utc, TimeZone};
use r2d2_sqlite::SqliteConnectionManager;
use r2d2::Pool;
use lazy_static::lazy_static;
use rusqlite::params;
use uuid::Uuid;

use crate::model::{ViewKiln, Firing};

lazy_static!{
    static ref POOL: Pool<SqliteConnectionManager> = {
        let mut home_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
        home_dir.push("db.sqlite3");
        let manager = SqliteConnectionManager::file(home_dir);
        let pool = Pool::new(manager).unwrap();
        let conn = pool.get().unwrap();
        conn.execute("
        CREATE TABLE IF NOT EXISTS data (
            time INTEGER PRIMARY KEY,
            firing TEXT,
            data BLOB
        );", []).unwrap();
        conn.execute("
        CREATE TABLE IF NOT EXISTS firings (
            uuid TEXT PRIMARY KEY,
            time INTEGER
        );", []).unwrap();
        pool
    };
}

pub fn add_update(view_kiln: &ViewKiln, uuid: &Uuid) -> Result<(), Box<dyn Error>> {
    let conn = POOL.get().unwrap();
    let time = view_kiln.updated_at.timestamp_millis();
    let data = serde_json::to_vec(view_kiln).unwrap();
    conn.execute("
    INSERT OR IGNORE INTO data (time, firing, data) VALUES (?1, ?2, ?3);
    ", params![time, uuid.to_string(), data])?;
    Ok(())
}

pub fn add_firing(uuid: &Uuid, time: i64) -> Result<(), Box<dyn Error>> {
    let conn = POOL.get().unwrap();
    conn.execute("
    INSERT OR IGNORE INTO firings (uuid, time) VALUES (?1, ?2);
    ", params![uuid.to_string(), time])?;
    Ok(())
}

pub fn get_firings() -> Result<Vec<Firing>, Box<dyn Error>> {
    let conn = POOL.get().unwrap();
    let mut stmt = conn.prepare("
    SELECT * FROM firings ORDER BY time DESC;
    ")?;

    let mut rows = stmt.query(params![])?;

    let mut firings: Vec<Firing> = Vec::new();
    while let Some(row) = rows.next()? {
        let uuid: String = row.get(0)?;
        let time: i64 = row.get(1)?;
        firings.push(Firing{
            uuid,
            time: Utc.timestamp_millis(time)
        });
    }

    Ok(firings)
}

pub fn get_updates(firing: String) -> Result<Vec<ViewKiln>, Box<dyn Error>> {
    let conn = POOL.get().unwrap();
    let mut stmt = conn.prepare("
    SELECT 
        data
    FROM
        data
    WHERE
        firing = ?1
    ORDER BY
        time DESC;
    ")?;

    let mut rows = stmt.query(params![firing])?;

    let mut kilns: Vec<ViewKiln> = Vec::new();
    while let Some(row) = rows.next()? {
        let data: Vec<u8> = row.get(0)?;
        kilns.push(serde_json::from_slice(&data)?);
    }

    Ok(kilns)
}
