-- Station-level imbalance: arrivals minus departures (negative = station runs out of bikes)
WITH dep AS (
  SELECT
    start_station_id AS station_id,
    ANY_VALUE(start_station_name)      AS station_name,
    ANY_VALUE(start_station_latitude)  AS latitude,
    ANY_VALUE(start_station_longitude) AS longitude,
    COUNT(DISTINCT trip_date) AS active_days,
    COUNT(*) AS departures,
    COUNTIF(dow_num BETWEEN 2 AND 6 AND start_hour BETWEEN 7 AND 9)   AS am_departures,
    COUNTIF(dow_num BETWEEN 2 AND 6 AND start_hour BETWEEN 16 AND 18) AS pm_departures
  FROM `citibike-analysis-513501.citibike.trips_clean`
  GROUP BY start_station_id
),
arr AS (
  SELECT
    end_station_id AS station_id,
    COUNT(*) AS arrivals,
    COUNTIF(EXTRACT(DAYOFWEEK FROM stoptime) BETWEEN 2 AND 6
            AND EXTRACT(HOUR FROM stoptime) BETWEEN 7 AND 9)   AS am_arrivals,
    COUNTIF(EXTRACT(DAYOFWEEK FROM stoptime) BETWEEN 2 AND 6
            AND EXTRACT(HOUR FROM stoptime) BETWEEN 16 AND 18) AS pm_arrivals
  FROM `citibike-analysis-513501.citibike.trips_clean`
  GROUP BY end_station_id
)
SELECT
  d.station_id,
  d.station_name,
  d.latitude,
  d.longitude,
  d.active_days,
  d.departures,
  a.arrivals,
  a.arrivals - d.departures AS net_flow,
  ROUND((a.arrivals - d.departures) / d.active_days, 1) AS avg_daily_net_flow,
  a.am_arrivals - d.am_departures AS am_rush_net_flow,
  a.pm_arrivals - d.pm_departures AS pm_rush_net_flow
FROM dep d
LEFT JOIN arr a USING (station_id)
ORDER BY avg_daily_net_flow;