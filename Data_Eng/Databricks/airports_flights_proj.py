# Databricks notebook source
# MAGIC %pip install markdown
# MAGIC %pip install lxml
# MAGIC %pip install beautifulsoup4
# MAGIC %pip install geopandas
# MAGIC %pip install shapely

# COMMAND ----------

# MAGIC %sh
# MAGIC ls /dbfs/databricks-datasets/airlines

# COMMAND ----------

# MAGIC %python
# MAGIC import markdown as md
# MAGIC
# MAGIC
# MAGIC class Markdown:
# MAGIC     """Markdown class for properly rendering Markdown in Databricks notebook"""
# MAGIC     def __init__(self, markdown_text):
# MAGIC         self.html = md.markdown(markdown_text)
# MAGIC     def _repr_html_(self):
# MAGIC         return self.html
# MAGIC
# MAGIC
# MAGIC with open("/dbfs/databricks-datasets/airlines/README.md", "r") as f:
# MAGIC     readme_content = f.read()
# MAGIC
# MAGIC Markdown(readme_content)

# COMMAND ----------

# MAGIC %md
# MAGIC ## Describe Data
# MAGIC - Directory Size
# MAGIC - File Size
# MAGIC - File Type
# MAGIC - Rows

# COMMAND ----------

# MAGIC %sh
# MAGIC du --human-readable /dbfs/databricks-datasets/airlines/                  # size of directory
# MAGIC ls -s --human-readable /dbfs/databricks-datasets/airlines/part-00000     # size of 1 data-file
# MAGIC wc --lines /dbfs/databricks-datasets/airlines/part-00000                 # rows in 1 data-file
# MAGIC ls /dbfs/databricks-datasets/airlines/part-* | wc --lines                # count of data-files
# MAGIC file /dbfs/databricks-datasets/airlines/part-00000                       # data-file type
# MAGIC echo
# MAGIC head --lines 5 /dbfs/databricks-datasets/airlines/part-00000             # sample of data-file 1; headers
# MAGIC echo
# MAGIC head --lines 5 /dbfs/databricks-datasets/airlines/part-00002             # sample of data-file 2; no headers

# COMMAND ----------

# MAGIC %sh
# MAGIC ls /dbfs/databricks-datasets/airlines/part-* | tail -2       # what's the 2nd to last file, which maybe has more data than the last, so I can use it for demo?

# COMMAND ----------

# MAGIC %python
# MAGIC from pyspark.sql import SparkSession
# MAGIC import pandas as pd
# MAGIC
# MAGIC
# MAGIC spark = SparkSession.builder.getOrCreate()
# MAGIC
# MAGIC df_first = spark.read.csv('/databricks-datasets/airlines/part-00000', sep=',', header=True, inferSchema=True)                           # grab headers & infer schema from first file
# MAGIC df_first_ten = spark.read.csv('/databricks-datasets/airlines/part-0000*', sep=',', header=False, schema=df_first.schema).na.drop()      # using schema, read in first 10 CSVs & drop the bogus header row; takes a min
# MAGIC # df_all = spark.read.csv('/databricks-datasets/airlines/part-*', sep=',', header=False, schema=df_first.schema).na.drop()                # using schema, read in all CSVs & drop the bogus header row; takes 10min+
# MAGIC df_demo = spark.read.csv('/databricks-datasets/airlines/part-01918', sep=',', header=True, schema=df_first.schema)                      # using schema, read in 2nd to last CSV for demo work; presumably, more likely to have data for all fields
# MAGIC
# MAGIC df_first_ten.count()

# COMMAND ----------

# MAGIC %sh
# MAGIC # sanity check; this ties out with above df_first_ten + 1 header row
# MAGIC wc --lines /dbfs/databricks-datasets/airlines/part-0000* | grep total

# COMMAND ----------

# MAGIC %md
# MAGIC ## Describe Data
# MAGIC - Schema

# COMMAND ----------

# MAGIC %python
# MAGIC df_demo.printSchema()
# MAGIC df_demo.display()
# MAGIC # Doesn't tell us that perhaps, certain airlines/cariers are worst offenders. I would suggest integrating this additional information for more insights

# COMMAND ----------

# MAGIC %python
# MAGIC df_demo.createOrReplaceTempView("airlines")

# COMMAND ----------

# MAGIC %md
# MAGIC ## [Bureau of Transportation Statistics (BTS) Flight Departure Delay Cause Definitions](https://www.bts.gov/topics/airlines-and-airports/understanding-reporting-causes-flight-delays-and-cancellations)
# MAGIC A flight is considered delayed when it arrived 15 or more minutes than the schedule \
# MAGIC When multiple causes are assigned to one delayed flight, each cause is prorated based on delayed minutes it is responsible for
# MAGIC - **Air Carrier**: The cause of the cancellation or delay was due to circumstances within the airline's control (e.g. maintenance or crew problems, aircraft cleaning, baggage loading, fueling, etc.).
# MAGIC - **Extreme Weather**: Significant meteorological conditions (actual or forecasted) that, in the judgment of the carrier, delays or prevents the operation of a flight such as tornado, blizzard or hurricane.
# MAGIC - **National Aviation System (NAS)**: Delays and cancellations attributable to the national aviation system that refer to a broad set of conditions, such as non-extreme weather conditions, airport operations, heavy traffic volume, and air traffic control.
# MAGIC - **Late-arriving aircraft**: A previous flight with same aircraft arrived late, causing the present flight to depart late.
# MAGIC - **Security**: Delays or cancellations caused by evacuation of a terminal or concourse, re-boarding of aircraft because of security breach, inoperative screening equipment and/or long lines in excess of 29 minutes at screening areas.

# COMMAND ----------

# MAGIC %md
# MAGIC # Delay Occurences

# COMMAND ----------

# MAGIC %md
# MAGIC ### By volume of occurence, which origin-airports have most departure-delays?
# MAGIC - (data, visual)
# MAGIC ### For each origin-airport, how many departure-delays were related to each delay-cause?
# MAGIC - (data)
# MAGIC
# MAGIC 1 delayed flight can have multiple delay causes. See above.

# COMMAND ----------

# MAGIC %python
# MAGIC depart_delays_df = spark.sql("""
# MAGIC     WITH origin_flights AS (
# MAGIC         SELECT Origin, COUNT(*) DepFlights
# MAGIC         FROM airlines
# MAGIC         GROUP BY Origin
# MAGIC     ),
# MAGIC     depart_delays AS (
# MAGIC         SELECT
# MAGIC             Origin,
# MAGIC             SUM(CASE WHEN CarrierDelay>0 THEN 1 ELSE 0 END) CarrierDelays,
# MAGIC             SUM(CASE WHEN WeatherDelay>0 THEN 1 ELSE 0 END) WeatherDelays,
# MAGIC             SUM(CASE WHEN NASDelay>0 THEN 1 ELSE 0 END) NASDelays,
# MAGIC             SUM(CASE WHEN SecurityDelay>0 THEN 1 ELSE 0 END) SecurityDelays,
# MAGIC             SUM(CASE WHEN LateAircraftDelay>0 THEN 1 ELSE 0 END) LateAircraftDelays,
# MAGIC             COUNT(*) DepDelays
# MAGIC         FROM airlines
# MAGIC         WHERE IsDepDelayed = 'YES'
# MAGIC         GROUP BY Origin
# MAGIC     )
# MAGIC     SELECT depart_delays.*, origin_flights.DepFlights
# MAGIC     FROM depart_delays
# MAGIC     RIGHT JOIN origin_flights
# MAGIC         ON origin_flights.Origin = depart_delays.Origin
# MAGIC     ORDER BY DepDelays DESC;
# MAGIC """)
# MAGIC depart_delays_df.limit(30).display()  # just display 30 rows in chart
# MAGIC depart_delays_df.createOrReplaceTempView("depart_delays")
# MAGIC # hm, there seems to be irregular ratios among the top 30. Let's dig deeper

# COMMAND ----------

# MAGIC %md
# MAGIC ### By ratio of departure-delay occurences to departures, which origin-airports have the most departure-delays?
# MAGIC - (data, visual)
# MAGIC ### For each origin-airport, what proportion of total departures is delayed by each delay-cause?
# MAGIC - (data)
# MAGIC
# MAGIC 1 delayed flight can have multiple causes. See above.

# COMMAND ----------

# MAGIC %python
# MAGIC depart_delays_ratios_df = spark.sql("""
# MAGIC     SELECT
# MAGIC         Origin,
# MAGIC         ROUND((CarrierDelays / DepFlights), 2) CarrierDelaysRatio,
# MAGIC         ROUND((WeatherDelays / DepFlights), 2) WeatherDelaysRatio,
# MAGIC         ROUND((NASDelays / DepFlights), 2) NASDelaysRatio,
# MAGIC         ROUND((SecurityDelays / DepFlights), 2) SecurityDelaysRatio,
# MAGIC         ROUND((LateAircraftDelays / DepFlights), 2) LateAircraftDelaysRatio,
# MAGIC         ROUND((DepDelays / DepFlights), 2) DepDelaysRatio,
# MAGIC         DepDelays,
# MAGIC         DepFlights
# MAGIC     FROM depart_delays
# MAGIC     ORDER BY DepDelaysRatio DESC;
# MAGIC """)
# MAGIC depart_delays_ratios_df.display()
# MAGIC depart_delays_ratios_df.createOrReplaceTempView("depart_delays_ratios")
# MAGIC # hm, there's a very broad range of delay-ratios across airports. Let's dig deeper

# COMMAND ----------

# MAGIC %md
# MAGIC # Delay Time

# COMMAND ----------

# MAGIC %md
# MAGIC ### By summation of departure delay-time, which origin-airports have the most delay-time?
# MAGIC - (data, visual)
# MAGIC ### For each origin-airport, how much delay-time is each delay-cause responsible for?
# MAGIC - (data, visual)

# COMMAND ----------

# MAGIC %python
# MAGIC depart_delays_minutes_df = spark.sql("""
# MAGIC     WITH depart_delays AS (
# MAGIC         SELECT
# MAGIC             Origin,
# MAGIC             SUM(CarrierDelay) CarrierDelayMin,
# MAGIC             SUM(WeatherDelay) WeatherDelayMin,
# MAGIC             SUM(NASDelay) NASDelayMin,
# MAGIC             SUM(SecurityDelay) SecurityDelayMin,
# MAGIC             SUM(LateAircraftDelay) LateAircraftDelayMin,
# MAGIC             COUNT(*) DepDelays
# MAGIC         FROM airlines
# MAGIC         WHERE IsDepDelayed = 'YES'
# MAGIC         GROUP BY Origin
# MAGIC     )
# MAGIC     SELECT *, (CarrierDelayMin + WeatherDelayMin + NASDelayMin + SecurityDelayMin + LateAircraftDelayMin) TotalDelayMin
# MAGIC     FROM depart_delays
# MAGIC     ORDER BY TotalDelayMin DESC;
# MAGIC """)
# MAGIC depart_delays_minutes_df.limit(30).display()  # just display 30 rows in chart
# MAGIC depart_delays_minutes_df.createOrReplaceTempView("depart_delays_minutes")
# MAGIC # hm, there seems to be an irregular skew of delay-causes among airports. I wonder if we can dig deeper and hypothesize about some pattern

# COMMAND ----------

# MAGIC %md
# MAGIC ### For each origin-airport, what's the distribution of total departure delay-time among delay-causes?
# MAGIC - (data, visual)

# COMMAND ----------

# MAGIC %python
# MAGIC depart_delays_minutes_ratios_df = spark.sql("""
# MAGIC     SELECT
# MAGIC         Origin,
# MAGIC         ROUND((CarrierDelayMin / TotalDelayMin), 2) CarrierDelayRatio,
# MAGIC         ROUND((WeatherDelayMin / TotalDelayMin), 2) WeatherDelayRatio,
# MAGIC         ROUND((NASDelayMin / TotalDelayMin), 2) NASDelayRatio,
# MAGIC         ROUND((SecurityDelayMin / TotalDelayMin), 2) SecurityDelayRatio,
# MAGIC         ROUND((LateAircraftDelayMin / TotalDelayMin), 2) LateAircraftDelayRatio,
# MAGIC         TotalDelayMin
# MAGIC     FROM depart_delays_minutes
# MAGIC     ORDER BY TotalDelayMin DESC;
# MAGIC """)
# MAGIC depart_delays_minutes_ratios_df.limit(30).display()  # just display 30 rows in chart
# MAGIC depart_delays_minutes_ratios_df.createOrReplaceTempView("depart_delays_minutes_ratios")
# MAGIC # hm, yep different skews of delay-causes among airports, better visualized independent of volume. I wonder if we can dig deeper and hypothesize about some pattern

# COMMAND ----------

# MAGIC %md
# MAGIC ### Among all origin-airports, what's the distribution of total departure delay-time among delay-causes?
# MAGIC - (data, visual)

# COMMAND ----------

# MAGIC %python
# MAGIC # this is an ugly transformation to make the pie chart work
# MAGIC depart_delays_minutes_df = spark.sql("""
# MAGIC     SELECT
# MAGIC         'CarrierDelay' DelayCause, SUM(CarrierDelay) DelayMin, SUM(CASE WHEN CarrierDelay>0 THEN 1 ELSE 0 END) DelayCount
# MAGIC     FROM airlines
# MAGIC     WHERE IsDepDelayed = 'YES'
# MAGIC     UNION ALL
# MAGIC     SELECT
# MAGIC         'WeatherDelay' DelayCause, SUM(WeatherDelay) DelayMin, SUM(CASE WHEN WeatherDelay>0 THEN 1 ELSE 0 END) DelayCount
# MAGIC     FROM airlines
# MAGIC     WHERE IsDepDelayed = 'YES'
# MAGIC     UNION ALL
# MAGIC     SELECT
# MAGIC         'NASDelay' DelayCause, SUM(NASDelay) DelayMin, SUM(CASE WHEN NASDelay>0 THEN 1 ELSE 0 END) DelayCount
# MAGIC     FROM airlines
# MAGIC     WHERE IsDepDelayed = 'YES'
# MAGIC     UNION ALL
# MAGIC     SELECT
# MAGIC         'SecurityDelay' DelayCause,SUM(SecurityDelay) DelayMin, SUM(CASE WHEN SecurityDelay>0 THEN 1 ELSE 0 END) DelayCount
# MAGIC     FROM airlines
# MAGIC     WHERE IsDepDelayed = 'YES'
# MAGIC     UNION ALL
# MAGIC     SELECT
# MAGIC         'LateAircraftDelay' DelayCause, SUM(LateAircraftDelay) DelayMin, SUM(CASE WHEN LateAircraftDelay>0 THEN 1 ELSE 0 END) DelayCount
# MAGIC     FROM airlines
# MAGIC     WHERE IsDepDelayed = 'YES';
# MAGIC """)
# MAGIC depart_delays_minutes_df.display()
# MAGIC # that's good that there aren't many security delays. I am surprised at how little weather-delays' share of the pie is.
# MAGIC # I suspect that there could be a pattern for weather delays.

# COMMAND ----------

# MAGIC %md
# MAGIC
# MAGIC ---
# MAGIC # Are there geographic areas where a larger share of departure-delays is due to weather?

# COMMAND ----------

# MAGIC %python
# MAGIC import requests
# MAGIC import pandas as pd
# MAGIC from bs4 import BeautifulSoup

# COMMAND ----------

# MAGIC %python
# MAGIC """
# MAGIC whoops, all this FAA stuff was useless. The Origin-Airports seem to be IATA codes, not FAA codes.
# MAGIC """
# MAGIC """grab FAA codes & Locations from this site"""
# MAGIC df_airports_faa_states = pd.read_html(requests.get("https://www.airport-data.com/usa-airports/faa-code/O.html").text)[0]
# MAGIC df_airports_faa_states.head()
# MAGIC """clean it up a bit"""
# MAGIC df_airports_faa_states['State'] = df_airports_faa_states['Location'].str.split(' ').str[-1]
# MAGIC df_airports_faa_states = df_airports_faa_states[['FAA Code', 'State']].rename(columns={"FAA Code": "FAA_Code", "State": "State"})
# MAGIC df_airports_faa_states.head()
# MAGIC df_airports_faa_states = spark.createDataFrame(df_airports_faa_states)
# MAGIC df_airports_faa_states.createOrReplaceTempView("airports_faa_states")
# MAGIC df_airports_faa_states.display()

# COMMAND ----------

# MAGIC %python
# MAGIC """
# MAGIC This was mostly useless. Half the IATA codes are not in this dataset.
# MAGIC """
# MAGIC """grab IATA codes and States"""
# MAGIC df_states_iata = pd.read_html(requests.get("https://www.leonardsguide.com/us-airport-codes.shtml").text)[0]
# MAGIC """transform the terrible table format"""
# MAGIC states_iata_ls = []
# MAGIC for row in df_states_iata.iterrows():
# MAGIC     item = row[1][1]
# MAGIC     if len(item) == 2:
# MAGIC         current_state = item
# MAGIC     if len(item) == 3:
# MAGIC         states_iata_ls.append([current_state, item])
# MAGIC
# MAGIC states_iata_df = pd.DataFrame(states_iata_ls)
# MAGIC states_iata_df.columns = ["State", "IATA"]
# MAGIC
# MAGIC states_iata_df = spark.createDataFrame(states_iata_df)
# MAGIC states_iata_df.createOrReplaceTempView("states_iata")
# MAGIC states_iata_df.display()

# COMMAND ----------

# MAGIC %python
# MAGIC """
# MAGIC Finally. This had all but a few of the IATA codes in this dataset. The few are presumably smaller airports.
# MAGIC """
# MAGIC html = requests.get("https://nobleaircharter.com/airport-codes-usa/").text
# MAGIC soup = BeautifulSoup(html, 'html.parser')
# MAGIC
# MAGIC iata_aps = []
# MAGIC for elem in soup.select("div div[class*='fusion-text-4'] p"):
# MAGIC     for line in elem.text.splitlines():
# MAGIC         iata_aps.append(line)
# MAGIC
# MAGIC org_iata_aps = []
# MAGIC for line in iata_aps:
# MAGIC     split_line = line.split(' ')
# MAGIC     for piece in split_line:
# MAGIC         if (len(piece) == 2) and (piece.upper() == piece):
# MAGIC             state = piece
# MAGIC         if "(" in piece:
# MAGIC             iata = piece
# MAGIC     org_iata_aps.append([state, iata])
# MAGIC     if iata == "(YUM)":
# MAGIC         break
# MAGIC org_iata_aps_df = pd.DataFrame(org_iata_aps)
# MAGIC org_iata_aps_df.columns = ["State", "IATA"]
# MAGIC org_iata_aps_df["IATA"] = org_iata_aps_df["IATA"].str.strip('(').str.strip(')')
# MAGIC
# MAGIC org_iata_aps_df = spark.createDataFrame(org_iata_aps_df)
# MAGIC org_iata_aps_df.createOrReplaceTempView("better_states_iata")
# MAGIC org_iata_aps_df.display()

# COMMAND ----------

# MAGIC %python
# MAGIC """grab State and FIPS codes"""
# MAGIC df_states_fips = pd.read_html(requests.get("https://www.mercercountypa.gov/dps/state_fips_code_listing.htm").text)[0]
# MAGIC onehalf_df = df_states_fips.iloc[1:,0:2]; onehalf_df.columns = ["State", "FIPS"]
# MAGIC twohalf_df = df_states_fips.iloc[1:,3:5]; twohalf_df.columns = ["State", "FIPS"]
# MAGIC df_states_fips = pd.concat([onehalf_df, twohalf_df]).dropna().reset_index(drop=True, inplace=False)
# MAGIC df_states_fips = spark.createDataFrame(df_states_fips)
# MAGIC df_states_fips.createOrReplaceTempView("states_fips")
# MAGIC df_states_fips.display()

# COMMAND ----------

# MAGIC %python
# MAGIC airports_states_iata_fips = spark.sql("""
# MAGIC     SELECT iata.State, iata.IATA, fips.FIPS
# MAGIC     FROM better_states_iata iata
# MAGIC     LEFT JOIN states_fips fips
# MAGIC         ON iata.State = fips.State
# MAGIC     ORDER BY State ASC;
# MAGIC """)
# MAGIC airports_states_iata_fips.display()
# MAGIC airports_states_iata_fips.createOrReplaceTempView("airports_states_iata_fips")

# COMMAND ----------

# MAGIC %python
# MAGIC """chloropleth visualization can be a little buggy. If it fails, refresh your web-browser window."""
# MAGIC weather_delay_chart_df = spark.sql("""
# MAGIC SELECT ddmr.Origin, ddmr.WeatherDelayRatio, asif.State, asif.FIPS
# MAGIC FROM depart_delays_minutes_ratios ddmr
# MAGIC LEFT JOIN airports_states_iata_fips asif
# MAGIC   ON ddmr.Origin = asif.IATA;
# MAGIC """)
# MAGIC weather_delay_chart_df.display()
# MAGIC # maybe winters are harsh in the north, tornadoes in the middle, hurricanes in Florida

# COMMAND ----------

# MAGIC %md
# MAGIC
# MAGIC ---
# MAGIC ## Can we map all the flights?

# COMMAND ----------

# MAGIC %python
# MAGIC """data found at https://openflights.org/data.html available under Database Contents License"""
# MAGIC """Native Databricks Map (Markers) chart too unstable"""
# MAGIC airports_df = pd.read_csv("https://raw.githubusercontent.com/jpatokal/openflights/master/data/airports.dat",
# MAGIC                           delimiter=',',
# MAGIC                           names=['id', 'name', 'city', 'country', 'iata', 'icao', 'lat', 'long', 'altitude', 'timezone', 'dst', 'tz', 'type', 'source'])
# MAGIC
# MAGIC airports_df = spark.createDataFrame(airports_df)
# MAGIC airports_df.createOrReplaceTempView("airports_data")
# MAGIC airports_df = spark.sql("""
# MAGIC     SELECT iata, lat, long
# MAGIC     FROM airports_data
# MAGIC     WHERE COUNTRY = 'United States'
# MAGIC     AND LAT > 25 AND LAT < 50              -- Normal USA landmass
# MAGIC     AND LONG < -65 AND LONG > -125         -- Normal USA landmass
# MAGIC """)
# MAGIC airports_df.createOrReplaceTempView("airports_data")
# MAGIC airports_df.display()
# MAGIC pd_airports_df = airports_df.toPandas()

# COMMAND ----------

# MAGIC %python
# MAGIC import matplotlib.pyplot as plt
# MAGIC
# MAGIC fig, ax = plt.subplots()
# MAGIC fig.set_size_inches(20, 10)
# MAGIC
# MAGIC ax.scatter(pd_airports_df['long'], pd_airports_df['lat'], s=5)
# MAGIC ax.axis('off')
# MAGIC
# MAGIC plt.show()

# COMMAND ----------

# MAGIC %python
# MAGIC flights_df = spark.sql("""
# MAGIC     SELECT airlines.origin, airlines.dest, ad1.lat origin_lat, ad1.long origin_long, ad2.lat dest_lat, ad2.long dest_long
# MAGIC     FROM airlines
# MAGIC     INNER JOIN airports_data ad1 -- have to sacrifice losing a few iata airports
# MAGIC       ON airlines.ORIGIN = ad1.IATA
# MAGIC     INNER JOIN airports_data ad2 -- have to sacrifice losing a few iata airports
# MAGIC       ON airlines.dest = ad2.IATA
# MAGIC """)
# MAGIC flights_df.createOrReplaceTempView("flights")
# MAGIC flights_df.display()

# COMMAND ----------

# MAGIC %python
# MAGIC import geopandas as gpd
# MAGIC from shapely.geometry import LineString
# MAGIC
# MAGIC
# MAGIC pd_flights_df = flights_df.toPandas().sample(10000) # we just need a random sample of 10,000 flights for the visual, else it's too ridiculous
# MAGIC geometry = [LineString([[pd_flights_df.iloc[i]['origin_long'], pd_flights_df.iloc[i]['origin_lat']], [pd_flights_df.iloc[i]['dest_long'], pd_flights_df.iloc[i]['dest_lat']]]) for i in range(pd_flights_df.shape[0])]
# MAGIC routes = gpd.GeoDataFrame(pd_flights_df, geometry=geometry, crs='EPSG:4326')
# MAGIC print(routes)

# COMMAND ----------

# MAGIC %python
# MAGIC fig = plt.figure()
# MAGIC ax = plt.axes()
# MAGIC
# MAGIC fig.set_size_inches(20, 10)
# MAGIC # ax.patch.set_facecolor('black')
# MAGIC
# MAGIC routes.plot(ax=ax, color='black', linewidth=0.1)
# MAGIC
# MAGIC plt.setp(ax.spines.values(), color='black')
# MAGIC plt.setp([ax.get_xticklines(), ax.get_yticklines()], color='black')
# MAGIC
# MAGIC plt.show()
# MAGIC # it would be cool to overlay this on a map with major cities highlighted
