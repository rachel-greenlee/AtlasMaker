


library(AtlasMaker)
library(leaflet)
library(shiny)


###HOW TO DO LOAD CALL SO IT ISN"T MY PC?


data(vignette_data_prepped)



# Creating Lists for Map Tab Creation


## Tab 1 - Flowering Plants


## polygons list for tab 1: flowering plants-------------
polys_flowering_plants <- list(
    list(
        name = 'flowering_plants',
        data = flowering_plants,
        label = 'name',
        fill = 'fill_value'
    )
)



## points list for tab 1: flowering plants-------------
points_flowering_plants <- list(
    list(
        name = 'points_parks',
        data = points_parks,
        long = 'long',
        lat = 'lat',
        label = 'label'
    )
)


## Tab 2 - Birds

## polygon list for tab 2: birds-------------
polys_birds <- list(
  list(
    name = 'birds',
    data = birds,
    label = 'name',
    fill = 'fill_value'
  )
)

## polyline list for tab 2: birds-------------
lines_birds <- list(
  list(
    name = 'ny_interstates',
    data = roads_ny_interstate
  )
)

## points list for tab 2: birds-------------
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



## Tab 3 & 4

## polygon list for tab 3: amph & rept -------------
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

## point list for tab 3: amph & rept-------------
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
## polygons list for tab 4: all-------------
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

## points list for tab 4: all-------------
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


server <- function(input, output) {
    map_server("flowering_plants",
               polygons = polys_flowering_plants,
    		   polygon_legend_title = "Biodiversity Count",
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








