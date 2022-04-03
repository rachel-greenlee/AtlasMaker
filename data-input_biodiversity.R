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

# 0. Pre-processing data------

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





# 1. Select polygons---------

# Load bundle saved from supported-polygons.R script
load("supported_polygons.rdata")


### EXAMPLE PACKAGE CALL ----base_map(base_polygons = 'counties_NY')
base_polygons <- counties_NY



flowering_plants <- base_polygons %>%
  left_join(flowering_plants, by = 'NAME')
flowering_plants <- as_Spatial(flowering_plants)


birds <- base_polygons %>%
  left_join(birds, by = 'NAME')
birds <- as_Spatial(birds)


amphibians <- base_polygons %>%
  left_join(amphibians, by = 'NAME')
amphibians <- as_Spatial(amphibians)

reptiles <- base_polygons %>%
  left_join(reptiles, by = 'NAME')
reptiles <- as_Spatial(reptiles)



# # 4. Assigning theme #1------
# 
# ### EXAMPLE PACKAGE CALL ---- theme_1(name = "Flowering Plants", points = c(pts1, pts3), poly_fill = df1)
# 
# theme1_name <- "Flowering Plants"
# 
# theme1_pts_1 <- pts1
# 
# theme1_pts_2 <- pts3
# 
 theme1_poly_fill_1 <- as_Spatial(flowering_plants)
# 
theme1_max_val <- as.numeric(max(flowering_plants@data$fill_value))
theme1_min_val <- as.numeric(min(flowering_plants@data$fill_value))
theme1_pal <- colorNumeric(c("RdYlGn"), theme1_min_val:theme1_max_val)

# 
# ### EXAMPLE PACKAGE CALL ---- theme_2(name = "Birds", points = c(pts2, pts3), poly_fill = df2)
# 
# theme2_name <- "Birds"
# 
# theme2_pts_1 <- pts2
# 
# theme2_pts_2 <- pts3
# 
# theme2_poly_fill_1 <- as_Spatial(df2)
# 
# theme2_max_val <- as.numeric(max(theme2_poly_fill_1@data$fill_value))
# theme2_min_val <- as.numeric(min(theme2_poly_fill_1@data$fill_value))
# theme2_pal <- colorNumeric(c("RdYlGn"), theme2_min_val:theme2_max_val)
# 
# 
# ### EXAMPLE PACKAGE CALL ---- theme_3(name = "Birds", points = c(pts2, pts3), poly_fill = df2)
# 
# theme3_name <- "Amphibians"
# 
# theme3_pts_1 <- pts1
# 
# theme3_pts_2 <- pts2
# 
# theme3_poly_fill_1 <- as_Spatial(df3)
# 
# theme3_max_val <- as.numeric(max(theme3_poly_fill_1@data$fill_value))
# theme3_min_val <- as.numeric(min(theme3_poly_fill_1@data$fill_value))
# theme3_pal <- colorNumeric(c("RdYlGn"), theme3_min_val:theme3_max_val)
# 
# 
# ### EXAMPLE PACKAGE CALL ---- theme_3(name = "Fish", points = c(pts2, pts3), poly_fill = df2)
# 
# theme4_name <- "Reptiles"
# 
# theme4_pts_1 <- pts2
# 
# theme4_pts_2 <- pts3
# 
# theme4_poly_fill_1 <- as_Spatial(df4)
# 
# theme4_max_val <- as.numeric(max(theme4_poly_fill_1@data$fill_value))
# theme4_min_val <- as.numeric(min(theme4_poly_fill_1@data$fill_value))
# theme4_pal <- colorNumeric(c("RdYlGn"), theme4_min_val:theme4_max_val)
# 
# 



# 5. Select map defaults--------

#variable for user picks base map, nice way to preview them all here:
#https://leaflet-extras.github.io/leaflet-providers/preview/
map_base_theme <- "Stamen.Terrain"


#setting center point for map default, will want package user to set this or
#a way to code a midpoint based on data they load? maybe a wishlist thing for later
center_lat <- "42.8"
center_long <- "-75.2327"

#user sets zoom
min_zoom <- 7.2



# Saving data and variables ------


datalist <- list(
  tab1 = list(
    title = "Flowering Plants",
    fills = flowering_plants,
    points = list(points_parks, points_watchsites)
      ),
  tab2 = list(
    title = "Birds",
    fills = birds,
    points = list(points_watchsites, points_campgrounds)
      ),
  tab3 = list(
    title = "Amphibians & Reptiles",
    fills = list(amphibians, reptiles),
    points = list(points_campgrounds, points_parks)
  ))




save(map_base_theme, center_lat, center_long, min_zoom,
     datalist, theme1_pal,
     file = "final_data.rdata")

