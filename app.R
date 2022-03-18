
# Libraries & data ----
library(shiny)
library(shinydashboard)
library(leaflet)
library(tidyverse)
library(RColorBrewer)


# Load data bundle saved from data-input script
load("final_data.rdata")


# Define Module Map UI -----

map_UI <- function(id) {
  ns <- NS(id)
  leafletOutput(ns("mymap"), height =700)
}


# Define Module Map Server -----

map_server <- function(id, df, pts1, pts2, pal){
  moduleServer(id, function(input, output, session){
    
    output$mymap <- renderLeaflet({
      leaflet(base_polygons, options = 
                leafletOptions(minZoom = min_zoom)) %>% #don't let them zoom out too much
        addTiles() %>%
        #add base tiles with theme choice
        addProviderTiles(provider = map_base_theme) %>%
        #set center default point on map
        setView(lng = center_long, lat = center_lat, zoom = min_zoom) %>%
        ##!!set maximum boundary of map, not sure how to automate this year so leaving as placeholder
        #setMaxBounds()  %>%
        
        addPolygons(weight = 1,
                    fillOpacity = 0.7,
                    color = ~pal(df@data$fill_value),
                    label = ~paste(df@data$NAME, signif(df@data$fill_value, digits = 6)),
                    highlight = highlightOptions(weight = 1,
                                                 color = "black",
                                                 bringToFront = TRUE)) %>%
        addLegend(position = "bottomright", 
                  pal = pal, values = df@data$fill_value) %>% 
        
        addCircleMarkers(lng = pts1$long, lat = pts1$lat, 
                         popup = pts1$label,
                         color = "purple", radius = 2) %>%
        
        addCircleMarkers(lng = pts2$long, lat = pts2$lat, 
                         popup = pts2$label,
                         color = "purple", radius = 2)
        

      
    })
  })
}




# Define overall UI -----

ui <- dashboardPage(skin = "purple",
                    
                    
                    dashboardHeader(title = "Package Drafting"),
                    dashboardSidebar(
                      sidebarMenu(
                        menuItem(theme1_name, tabName = theme1_name),
                        menuItem(theme2_name, tabName = theme2_name),
                        menuItem(theme3_name, tabName = theme3_name),
                        menuItem(theme4_name, tabName = theme4_name),
                        menuItem("About", tabName = "about")
                      )
                    ),
                    dashboardBody(
                      tabItems(
                        tabItem(tabName = theme1_name,
                                class = "active",  #necessary only on first tab to make active it appears
                                map_UI("theme1_map")),
                                
                        tabItem(tabName = theme2_name,
                                map_UI("theme2_map")),
                        
                        tabItem(tabName = theme3_name,
                                map_UI("theme3_map")),
                        
                        tabItem(tabName = theme4_name,
                                map_UI("theme4_map")),
                        
                        
                        tabItem(tabName = "about",
                                h3(strong("About")), 
                                h5("This is a module designed with 
                                        diversity in mind; species diversity
                                        that is. Through the tabs on the left 
                                        you can navigate through different species
                                        abundances to see how many unique species appear 
                                        in each county within the U.S. state of New York."), 
                                h5(em("Data comes from the State of New York")))
                        
                        
                                )
                                
                        )
                      )
                    


# Server --------

server <- function(input, output) {
  # Theme 1 Tab --------------------------------------------------------------
  map_server("theme1_map", df = theme1_poly_fill_1, pts1 = theme1_pts_1, pts2 = theme1_pts_2, pal = theme1_pal) 
             
  
  # Theme 2 Tab ---------------------------------------------------------------
  map_server("theme2_map", df = theme2_poly_fill_1, pts1 = theme2_pts_1, pts2 = theme2_pts_2, pal = theme2_pal) 
  
  # Theme 3 Tab----------------------------------------------------------------
  map_server("theme3_map", df = theme3_poly_fill_1, pts1 = theme3_pts_1, pts2 = theme3_pts_2, pal = theme3_pal) 
  
  # Theme 4 Tab----------------------------------------------------------------
  map_server("theme4_map", df = theme4_poly_fill_1, pts1 = theme4_pts_1, pts2 = theme4_pts_2, pal = theme4_pal) 
  

}


# App call --------
shinyApp(ui = ui, server = server)



