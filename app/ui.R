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
library(lubridate)

dashboardPage(
    skin = "green",
    title = "RadaR",
    dashboardHeader(title = "Social Distancing & Covid 19",
                    titleWidth = 300),
    dashboardSidebar( 
        sidebarMenu(
        menuItem("Home&Introduction", tabName = "home", icon = icon("dashboard")),
        menuItem("Covid_Dashboard or Map", tabName = "dashboard", icon = icon("map")),
        menuItem("Social_Distance", tabName = "sd", icon = icon("people-arrows")),
        menuItem("Data_Source", tabName = "source", icon = icon("database"))
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
                                solidHeader = TRUE, h3("Social_Distancing & Covid"),
                                h4("By Qinzhe Hu, Depeng Kong, Rui Liang, Yotam Segal, Hankun Shi"),
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
                        h2("dashboard tab content"),
                        leafletOutput("map_park_covid", width = "100%", height = "1200"),
                        absolutePanel(id = "control", class = "panel panel-default", fixed = F, draggable = TRUE,
                                      top = 100, left = 20, right = "auto", bottom = "auto", width = 300, height = "auto",
                                      
                                      h4("Which covid cases to visualize:"),
                                      checkboxInput("if_covid_boro_map", "historical cases at borough level", value = T),
                                      # checkboxInput("if_covid_zip_map", "today's cases at zipcode level", value = TRUE),
                                      sliderInput('date_map','Input Date:', value = lubridate::ymd('2020-05-01'), 
                                                  min = lubridate::ymd('2020-03-25'), max = lubridate::ymd(('2020-06-30')), 
                                                  timeFormat = "%Y-%m-%d",animate = TRUE, step = 1),
                                      radioButtons(inputId = "cum_choice_new_map","cumulative / daily new",
                                                   choices = list("cumulative","new"),selected = "cumulative"),
                                      sliderInput(inputId = "covid_fillOpacity_map", label = "fill Opacity",
                                                  value=0.5,min=0,max=1,step=0.01,ticks = F,dragRange = F),
                                      style = "opacity: 0.90"
                        )
            ),
            # Third tab content
            tabItem(tabName = "sd",
                    h2("social distance tab content")
            ),
            # Fourth tab content
            tabItem(tabName = "source",
                    h2("Data source tab content")
            )
        )
    )
)

