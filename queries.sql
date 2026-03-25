SELECT
  *
FROM
  green_trips
WHERE
  lpep_pickup_datetime = '2025-11-18'
LIMIT
  1;

--Q3

SELECT
  COUNT(*)
FROM
  green_trips
WHERE
  lpep_pickup_datetime >= '2025-11-01'
  AND lpep_pickup_datetime < '2025-12-01'
  AND trip_distance <= 1

  --Q4
SELECT
  lpep_pickup_datetime,
  SUM(trip_distance)
FROM
  green_trips
WHERE
  trip_distance < 100
GROUP BY
  lpep_pickup_datetime
ORDER BY
  SUM(trip_distance) DESC

  --Q5
SELECT
  gt."PULocationID",
  SUM(gt.total_amount),
  tz."Zone"
FROM
  green_trips gt
  INNER JOIN taxi_zone tz ON gt."PULocationID" = tz."LocationID"
WHERE
  gt."lpep_pickup_datetime" >= '2025-11-18'
  AND gt."lpep_pickup_datetime" < '2025-11-19'
GROUP BY
  gt."PULocationID",
  tz."Zone"
ORDER BY
  SUM(gt.total_amount) DESC;

--Q6
SELECT
  dz."Zone",
  gt."tip_amount"
FROM
  green_trips gt
  INNER JOIN taxi_zone pu ON gt."PULocationID" = pu."LocationID"
  INNER JOIN taxi_zone dz ON gt."DOLocationID" = dz."LocationID"
WHERE
  gt."lpep_pickup_datetime" >= '2025-11-01'
  AND gt."lpep_pickup_datetime" < '2025-12-01'
  AND pu."Zone" = 'East Harlem North'
order by  gt."tip_amount" desc;