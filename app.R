# Packages-----
library(leaflet)
library(leaflet.extras)
library(dplyr)
library(shiny)
library(readr)
library(sf)



#running the script that represents our eventual package
# source('our_responsibility.R') # eventually this would library(something)
source('our_responsibility_copy.R')

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

#load('ny_roads.rdata') # May take a long time (2 - 5 minutes) - not run*
# sample_ny_roads is all that is required - only 6000 obs vs 1+ million 


#interstate only
load('roads_ny_interstate.rdata')
roads_ny_interstate <- as_Spatial(roads_ny_interstate)


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
    name = 'ny_interstates',
    data = roads_ny_interstate
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


## for tab 4-------------
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

?leaflet::addPolygons()

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
for(i in 1:length(points_all)){
  output <- points_all[[i]]$name
  point_names <- append(point_names, output)}


### ----- Color Testing Delete Later ----- ###
# min(polys_all[[1]]$data$fill_value)
# min(polys_all[[2]]$data$fill_value)
# min(polys_all[[3]]$data$fill_value)
# min(polys_all[[4]]$data$fill_value)
# 
# function(d){
#   d[[1]]$data$fill_value
# }
# 
# pal_amphibians_max <- as.numeric(max(amphibians@data$fill_value))
# pal_amphibians_min <- as.numeric(min(amphibians@data$fill_value))
# pal_amphibians <- colorNumeric(c("RdYlGn"), pal_amphibians_min:pal_amphibians_max)
# 
# for (i in 1:length(polys_all)){
#   mn <- as.numeric(min(polys_all[[i]]$data$fill_value))
#   mx <- as.numeric(max(polys_all[[i]]$data$fill_value))
#   pal_df <- colorNumeric(c("RdYlGn"), mn:mx)
#   list()
# }
# 
# brew_pal <- function(d){
#   mn <- as.numeric(min(d[[1]]$data$fill))
#   mx <- as.numeric(max(d[[1]]$data$fill))
#   pal_cols <- colorNumeric(c("RdYlGn"), mn:mx)
# }
# 
# brew_pal(polys_amph_rept)


# function(polys_all){
# 
#   for (i in 1:length(polys_all)){
#       mn <- as.numeric(min(polys_all[[i]]$data$fill_value))
#       mx <- as.numeric(max(polys_all[[i]]$data$fill_value))
#       pal_df <- colorNumeric(c("RdYlGn"), mn:mx)
#   }
# 
# }
# 
# for (i in polys_all){
# 
# }
# 
# pal_sel <- function(d){
#   for(i in 1:length(d)){
#     mn <- as.numeric(min(d[[i]]$data$fill_value))
#     mx <- as.numeric(max(d[[i]]$data$fill_value))
#     pal_df <- colorNumeric(c("RdYlGn"), mn:mx)
#   }
#   return(pal_df)
# }
# 
# pal_selector <- function(d){
#   pal <- colorNumeric(c("RdYlGn"), 
#     as.numeric(min(d[[i]]$data$fill_value)):as.numeric(max(d[[i]]$data$fill_value)))
#   return(pal)
# }
# 
# pal <- colorNumeric(c("RdYlGn"), min():max())

# RColorBrewer::display.brewer.pal(4, "RdYlGn")
# 
# ifelse(d[[1]]$data$fill_value = !is.na,  )
# if(d[[1]]
#   colorNumeric()
# 
#   
# for (i in 1:length(d)){
#   
# }

# colorNumeric(c("RdYlGn"), 
#             domain = min(polys_all[[2]]$data$fill_value):max(polys_all[[2]]$data$fill_value))
# 
# colorNumeric(c("RdylGn"), min(polygons[[i]]$data$fill_value):max(polygons[[i]]$data$fill_value))

pal_amphibians_max <- as.numeric(max(amphibians@data$fill_value))
pal_amphibians_min <- as.numeric(min(amphibians@data$fill_value))
pal_amphibians <- colorNumeric(c("RdYlGn"), pal_amphibians_min:pal_amphibians_max)

pal_selector1 <- function(sf){
  if(sf[[1]]$name == "flowering_plants"){
    return(pal_flowering)
  } else if(sf[[2]]$name == "birds"){
    return(pal_birds)
  } else if(sf[[3]]$name == "amphibians"){
    return(pal_amphibians)
  } else if(sf[[4]]$name == "reptiles"){
    return("not available")
  }
}

# Function needs to adapt to each polygon selection: 
# *identify the layer that is selected* how to do this in the module?
# find the min and max 
# assign colors over the range for a given color palette



pal_selector2 <- function(W){

  palette =function(X){
    pal_x = colorNumeric(c("RdYlGn"), min(polygons[[i]]$data$fill_value):max(polygons[[i]]$data$fill_value)) 
    return(pal_x)
  }
  assign("pal_x", palette, envir = .GlobalEnv)
  return(invisible())
}

pal_selector3 <- function(W){
  
  palette =function(X){
    pal_x = colorNumeric(c("RdYlGn"), min(polygons[[i]]$data$fill_value):max(polygons[[i]]$data$fill_value)) 
    return(pal_x)
  }
  return(palette)
}


# pal_selector2(polys_flowering_plants)

# 
# 
# 
# pal_selector(sf = polys_all)

### ----- End Color Testing ----- ###



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
               polylines = NULL,
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
               polygons = polys_all, 
               polylines = NULL,
               points = points_all,
               pal = pal_flowering
              )
}


# Run the application 
shinyApp(ui = ui, server = server)
