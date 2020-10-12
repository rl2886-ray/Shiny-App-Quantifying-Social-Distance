#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
#global.r will enable us to get new data everyday
#update data with automated script
source("global.R") 


# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$distPlot <- renderPlot({

        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white')

    })


#----------------------------------------
#tab panel 2 - Maps
    
    map_base = leaflet(
        options = leafletOptions(dragging = FALSE, 
                                 minZoom = 9, maxZoom = 16)
    ) %>%
        setView(lng = -73.92,lat = 40.73, zoom = 11) %>% 
        addTiles(group = "OpenStreetMap") %>% 
        addProviderTiles("CartoDB", group = "Carto") %>% 
        # addProviderTiles("Esri", group = "Esri")  %>% 
        # addProviderTiles("Wikimedia", group = "Wikimedia")  %>% 
        addLayersControl(baseGroups = c("OpenStreetMap", "Carto"),
                         overlayGroups = c(park_join.action_taken)) 
    
    pal_park <- colorFactor(palette = c("red","green", "blue"), 
                            levels = park_join.action_taken)
    
    observe({
        if(!is.null(input$date_map)){
            input_date <- format.Date(input$date_map,'%Y-%m-%d')}
        input_if_covid_boro = input$if_covid_boro_map
        input_if_covid_zip = input$if_covid_zip_map
        covid_fillOpacity = input$covid_fillOpacity_map
        input_cum_new = input$cum_choice_new_map
        
        
        output$map_park_covid = renderLeaflet({
            if (input_cum_new == "cumulative"){
                # input_date = ymd("2020-05-01") #test case
                park_join = park_join %>% filter(date <= input_date)
                case_df = case_df %>% filter(date <= input_date) %>% 
                    group_by(borough) %>% summarise(cases = sum(cases))
            } else {
                park_join = park_join %>% filter(date == input_date)
                case_df = case_df %>% filter(date == input_date)
            }
            zipcode_geo = zipcode_geo %>% 
                left_join(case_df,by = c("COUNTY"="borough"))
            
            map_out = map_base
            
            
            if (input_if_covid_boro){
                pal_covid <- colorNumeric(palette = "Blues",
                                          domain = (zipcode_geo$cases))  
                map_out = map_out %>%
                    addPolygons(data = zipcode_geo,
                                weight = 1, 
                                color = ~pal_covid(cases),
                                fillOpacity = covid_fillOpacity,
                                popup = ~(paste0("<b>Zip Code: ",ZIPCODE , "</b><br/>borough: ",
                                                 COUNTY,"<br/>cases: ", cases)),
                                highlight = highlightOptions(weight = 3,
                                                             color = "red", 
                                                             bringToFront = TRUE))
            }
            
            
            map_out = map_out  %>%
                addCircleMarkers(data = subset(park_join,
                                               action_taken=="Approached the crowd; they complied with instructions"),
                                 lng = ~lon, lat = ~lat,
                                 color = ~pal_park(action_taken), radius = 3, 
                                 clusterOptions = markerClusterOptions(),
                                 popup = ~paste0("<b>", name, "</b><br/>", address),
                                 group = "Approached_complied") %>% 
                addCircleMarkers(data = subset(park_join,
                                               action_taken=="Approached the crowd; they ignored the employee"),
                                 lng = ~lon, lat = ~lat,
                                 color = ~pal_park(action_taken), radius = 3, 
                                 clusterOptions = markerClusterOptions(),
                                 popup = ~paste0("<b>", name, "</b><br/>", address),
                                 group = "Approached_ignored") %>%
                addCircleMarkers(data = subset(park_join,
                                               action_taken=="Did not approach the crowd; the crowd remains"),
                                 lng = ~lon, lat = ~lat,
                                 color = ~pal_park(action_taken), radius = 3, 
                                 clusterOptions = markerClusterOptions(),
                                 popup = ~paste0("<b>", name, "</b><br/>", address),
                                 group = "NotApproached") %>%
                addLegend(data = park_join, position = "bottomright",
                          pal = pal_park, opacity = 0.5, title = "social distancing: action_taken",
                          values = ~action_taken) %>% 
                addLayersControl(baseGroups = c("OpenStreetMap", "Carto"),
                                 overlayGroups = c(park_join.action_taken)) 
            
        })
        
        leafletProxy("map_base")
        
    })
    
})
