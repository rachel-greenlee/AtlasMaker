library(shiny)
library(rgdal)
library(maptools)
library(leaflet)

source('map_module.R') # eventually this would library(something)

boroughs <- readOGR(dsn = 'boroughs/',
                    stringsAsFactors = FALSE)
boroughs <- spTransform(boroughs, CRS("+proj=longlat +datum=WGS84 +no_defs"))

MODZCTA <- readOGR(dsn = 'MODZCTA', stringsAsFactors = FALSE)
MODZCTA <- spTransform(MODZCTA, CRS("+proj=longlat +datum=WGS84 +no_defs"))


boroughs_layer <- list(
    list(
        name = 'Boroughs',
        data = boroughs,
        label = 'boro_name',
        fill = 'shape_area'
    ), 
    list(
        name = 'Zip Codes',
        data = MODZCTA,
        label = 'label',
        fill = 'pop_est'
    )
)

my_points <- list(
    list(
        name = 'Points A',
        long = NA,
        lat = NA,
        label = 'some column'
    )
)

MODZCTA_layer <- list(
    data = MODZCTA,
    label = 'label',
    fill = 'pop_est'
)

# Define UI for application that draws a histogram
ui <- fluidPage(
    titlePanel("My Test Map"),

    sidebarLayout(
        sidebarPanel(
        ),

        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(
                tabPanel('Boroughs', map_UI('boroughs')),
                tabPanel('Zip Codes', map_UI('MODZCTA'))
            )
            
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    map_server("boroughs", 
               polygons = boroughs_layer # Closer, sometimes displays the polygons
               # polygons = my_polygons
               # points = datalist$tab2$points[[1]]$label, # Left alone, not yet functioning
               # pal = theme1_pal
               ) 
    map_server("MODZCTA",
               polygons = MODZCTA_layer
               # points = MODZCTA_points
               )
}

# Run the application 
shinyApp(ui = ui, server = server)
