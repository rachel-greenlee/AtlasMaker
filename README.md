# AtlasMaker

<!-- badges: start -->
<!-- badges: end -->

The goal of the `AtlasMaker` R package is to create multiple, related `leaflet` maps across tabs for a `shiny` application without having to copy, paste, and continually edit core code blocks that share much of the same structure across map tabs. Users build lists of any polygons, points, and polylines needed for the project, use the `map_server()` function to feed built lists and other chosen aesthetics into the tab, and the package does the rest.

Download slides exploring AtlasMaker's purpose and creation:
[slides](https://github.com/rachel-greenlee/AtlasMaker/blob/main/inst/slides/AtlasMaker_slides.pdf).

## Installation

You can install the development version of AtlasMaker from [GitHub](https://github.com/rachel-greenlee/AtlasMaker) with:

``` r
# install.packages("devtools")
devtools::install_github("rachel-greenlee/AtlasMaker")
```

To run the Shiny demo application, run the following command:

``` r
AtlasMaker::shiny_AtlasMaker()
```

## Using AtlasMaker in your Shiny Application

