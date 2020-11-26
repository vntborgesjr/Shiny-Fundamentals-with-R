# -------------------------------------------------
# Building Web Applications with Shiny in R - Build Shiny Apps
# 26 nov 2020
# VNTBJR
# ------------------------------------------------
# 
# Load packages
library(tidyverse)
library(shiny)

# Load data
usa_ufo_sightings <-read.csv("Datasets/usa_ufo_sightings.csv")
str(usa_ufo_sightings)

# App #1:Alien sightings
ui <- fluidPage(
  # CODE BELOW: Add a title
  titlePanel("UFO Sightings"),
  sidebarLayout(
    sidebarPanel(
      # CODE BELOW: One input to select a U.S. state
      # And one input to select a range of dates
      selectInput(inputId = "state", label = "Choose a U.S. state:",
                  choices = unique(usa_ufo_sightings$state)),
      dateRangeInput(inputId = "dates", label = "Choose a data range:", 
                     start = sort(usa_ufo_sightings$date_sighted)[1], 
                     end = sort(usa_ufo_sightings$date_sighted)[150])
    ),
    # MODIFY CODE BELOW: Create a tab layout for the dashboard
    mainPanel(
      tabsetPanel(
        tabPanel("Number sighted", 
                 # Add plot output named 'shapes'
                 plotOutput(outputId = "shapes")),
        tabPanel("Duration table",
                 # Add table output named 'duration_table'
                 tableOutput(outputId = "duration_table"))
      )
    )
  )
)

server <- function(input, output) {
  data <- reactive({
    usa_ufo_sightings %>% 
      filter(state == input$state) %>% 
      filter(date_sighted > input$dates[1]) %>%
      filter(date_sighted <= input$dates[2])
  })
  # CODE BELOW: Create a plot output of sightings by shape,
  # For the selected inputs
  output$shapes <- renderPlot({
    data() %>% 
    ggplot(mapping = aes(x = shape)) +
      geom_bar() +
      labs(
        x = "Shape",
        y = "# Sighted"
      )
  })
  # CODE BELOW: Create a table output named 'duration_table', by shape,
  # of # sighted, plus mean, median, max, and min duration of sightings
  # for the selected inputs
  output$duration_table <- renderTable({
   data() %>%
      group_by(shape) %>% 
      summarise(nb_sighted = n(),
                avg_duration_min = mean(duration_sec) / 60,
                median_duration_min = median(duration_sec) / 60,
                min_duration_min = min(duration_sec) / 60,
                max_duration_min = max(duration_sec) / 60)
  })
}

shinyApp(ui, server)
