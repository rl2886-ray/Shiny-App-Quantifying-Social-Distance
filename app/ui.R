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
    title = "Quantifying Social Distancing",
    dashboardHeader(title = "Quantifying Social Distancing",
                    titleWidth = 300),
    dashboardSidebar( 
        sidebarMenu(
        menuItem("Home", tabName = "home", icon = icon("dashboard")),
        menuItem("Map", tabName = "dashboard", icon = icon("map")),
        menuItem("Parks Timelime", tabName = "sd", icon = icon("tree"),startExpanded = TRUE,
                 menuSubItem("Brooklyn",tabName = "sd1"),
                 menuSubItem("Bronx",tabName = "sd2"),
                 menuSubItem("Manhattan",tabName = "sd3"),  
                 menuSubItem("Queens",tabName = "sd4"), 
                 menuSubItem("Staten ISland",tabName = "sd5")
                 ),
        menuItem("Transportation Timeline", tabName = "ts", icon = icon("car")),
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
                                h5("Social Distancing is an important factor in the fight against the Pandemic. The scientific community urges us to respect Social Distancing as it was proven an effective measure. Nevertheless, to date, there has been very little research on how to quantify and measure social distancing.", tags$br(),"It is indeed a difficult task. People move around and it is virtually impossible to keep track on their interactions and physical distance from others.", tags$br(),"Accurately measuring social distancing would allow society to predict cases and inform decision makers by providing real-time data, as apposed to the 14-days delayed testing results. This crucial step would enable to take highly targeted preemptive measures, rather than wide lock-downs." , tags$br(),"Indeed, some nations are using cellular tracking to measure social distancing and help with contact tracing, but in most countries this measure is unconstitutional and, in some regions, it is simply unfeasible.", tags$br(),"In this study we explore ways in which society can measure social distancing by using control variables: Park Gatherings, collected by NYC, and Transportation data, collected by Apple.")
                               )),
                        fluidRow(box(width = 15, title = "User Guide", status = "success",
                                     solidHeader = TRUE, h3("What Does This App Do?"),
                                     tags$div(tags$ul(
                                         tags$li("Map: An interactive map of NYC, displaying commulative park gatherings and confirmed Covid-19 cases"),
                                         tags$li("Parks Timelime: An interactive timelime of new daily updated park gatherings and confirmed Covid-19 cases"),
                                         tags$li("Transportation Timeline: An interactive timeline of transportation methods taken at NYC and new Covid-19 cases" ),
                                         tags$li("Data: Data sources we used in building this app")
                                     ))))
                    )),
            # Second tab content
            tabItem(tabName = "dashboard",
                    h2("Park Gathering and Covid-19"),
                    leafletOutput("map_park_covid", width = "100%", height = 800),
                    absolutePanel(id = "control", class = "panel panel-default", fixed = T, draggable = TRUE,
                                  top = 150, left = 300, right = "auto", bottom = "auto", width = 300, height = "auto",
                    )
            ),
            # Third tab content
            tabItem(tabName = "sd1",
                    fluidPage(
                        fluidRow(
                            column( width = 12,h2("Park Gathering and Covid-19 Brooklyn ", align = 'center'), highchartOutput('BKdistPlot')
                            )  
                        )
                    )
                    
            ),
            tabItem(tabName = "sd2",
                    fluidPage(
                        fluidRow(
                            column( width = 12,h2("Park Gathering and Covid-19 Bronx ", align = 'center'), highchartOutput('BXdistPlot')
                            )  
                        )
                    )
                    
            ),
            tabItem(tabName = "sd3",
                    fluidPage(
                        fluidRow(
                            column( width = 12,h2("Park Gathering and Covid-19 Manhattan ", align = 'center'), highchartOutput('MNdistPlot')
                            )  
                        )
                    )
                    
            ),
            tabItem(tabName = "sd4",
                    fluidPage(
                        fluidRow(
                            column( width = 12,h2("Park Gathering and Covid-19 Queens ", align = 'center'), highchartOutput('QNdistPlot')
                            )  
                        )
                    )
                    
            ),
            tabItem(tabName = "sd5",
                    fluidPage(
                        fluidRow(
                            column( width = 12,h2("Park Gathering and Covid-19 Staten ISland ", align = 'center'), highchartOutput('SIdistPlot')
                            )  
                        )
                    )
                    
            ),
            # Fourth tab content
            tabItem(tabName = "ts",
                    h2("Transportation"),
                    fluidPage(
                        fluidRow(
                            column( width = 12, highchartOutput('transPlot'))
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
