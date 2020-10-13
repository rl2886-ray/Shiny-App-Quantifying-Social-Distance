#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)

dashboardPage(
    skin = "green",
    title = "RadaR",
    dashboardHeader(title = "Quantifying Social Distancing",
                    titleWidth = 300),
    dashboardSidebar( 
        sidebarMenu(
        menuItem("Home", tabName = "home", icon = icon("dashboard")),
        menuItem("Map", tabName = "dashboard", icon = icon("map")),
        menuItem("Parks", tabName = "sd", icon = icon("people-arrows")),
        menuItem("Transportation", tabName = "ts", icon = icon("dashboard")),
        menuItem("Data", tabName = "source", icon = icon("database"))
    )
    ),
    dashboardBody(
        tabItems(
            # First tab content
            #home
            tabItem(tabName = "home",
                    fluidPage(
                        fluidRow(
                            box(width = 15, title = "Introduction", status = "success",
                                solidHeader = TRUE, h3("Quantifying Social Distancing"),
                                h4("By Qinzhe Hu, Depeng Kong, Rui Liang, Yotam Segal, Hankun Shi"),
                                h5("Social Distancing is an important factor in the fight against the Pandemic. The scientific community urges us to respect Social Distancing as it was proven an effective measure. Nevertheless, to date, there has been very little research on how to quantify and measure social distancing. It is indeed a difficult task. People move around and it is virtually impossible to keep track on their interactions and physical distance from others. Accurately measuring social distancing would allow society to predict cases and inform decision makers by providing real-time data, as apposed to the 14-days delayed testing results. This crucial step would enable to take highly targeted preemptive measures, rather than wide lock-downs. Indeed, some nations are using cellular tracking to measure social distancing and help with contact tracing, but in many countries this measure is unconstitutional and, in some regions,, it is simply unfeasible. In this study we explore ways in which society can measure social distancing by using control variables: Park Gatherings, collected by NYC, and Transportation data, collected by Apple.")
                               )),
                        fluidRow(box(width = 15, title = "User Guide", status = "success",
                                     solidHeader = TRUE, h3("What Does This App Do?"),
                                     tags$div(tags$ul(
                                         tags$li("Covid_Dashboard&Map: This part contains "),
                                         tags$li("Social_Distance: This part is "),
                                         tags$li("Data_Source: ")
                                     ))))
                    )),
            # Second tab content
            tabItem(tabName = "dashboard",
                    h2("Map for park gathering and covid-19 cases"),
                    leafletOutput("map_park_covid", width = "100%", height = 800),
                    absolutePanel(id = "control", class = "panel panel-default", fixed = T, draggable = TRUE,
                                  top = 150, left = 300, right = "auto", bottom = "auto", width = 300, height = "auto",
                                  
                                  # h4("Which covid cases to visualize"),
                                  # checkboxInput("if_covid_boro_map", "historical cases at borough level", value = T),
                                  # # checkboxInput("if_covid_zip_map", "today's cases at zipcode level", value = TRUE),
                                  # sliderInput('date_map','Input Date:', value = lubridate::ymd('2020-05-01'), 
                                  #             min = lubridate::ymd('2020-03-25'), max = lubridate::ymd(('2020-06-30')), 
                                  #             timeFormat = "%Y-%m-%d",animate = TRUE, step = 1),
                                  # radioButtons(inputId = "cum_choice_new_map","cumulative / daily new",
                                  #              choices = list("cumulative","new"),selected = "cumulative"),
                                  # # sliderInput(inputId = "covid_fillOpacity_map", label = "fill Opacity",
                                  # #             value=0.5,min=0,max=1,step=0.01,ticks = F,dragRange = F),
                                  # style = "opacity: 0.90"
                    )
            ),
            # Third tab content
            tabItem(tabName = "sd",
                    fluidPage(
                        h2("Cases-19 Cases and Park Gatherings" ),
                        fluidRow(
                            column( width = 12,h4("Brooklyn ", align = 'center'), highchartOutput('BKdistPlot')
                            )  
                        ),
                        fluidRow(
                            column( width = 12,h4("Bronx  ", align = 'center'), highchartOutput('BXdistPlot') )
                            
                        ),
                        fluidRow(
                            column( width = 12,h4("Manhattan ", align = 'center'), highchartOutput('MNdistPlot') )
                            
                        ),
                        fluidRow(
                            column( width = 12,h4("Queens ", align = 'center'), highchartOutput('QNdistPlot') )
                            
                        ),
                        fluidRow(
                            column( width = 12,h4("StatenIsland ", align = 'center'), highchartOutput('SIdistPlot') )
                            
                        )
                    )
                    
            ),
            # Fourth tab content
            tabItem(tabName = "ts",
                    h2("Transportation"),
                    fluidPage(
                        fluidRow(
                            column( width = 12,h4("TransportationPlot ", align = 'center'), highchartOutput('transPlot'))
                        )
            )
        ),
        # Fifth tab content
        tabItem(tabName = "source",
                h2("Data source tab content")
        )
    )
)
)
