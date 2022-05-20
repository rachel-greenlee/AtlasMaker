library(devtools)

document()
install()
build()
check()

usethis::use_package('sf', type = 'Imports')
# usethis::use_package('leaflet', type = 'Suggests')

##### Some simple tests
library(AtlasMaker)
ls('package:AtlasMaker')
data(package = 'AtlasMaker')
AtlasMaker::shiny_AtlasMaker()


##### Prepare data files for package
library(readr)
library(tibble)

points_parks <- read_csv("raw-data/State_Park_Facility_Points.csv")
#add lat/lon to a tibble for inputting to addMarkers() later
points_parks <- tibble(
	label = points_parks$Name,
	long = points_parks$Longitude,
	lat = points_parks$Latitude)
save(points_parks, file = 'data/points_parks.rda')


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
save(points_campgrounds, file = 'data/points_campgrounds.rda')


points_watchsites <- read_csv("raw-data/Watchable_Wildlife_Sites.csv")
#add lat/lon to a tibble for inputting to addMarkers() later
points_watchsites <- tibble(
	label = points_watchsites$`Site Name`,
	long = points_watchsites$Longitude,
	lat = points_watchsites$Latitude)
save(points_watchsites, file = 'data/points_watchsites.rda')

biodiversity <- read_csv("raw-data/Biodiversity_by_County_-_Distribution_of_Animals__Plants_and_Natural_Communities.csv")
save(biodiversity, file = 'data/biodiversity.rda')

