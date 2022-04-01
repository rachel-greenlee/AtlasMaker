
# ACCESS DATA SOURCES 
# NOT PART OF THE PACKAGE - FOR TESTING PURPOSES ONLY

require(RSocrata)

# An APP_TOKEN is needed to ensure these run
 
# Modified Zip Code Tabulation Areas (Maintained by DOHMH)
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
# https://data.cityofnewyork.us/Public-Safety/Motor-Vehicle-Collisions-Crashes/h9gi-nx95
MVColisions <- read.socrata(
  "https://data.cityofnewyork.us/resource/h9gi-nx95.json?$limit=10000", 
  app_token = Sys.getenv("APP_TOKEN"),
  email     = Sys.getenv("PHDS_EMAIL"),
  password  = Sys.getenv("PHDS_PASSWORD")
)

# NYPD Complaint Data Historic
# https://data.cityofnewyork.us/Public-Safety/NYPD-Complaint-Data-Historic/qgea-i56i
Complaints <- read.socrata(
  "https://data.cityofnewyork.us/resource/qgea-i56i.json?$limit=10000", 
  app_token = Sys.getenv("APP_TOKEN"),
  email     = Sys.getenv("PHDS_EMAIL"),
  password  = Sys.getenv("PHDS_PASSWORD")
)

# New York City Leading Causes of Death
# https://data.cityofnewyork.us/Health/New-York-City-Leading-Causes-of-Death/jb7j-dtam
Deaths <- read.socrata(
  "https://data.cityofnewyork.us/resource/jb7j-dtam.json", 
  app_token = Sys.getenv("APP_TOKEN"),
  email     = Sys.getenv("PHDS_EMAIL"),
  password  = Sys.getenv("PHDS_PASSWORD")
)

# Bus Routes 
# https://data.cityofnewyork.us/Transportation/Bus-Lanes-Local-Streets/ycrg-ses3
Routes <- read.socrata(
  "https://data.cityofnewyork.us/resource/ycrg-ses3.json", 
  app_token = Sys.getenv("APP_TOKEN"),
  email     = Sys.getenv("PHDS_EMAIL"),
  password  = Sys.getenv("PHDS_PASSWORD")
)

# A potential addition should any of these not work
# https://data.cityofnewyork.us/Transportation/TLC-Approved-LabCorp-Patient-Services-Drug-Test-Lo/hiik-hmf3

# exported as csv's using write.csv() for Complaints, MODZCTA, MVColisions 