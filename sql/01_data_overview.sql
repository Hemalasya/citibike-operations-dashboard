-- Trip volume and data range by year
-- Finding: only 2014 and 2015 are complete years; analysis uses Jan 2014 - Dec 2015
SELECT
  EXTRACT(YEAR FROM starttime) AS year,
  COUNT(*) AS trips,
  ROUND(COUNTIF(usertype = 'Subscriber') * 100 / COUNT(*), 1) AS pct_subscribers,
  ROUND(AVG(tripduration) / 60, 1) AS avg_trip_minutes,
  MIN(starttime) AS first_trip,
  MAX(starttime) AS last_trip
FROM `bigquery-public-data.new_york_citibike.citibike_trips`
WHERE starttime IS NOT NULL
GROUP BY year
ORDER BY year;