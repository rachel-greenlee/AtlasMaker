# Packages-----
library(leaflet)
library(leaflet.extras)
library(dplyr)
library(shiny)
library(readr)
library(sf)



#running the script that represents our eventual package
source('our_responsibility.R') # eventually this would library(something)
# * Ensure 'map_server' function is present * 
# This is the only thing needed from source('our_responsibility.R') unless
# Desired for running map_ui naming convention for main panel mapping
load('app2.rdata')

# 1. Pre-processing data into dataframes ------

## Cleaning ----
Boats <- Boats %>% 
  filter(record_type == "BOAT") %>% 
  group_by(county) %>% 
  summarise(fill_value = n())
HateCrimes <- HateCrimes %>% 
  filter(year == "2020", 
         crime_type == "Crimes Against Persons") %>% 
  dplyr::select(county, year, total_victims) 
HateCrimes$total_victims <- as.numeric(HateCrimes$total_victims)
BestFish <- BestFish %>% 
  dplyr::select(name, location.longitude, location.latitude, county, fish_spec, url) 
AgFairs <- AgFairs %>% 
  dplyr::select(georeference.coordinates, county, fair_name, url)
# AgFairs$georeference.coordinates - Contains lat and long together (needs splitting)


## Points ----
points_complaints <- tibble(
  #add lat/lon to a tibble for inputting to addMarkers() later
  label = Complaints$pd_desc, 
  long = as.numeric(Complaints$longitude), 
  lat = as.numeric(Complaints$latitude)
)

points_MVColisions <- tibble(
  label = MVColisions$collision_id, 
  long = as.numeric(MVColisions$longitude), 
  lat = as.numeric(MVColisions$latitude)
)

points_lotto <- tibble(
  label = Lotto$name,
  long = as.numeric(Lotto$longitude), 
  lat = as.numeric(Lotto$latitude)
)

points_fish <- tibble(
  label = BestFish$name, 
  long = as.numeric(BestFish$location.longitude), 
  lat = as.numeric(BestFish$location.latitude)
)

# No binding necessary for these datasets

## ----- Polygons -----

# Load bundle saved from supported-polygons.R script
load("counties_NY.rdata") # Might need/want geometries for MODZCTA? 
  # Could also join with its own geoms to form spatial data frame? 

## MODZCTA species 
# class(as.numeric(MODZCTA$pop_est))
# MODZCTA$pop_est <- as.numeric(MODZCTA$pop_est)
# MODZCTA %>% 
#   dplyr::select(MODZCTA, MODZCTA$the_geom.coordinates)
# as_Spatial(MODZCTA) # Error in UseMethod("st_cast") : 
#   no applicable method for 'st_cast' applied to an object of class "data.frame"
# Special Note:
# User should consider what geometries they need before mapping! Duh

## Income classes from Returns -----
Income$number_of_all_returns <- as.numeric(Income$number_of_all_returns) # Make number numeric for computation
Income <- Income %>% 
  filter(country == "United States", 
         state == "New York") %>% 
  group_by(tax_year, county, income_class, number_of_all_returns) %>%
  summarise() 
Income <- Income %>% 
  filter(income_class == "Under 5,000", 
         tax_year == "2014") %>% 
  rename(NAME = county, 
         fill_value = number_of_all_returns)   
# Join and convert to Spatial Polygons
Income <- counties_NY %>% 
  left_join(Income, by = "NAME")
Income <- as_Spatial(Income)

## Electric Vehicles by County ----- * Clean DF Naming Later * 
EVs$registration_class <- as.numeric(EVs$registration_class)
EVs <- EVs %>%
  rename(NAME = "county", 
         fill_value = registration_class) %>% 
  dplyr::select(NAME, fill_value) # NAME is capitalized here
Evs <- counties_NY %>% # It is not capitalized here
  left_join(EVs, by = "NAME") # Need exact matches for left_join 

counties_NY$NAME <- toupper(counties_NY$NAME) # We capitalize names in spatial reference
evs <- counties_NY %>% # New Uppercase NAME should match exactly with reference
  left_join(EVs, by = "NAME") # Consider rename with EVs? 
evs <- as_Spatial(evs) # Form Large Spatial DataFrame

## Boat Registrations 
Boats <- Boats %>% 
  rename(
   NAME = 'county')
Boats <- counties_NY %>% 
  left_join(Boats, by = 'NAME')
Boats <- as_Spatial(Boats)

## Hate Crimes in NY State 
HateCrimes <- HateCrimes %>% 
  transmute(NAME = toupper(county), # transmutation has something to do with -> sf? 
            year = as.numeric(year), 
            fill_value = total_victims) 
HateCrimes <- counties_NY %>% 
  left_join(HateCrimes, by = "NAME")
HateCrimes <- as_Spatial(HateCrimes)



# 2. Create lists per tab/theme-----------------

## for tab 1 -------------

polys_income <- list(
  list(
    name = 'Income_class',
    data = Income,
    label = 'NAME',
    fill = 'fill_value'
  )
)

points_lotto <- list(
  list(
    name = 'Lotto',
    data = points_lotto,
    long = 'longitude',
    lat = 'latitude',
    label = 'name'
  )
)

#palette scaling for polygon fills
pal_income_max <- as.numeric(max(Income@data$fill_value, na.rm = T)) # Improved!
pal_income_min <- as.numeric(min(Income@data$fill_value, na.rm = T)) # Now works with missing values
pal_income <- colorNumeric(c("RdYlGn"), pal_income_min:pal_income_max) # Woot!



## for tab 2-------------

polys_evs <- list(
  list(
    name = 'evs',
    data = evs,
    label = 'NAME',
    fill = 'fill_value'
  )
)

points_fish <- list(
  list(
    name = 'bestfish',
    data = points_fish,
    long = 'location.longitude',
    lat = 'location.latitude',
    label = 'fish_spec'
  )
)

#palette scaling for polygon fills
pal_evs_max <- as.numeric(max(evs@data$fill_value, na.rm = T)) # Improved!  
pal_evs_min <- as.numeric(min(evs@data$fill_value, na.rm = T)) # Now works with missing values
pal_evs <- colorNumeric(c("RdYlGn"), pal_evs_min:pal_evs_max) # Woot! 



## for tab 3-------------

polys_boats <- list(
  name = 'boats', 
  data = Boats, 
  label = 'NAME', 
  fill = 'fill_value'
)

# reuse points_fish 

polys_hatecrimes <- list(
    name = 'hatecrimes',
    data = HateCrimes,
    label = 'NAME',
    fill = 'fill_value'
  )

points_hatecrimeslotto <- list(
  list(
    name = 'Lotto',
    data = points_lotto,
    long = 'longitude',
    lat = 'latitude',
    label = 'name'
  )
)

#palette scaling for polygon fills
pal_hatecrimes_max <- as.numeric(max(HateCrimes@data$fill_value, na.rm = T)) # Improved!  
pal_hatecrimes_min <- as.numeric(min(HateCrimes@data$fill_value, na.rm = T)) # Now works with missing values
pal_hatecrimes <- colorNumeric(c("RdYlGn"), pal_hatecrimes_min:pal_hatecrimes_max) # Woot! 
pal_boats_max <- as.numeric(max(Boats@data$fill_value, na.rm = T))
pal_boats_min <- as.numeric(min(Boats@data$fill_value, na.rm = T))
pal_boats <- colorNumeric(c("RdYlGn"), pal_boats_min:pal_boats_max)


## Combine the lists for mapping

all <- list( 
  polys = list(polys_income, polys_evs, polys_boats), 
  points = list(points_lotto, points_fish, points_fish)
)


# 3. Set ui/layout --------
ui <- fluidPage(
  titlePanel("Package Test Map 2"),
  
  # sidebarLayout(
  #     sidebarPanel(
  #     ),
  
  mainPanel(
    tabsetPanel(
      tabPanel('Income & Lotto', map_UI('income')),
      tabPanel('EVs and Fish', map_UI('fishevs')),
      tabPanel('Boats and Fish', map_UI('boatsfish'))
    )
    
  )
)



server <- function(input, output) {
# 4. Create 1 map_server per theme/tab ------

  # map_server("income", 
  #            polygons = all$polys, 
  #            points = all$points, 
  #            pal = pal_income
  #  )
 map_server("income",
            polygons = polys_income,
            points = points_lotto,
            pal = pal_income
 )
 map_server("fishevs",
            polygons = polys_evs,
            points = points_fish,
            pal = pal_evs
 )
 map_server("boatsfish",
            polygons = polys_boats,
            points = points_fish,
            pal = pal_boats
 )

}


# Run the application 
shinyApp(ui = ui, server = server)
