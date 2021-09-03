use std::path::PathBuf;
use chrono::{DateTime, Utc};
use r2d2_sqlite::SqliteConnectionManager;
use r2d2::Pool;
use lazy_static::lazy_static;
use rusqlite::{params, Error};

use crate::model::ViewKiln;

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
            data BLOB
        )", []).unwrap();
        pool
    };
}

pub fn add_update(view_kiln: &ViewKiln) {
    let conn = POOL.get().unwrap();
    let time = view_kiln.updated_at.timestamp_millis();
    let data = serde_json::to_vec(view_kiln).unwrap();
    conn.execute("
    INSERT OR IGNORE INTO data (time, data) VALUES (?1, ?2)
    ", params![time, data]).unwrap();
}

pub fn get_updates(last_time: Option<DateTime<Utc>>) -> Result<Vec<ViewKiln>, Box<dyn std::error::Error>> {
    let conn = POOL.get().unwrap();
    let mut stmt = conn.prepare("
    SELECT 
        data
    FROM
        data
    WHERE
        time >= ?1
    ORDER BY
        time DESC
    LIMIT ?2
    ")?;
    // let data = stmt.query_map(
    //     params![
    //         last_time.map(|t| t.timestamp_millis()).unwrap_or(0),
    //         5
    //     ], 
    //     |row| {
    //         let data: Vec<u8> = row.get(0)?;
    //         let kiln = serde_json::from_slice::<ViewKiln>(&data);
    //         Ok(())
    //     }
    // )?;
    let mut rows = stmt.query(params![
        last_time.map(|t| t.timestamp_millis()).unwrap_or(0),
        5
    ])?;

    let mut kilns: Vec<ViewKiln> = Vec::new();
    while let Some(row) = rows.next()? {
        let data: Vec<u8> = row.get(0)?;
        kilns.push(serde_json::from_slice(&data)?);
    }

    Ok(kilns)
}
