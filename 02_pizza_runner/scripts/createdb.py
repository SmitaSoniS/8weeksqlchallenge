import sqlite3

conn = sqlite3.connect("casestudy2.db")

with open("02_pizza_runner\scripts\schema.sql", "r") as f:
    schema = f.read()

conn.executescript(schema)

conn.close()

print("Database created")