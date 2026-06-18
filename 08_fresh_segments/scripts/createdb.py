import sqlite3
import pandas as pd

sales = pd.read_csv("sales.csv")
menu = pd.read_csv("menu.csv")
members = pd.read_csv("members.csv")

conn = sqlite3.connect("casestudy1.db")

sales.to_sql("sales", conn, if_exists="replace", index=False)
menu.to_sql("menu", conn, if_exists="replace", index=False)
members.to_sql("members", conn, if_exists="replace", index=False)

conn.close()

print("Database created")