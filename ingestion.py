import math
import pandas as pd
from sqlalchemy import create_engine, text
from tqdm import tqdm

#link to the november 2025 green taxi trips dataset
PARQUET_URL = "https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2025-11.parquet"

#link to taxi zones dataset
CSV_URL = "https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv"

DB_USER = "postgres"
DB_PASSWORD = "postgres"
DB_HOST = "db"
DB_PORT = 5432
DB_NAME = "ny_taxi"

GREEN_TABLE = "green_trips"
ZONE_TABLE = "taxi_zone"

CHUNK_SIZE_GREEN = 10000
CHUNK_SIZE_ZONE = 1000

def load_data(df: pd.DataFrame, table_name: str, engine, chunk_size: int) -> None:
    total_rows = len(df)
    total_chunks = math.ceil(total_rows / chunk_size)

    print(f"Loading {total_rows} rows into '{table_name}' in {total_chunks} chunks...")

    for i in tqdm(range(total_chunks), desc=f"Writing {table_name}", unit="chunk"):
        start = i * chunk_size
        end = start + chunk_size
        chunk = df.iloc[start:end]

        if_exists_mode = "replace" if i == 0 else "append"

        chunk.to_sql(
            name=table_name,
            con=engine,
            if_exists=if_exists_mode,
            index=False,
            method="multi",
        )

def main() -> None:
    engine = create_engine(
        f"postgresql+psycopg2://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
    )

    print("Connected to database")

    print("Reading green trip parquet file...")
    df_green = pd.read_parquet(PARQUET_URL)
    print(f"Green trips rows found: {len(df_green)}")

    load_data(
        df=df_green,
        table_name=GREEN_TABLE,
        engine=engine,
        chunk_size=CHUNK_SIZE_GREEN,
    )

    print("Reading taxi zone lookup csv file...")
    df_zones = pd.read_csv(CSV_URL)
    print(f"Taxi zone rows found: {len(df_zones)}")

    load_data(
        df=df_zones,
        table_name=ZONE_TABLE,
        engine=engine,
        chunk_size=CHUNK_SIZE_ZONE,
    )

    with engine.connect() as conn:
        green_count = conn.execute(text(f"SELECT COUNT(*) FROM {GREEN_TABLE}")).scalar()
        zone_count = conn.execute(text(f"SELECT COUNT(*) FROM {ZONE_TABLE}")).scalar()

    print(f"{GREEN_TABLE} row count: {green_count}")
    print(f"{ZONE_TABLE} row count: {zone_count}")
    print("Done")


if __name__ == "__main__":
    main()