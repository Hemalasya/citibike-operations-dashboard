-- Clean trips view: 2014-2015, trips between 1 min and 3 hours
CREATE OR REPLACE VIEW `citibike-analysis-513501.citibike.trips_clean` AS
SELECT
  starttime,
  stoptime,
  tripduration,
  start_station_id,
  start_station_name,
  start_station_latitude,
  start_station_longitude,
  end_station_id,
  end_station_name,
  end_station_latitude,
  end_station_longitude,
  usertype,
  DATE(starttime)               AS trip_date,
  EXTRACT(HOUR FROM starttime)  AS start_hour,
  EXTRACT(DAYOFWEEK FROM starttime) AS dow_num,   -- 1 = Sunday
  FORMAT_DATE('%A', DATE(starttime)) AS day_name
FROM `bigquery-public-data.new_york_citibike.citibike_trips`
WHERE starttime >= DATETIME '2014-01-01'
  AND starttime <  DATETIME '2016-01-01'
  AND tripduration BETWEEN 60 AND 10800;