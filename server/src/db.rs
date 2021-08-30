use std::path::PathBuf;
use r2d2_sqlite::SqliteConnectionManager;
use r2d2::Pool;
use lazy_static::lazy_static;
use rusqlite::params;

use crate::model::ViewKiln;

lazy_static!{
    static ref POOL: Pool<SqliteConnectionManager> = {
        let mut home_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
        home_dir.push("db.sqlite3");
        let manager = SqliteConnectionManager::file(home_dir);
        let pool = Pool::new(manager).unwrap();
        let conn = pool.get().unwrap();
        conn.execute("CREATE TABLE data (
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
    conn.execute("INSERT OR IGNORE INTO data (time, data) VALUES (?1, ?2)", params![time, data]).unwrap();
}
