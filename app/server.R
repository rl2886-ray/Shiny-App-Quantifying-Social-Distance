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
    # addProviderTiles("MapBox", group = "Esri") %>%
    # addProviderTiles("Esri.WorldGrayCanvas", group = "WorldGrayCanvas")
    # 
    # pal_park <- colorNumeric(palette = "Greens",
    #                          domain = park_join$patroncount)
    #                         
    
    observe({
        # if(!is.null(input$date_map)){
        #     input_date <- format.Date(input$date_map,'%Y-%m-%d')}
        # input_if_covid_boro = input$if_covid_boro_map
        # input_if_covid_zip = input$if_covid_zip_map
        # covid_fillOpacity = 0.5
        # input_cum_new = input$cum_choice_new_map
        
        
        output$map_park_covid = renderLeaflet({
            
            # if (input_cum_new == "cumulative"){
            #     # input_date = ymd("2020-05-01") #test case
            #     park_join = park_join %>% filter(date <= input_date)
            #     case_df = case_df %>% filter(date <= input_date) %>%
            #         group_by(borough) %>% summarise(cases = sum(cases))
            # } else {
            #     park_join = park_join %>% filter(date == input_date)
            #     case_df = case_df %>% filter(date == input_date)
            # }
            
            zipcode_geo = zipcode_geo %>% 
                left_join(covid0630,by = c("ZIPCODE"="ZIPCODE"))
            
            map_out = map_base
            
            # shades: covid cases
            # if (input_if_covid_boro){
            # pal_covid <- colorNumeric(palette = "Blues",
            #                           domain = (zipcode_geo$cases))  
            map_out = map_out  %>% 
                # addPolygons
                addPolygons(data = zipcode_geo,
                            weight = 0.25,
                            fillOpacity = 0,
                            popup = ~(paste0("<b>Zip Code: ",ZIPCODE ,"</b><br/>borough: ",
                                             PO_NAME,"<br/>Number of confirmed cases by Jun 30: ", cases)),
                            highlight = highlightOptions(weight = 2,
                                                         color = "red",
                                                         bringToFront = F)) %>%
                addCircleMarkers(data = park_join.nrow_patron_zip,
                                 lng = ~LNG_repre, lat = ~LAT_repre,
                                 color = "#FFB400", radius = ~ceiling(n/5), 
                                 popup = ~(paste0("<b>Zip Code: ",zip ,
                                                  "</b><br/>Number of records of people violating social-distancing: ", n)),
                                 group = "social_distancing") %>%
                addCircleMarkers(data = covid0630,
                                 lng = ~LNG_repre, lat = ~LAT_repre,
                                 color = "#2C6BAC", radius = ~(cases)/100, 
                                 popup = ~(paste0("<b>Zip Code: ",ZIPCODE , 
                                                  "</b><br/>Number of confirmed cases by Jun 30: ", cases)),
                                 group = "covid")
            # }
            
            
            map_out = map_out  %>%
                # addMarkers(data = park_join, lng = ~lon, lat = ~lat,
                #            label = ~patroncount) %>%
                # addCircleMarkers(data = park_join, lng = ~lon, lat = ~lat,
                #                  color = ~pal_park(patroncount), radius = 5, 
                #                  
                #                  # clusterOptions = markerClusterOptions(),
                #                  popup = ~paste0("<b>", name, "</b><br/>", address,
                #                                  "<br/>", 
                #                                  format(timestamp,"%Y-%m-%d %H:%M"))
                # highlight = highlightOptions(weight = 3,
                #                              color = "red", 
            #                              bringToFront = TRUE)
            # ) %>% 
            # addLegend(data = park_join, position = "bottomright",
            #           pal = pal_park, opacity = 0.5, 
            #           title = "social distancing: patroncount",
            #           values = ~patroncount) %>% 
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
            hc_series( list(name = 'Number of gatherings', data =BK_data$number, color='green', marker = list(symbol = 'circle'), yAxis = 1 ),
                       list(name = 'Covid-19 cases', data =BK_data$BK_CASE_COUNT, color = 'green', dashStyle = 'shortDot', marker = list(symbol = 'triangle') )
            )%>%
            hc_xAxis( categories = unique(park_borough_data$timestamp) ) %>%
            hc_yAxis_multiples( list(title = list(text = "Covid-19 cases")),
                                list(showLastLabel = FALSE, opposite = TRUE, title = list(text = "Number of gatherings")))%>%
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
            hc_series( list(name = 'Number of gatherings', data =BX_data$number, color='green', marker = list(symbol = 'circle'), yAxis = 1 ),
                       list(name = 'Covid-19 cases', data =BX_data$BX_CASE_COUNT, color = 'green', dashStyle = 'shortDot', marker = list(symbol = 'triangle') )
            )%>%
            hc_xAxis( categories = unique(park_borough_data$timestamp) ) %>%
            hc_yAxis_multiples( list(title = list(text = "Covid-19 cases")),
                                list(showLastLabel = FALSE, opposite = TRUE, title = list(text = "Number of gatherings")))%>%
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
            hc_series( list(name = 'Number of gatherings', data =MN_data$number, color='green', marker = list(symbol = 'circle'), yAxis = 1 ),
                       list(name = 'Covid-19 cases', data =MN_data$MN_CASE_COUNT, color = 'green', dashStyle = 'shortDot', marker = list(symbol = 'triangle') )
            )%>%
            hc_xAxis( categories = unique(park_borough_data$timestamp) ) %>%
            hc_yAxis_multiples( list(title = list(text = "Covid-19 cases")),
                                list(showLastLabel = FALSE, opposite = TRUE, title = list(text = "Number of gatherings")))%>%
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
            hc_series( list(name = 'Number_of_Crowd', data =QN_data$number, color='green', marker = list(symbol = 'circle'), yAxis = 1 ),
                       list(name = 'Covid_Cases', data =QN_data$QN_CASE_COUNT, color = 'green', dashStyle = 'shortDot', marker = list(symbol = 'triangle') )
            )%>%
            hc_xAxis( categories = unique(park_borough_data$timestamp) ) %>%
            hc_yAxis_multiples( list(title = list(text = "Covid-19 cases")),
                                list(showLastLabel = FALSE, opposite = TRUE, title = list(text = "Number of gatherings")))%>%
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
            hc_series( list(name = 'Number of gatherings', data =SI_data$number, color='green', marker = list(symbol = 'circle'), yAxis = 1 ),
                       list(name = 'Covid-19 cases', data =SI_data$Cases, color = 'green', dashStyle = 'shortDot', marker = list(symbol = 'triangle') )
            )%>%
            hc_xAxis( categories = unique(park_borough_data$timestamp) ) %>%
            hc_yAxis_multiples( list(title = list(text = "Covid-19 cases")),
                                list(showLastLabel = FALSE, opposite = TRUE, title = list(text = "Number of gatherings")))%>%
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
    #tab panel 4 - Demographic
    
    
    output$distPlot1 <- renderPlotly({
        
        plot_ly(data %>% select(DATE, TOTAL_TESTS),
                x = ~DATE,
                y = ~TOTAL_TESTS,type = 'scatter',
                mode = 'lines',
                name= "daily cases") %>% add_trace(y=data$TOTAL_TESTS_7DAYS_AVG,name="7 days avg") %>%
            layout(title="Total Tests")
    })
    
    output$piePlot1 <- renderPlotly({
        plot_ly(boro[1:5,] %>% select(BOROUGH_GROUP, CASE_COUNT), 
                labels = ~BOROUGH_GROUP, 
                values = ~CASE_COUNT, 
                type = 'pie') %>%
            layout(title="COVID case by borough",
                   xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                   yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    })
    
    output$piePlot2 <- renderPlotly({
        plot_ly(parkdata %>% select(park_borough, patroncount) %>%
                    group_by(park_borough) %>%
                    summarise(count = n()), 
                labels = ~park_borough, 
                values = ~count, 
                type = 'pie') %>%
            layout(title="people gathering by borough",
                   xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                   yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    })
    
    output$piePlot3 <- renderPlotly({
        plot_ly(sex %>% select(SEX_GROUP, CASE_COUNT) %>% filter(SEX_GROUP %in% c("Male","Female")), 
                labels = ~SEX_GROUP,
                values = ~CASE_COUNT, 
                type = 'pie') %>%
            layout(title="COVID case by sex",
                   xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                   yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    })
    
    output$piePlot4 <- renderPlotly({
        plot_ly(race %>% select(RACE_GROUP, CASE_COUNT), 
                labels = ~RACE_GROUP,
                values = ~CASE_COUNT, 
                type = 'pie') %>%
            layout(title="COVID case by race",
                   xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                   yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    })
    
    output$piePlot5 <- renderPlotly({
        plot_ly(age %>% select(AGE_GROUP, CASE_COUNT) %>% filter(AGE_GROUP!="Citywide"), 
                labels = ~AGE_GROUP,
                values = ~CASE_COUNT, 
                type = 'pie') %>%
            layout(title="COVID case by age",
                   xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                   yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    })
    
    output$piePlot6 <- renderPlotly({
        plot_ly(age %>% select(AGE_GROUP, DEATH_COUNT) %>% filter(AGE_GROUP!="Citywide"), 
                labels = ~AGE_GROUP,
                values = ~DEATH_COUNT, 
                type = 'pie') %>%
            layout(title="COVID death case by age",
                   xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                   yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
    })
    
    output$parkPlot2 <- renderPlotly({
        plot_ly(parkdata %>%filter(patroncount>=3&patroncount<=50)%>%
                    mutate(encounter_timestamp = substr(encounter_timestamp, start = 0, stop = 10)) %>% 
                    group_by(encounter_timestamp) %>%
                    summarise(count = n()),
                x = ~encounter_timestamp,
                y = ~count,
                type = "bar") %>%
            layout(title = "Encounter count violanting social distance rule")
    })
})
