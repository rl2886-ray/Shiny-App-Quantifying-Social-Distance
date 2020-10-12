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
                    h2("covid tab content")
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

