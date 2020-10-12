#--------------------------------------------------------------------
###############################Install Related Packages #######################
if (!require("dplyr")) {
  install.packages("dplyr")
  library(dplyr)
}
if (!require("tibble")) {
  install.packages("tibble")
  library(tibble)
}
if (!require("tidyverse")) {
  install.packages("tidyverse")
  library(tidyverse)
}
if (!require("shinythemes")) {
  install.packages("shinythemes")
  library(shinythemes)
}

if (!require("sf")) {
  install.packages("sf")
  library(sf)
}
if (!require("RCurl")) {
  install.packages("RCurl")
  library(RCurl)
}
if (!require("tmap")) {
  install.packages("tmap")
  library(tmap)
}
if (!require("rgdal")) {
  install.packages("rgdal")
  library(rgdal)
}
if (!require("leaflet")) {
  install.packages("leaflet")
  library(leaflet)
}
if (!require("shiny")) {
  install.packages("shiny")
  library(shiny)
}
if (!require("shinythemes")) {
  install.packages("shinythemes")
  library(shinythemes)
}
if (!require("plotly")) {
  install.packages("plotly")
  library(plotly)
}
if (!require("ggplot2")) {
  install.packages("ggplot2")
  library(ggplot2)
}
if (!require("viridis")) {
  install.packages("viridis")
  library(viridis)
}
#--------------------------------------------------------------------
###############################Define Functions#######################

#--------------------------------------------------------------------
###############################Data Preparation#######################
#Data Sources

#Download the park crowds data in this link and after cleaning it, put it to output file
# https://data.cityofnewyork.us/dataset/Social-Distancing-Parks-Crowds-Data/gyrw-gvqc

setwd('..')
output_shapefile_filepath <- "./output/clean_parks_data.csv"
park_data<-read.csv(output_shapefile_filepath)


#####################import data for dashboard#######################

# read ZIP_CODE_040114.shp
path_zip = "./data/"
file_zip = "ZIP_CODE_040114.shp"
zipcode_geo <- sf::st_read(paste0(path_zip, file_zip)) %>%
  sf::st_transform('+proj=longlat +datum=WGS84')

# read park data
park_join = read_csv(getURL("./output/park_join_4map.csv"),
                         col_types = cols())

park_join.action_taken = c("Approached the crowd; they ignored the employee",
                           "Approached the crowd; they complied with instructions",
                           "Did not approach the crowd; the crowd remains")

# read covid cases data
case_df = read_csv(getURL("./output/daily_cases_by_boro.csv"))
