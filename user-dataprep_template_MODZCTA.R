
### THIS FILE IS NOT A PART OF OUR PACKAGE
### SIMULATING WHAT USER DOES AHEAD OF USING PACKAGE






# Datasets----







# Packages-----
library(leaflet)
library(leaflet.extras)
library(tigris)
library(dplyr)
library(shiny)
library(readr)
library(sf)



# Reading in data ----

# MODZCTA
# Alt Lacks geometries, lat, lon, or other mapping features but has some data
# MODZCTA_Alt <- read.csv("https://raw.githubusercontent.com/rachel-greenlee/package-drafting-v2/main/raw-data/MODZCTA.csv?token=GHSAT0AAAAAABSDW5BB5AKWV3LQLWMEEBT2YR442XA")
# Full data cannot be accessed as a csv due to listing of geometries
# The file reads commas to separate elements and there are a lot of commas in the first element of the multipolygon
# We access directly from the source
MODZCTA <- read.socrata(
  "https://data.cityofnewyork.us/resource/pri4-ifjk.json?$select=MODZCTA,the_geom,pop_est", 
  app_token = Sys.getenv("APP_TOKEN"),
  email     = Sys.getenv("PHDS_EMAIL"),
  password  = Sys.getenv("PHDS_PASSWORD")
)

# Police Department Complaints 
# NYPD Complaint Data Historic
# https://data.cityofnewyork.us/Public-Safety/NYPD-Complaint-Data-Historic/qgea-i56i
Complaints <- read.socrata(
  "https://data.cityofnewyork.us/resource/qgea-i56i.json?$limit=10000", 
  app_token = Sys.getenv("APP_TOKEN"),
  email     = Sys.getenv("PHDS_EMAIL"),
  password  = Sys.getenv("PHDS_PASSWORD")
)


# Motor Vehicle Colisions
# NYC Open Data on Motor Vehicle Colisions
# https://data.cityofnewyork.us/Public-Safety/Motor-Vehicle-Collisions-Crashes/h9gi-nx95
MVColisions <- read.socrata(
  "https://data.cityofnewyork.us/resource/h9gi-nx95.json?$limit=10000", 
  app_token = Sys.getenv("APP_TOKEN"),
  email     = Sys.getenv("PHDS_EMAIL"),
  password  = Sys.getenv("PHDS_PASSWORD")
)


# ------ From Here Cleaning is Specific to MODZCTA ----- # 


## Point data ----
### needs columns of label, long, and lat for each df




## Polygon fill data-----

# load raw dataset

# Prep dfs by theme--------------
# need the geomotry column (state/county/etc) to be named NAME and the data to be named fill_value
# 1 df per theme/polygonf ill






# Save prepped data----

#### saving all files created above in an .rdata file, add as we go
save(MODZCTA, Complaints, MVColisions,
     file = "userdata.rdata")
