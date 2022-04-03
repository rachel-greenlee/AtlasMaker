
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


# Bus Routes 
# https://data.cityofnewyork.us/Transportation/Bus-Lanes-Local-Streets/ycrg-ses3
Routes <- read.socrata(
  "https://data.cityofnewyork.us/resource/ycrg-ses3.json", 
  app_token = Sys.getenv("APP_TOKEN"),
  email     = Sys.getenv("PHDS_EMAIL"),
  password  = Sys.getenv("PHDS_PASSWORD")
)

## Point data ----
### needs columns of label, long, and lat for each df

# User needs to convert objects of list / dataframe to Spatial
MVColisions$number_of_persons_injured <- as.numeric(MVColisions$number_of_persons_injured )
as_Spatial(MVColisions)
class(MVColisions$latitude)
# as(MVColusions, "sf") - Not needed in list for Leaflet 
# st_cast(MODZCTA, "Polygon") - Not needed in list for Leaflet (Datum and Projection are Already Set)


## Polylines data ----- 

# User needs to convert objects of list / dataframe to Spatial

Routes <- Routes %>% 
  dplyr::select(the_geom.coordinates, shape_leng) # Access Only what user would need
Routes$shape_leng <- as.numeric(Routes$shape_leng) # Convert to numeric
st_cast(Routes, "MULTIPOLYGON") # Polylines does not exist  
as_Spatial(Routes$the_geom.coordinates)
c(Routes$the_geom.coordinates)
print(Routes$the_geom.coordinates)



## Polygon fill data-----

# User needs to convert objects of list / dataframe to Spatial
MODZCTA$pop_est <- as.numeric(MODZCTA$pop_est)
as_Spatial(MODZCTA)
class(MODZCTA$the_geom.coordinates)
as(MODZCTA, "sf") 
st_cast(MODZCTA, "Polygon")



# load raw dataset

# Prep dfs by theme--------------
# need the geomotry column (state/county/etc) to be named NAME and the data to be named fill_value
# 1 df per theme/polygonf ill






# Save prepped data----

#### saving all files created above in an .rdata file, add as we go
save(Complaints, MODZCTA, MVColisions, Routes,
     file = "userdata.rdata")






