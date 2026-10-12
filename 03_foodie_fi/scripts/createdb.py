import sqlite3
from pathlib import Path

DB_PATH = Path(__file__).parent / "foodie_fi.db"
SCHEMA_PATH = Path(__file__).parent / "schema.sql"

conn = sqlite3.connect(DB_PATH)

try:
    conn.execute("PRAGMA foreign_keys = ON")

    schema = SCHEMA_PATH.read_text(encoding="utf-8")
    conn.executescript(schema)

    print(f"Database created at: {DB_PATH}")

finally:
    conn.close()