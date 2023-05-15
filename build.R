library(devtools)

document()
install(build_vignettes = TRUE)
build()
check()

# usethis::use_package('sf', type = 'Imports')
# usethis::use_package('sp', type = 'Imports')
# usethis::use_package('leaflet', type = 'Suggests')

##### Some simple tests
library(AtlasMaker)
ls('package:AtlasMaker')
vignette(package = 'AtlasMaker')
vignette('AtlasMaker')
data(package = 'AtlasMaker')
AtlasMaker::shiny_AtlasMaker()

# tools::resaveRdaFiles('data')

