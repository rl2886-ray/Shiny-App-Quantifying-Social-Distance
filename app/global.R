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
if (!require("highcharter")) {
  install.packages("highcharter")
  library(highcharter)
}
if (!require("lubridate")) {
  install.packages("lubridate")
  library(lubridate)
}
#--------------------------------------------------------------------
###############################Define Functions#######################
# Help to select the data that are between March and June
date_truncate<-function(data){
  data$DATE_OF_INTEREST<-as.Date(data$DATE_OF_INTEREST, format = "%m/%d/%y")
  data_new<-data[data$DATE_OF_INTEREST >= "2020-03-01" & data$DATE_OF_INTEREST < "2020-07-01",]
  data_new<-data_new %>% rename(
    timestamp =  DATE_OF_INTEREST
  )
  return(data_new)
}

#--------------------------------------------------------------------
###############################Data Preparation#######################
#Data Sources

#####################import data for timeseries#######################
#Download the park crowds data in this link and aftering cleaning it, put it to output file
# https://data.cityofnewyork.us/dataset/Social-Distancing-Parks-Crowds-Data/gyrw-gvqc


output_shapefile_filepath <- "./output/clean_parks_data.csv"
park_data<-read.csv(output_shapefile_filepath)
park_data$timestamp<-as.Date(as.POSIXct(park_data$timestamp, origin="1970-01-01"))
park_borough_data<-park_data %>% 
                               count(park_borough,timestamp,name="number")
park_borough_data<-park_borough_data[order(park_borough_data$timestamp),]
BX_bor<-park_borough_data[park_borough_data$park_borough == "Bronx",]
BK_bor<-park_borough_data[park_borough_data$park_borough == "Brooklyn",]
MN_bor<-park_borough_data[park_borough_data$park_borough == "Manhattan",]
QN_bor<-park_borough_data[park_borough_data$park_borough == "Queens",]
SI_bor<-park_borough_data[park_borough_data$park_borough ==  "Staten Island",]

#Download from NYC health Covid 19 data link 
# https://www1.nyc.gov/site/doh/covid/covid-19-data-boroughs.page
BK_data<-read.csv('./output/data-BK.csv')
BX_data<-read.csv('./output/data-BX.csv')
MN_data<-read.csv('./output/data-MN.csv')
QN_data<-read.csv('./output/data-QN.csv')
SI_data<-read.csv('./output/data-SI.csv')

# Truncating the data to the date between March and June
BK_data<-date_truncate(BK_data)
BX_data<-date_truncate(BX_data)
MN_data<-date_truncate(MN_data)
QN_data<-date_truncate(QN_data)
SI_data<-date_truncate(SI_data)

#Merging covid data and park crowds data 
BK_data<-merge(BK_data,BK_bor,by="timestamp")
BX_data<-merge(BX_data,BX_bor,by="timestamp")
MN_data<-merge(MN_data,MN_bor,by="timestamp")
QN_data<-merge(QN_data,QN_bor,by="timestamp")
SI_data<-merge(SI_data,SI_bor,by="timestamp")


#####################import data for map#######################

# read ZIP_CODE_040114.shp
zipcode_geo <- sf::st_read("./output/ZIP_CODE_040114/ZIP_CODE_040114.shp") %>%
  sf::st_transform('+proj=longlat +datum=WGS84')

# read park data
park_join = read_csv("./output/park_join_4map.csv")
park_join.nrow_patron_zip = read_csv("./output/park_join.nrow_patron_zip.csv",
              col_types = cols(zip=col_character()))

# read covid cases data
zc2013 = read_csv("./output/zc2013.csv")
covid0630 = read_csv("./output/covid0630.csv",
                     col_types = cols(ZIPCODE=col_character()))

#####################import data for transportation#######################
transit = read_csv("./output/proccessed_data_mobility.csv")
data<-read_csv("./output/tests.csv") %>% filter(DATE <= "06/30/2020")
trans_drive = transit %>% dplyr::filter(mobility == "driving")
trans_walk = transit %>% dplyr::filter(mobility == "walking")
trans_bus = transit %>% dplyr::filter(mobility == "transit")


