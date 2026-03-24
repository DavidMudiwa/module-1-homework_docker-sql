select * from green_trips 
where lpep_pickup_datetime = '2025-11-18' limit 1;

select * from taxi_zone
select count(*) from green_trips
where lpep_pickup_datetime >= '2025-11-01' and lpep_pickup_datetime < '2025-12-01' and trip_distance <= 1

select lpep_pickup_datetime, sum(trip_distance) from green_trips
where trip_distance < 100
group by lpep_pickup_datetime
order by sum(trip_distance) desc


SELECT gt."PULocationID", sum(gt.total_amount), tz."Zone"
FROM green_trips gt
INNER JOIN taxi_zone tz
  ON gt."PULocationID" = tz."LocationID"
WHERE gt."lpep_pickup_datetime" >= '2025-11-18'
  AND gt."lpep_pickup_datetime" < '2025-11-19'
group by gt."PULocationID", tz."Zone"
ORDER BY sum(gt.total_amount) DESC;

select tz."Zone", gt."tip_amount"
FROM green_trips gt
INNER JOIN taxi_zone tz
  ON gt."DOLocationID" = tz."LocationID"
WHERE gt."lpep_pickup_datetime" >= '2025-11-01'
  AND gt."lpep_pickup_datetime" < '2025-12-01'
  and gt."PULocationID" = '74'