### THIS FILE IS NOT A PART OF OUR PACKAGE
### SIMULATING WHAT USER DOES AHEAD OF USING PACKAGE


# Datasets----
#NY county and interstate data from tigris package

#biodiversity by county
#https://data.ny.gov/Energy-Environment/Biodiversity-by-County-Distribution-of-Animals-Pla/tk82-7km5

#watchable wildlife sites
#https://data.ny.gov/Recreation/Watchable-Wildlife-Sites/hg7a-5ssi

#state park facility points -
#https://data.ny.gov/Recreation/Watchable-Wildlife-Sites/hg7a-5ssi

#campground in and outside adirondack/catskills
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

# 0. Pre-processing data------

## NY counties polygons -----

counties_NY <- tigris::counties() %>%
	filter(STATEFP == "36") %>%
	dplyr::select(STATEFP, NAME, INTPTLAT, INTPTLON, ALAND, AWATER, geometry)


## NY interstates polylines -----

c(counties_NY$NAME)

roads_NY <- tigris::roads("New York", county = c(counties_NY$NAME)) # Takes a long time
roads_NY_1_10 <- tigris::roads("New York", county = c(counties_NY$NAME[1:10]))
roads_NY_11_20 <- tigris::roads("New York", county = c(counties_NY$NAME[11:20]))
roads_NY_21_30 <- tigris::roads("New York", county = c(counties_NY$NAME[21:30]))
roads_NY_31_40 <- tigris::roads("New York", county = c(counties_NY$NAME[31:40]))
roads_NY_41_50 <- tigris::roads("New York", county = c(counties_NY$NAME[41:50]))
roads_NY_51_62 <- tigris::roads("New York", county = c(counties_NY$NAME[51:62]))

#try just interstate ny roads
roads_ny_interstate <- roads_NY %>%
	filter(RTTYP == "I")





# bring in biodiversity data
biodiversity_raw <- read_csv("raw-data/Biodiversity_by_County_-_Distribution_of_Animals__Plants_and_Natural_Communities.csv")


## Flowering Plant species------------

# Species Abundance Selection
flowering_plants <- biodiversity_raw %>%
	group_by(County, `Taxonomic Group`) %>%
	filter(`Taxonomic Group` == "Flowering Plants") %>%
	summarise(n())
# Join and convert to Spatial Polygons
flowering_plants <- flowering_plants %>%
	rename("NAME" = 'County',
		   "fill_value" = `n()`)

# Make Spatial DataFrames with counties_NY
# For flowering plants
flowering_plants <- counties_NY %>%
	left_join(flowering_plants, by = 'NAME')
flowering_plants <- as_Spatial(flowering_plants)


## Birds ------------
# Species Abundance Selection (Birds)
birds <- biodiversity_raw %>%
	group_by(County, `Taxonomic Group`) %>%
	filter(`Taxonomic Group` == "Birds") %>%
	summarise(n())
# Join and convert to Spatial Polygons
birds <- birds %>%
	rename("NAME" = 'County',
		   "fill_value" = `n()`)
# Make Spatial DataFrames with counties_NY
# For birds
birds <- counties_NY %>%
	left_join(birds, by = 'NAME')
birds <- as_Spatial(birds)







## Amphibians ------------
# Species Abundance Selection
amphibians <- biodiversity_raw %>%
	group_by(County, `Taxonomic Group`) %>%
	filter(`Taxonomic Group` == "Amphibians") %>%
	summarise(n())
# Join and convert to Spatial Polygons
amphibians <- amphibians %>%
	rename("NAME" = 'County',
		   "fill_value" = `n()`)

# Make Spatial DataFrames with counties_NY
# For amphibians
amphibians <- counties_NY %>%
	left_join(amphibians, by = 'NAME')
amphibians <- as_Spatial(amphibians)

## Fish species------------

# Species Abundance Selection
reptiles <- biodiversity_raw %>%
	group_by(County, `Taxonomic Group`) %>%
	filter(`Taxonomic Group` == "Reptiles") %>%
	summarise(n())
# Join and convert to Spatial Polygons
reptiles <- reptiles %>%
	rename("NAME" = 'County',
		   "fill_value" = `n()`)

# Make Spatial DataFrames with counties_NY
# For reptiles
reptiles <- counties_NY %>%
	left_join(reptiles, by = 'NAME')
reptiles <- as_Spatial(reptiles)

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



save(flowering_plants, birds, amphibians, reptiles,
	 points_watchsites, points_campgrounds, points_parks, points,
	 counties_NY, roads_ny_interstate,
	 file = "data/vignette_data_prepped.rdata")
