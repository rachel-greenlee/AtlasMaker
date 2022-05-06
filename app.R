# Packages-----
library(leaflet)
library(leaflet.extras)
library(dplyr)
library(shiny)
library(readr)
library(sf)



#running the script that represents our eventual package
source('our_responsibility.R') # eventually this would library(something)


# 1. Pre-processing data into dataframes------

## Points ----

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


## Polylines ----
# Load bundle saved from tigris_imports.R
load("clinton_county_roads.rdata")

clinton_roads <- as_Spatial(clinton_county_roads)

load('ny_roads.rdata') # May take a long time (2 - 5 minutes) - not run*
# sample_ny_roads is all that is required - only 6000 obs vs 1+ million 
ny_sample_roads <- as_Spatial(sample_ny_roads)


## Polygons-----
load("counties_NY.rdata")

# bring in biodiversity data 
biodiversity <- read_csv("raw-data/Biodiversity_by_County_-_Distribution_of_Animals__Plants_and_Natural_Communities.csv")

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

# Make Spatial DataFrames with counties_NY
# For flowering plants
flowering_plants <- counties_NY %>%
  left_join(flowering_plants, by = 'NAME')
flowering_plants <- as_Spatial(flowering_plants)



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

# For birds
birds <- counties_NY %>%
  left_join(birds, by = 'NAME')
birds <- as_Spatial(birds)




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

# For amphibians
amphibians <- counties_NY %>%
  left_join(amphibians, by = 'NAME')
amphibians <- as_Spatial(amphibians)



## Reptiles------------

# Species Abundance Selection
reptiles <- biodiversity %>%  
  group_by(County, `Taxonomic Group`) %>% 
  filter(`Taxonomic Group` == "Reptiles") %>%
  summarise(n())
# Join and convert to Spatial Polygons
reptiles <- reptiles %>%
  rename("NAME" = 'County', 
         "fill_value" = `n()`)

# For reptiles
reptiles <- counties_NY %>%
  left_join(reptiles, by = 'NAME')
reptiles <- as_Spatial(reptiles)





# 2. Create lists per tab/theme-----------------


## for tab 1-------------

polys_flowering_plants <- list(
    list(
        name = 'flowering_plants',
        data = flowering_plants,
        label = 'name',
        fill = 'fill_value'
    )
)


lines_flowering_plants <- list(
  list(
    name = 'clinton_roads',
    data = clinton_county_roads
  )
)


points_flowering_plants <- list(
    list(
        name = 'points_parks',
        data = points_parks,
        long = 'long',
        lat = 'lat',
        label = 'label'
    )
)


#palette scaling for polygon fills
pal_flowering_max <- as.numeric(max(flowering_plants@data$fill_value))
pal_flowering_min <- as.numeric(min(flowering_plants@data$fill_value))
pal_flowering <- colorNumeric(c("RdYlGn"), pal_flowering_min:pal_flowering_max)



## for tab 2-------------

polys_birds <- list(
  list(
    name = 'birds',
    data = birds,
    label = 'name',
    fill = 'fill_value'
  )
)

lines_birds <- list(
  list(
    name = 'ny_roads_sample',
    data = ny_sample_roads
  )
)



points_birds <- list(
  list(
    name = 'points_watchsites',
    data = points_watchsites,
    long = 'long',
    lat = 'lat',
    label = 'label'
  ),
  list(
    name = 'points_campgrounds',
    data = points_campgrounds,
    long = 'long',
    lat = 'lat',
    label = 'label'
    
  )
)

#palette scaling for polygon fills
pal_birds_max <- as.numeric(max(birds@data$fill_value))
pal_birds_min <- as.numeric(min(birds@data$fill_value))
pal_birds <- colorNumeric(c("RdYlGn"), pal_birds_min:pal_birds_max)



## for tab 3-------------

polys_amph_rept <- list(
  list(
    name = 'amphibians',
    data = amphibians,
    label = 'name',
    fill = 'fill_value'
  ), 
  list(
    name = 'reptiles',
    data = reptiles,
    label = 'label',
    fill = 'fill_value'
  )
)


polygon_names <- list()
for(i in 1:length(polys_amph_rept)){
  output <- polys_amph_rept[[i]]$name
  polygon_names <- append(polygon_names, output)}


points_amp_rept <- list(
  list(
    name = 'points_parks',
    data = points_parks,
    long = 'long',
    lat = 'lat',
    label = 'label'
  ),
  list(
    name = 'points_campgrounds',
    data = points_campgrounds,
    long = 'long',
    lat = 'lat',
    label = 'label'
    
  )
)


point_names <- list()
for(i in length(points_amp_rept)){
  output <- points_amp_rept[[i]]$name
  point_names <- append(point_names, output)}


#palette scaling for polygon fills
pal_amphibians_max <- as.numeric(max(amphibians@data$fill_value))
pal_amphibians_min <- as.numeric(min(amphibians@data$fill_value))
pal_amphibians <- colorNumeric(c("RdYlGn"), pal_amphibians_min:pal_amphibians_max)


## ----- Tab 4 ---- ## 
# All Polygons
polys_all <- list(
  list(
    name = 'flowering_plants',
    data = flowering_plants,
    label = 'name',
    fill = 'fill_value'
  ),
  list(
    name = 'birds',
    data = birds,
    label = 'name',
    fill = 'fill_value'
  ),
  list(
    name = 'amphibians',
    data = amphibians,
    label = 'name',
    fill = 'fill_value'
  ), 
  list(
    name = 'reptiles',
    data = reptiles,
    label = 'label',
    fill = 'fill_value'
  )
)

polygon_names <- list()
for(i in 1:length(polys_all)){
  output <- polys_all[[i]]$name
  polygon_names <- append(polygon_names, output)}

# All Points
points_all <- list(
  list(
    name = 'points_parks',
    data = points_parks,
    long = 'long',
    lat = 'lat',
    label = 'label'
  ),
  list(
    name = 'points_campgrounds',
    data = points_campgrounds,
    long = 'long',
    lat = 'lat',
    label = 'label'
  )
)

point_names <- list()
for(i in length(points_all)){
  output <- points_all[[i]]$name
  point_names <- append(point_names, output)}



# 3. Set ui/layout --------
ui <- fluidPage(
    titlePanel("Package Test Map"),

    # sidebarLayout(
    #     sidebarPanel(
    #     ),

        mainPanel(
            tabsetPanel(
                tabPanel('Flowering Plants', map_UI('flowering_plants')),
                tabPanel('Birds', map_UI('birds')),
                tabPanel('Amphibians & Reptiles', map_UI('amph_rept')),
                tabPanel("All", map_UI("allthegoods"))
            )
            
        )
    )



# 4. Create 1 map_server per theme/tab ------

server <- function(input, output) {
    map_server("flowering_plants", 
               polygons = polys_flowering_plants,
               polylines = lines_flowering_plants,
               points = points_flowering_plants,
               pal = pal_flowering
               ) 
    map_server("birds", 
             polygons = polys_birds,
             polylines = lines_birds,
             points = points_birds,
             pal = pal_birds
              ) 
    map_server("amph_rept", 
             polygons = polys_amph_rept,
             polylines = NULL,
             points = points_amp_rept,
             pal = pal_amphibians
  ) 
    map_server("allthegoods", 
               polygons = polys_all_names, 
               polylines = points_amp_rept, 
               pal = pal_birds)
}


# Run the application 
shinyApp(ui = ui, server = server)
