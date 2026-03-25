# Data Engineering Zoomcamp -- Module 1 Homework

This repository contains my answers to the\
[Module 1 Homework (Docker &
SQL)](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/cohorts/2026/01-docker-terraform/homework.md)\
for **Data Engineering by DataTalksClub**.

------------------------------------------------------------------------

## Question 1

Created a Dockerfile from which Docker builds an image:

``` dockerfile
FROM python:3.13

WORKDIR /app

RUN pip install --no-cache-dir pandas pyarrow sqlalchemy psycopg2-binary requests tqdm

ENTRYPOINT [ "/bin/bash" ]
```

### Build the image:

``` bash
docker build -t python313-bash .
```

### Run the container:

``` bash
docker run -it python313-bash
```

### Check pip version:

``` bash
pip --version
```

**Answer:** `25.3`

------------------------------------------------------------------------

## Question 2

Created a `docker-compose.yaml` file with services for PostgreSQL,
pgAdmin, and the Python app.

``` yaml
services:
  db:
    container_name: postgres
    image: postgres:17-alpine
    environment:
      POSTGRES_USER: 'postgres'
      POSTGRES_PASSWORD: 'postgres'
      POSTGRES_DB: 'ny_taxi'
    ports:
      - '5433:5432'
    volumes:
      - vol-pgdata:/var/lib/postgresql/data

  pgadmin:
    container_name: pgadmin
    image: dpage/pgadmin4:latest
    environment:
      PGADMIN_DEFAULT_EMAIL: "pgadmin@pgadmin.com"
      PGADMIN_DEFAULT_PASSWORD: "pgadmin"
    ports:
      - "8080:80"
    volumes:
      - vol-pgadmin_data:/var/lib/pgadmin

  app:
    build: .
    volumes:
      - .:/app
    stdin_open: true
    tty: true

volumes:
  vol-pgdata:
    name: vol-pgdata
  vol-pgadmin_data:
    name: vol-pgadmin_data
```

**Answer:** `db:5432, postgres:5432`

------------------------------------------------------------------------

## Question 3

``` sql
SELECT COUNT(*)
FROM green_trips
WHERE lpep_pickup_datetime >= '2025-11-01'
AND lpep_pickup_datetime < '2025-12-01'
AND trip_distance <= 1;
```

**Answer:** `8007`

------------------------------------------------------------------------

## Question 4

``` sql
SELECT lpep_pickup_datetime, SUM(trip_distance)
FROM green_trips
WHERE trip_distance < 100
GROUP BY lpep_pickup_datetime
ORDER BY SUM(trip_distance) DESC
LIMIT 1;
```

**Answer:** `2025-11-14`

------------------------------------------------------------------------

## Question 5

``` sql
SELECT gt."PULocationID", SUM(gt.total_amount), tz."Zone"
FROM green_trips gt
INNER JOIN taxi_zone tz ON gt."PULocationID" = tz."LocationID"
WHERE gt."lpep_pickup_datetime" >= '2025-11-18'
AND gt."lpep_pickup_datetime" < '2025-11-19'
GROUP BY gt."PULocationID", tz."Zone"
ORDER BY SUM(gt.total_amount) DESC;
```

**Answer:** `East Harlem North`

------------------------------------------------------------------------

## Question 6

``` sql
SELECT dz."Zone", gt."tip_amount"
FROM green_trips gt
INNER JOIN taxi_zone pu ON gt."PULocationID" = pu."LocationID"
INNER JOIN taxi_zone dz ON gt."DOLocationID" = dz."LocationID"
WHERE gt."lpep_pickup_datetime" >= '2025-11-01'
AND gt."lpep_pickup_datetime" < '2025-12-01'
AND pu."Zone" = 'East Harlem North'
ORDER BY gt."tip_amount" DESC;
```

**Answer:** `Yorkville West`

