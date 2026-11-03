-- Data quality checks for the 2014-2015 analysis window
SELECT
  COUNT(*) AS total_trips,
  COUNTIF(tripduration < 60) AS under_1_min,
  COUNTIF(tripduration > 10800) AS over_3_hours,
  COUNTIF(start_station_id IS NULL OR end_station_id IS NULL) AS missing_station,
  COUNTIF(start_station_id = end_station_id) AS same_start_end,
  COUNTIF(usertype IS NULL OR usertype = '') AS missing_usertype,
  COUNT(DISTINCT start_station_id) AS unique_stations,
  APPROX_QUANTILES(tripduration, 100)[OFFSET(50)] / 60 AS median_trip_min,
  APPROX_QUANTILES(tripduration, 100)[OFFSET(99)] / 60 AS p99_trip_min
FROM `bigquery-public-data.new_york_citibike.citibike_trips`
WHERE starttime >= DATETIME '2014-01-01'
  AND starttime <  DATETIME '2016-01-01';