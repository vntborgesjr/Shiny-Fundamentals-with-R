# -------------------------------------------------
# Building Web Applications with Shiny in R - Build Shiny Apps
# 26 nov 2020
# VNTBJR
# ------------------------------------------------
# 
# Build an Alien Sightings Dashboard ------------------------------------------------

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

# Exploring the 2014 Mental Health in Tech Survey ------------------------------------------------
# Load packages
library(shiny)
library(tidyverse)
library(shinyWidgets)

# Load data
mental_health_survey <- read_csv("Datasets/mental_health_survey_edited.csv")

# Validate that a user made a selection

ui <- fluidPage(
  # CODE BELOW: Add an appropriate title
  titlePanel("2014 Mental Health in Tech Survey"),
  sidebarPanel(
    sliderTextInput(
      inputId = "work_interfere",
      label = "If you have a mental health condition, do you feel that it interferes with your work?", 
      grid = TRUE,
      force_edges = TRUE,
      choices = c("Never", "Rarely", "Sometimes", "Often")
    ),
    # CODE BELOW: Add a checkboxGroupInput
    checkboxGroupInput(
    inputId = "mental_health_consequence", 
    label = "Do you fell that discussing a mental health issue with your
    employer woukd have negative consequenses?", 
    choices = c("Maybe", "Yes", "No"), 
    selected = "Maybe"),
    # CODE BELOW: Add a pickerInput
    pickerInput(
    inputId = "mental_vs_physical", 
    label = "Do you fell that your employer takes mental health as 
    seriouly as physical health?",
    choices = c("Don't know", "No", "Yes"), 
    multiple = TRUE)
    ),
  mainPanel(
    # CODE BELOW: Display the output
    plotOutput(outputId = "age")
  )
)

server <- function(input, output, session) {
  # CODE BELOW: Build a histogram of the age of respondents
  # Filtered by the two inputs
  output$age <- renderPlot({
    # MODIFY CODE BELOW: Add validation that user selected a 3rd input
    validate(
      need(input$mental_vs_physical != "", "Be sure to select a choice
           for mental versus physical health question.")
    )
    mental_health_survey %>% 
      filter(work_interfere == input$work_interfere, 
             mental_health_consequence %in% input$mental_health_consequence,
             mental_vs_physical %in% input$mental_vs_physical) %>% 
      ggplot(mapping = aes(x = Age)) +
      geom_histogram()
  })

}

shinyApp(ui, server)

# Explore cuisines  -------------------------------------------
# Load packages
library(d3wordcloud)

# Load data
recipes <- readRDS('Datasets/recipes.rds')
# need to transform the list into a data frame

ui <- fluidPage(
  titlePanel('Explore Cuisines'),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = 'cuisine', 
        label = 'Select Cuisine', 
        choices = unique(recipes$cuisine)
      ),
      sliderInput(
        inputId = 'nb_ingerdients',
        label = 'Select No. of ingredients',
        min = 5,
        max = 100,
        value = 20
      )
      ),
      mainPanel(
        tabsetPanel(
          tabPanel(
            title = 'Word Cloud',
            d3wordcloudOutput('wc_ingredients')),
          tabPanel('Plot', 
                   plotly::plotlyOutput('plot_top_ingredients')),
          tabPanel('Table',
                   DT::DTOutput('dt_top_ingredients'))
        )
      )
    )
  )

server <- function(input, output, session) {
  # Compute TFIDF
  recipes_enriched <- recipes %>% 
    count(cuisine, ingredient, name = 'nb_recipes') %>% 
    tidytext::bind_tf_idf(ingredient, cuisine, nb_recipes)
  # Add a reactive expression
  rval_top_ingredients <- reactive({
    recipes_enriched %>% 
      filter(cuisine == input$cuisine) %>% 
      arrange(desc(tf_idf)) %>% 
      head(input$nb_ingredients) %>% 
      mutate(ingredient = forcats::fct_reorder(ingredient, tf_idf))
  }) 
  # Add output: interactive table
  output$dt_top_ingredients <- DT::renderDT({
     recipes %>% 
       filter(cuisine == input$cuisine) %>% 
       count(ingredient, name = 'nb_recipes') %>% 
       arrange(desc(nb_recipes)) %>% 
       head(input$nb_ingredients)
   })
  # Add output: interactive plot 
  output$plot_top_ingredients <- plotly::renderPlotly({
    rval_top_ingredients() %>% 
      arrange(desc(tf_idf)) %>% 
      ggplot(aes(x = ingredient, y = tf_idf, )) +
      geom_col() +
      coord_flip()
  })
  # Add output: word cloud
  output$wc_ingredients <- renderD3wordcloud({
    d <- rval_top_ingredients()
    d3wordcloud(d$ingredient, d$nb_recipes, tooltip = TRUE)
  })
}

shinyApp(ui = ui, server = server)

# Mass shootings  -------------------------------------------
# Load packages
library(leaflet)

# Load data
mass_shootings <- read_csv('Datasets/mass-shootings.csv')

# Add UI
ui <- bootstrapPage(
  shinythemes::shinytheme('simplex'),
  leaflet::leafletOutput(outputId = 'map', width = '100%', 
                         height = '100%'),
  absolutePanel(top = 10, right = 10, id = 'controls',
                # CODE BELOW: Add slider input named nb_fatalities
                sliderInput(inputId = 'nb_fatalities',
                            label = 'Minimum Fatalities', 
                            min = 1, max = 40, value = 10),
                # CODE BELOW: Add date range input named date_range
                dateRangeInput(inputId = 'data_range', 
                               label = 'Select Date', 
                               start = '01/01/2010', end = '12/01/2019'),
                # Add an action button named show_about
                actionButton('show_about', 'About')
                ),
  tags$style(type = "text/css", "
             html, body {width:100%;heigh:100%}
             #controls{background-color:white;padding:20px;}
             ")
)

# Add output
server <- function(input, output, session) {
  # Use observeEvent to display a modal dialog
  # with the help text stored in text_about.
  observeEvent(input$show_about, {
    showModal(modalDialog(text_about, title = 'About'))
  })
  # Add reactive expression: Filter mass_shootings on nb_fatalities and 
  # selected date_range.
  rval_mass_shootings <- reactive({
    mass_shootings %>% 
      filter(
        date >= input$date_range[1],
        date <= input$date_range[2],
        fatalities >= input$nb_fatalities
      )
  })
  # Add an interactive map
  output$map <- leaflet::renderLeaflet({
    rval_mass_shootings() %>% 
      leaflet() %>% 
      addTiles() %>% 
      setView(-98.58, 39.82, zoom = 5) %>% 
      addCircleMarkers(
        # Add parameters popup and radius and map them
        # to the summary and fatalities columns
        popup = ~ summary,
        radius = ~ sqrt(fatalities)*3,
        fillColor = 'red', color = 'red', weight = 1
      )
  })
}

shinyApp(ui, server)
