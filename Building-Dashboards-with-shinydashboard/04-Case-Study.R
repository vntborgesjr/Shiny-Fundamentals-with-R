# --------------------------------------------------- 
# Building Dashboards with shinydashboard - Case Study 
# 03 dez 2020 
# VNTBJR 
# --------------------------------------------------- 
#
# Introduction to the NASA fireball data set  -------------------------------------------
# Load data 
load("Datasets/nasa_fireball.rda")

# Examine the variables in the data set
# Print the nasa_fireball data frame
nasa_fireball

# Examine the types of variables present
sapply(nasa_fireball, class)

# Observe the number of observations in this data frame
nrow(nasa_fireball)

# Check for missing data
sapply(nasa_fireball, anyNA)

#Create a value box for the maximum velocity
library("shiny")
max_vel <- max(nasa_fireball$vel, na.rm = TRUE)

body <- dashboardBody(
  fluidRow(
    # Add a value box for maximum velocity
    valueBox(value = max_vel,
             subtitle = "Maximum pre-impact velocity",
             icon = icon("fire"))
  )
)
ui <- dashboardPage(header = dashboardHeader(),
                    sidebar = dashboardSidebar(),
                    body = body
)
shinyApp(ui, server)

# Create a value box for the maximum impact
library("shiny")

max_impact_e <- max(nasa_fireball$impact_e, na.rm = TRUE)

body <- dashboardBody(
  fluidRow(
    # Add a value box for maximum impact
    valueBox(
      value = max_impact_e,
      subtitle = "Maximum impact energy (kilotons of TNT)",
      icon = icon("star")
    ),
    valueBox(
      value = max_vel,
      subtitle = "Maximum pre-impact velocity", 
      icon = icon("fire")
    )
  )
)

ui <- dashboardPage(header = dashboardHeader(),
                    sidebar = dashboardSidebar(),
                    body = body
)
shinyApp(ui, server)

# Create a value box for the maximum energy
library("shiny")

max_energy <- max(nasa_fireball$energy, na.rm = TRUE)

body <- dashboardBody(
  fluidRow(
    # Add a value box for maximum energy
    valueBox(
      value = max_energy,
      subtitle = "Maximum total radiated energy (Joules)",
      icon = icon("lightbulb-o")
    ),
    valueBox(
      value = max_impact_e, 
      subtitle = "Maximum impact energy (kilotons of TNT)",
      icon = icon("star")
    ),
    valueBox(
      value = max_vel,
      subtitle = "Maximum pre-impact velocity", 
      icon = icon("fire")
    )
  )
)

ui <- dashboardPage(header = dashboardHeader(),
                    sidebar = dashboardSidebar(),
                    body = body
)
shinyApp(ui, server)

# Dynamic refresh  -------------------------------------------
# Make the value boxes dynamic
n_us <- sum(
  ifelse(
    nasa_fireball$lat < 64.9 & nasa_fireball$lat > 19.5
    & nasa_fireball$lon < -68.0 & nasa_fireball$lon > -161.8,
    1, 0),
  na.rm = TRUE)

server <- function(input, output) {
  output$us_box <- renderValueBox({
    valueBox(value = n_us,
             subtitle = "Number of Fireballs in the US",
             icon = icon("globe"), 
             color = if (n_us < 10) {
               "blue"
             } else {
               "fuchsia"
             })
  })
}

body <- dashboardBody(
  fluidRow(
    valueBoxOutput(outputId = "us_box")
  )
)
ui <- dashboardPage(header = dashboardHeader(),
                    sidebar = dashboardSidebar(),
                    body = body
)
shinyApp(ui, server)

# Allow the user to input an alert threshold
sidebar <- dashboardSidebar(
  sliderInput(inputId = "threshold", label = "Color Threshold",
              min = 0, max = 100, value = 10)
)

server <- function(input, output) {
  output$us_box <- renderValueBox({
    valueBox(
      value = n_us,
      subtitle = "Number of Fireballs in the US",
      icon = icon("globe"),
      color = if (n_us < input$threshold) {
        "blue"
      } else {
        "fuchsia"
      }
    )
  })
}


ui <- dashboardPage(header = dashboardHeader(),
                    sidebar = sidebar,
                    body = body
)
shinyApp(ui, server)

# Create a dynamic plot of the location of fireballs
nasa_fireball <- nasa_fireball[complete.cases(nasa_fireball),]

library("leaflet")

server <- function(input, output) {
  output$plot <- renderLeaflet({
    leaflet() %>% 
      addTiles() %>% 
      addCircleMarkers(lng = nasa_fireball$lon, lat = nasa_fireball$lat,
                       radius = log(nasa_fireball$impact_e), 
                       label = nasa_fireball$date, weight = 2)
  })
}

body <- dashboardBody( 
  leafletOutput("plot")
)

ui <- dashboardPage(
  header = dashboardHeader(),
  sidebar = dashboardSidebar(),
  body = body
)

shinyApp(ui, server)

# Update the look of your new application
library("leaflet")

server <- function(input, output) {
  output$plot <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%  
      addCircleMarkers(
        lng = nasa_fireball$lon,
        lat = nasa_fireball$lat, 
        radius = log(nasa_fireball$impact_e), 
        label = nasa_fireball$date, 
        weight = 2)
  })
}

body <- dashboardBody(
  fluidRow(
    valueBox(
      value = max_energy, 
      subtitle = "Maximum total radiated energy (Joules)", 
      icon = icon("lightbulb-o")
    ),
    valueBox(
      value = max_impact_e, 
      subtitle = "Maximum impact energy (kilotons of TNT)",
      icon = icon("star")
    ),
    valueBox(
      value = max_vel,
      subtitle = "Maximum pre-impact velocity", 
      icon = icon("fire")
    )
  ),
  fluidRow(
    leafletOutput("plot")
  )
)


ui <- dashboardPage(
  skin = "purple",
  header = dashboardHeader(),
  sidebar = dashboardSidebar(),
  body = body
)

shinyApp(ui, server)
