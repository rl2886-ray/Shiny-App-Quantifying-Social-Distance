#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#global.r will enable us to get new data everyday
#update data with automated script
source("global.R") 


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    #----------------------------------------
    #tab panel 2 - Maps
    
    map_base = leaflet(
        options = leafletOptions(dragging = T, 
                                 minZoom = 10, maxZoom = 16)
    ) %>%
        setView(lng = -73.92,lat = 40.73, zoom = 11) %>% 
        addTiles() %>%
        addProviderTiles("CartoDB.Positron", group = "Carto")
                        
    
    observe({

        output$map_park_covid = renderLeaflet({
            
            zipcode_geo = zipcode_geo %>% 
                left_join(covid0630,by = c("ZIPCODE"="ZIPCODE"))
            
            map_out = map_base

            map_out = map_out  %>% 
                # addPolygons
                addPolygons(data = zipcode_geo,
                            weight = 0.25,
                            fillOpacity = 0,
                            popup = ~(paste0("<b>Zip Code: ",ZIPCODE ,"</b><br/>Borough: ",
                                             PO_NAME,"<br/>Number of confirmed cases by Jun 30: ", cases)),
                            highlight = highlightOptions(weight = 2,
                                                         color = "red",
                                                         bringToFront = F)) %>%
                addCircleMarkers(data = park_join.nrow_patron_zip,
                                 lng = ~LNG_repre, lat = ~LAT_repre,
                                 color = "#FFB400", radius = ~ceiling(n/5), 
                                 popup = ~(paste0("<b>Zip Code: ",zip ,
                                                  "</b><br/>Gatherings: ", n)),
                                 group = "social_distancing") %>%
                addCircleMarkers(data = covid0630,
                                 lng = ~LNG_repre, lat = ~LAT_repre,
                                 color = "#2C6BAC", radius = ~(cases)/100, 
                                 popup = ~(paste0("<b>Zip Code: ",ZIPCODE , 
                                                  "</b><br/>Number of confirmed cases by Jun 30: ", cases)),
                                 group = "covid")
            # }
            
            
            map_out = map_out  %>%

            addLayersControl(baseGroups =  c("Carto"),
                             overlayGroups = c("covid","social_distancing")) 
            
        })
        
        leafletProxy("map_base")
        
    })
    
    
    #----------------------------------------
    #tab panel 3 - TimeSeriesPlot
    output$BKdistPlot <- renderHighchart({
        
        highchart() %>%
            hc_exporting(enabled = TRUE, formAttributes = list(target = "_blank")) %>%
            hc_chart(type = 'line') %>%
            hc_series( list(name = 'Number of gatherings', data =BK_data$number, color='green', marker = list(symbol = 'circle')),
                       list(name = 'Covid-19 cases', data =BK_data$BK_CASE_COUNT, color = 'green', dashStyle = 'shortDot', marker = list(symbol = 'triangle'), yAxis = 1  )
            )%>%
            hc_xAxis( categories = unique(park_borough_data$timestamp) ) %>%
            hc_yAxis_multiples( list(title = list(text = "Number of gatherings")),
                                list(showLastLabel = FALSE, opposite = TRUE, title = list(text = "Covid-19 cases")))%>%
            hc_plotOptions(column = list(
                dataLabels = list(enabled = F),
                #stacking = "normal",
                enableMouseTracking = T ) 
            )%>%
            hc_tooltip(table = TRUE,
                       sort = TRUE,
                       pointFormat = paste0( '<br> <span style="color:{point.color}">\u25CF</span>',
                                             " {series.name}: {point.y}"),
                       headerFormat = '<span style="font-size: 13px">Date {point.key}</span>'
            ) %>%
            hc_legend( layout = 'vertical', align = 'left', verticalAlign = 'top', floating = T, x = 100, y = 000 )
        
    })
    output$BXdistPlot <- renderHighchart({
        
        highchart() %>%
            hc_exporting(enabled = TRUE, formAttributes = list(target = "_blank")) %>%
            hc_chart(type = 'line') %>%
            hc_series( list(name = 'Number of gatherings', data =BX_data$number, color='green', marker = list(symbol = 'circle') ),
                       list(name = 'Covid-19 cases', data =BX_data$BX_CASE_COUNT, color = 'green', dashStyle = 'shortDot', marker = list(symbol = 'triangle'), yAxis = 1 )
            )%>%
            hc_xAxis( categories = unique(park_borough_data$timestamp) ) %>%
            hc_yAxis_multiples( list(title = list(text = "Number of gatherings")),
                            list(showLastLabel = FALSE, opposite = TRUE, title = list(text = "Covid-19 cases")))%>%
            hc_plotOptions(column = list(
                dataLabels = list(enabled = F),
                #stacking = "normal",
                enableMouseTracking = T ) 
            )%>%
            hc_tooltip(table = TRUE,
                       sort = TRUE,
                       pointFormat = paste0( '<br> <span style="color:{point.color}">\u25CF</span>',
                                             " {series.name}: {point.y}"),
                       headerFormat = '<span style="font-size: 13px">Date {point.key}</span>'
            ) %>%
            hc_legend( layout = 'vertical', align = 'left', verticalAlign = 'top', floating = T, x = 100, y = 000 )
        
    })
    output$MNdistPlot <- renderHighchart({
        
        highchart() %>%
            hc_exporting(enabled = TRUE, formAttributes = list(target = "_blank")) %>%
            hc_chart(type = 'line') %>%
            hc_series( list(name = 'Number of gatherings', data =MN_data$number, color='green', marker = list(symbol = 'circle') ),
                       list(name = 'Covid-19 cases', data =MN_data$MN_CASE_COUNT, color = 'green', dashStyle = 'shortDot', marker = list(symbol = 'triangle') , yAxis = 1)
            )%>%
            hc_xAxis( categories = unique(park_borough_data$timestamp) ) %>%
            hc_yAxis_multiples( list(title = list(text = "Number of gatherings")),
                            list(showLastLabel = FALSE, opposite = TRUE, title = list(text = "Covid-19 cases")))%>%
            hc_plotOptions(column = list(
                dataLabels = list(enabled = F),
                #stacking = "normal",
                enableMouseTracking = T ) 
            )%>%
            hc_tooltip(table = TRUE,
                       sort = TRUE,
                       pointFormat = paste0( '<br> <span style="color:{point.color}">\u25CF</span>',
                                             " {series.name}: {point.y}"),
                       headerFormat = '<span style="font-size: 13px">Date {point.key}</span>'
            ) %>%
            hc_legend( layout = 'vertical', align = 'left', verticalAlign = 'top', floating = T, x = 100, y = 000 )
        
    })
    output$QNdistPlot <- renderHighchart({
        
        highchart() %>%
            hc_exporting(enabled = TRUE, formAttributes = list(target = "_blank")) %>%
            hc_chart(type = 'line') %>%
            hc_series( list(name = 'Number_of_Crowd', data =QN_data$number, color='green', marker = list(symbol = 'circle') ),
                       list(name = 'Covid_Cases', data =QN_data$QN_CASE_COUNT, color = 'green', dashStyle = 'shortDot', marker = list(symbol = 'triangle') , yAxis = 1)
            )%>%
            hc_xAxis( categories = unique(park_borough_data$timestamp) ) %>%
            hc_yAxis_multiples( list(title = list(text = "Number of gatherings")),
                            list(showLastLabel = FALSE, opposite = TRUE, title = list(text = "Covid-19 cases")))%>%
            hc_plotOptions(column = list(
                dataLabels = list(enabled = F),
                #stacking = "normal",
                enableMouseTracking = T ) 
            )%>%
            hc_tooltip(table = TRUE,
                       sort = TRUE,
                       pointFormat = paste0( '<br> <span style="color:{point.color}">\u25CF</span>',
                                             " {series.name}: {point.y}"),
                       headerFormat = '<span style="font-size: 13px">Date {point.key}</span>'
            ) %>%
            hc_legend( layout = 'vertical', align = 'left', verticalAlign = 'top', floating = T, x = 100, y = 000 )
        
    })
    output$SIdistPlot <- renderHighchart({
        
        highchart() %>%
            hc_exporting(enabled = TRUE, formAttributes = list(target = "_blank")) %>%
            hc_chart(type = 'line') %>%
            hc_series( list(name = 'Number of gatherings', data =SI_data$number, color='green', marker = list(symbol = 'circle')),
                       list(name = 'Covid-19 cases', data =SI_data$Cases, color = 'green', dashStyle = 'shortDot', marker = list(symbol = 'triangle') , yAxis = 1)
            )%>%
            hc_xAxis( categories = unique(park_borough_data$timestamp) ) %>%
            hc_yAxis_multiples( list(title = list(text = "Number of gatherings")),
                            list(showLastLabel = FALSE, opposite = TRUE, title = list(text = "Covid-19 cases")))%>%
            hc_plotOptions(column = list(
                dataLabels = list(enabled = F),
                #stacking = "normal",
                enableMouseTracking = T ) 
            )%>%
            hc_tooltip(table = TRUE,
                       sort = TRUE,
                       pointFormat = paste0( '<br> <span style="color:{point.color}">\u25CF</span>',
                                             " {series.name}: {point.y}"),
                       headerFormat = '<span style="font-size: 13px">Date {point.key}</span>'
            ) %>%
            hc_legend( layout = 'vertical', align = 'left', verticalAlign = 'top', floating = T, x = 100, y = 000 )
        
    })
    
  
    #----------------------------------------
    #tab panel 4 - transportation
    output$transPlot <- renderHighchart({
    highchart() %>%
      hc_exporting(enabled = TRUE, formAttributes = list(target = "_blank")) %>%
      hc_chart(type = 'line') %>%
      hc_series( list(name = 'Driving', data =trans_drive$moving_avg, color='#32CD32', marker = list(symbol = 'triangle'), yAxis = 1 ),
                 list(name = 'Waling', data =trans_walk$moving_avg, color="#228B22", marker = list(symbol = 'triangle'), yAxis = 1 ),
                 list(name = 'Public Transport', data =trans_bus$moving_avg, color='#006400', marker = list(symbol = 'triangle'), yAxis = 1 ),
                 list(name = 'Covid-19 Cases', data =data$POSITIVE_TESTS_7DAYS_AVG, color = 'green', dashStyle = 'shortDot', marker = list(symbol = 'circle') )
      )%>%
      hc_xAxis( categories = trans_drive$DATE ) %>%
      hc_yAxis_multiples( list(title = list(text = "Covid-19 Cases")),
                          list(showLastLabel = FALSE, opposite = TRUE, title = list(text = "Mobility Trend Compared to Baseline")))%>%
      hc_plotOptions(column = list(
        dataLabels = list(enabled = F),
        #stacking = "normal",
        enableMouseTracking = T ) 
      )%>%
      hc_tooltip(table = TRUE,
                 sort = TRUE,
                 pointFormat = paste0( '<br> <span style="color:{point.color}">\u25CF</span>',
                                       " {series.name}: {point.y}"),
                 headerFormat = '<span style="font-size: 13px">Date {point.key}</span>'
      ) %>%
      hc_legend( layout = 'vertical', align = 'left', verticalAlign = 'top', floating = T, x = 100, y = 000 )
    })
})