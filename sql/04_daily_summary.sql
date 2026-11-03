-- Daily trips joined with NOAA Central Park weather (2014-2015)
CREATE OR REPLACE TABLE `citibike-analysis-513501.citibike.daily_summary` AS
WITH daily AS (
  SELECT
    trip_date,
    COUNT(*) AS trips,
    COUNTIF(usertype = 'Subscriber') AS subscriber_trips,
    COUNTIF(usertype = 'Customer')   AS customer_trips,
    APPROX_QUANTILES(tripduration, 100)[OFFSET(50)] / 60 AS median_trip_min
  FROM `citibike-analysis-513501.citibike.trips_clean`
  GROUP BY trip_date
),
weather AS (
  SELECT
    DATE(CAST(year AS INT64), CAST(mo AS INT64), CAST(da AS INT64)) AS weather_date,
    temp AS avg_temp_f,
    IF(prcp = 99.99, NULL, prcp) AS precip_in,
    rain_drizzle = '1'     AS rain_day,
    snow_ice_pellets = '1' AS snow_day
  FROM `bigquery-public-data.noaa_gsod.gsod*`
  WHERE _TABLE_SUFFIX IN ('2014', '2015')
    AND stn = '725053' AND wban = '94728'
)
SELECT
  d.trip_date,
  EXTRACT(YEAR FROM d.trip_date)  AS year,
  EXTRACT(MONTH FROM d.trip_date) AS month,
  FORMAT_DATE('%A', d.trip_date)  AS day_name,
  EXTRACT(DAYOFWEEK FROM d.trip_date) IN (1, 7) AS is_weekend,
  d.trips,
  d.subscriber_trips,
  d.customer_trips,
  d.median_trip_min,
  w.avg_temp_f,
  w.precip_in,
  w.rain_day,
  w.snow_day
FROM daily d
LEFT JOIN weather w
  ON d.trip_date = w.weather_date;