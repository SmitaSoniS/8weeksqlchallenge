import sqlite3
import pandas as pd
from pathlib import Path

BASE_DIR = Path(__file__).parent.parent
RAW_DATA = BASE_DIR / "raw_data"
DB_PATH = BASE_DIR / "casestudy1.db"

sales = pd.read_csv(RAW_DATA / "sales.csv")
menu = pd.read_csv(RAW_DATA / "menu.csv")
members = pd.read_csv(RAW_DATA / "members.csv")

conn = sqlite3.connect("D:/code/SQL/Practice/8weeksqlchallenge/01_dannys_diner/casestudy1.db")

sales.to_sql("sales", conn, if_exists="replace", index=False)
menu.to_sql("menu", conn, if_exists="replace", index=False)
members.to_sql("members", conn, if_exists="replace", index=False)

conn.close()

print("Database created")