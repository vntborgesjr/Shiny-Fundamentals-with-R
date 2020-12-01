# --------------------------------------------------- 
# Case Studies: Building Web Applications with Shiny in R - Make the 
# perfect plot using Shiny 
# 01 dez 2020 
# VNTBJR 
# --------------------------------------------------- 
#
# Make the perfect plot using Shiny  -------------------------------------------
# Exploration of the Gapminder data
# Load the gapminder package
library(gapminder)

# Define UI for the application
ui <- fluidPage(
  "The population of France in 1972 was",
  textOutput("answer")
)

# Define the server function
server <- function(input, output) {
  output$answer <- renderText({
    # Determine the population of France in year 1972
    subset(gapminder, country == 'France' & year == 1972)$pop
  })
}

# Run the application
shinyApp(ui = ui, server = server)

# Add a plot title: text input
# Load the ggplot2 package for plotting
library(ggplot2)

# Define UI for the application
ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      # Add a title text input
      textInput(inputId = 'title', label = 'Title', 
                value = 'GDP vs life exp')
    ),
    mainPanel(
      plotOutput("plot")
    )
  )
)

# Define the server logic
server <- function(input, output) {
  output$plot <- renderPlot({
    ggplot(gapminder, aes(gdpPercap, lifeExp)) +
      geom_point() +
      scale_x_log10() +
      # Use the input value as the plot's title
      ggtitle(input$title)
  })
}

# Run the application
shinyApp(ui = ui, server = server)

# Change the point size: numeric input
# Define UI for the application
ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      textInput("title", "Title", "GDP vs life exp"),
      # Add a size numeric input
      numericInput(inputId = 'size', label = 'Point size', value = 1,
                   min = 1)
    ),
    mainPanel(
      plotOutput("plot")
    )
  )
)

# Define the server logic
server <- function(input, output) {
  output$plot <- renderPlot({
    ggplot(gapminder, aes(gdpPercap, lifeExp)) +
      # Use the size input as the plot point size
      geom_point(size = input$size) +
      scale_x_log10() +
      ggtitle(input$title)
  })
}

# Run the application
shinyApp(ui = ui, server = server)

# Fit a smooth curve: checkbox input
# Define UI for the application
ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      textInput("title", "Title", "GDP vs life exp"),
      numericInput("size", "Point size", 1, 1),
      # Add a checkbox for line of best fit
      checkboxInput(inputId = 'fit', label = 'Add line of best fit',
                    value = FALSE)
    ),
    mainPanel(
      plotOutput("plot")
    )
  )
)

# Define the server logic
server <- function(input, output) {
  output$plot <- renderPlot({
    p <- ggplot(gapminder, aes(gdpPercap, lifeExp)) +
      geom_point(size = input$size) +
      scale_x_log10() +
      ggtitle(input$title)
    
    # When the "fit" checkbox is checked, add a line
    # of best fit
    if (input$fit == TRUE) {
      p <- p + geom_smooth(method = "lm")
    }
    p
  })
}

# Run the application
shinyApp(ui = ui, server = server)

# More input types  -------------------------------------------
