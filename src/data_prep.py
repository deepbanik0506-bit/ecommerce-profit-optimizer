import pandas as pd
import sqlite3

# Load data
df = pd.read_csv("data/raw/superstore.csv", encoding="latin1")

# Clean column names
df.columns = (
    df.columns
    .str.strip()
    .str.lower()
    .str.replace(" ", "_")
    .str.replace("-", "_")
)

# Convert dates (force errors to surface)
df["order_date"] = pd.to_datetime(df["order_date"], errors="coerce")
df = df.dropna(subset=["ship_date"])

# Drop rows with critical nulls
df = df.dropna(subset=["order_date", "sales", "profit"])

# Derived metrics
df["profit_margin"] = df["profit"] / df["sales"]
df["order_year"] = df["order_date"].dt.year
df["order_month"] = df["order_date"].dt.to_period("M").astype(str)

# Guard against division issues
df.loc[df["sales"] == 0, "profit_margin"] = None

# Quick validation prints
print("Rows after cleaning:", len(df))
print("\nNull check:\n", df.isnull().sum())

# Save cleaned CSV
df.to_csv("data/processed/cleaned_superstore.csv", index=False)

# Create SQLite DB
conn = sqlite3.connect("data/processed/ecommerce.db")

# Load table
df.to_sql("orders", conn, if_exists="replace", index=False)

conn.close()

print("\nData pipeline complete.")