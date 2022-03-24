
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
# Alt Lacks geometries, lat, lon, or other mapping features but has some data
MODZCTA_Alt <- read.csv("https://raw.githubusercontent.com/rachel-greenlee/package-drafting-v2/main/raw-data/MODZCTA.csv?token=GHSAT0AAAAAABSDW5BB5AKWV3LQLWMEEBT2YR442XA")
MODZCTA <- read.csv("")

## Point data ----
### needs columns of label, long, and lat for each df




## Polygon fill data-----

# load raw dataset

# Prep dfs by theme--------------
# need the geomotry column (state/county/etc) to be named NAME and the data to be named fill_value
# 1 df per theme/polygonf ill






# Save prepped data----

#### saving all files created above in an .rdata file, add as we go
save(MODZCTA,
     file = "userdata.rdata")
