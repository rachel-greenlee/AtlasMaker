
### THIS FILE IS NOT A PART OF OUR PACKAGE
### SIMULATING WHAT USER DOES AHEAD OF USING PACKAGE






# Datasets----

#possible data sets to use for our demo app, all from data.ny.gov
#has api access if we don't want static csv download

#biodiversity by county
#https://data.ny.gov/Energy-Environment/Biodiversity-by-County-Distribution-of-Animals-Pla/tk82-7km5

#watchable wildlife sites
#https://data.ny.gov/Recreation/Watchable-Wildlife-Sites/hg7a-5ssi

#state park facility points - imported already
#https://data.ny.gov/Recreation/Watchable-Wildlife-Sites/hg7a-5ssi

#campground in and outside adirondack/catskills - imported already
#https://data.ny.gov/Recreation/Campgrounds-by-County-Within-Adirondack-Catskill-F/tnqf-vydw
#https://data.ny.gov/Recreation/Campgrounds-by-County-Outside-Adirondack-Catskill-/5zxz-z3ci


# Packages-----
library(leaflet)
library(leaflet.extras)
library(tigris)
library(dplyr)
library(shiny)
library(readr)
library(sf)



# Reading in data ----


## Point data ----

points_parks <- read_csv("raw-data/State_Park_Facility_Points.csv")
#add lat/lon to a tibble for inputting to addMarkers() later
points_parks <- tibble(
  label = points_parks$Name,
  long = points_parks$Longitude,
  lat = points_parks$Latitude)

points_campgrounds <- read_csv("raw-data/Campgrounds_by_County_Outside_Adirondack___Catskill_Forest_Preserve.csv")
#add lat/lon to a tibble for inputting to addMarkers() later
points_campgrounds <- tibble(
  label = points_campgrounds$Name,
  long = points_campgrounds$Longitude,
  lat = points_campgrounds$Latitude)

points_3_campgrounds <- read_csv("raw-data/Campgrounds_by_County_Within_Adirondack___Catskill_Forest_Preserve.csv")
#add lat/lon to a tibble for inputting to addMarkers() later
points_3_campgrounds <- tibble(
  label = points_3_campgrounds$Campground,
  long = points_3_campgrounds$X,
  lat = points_3_campgrounds$Y)

points_campgrounds <- bind_rows(points_campgrounds, points_3_campgrounds)




points_watchsites <- read_csv("raw-data/Watchable_Wildlife_Sites.csv")
#add lat/lon to a tibble for inputting to addMarkers() later
points_watchsites <- tibble(
  label = points_watchsites$`Site Name`,
  long = points_watchsites$Longitude,
  lat = points_watchsites$Latitude)




## Polygon fill data-----

# bring in biodiversity data 
biodiversity <- read_csv("raw-data/Biodiversity_by_County_-_Distribution_of_Animals__Plants_and_Natural_Communities.csv")

# Prep dfs by theme--------------






## Flowering Plant species------------

# Species Abundance Selection
flowering_plants <- biodiversity %>%  
  group_by(County, `Taxonomic Group`) %>% 
  filter(`Taxonomic Group` == "Flowering Plants") %>%
  summarise(n())
# Join and convert to Spatial Polygons
flowering_plants <- flowering_plants %>%
  rename("NAME" = 'County', 
         "fill_value" = `n()`)




## Birds ------------
# Species Abundance Selection (Birds)
birds <- biodiversity %>%  
  group_by(County, `Taxonomic Group`) %>% 
  filter(`Taxonomic Group` == "Birds") %>%
  summarise(n())
# Join and convert to Spatial Polygons
birds <- birds %>%
  rename("NAME" = 'County', 
         "fill_value" = `n()`)





## Amphibians ------------
# Species Abundance Selection
amphibians <- biodiversity %>%  
  group_by(County, `Taxonomic Group`) %>% 
  filter(`Taxonomic Group` == "Amphibians") %>%
  summarise(n())
# Join and convert to Spatial Polygons
amphibians <- amphibians %>%
  rename("NAME" = 'County', 
         "fill_value" = `n()`)



## Fish species------------

# Species Abundance Selection
reptiles <- biodiversity %>%  
  group_by(County, `Taxonomic Group`) %>% 
  filter(`Taxonomic Group` == "Reptiles") %>%
  summarise(n())
# Join and convert to Spatial Polygons
reptiles <- reptiles %>%
  rename("NAME" = 'County', 
         "fill_value" = `n()`)






# Save prepped data----

#### saving all files created above in an .rdata file, add as we go
save(points_parks, points_campgrounds, points_watchsites, 
     reptiles, birds, amphibians, flowering_plants, 
     file = "userdata.rdata")
