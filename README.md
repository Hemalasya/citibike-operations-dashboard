\# Citi Bike NYC Operations Analysis (2014-2015)



\*\*Live dashboard:\*\* \[Tableau Public](https://public.tableau.com/app/profile/hemalasya.annapureddy/viz/CitiBikeNYCOperationsDashboard/Overview)



\## Business Question

Where and when does Citi Bike run out of bikes or docks, what drives demand, and how should operations rebalance the fleet?



\## Data

\- 17,977,100 trips (Jan 2014 - Dec 2015) from the BigQuery public dataset `new\_york\_citibike`

\- Daily weather from NOAA GSOD (Central Park station)

\- Only 2014-2015 used: other years in the public dataset have missing months



\## Approach

1\. \*\*Data quality (SQL):\*\* found coverage gaps by year, removed 42,085 trips over 3 hours (0.23%), built a clean view

2\. \*\*Aggregation (BigQuery SQL):\*\* daily summary joined with weather, hourly demand patterns, station-level net flow (arrivals minus departures) overall and by rush hour

3\. \*\*Analysis (Python):\*\* weather impact, growth, station classification (temporary / newer / established)

4\. \*\*Forecasting (Prophet):\*\* compared 4 model versions on a validation period, tested once on held-out data

5\. \*\*Dashboard (Tableau Public):\*\* 4 pages - Overview, Demand Patterns, Station Operations, Forecast \& Recommendations



\## Key Findings

\- \*\*Growth:\*\* trips grew 22.8% (8.07M to 9.91M), almost entirely in the second half of 2015, in line with 152 new stations

\- \*\*Demand timing:\*\* weekday peaks at 8 AM and 5-6 PM; weekends one broad 11 AM - 5 PM block; 1-5 AM near-empty

\- \*\*Weather:\*\* temperature vs daily trips r = 0.80; 75°F+ days have \~3.5x the trips of days below 40°F; rain cuts trips \~20% on weekdays

\- \*\*Station imbalance:\*\* 49 of 331 established stations (15%) are off by 5+ bikes/day; the top 20 stations account for 36% of all imbalance

\- \*\*Transit-hub pairs:\*\* Penn Station's 8 Ave \& W 31 St loses 52 bikes/day while W 33 St \& 7 Ave, two blocks away, gains 30/day; Port Authority shows the same pattern

\- \*\*Forecast:\*\* test MAPE 17.9% vs 35.7% for a naive baseline (50% lower error); 80% interval covered 90% of days



\## Recommendations

1\. Rebalance transit-hub pairs daily before 8 AM and 5 PM (Penn Station, Port Authority, Grand Central)

2\. Run overnight truck rebalancing in the 1-5 AM window, prioritizing the top 20 stations

3\. Plan fleet size with weather forecasts; schedule maintenance in winter and add capacity at tourist/park stations May-Oct



\## Dashboards

!\[Overview](images/dashboard\_overview.png)

!\[Demand Patterns](images/dashboard\_demand.png)

!\[Station Operations](images/dashboard\_stations.png)

!\[Forecast](images/dashboard\_forecast.png)



\## Limitations

\- Forecast test used actual weather; real use needs weather forecasts, so expect somewhat higher error

\- Net flow measures trip imbalance only; real station capacity and existing

