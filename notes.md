\# Citi Bike NYC Operations Analysis - Project Notes



\## Data Coverage Finding

\- Public dataset has gaps: 2013 (Jul-Dec), 2016 (Jan-Sep), 2017 (Apr-Dec), 2018 (Jan-May)

\- Only 2014 and 2015 are complete years -> analysis window: Jan 2014 - Dec 2015 (\~18M trips)

\- Avg trip duration (14-17 min) inflated by extreme trips -> cleaned in next step



\## Data Quality (2014-2015, 18,019,185 trips)

\- 0 trips under 1 min, 0 missing stations/usertypes

\- 42,085 trips over 3 hours (0.23%) -> removed as lost/unreturned bikes

\- 425,584 round trips (2.4%) kept as leisure rides

\- 488 stations; median trip 10.4 min, p99 66.6 min

\- Using median (not mean) for trip duration due to right skew

\- Clean view (trips\_clean): 17,977,100 trips after removing 42,085 trips over 3 hours

\- Daily summary: 730 days, joined with NOAA Central Park weather (0 missing days), totals reconcile to 17,977,100 trips



\## Growth

\- 2014: 8,069,008 trips | 2015: 9,908,092 trips -> +22.8% YoY (totals reconcile to 17,977,100)

\- Part of the growth comes from network expansion: 152 stations opened during 2015

\- Monthly trend: 2015 ≈ 2014 for Jan-Jun (Feb-Apr 2015 slightly lower); 2015 pulls ahead Jul-Dec, peaking \~1.28M trips in Sep vs \~960K in 2014 -> growth concentrated in H2 2015, consistent with 2015 network expansion



\## Demand Patterns (hourly\_patterns.csv, 336 rows)

\- Weekday commute double peak: 8 AM (\~2,430 subscriber trips/day) and 5-6 PM (\~2,540 / \~2,480)

\- Heatmap: busiest slot Monday 5 PM (\~2,867 trips/day); Friday evening peak weaker than Mon-Thu

\- Weekends: one broad 11 AM - 5 PM block, no commute peaks

\- 1-5 AM is near-empty every day -> best window for overnight rebalancing

\- Customers (casual riders) peak 2-4 PM, mostly weekends; median trip 18.2 min vs 9.3 min for subscribers

\- Subscribers = 88.4% of trips (15.89M of 17.98M)

\- Rider mix: casual riders are \~2-4% of trips in Jan-Feb but \~15-17% in May-Oct -> summer demand at tourist/park stations

\- Implication: rebalancing must happen before the 8 AM and 5 PM peaks



\## Weather Impact (daily\_summary.csv)

\- Temperature vs daily trips correlation: 0.80

\- 75°F+ days avg 35,257 trips vs 10,078 below 40°F (\~3.5x; cold days 71% fewer trips)

\- Demand rises steeply up to \~60°F, then flattens (+8% from 60-75°F to 75°F+)

\- Rain reduces trips 19.7% on weekdays, 15.5% on weekends

\- Scatter: rain-day trend line sits below dry-day line at every temperature; the gap widens on warmer days

\- Implication: schedule fleet maintenance in winter; use weather forecasts in demand planning



\## Station Imbalance (station\_imbalance.csv, 488 stations)

\- Excluded temporary stations (Valet/Mobile/Depot) and ranked only stations open >= 365 days (331)

\- Station types: 331 established, 152 newer (<365 days), 5 temporary

\- Two stations share the name "E 41 St \& Madison Ave" (IDs 517, 3235) -> used Station Id in Tableau to keep them separate (483 non-temporary stations on map)

\- Biggest shortage: 8 Ave \& W 31 St (Penn Station) -52.2 bikes/day; AM rush net -72,568

\- Biggest overflow: W 33 St \& 7 Ave (Penn Station, \~2 blocks away) +29.8 bikes/day; PM rush net +27,346

\- Insight: commuters take bikes from one Penn Station dock in the AM and return to another in the PM -> a short daily transfer fixes both

\- Second transit-hub pair at Port Authority: W 42 St \& 8 Ave (-13.8/day) vs W 41 St \& 8 Ave (+10.3/day), one block apart -> same pattern

\- Transit hubs empty in AM; Midtown office stations fill in AM, empty in PM

\- 49 of 331 established stations (15%) are off by 5+ bikes/day: 23 run out of bikes, 26 fill up

\- Top 10 stations = 25% of total imbalance, top 20 = 36% -> focused rebalancing covers a large share

\- Top 20 imbalanced: 13 shortage (mostly Broadway/8th Ave Midtown corridor), 7 overflow (Union Square, Downtown Brooklyn, FiDi, Hudson riverfront)



\## Demand Forecast (Prophet)

\- Split: train Jan 2014-Aug 2015, validation Sep-Oct 2015 (model selection), test

