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



## Polygons-----

# Load bundle saved from supported-polygons.R script
load("app3.rdata")



# health insurance-------COULD USE LATER
# bring in health insurance coverage data 

---------
  
# coverage <- read_csv("raw-data/health_ins_coverage.csv")
# 
# coverage <- coverage %>%
#   rename("NAME" = 'State')
# 
# ins_coverage <- states %>%
#   left_join(coverage, by = 'NAME')
# ins_coverage <- as_Spatial(ins_coverage)
--------





# travel/trips-------
#https://www.kaggle.com/datasets/ramjasmaurya/trips-by-distancefrom-2019-to-nov-2021?select=State_trips.csv
# bring in travel data

################################################CRASHING MY PC, NO NEED TO USE/FIX

# trips <- read_csv("raw-data/State_trips.csv")
# 
# trips <- trips %>%
#   rename("STUSPS" = 'State Postal Code') %>%
#   select(STUSPS, `Population Staying at Home`, `Population Not Staying at Home`) %>%
#   mutate(state_pop =  rowSums(.[2:3]),
#          perc_trips = (`Population Not Staying at Home` / state_pop))
#   
# 
# trips <- states %>%
#   left_join(trips, by = 'STUSPS')
# 
# trips <- as_Spatial(trips)



  ## Polylines-----
  
roads <- as_Spatial(us_road)
  
rails <- as_Spatial(us_rails)
  
  


# 2. Create lists per tab/theme-----------------


## for tab 1-------------

polys_base <- list(
    list(
        name = 'base polys',
        data = states,
        label = 'NAME',
        fill = NULL
    )
)

lines_base <- list(
    list(
        name = 'rails lines',
        data = rails,
        label = 'FULLNAME'
    ),
    list(
      name = 'roads lines',
      data = roads,
      label = 'FULLNAME'
    )
)



## for tab 2-------------





# 3. Set ui/layout --------
ui <- fluidPage(
    titlePanel("US State & Rail Test"),

    # sidebarLayout(
    #     sidebarPanel(
    #     ),

        mainPanel(
            tabsetPanel(
                tabPanel('Base Map', map_UI('base_map')),
                #tabPanel('Birds', map_UI('birds')),
                #tabPanel('Amphibians & Reptiles', map_UI('amph_rept'))
            )
            
        )
    )



# 4. Create 1 map_server per theme/tab ------

server <- function(input, output) {
    map_server("base_map", 
               polygons = polys_base,
               points = NULL,
               polylines = lines_base,
               pal = NULL
               ) 
    # map_server("birds", 
    #          polygons = polys_birds,
    #          points = points_birds,
    #          pal = pal_birds
    #           ) 
    # map_server("amph_rept", 
    #          polygons = polys_amph_rept,
    #          points = points_amp_rept,
    #          pal = pal_amphibians
    # ) 
}


# Run the application 
shinyApp(ui = ui, server = server)
