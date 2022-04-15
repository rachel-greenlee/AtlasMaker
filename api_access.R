
# ACCESS DATA SOURCES 
# NOT PART OF THE PACKAGE - FOR TESTING PURPOSES ONLY

require(RSocrata)

# An APP_TOKEN is needed to ensure these run
 
# Modified Zip Code Tabulation Areas (Maintained by DOHMH)
# Geometries: Unique for NYC
# https://data.cityofnewyork.us/Health/Modified-Zip-Code-Tabulation-Areas-MODZCTA-/pri4-ifjk
# Also sounds like Jason would really like to see this data displayed somehow 
# See Git Notes on Homepage: https://github.com/jbryer/NYCFutureMap
# Alternative from DOHM https://data.ct.gov/resource/bfnu-rgqt.json
MODZCTA <- read.socrata(
  "https://data.cityofnewyork.us/resource/pri4-ifjk.json?$select=MODZCTA,the_geom,pop_est", 
  app_token = Sys.getenv("APP_TOKEN"),
  email     = Sys.getenv("PHDS_EMAIL"),
  password  = Sys.getenv("PHDS_PASSWORD")
)

# NYC Open Data on Motor Vehicle Colisions
# Geometries: Points in NYC
# https://data.cityofnewyork.us/Public-Safety/Motor-Vehicle-Collisions-Crashes/h9gi-nx95
MVColisions <- read.socrata(
  "https://data.cityofnewyork.us/resource/h9gi-nx95.json?$limit=10000", 
  app_token = Sys.getenv("APP_TOKEN"),
  email     = Sys.getenv("PHDS_EMAIL"),
  password  = Sys.getenv("PHDS_PASSWORD")
)

# NYPD Complaint Data Historic
# Geometries: Points in NYC 
# https://data.cityofnewyork.us/Public-Safety/NYPD-Complaint-Data-Historic/qgea-i56i
Complaints <- read.socrata(
  "https://data.cityofnewyork.us/resource/qgea-i56i.json?$limit=10000", 
  app_token = Sys.getenv("APP_TOKEN"),
  email     = Sys.getenv("PHDS_EMAIL"),
  password  = Sys.getenv("PHDS_PASSWORD")
)

# New York City Leading Causes of Death
# Geometries: None
# https://data.cityofnewyork.us/Health/New-York-City-Leading-Causes-of-Death/jb7j-dtam
Deaths <- read.socrata(
  "https://data.cityofnewyork.us/resource/jb7j-dtam.json", 
  app_token = Sys.getenv("APP_TOKEN"),
  email     = Sys.getenv("PHDS_EMAIL"),
  password  = Sys.getenv("PHDS_PASSWORD")
)

# Bus Routes 
# Geometries: Lines in NYC
# https://data.cityofnewyork.us/Transportation/Bus-Lanes-Local-Streets/ycrg-ses3
Routes <- read.socrata(
  "https://data.cityofnewyork.us/resource/ycrg-ses3.json", 
  app_token = Sys.getenv("APP_TOKEN"),
  email     = Sys.getenv("PHDS_EMAIL"),
  password  = Sys.getenv("PHDS_PASSWORD")
)

# Income Class by Quantity of Tax Returns *1999 - 2014 
# Geometries: Counties in NY state
# https://data.ny.gov/Government-Finance/Income-Tax-Components-by-Size-of-Income-by-Place-o/5bb2-yb85
Income <- read.socrata(
  "https://data.ny.gov/resource/5bb2-yb85.json", 
  app_token = Sys.getenv("APP_TOKEN"), 
  email = Sys.getenv("PHDS_EMAIL"), 
  password = Sys.getenv("PHDS_PASSWORD")
)

# Lottery locations in NY (all retailers who sell lotto products) *2022
# Geometries: Points all over NY state
# https://data.ny.gov/Government-Finance/NYS-Lottery-Retailers/2vvn-pdyi
Lotto <- read.socrata(
  "https://data.ny.gov/resource/2vvn-pdyi.json", 
  app_token = Sys.getenv("APP_TOKEN"), 
  email = Sys.getenv("PHDS_EMAIL"), 
  password = Sys.getenv("PHDS_PASSWORD")
)

# Occupation data 
# Geometries: Regions in NY state
# https://data.ny.gov/Economic-Development/Occupational-Employment-and-Wage-Statistics/gkgz-nw24
Occupations <- read.socrata(
  "https://data.ny.gov/resource/gkgz-nw24.json", 
  app_token = Sys.getenv("APP_TOKEN"), 
  email = Sys.getenv("PHDS_EMAIL"), 
  password = Sys.getenv("PHDS_PASSWORD")
)

# Electric Vehicles per County
# Geometries: Counties in NY state
# https://data.ny.gov/Transportation/Electric-Vehicles-per-County/uu25-czyc
EVs <- read.socrata(
  "https://data.ny.gov/resource/uu25-czyc.json", 
  app_token = Sys.getenv("APP_TOKEN"), 
  email = Sys.getenv("PHDS_EMAIL"), 
  password = Sys.getenv("PHDS_PASSWORD")
)

# Vehicles, Snowmobile, and Boat Registrations
# Geometries: Counties in NY state
# https://data.ny.gov/Transportation/Vehicle-Snowmobile-and-Boat-Registrations/w4pv-hbkt
Boats <- read.socrata(
  "https://data.ny.gov/resource/w4pv-hbkt.json?$limit=10000", 
  app_token = Sys.getenv("APP_TOKEN"), 
  email = Sys.getenv("PHDS_EMAIL"), 
  password = Sys.getenv("PHDS_PASSWORD")
) 

# Hate Crimes by County and Bias Type: Beginning 2010
# Geometries: Counties in NY state
# https://data.ny.gov/Public-Safety/Hate-Crimes-by-County-and-Bias-Type-Beginning-2010/6xda-q7ev
HateCrimes <- read.socrata(
  "https://data.ny.gov/resource/6xda-q7ev.json", 
  app_token = Sys.getenv("APP_TOKEN"), 
  email = Sys.getenv("PHDS_EMAIL"), 
  password = Sys.getenv("PHDS_PASSWORD")
) 

# Recommended Fishing Rivers, Streams, Lakes and Ponds Map
# Geometries: Points all over NY state
# https://data.ny.gov/Recreation/Recommended-Fishing-Rivers-Streams-Lakes-and-Ponds/f4vj-p8y5
BestFish <- read.socrata(
  "https://data.ny.gov/resource/f4vj-p8y5.json", 
  app_token = Sys.getenv("APP_TOKEN"), 
  email = Sys.getenv("PHDS_EMAIL"), 
  password = Sys.getenv("PHDS_PASSWORD")
) 


# Agricultural Fairs in New York State
# Geometries: Points all over NY State
# https://data.ny.gov/Recreation/Agricultural-Fairs-in-New-York-State/wcwd-s5vt
AgFairs <- read.socrata(
  "https://data.ny.gov/resource/wcwd-s5vt.json", 
  app_token = Sys.getenv("APP_TOKEN"), 
  email = Sys.getenv("PHDS_EMAIL"), 
  password = Sys.getenv("PHDS_PASSWORD")
) 

save(Complaints, Income, Lotto, EVs, MODZCTA, MVColisions, 
     Routes, Boats, HateCrimes, BestFish, AgFairs, file = "app2.rdata")

# A potential addition should any of these not work
# https://data.cityofnewyork.us/Transportation/TLC-Approved-LabCorp-Patient-Services-Drug-Test-Lo/hiik-hmf3

# exported as csv's using write.csv() for Complaints, MODZCTA, MVColisions 