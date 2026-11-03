-- Trips by day of week, hour, and user type (for heatmap)
SELECT
  dow_num,
  day_name,
  start_hour,
  usertype,
  COUNT(*) AS trips,
  ROUND(COUNT(*) / COUNT(DISTINCT trip_date), 1) AS avg_trips_per_day,
  APPROX_QUANTILES(tripduration, 100)[OFFSET(50)] / 60 AS median_trip_min
FROM `citibike-analysis-513501.citibike.trips_clean`
GROUP BY dow_num, day_name, start_hour, usertype
ORDER BY dow_num, start_hour, usertype;