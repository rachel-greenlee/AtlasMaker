# Packages-----
library(leaflet)
library(leaflet.extras)
library(dplyr)
library(shiny)
library(readr)
library(sf)

#running the script that represents our eventual package
# eventually this would library(something)
library(AtlasMaker)

# 1. Pre-processing data into dataframes------

## Points ----

data(points_campgrounds)
data(points_parks)
data(points_watchsites)


## Polylines ----
# Load bundle saved from tigris_imports.R
#interstate only
data(roads_ny_interstate)

## Polygons-----
# laod bundle saved from tigris_imports.R of county shapefiles and names
data(counties_NY)

## Polygon fill, data prep-----

# bring in biodiversity data that will be plotted via county
data(biodiversity)

## Flowering Plant species
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
flowering_plants <- counties_NY %>%
  left_join(flowering_plants, by = 'NAME')
flowering_plants <- as_Spatial(flowering_plants)


## Birds
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


## Amphibians
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


## Reptiles
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

## for tab 1: flowering plants-------------
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


# 3. Set ui/layout --------
ui <- fluidPage(
    titlePanel("AtlasMaker Demo Map (v0.9)"),
        mainPanel(
            tabsetPanel(
                tabPanel('Flowering Plants', map_UI('flowering_plants')),
                tabPanel('Birds', map_UI('birds')),
                tabPanel('Amphibians & Reptiles', map_UI('amph_rept')),
                tabPanel("All", map_UI("allthegoods"))
            )

        )
    )


# 4. Create 1 map_server per theme/tab with as few/little 'arguments' as you need ------

# see 'colors' section of Leaflet guide for options to pass in for colors/palettes
# rstudio.github.io/leaflet/colors.html

# pass in any base layer from the link below into 'map_base_theme'
# http://leaflet-extras.github.io/leaflet-providers/preview/index.html

server <- function(input, output) {
    map_server("flowering_plants",
               polygons = polys_flowering_plants,
               polylines = NULL,
               points = points_flowering_plants,
               poly_palette = 'RdPu',
               point_color = 'brown'
               )
    map_server("birds",
             polygons = polys_birds,
             polylines = lines_birds,
             points = points_birds,
             map_base_theme = 'Stamen.Watercolor',
             poly_palette = 'YlGn',
             point_color = '#ffa500',
             polyline_color = "#964b00"
              )
    map_server("amph_rept",
             polygons = polys_amph_rept,
             polylines = NULL,
             points = points_amp_rept,
             map_base_theme = 'Esri.WorldImagery',
             poly_palette = 'Greens',
             point_color = "black"
            )
    map_server("allthegoods",
               polygons = polys_all,
               polylines = NULL,
               points = points_all
              )
}


# Run the application
shinyApp(ui = ui, server = server)
