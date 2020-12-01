# --------------------------------------------------- 
# Case Studies: Building Web Applications with Shiny in R: Shiny review 
# 01 dez 2020 
# VNTBJR 
# --------------------------------------------------- 
#
# Introduction  -------------------------------------------
# Shiny App template
# load shiny app
library(shiny) 
# Create a web page - it is responsible for the appearence of the app
ui <- fluidPage(
  
)
# Create server  portion of the app - it is the brain of the app
server <- function(input, output, session) {
  
}
# combine ui + server into a shiny app and run it
shinyApp(ui, server)

# Functions to format text
# h1() - Primary header
# h2() - Secondary header
# strong() - bold
# em() - italicized

# Sidebar layout
ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(),
    mainPanel()
  )
)

# Simple text
# Load the shiny package
library(shiny)

# Define UI for the application
ui <- fluidPage(
  # Add the text "Shiny is fun"
  "Shiny is fun"
)

# Define the server logic
server <- function(input, output) {}

# Run the application
shinyApp(ui = ui, server = server)

# Formatted text
# Load the shiny package
library(shiny)

# Define UI for the application
ui <- fluidPage(
  # "DataCamp" as a primary header
  h1(strong("DataCamp")),
  # "Shiny use cases course" as a secondary header
  h2(strong("Shiny use cases course")),
  # "Shiny" in italics
  em("Shiny"),
  # "is fun" as bold text
  strong("is fun")
)

# Define the server logic
server <- function(input, output) {}

# Run the application
shinyApp(ui = ui, server = server)

# Add structure to your app 
# Load the shiny package
library(shiny)

# Define UI for the application
ui <- fluidPage(
  # Add a sidebar layout to the application
  sidebarLayout(
    # Add a sidebar panel around the text and inputs
    sidebarPanel(
      h4("Plot parameters"),
      textInput(inputId = "title", 
                label = "Plot title", 
                value = "Car speed vs distance to stop"),
      numericInput(inputId = "num", 
                   label = "Number of cars to show", 
                   value = 30, min = 1, max = nrow(cars)),
      sliderInput(inputId = "size", 
                  label = "Point size", 
                  min = 1, max = 5, value = 2, step = 0.5)
    ),
    # Add a main panel around the plot and table
    mainPanel(
      plotOutput("plot"),
      tableOutput("table")
    )
  )
)

# Define the server logic
server <- function(input, output) {
  output$plot <- renderPlot({
    plot(cars[1:input$num, ], main = input$title, cex = input$size)
  })
  output$table <- renderTable({
    cars[1:input$num, ]
  })
}

# Run the application
shinyApp(ui = ui, server = server)

# Inputs and outputs  -------------------------------------------
# Adding inputs
library(shiny)

# Define UI for the application
ui <- fluidPage(
  # Create a numeric input with ID "age" and label of
  # "How old are you?"
  numericInput(inputId = "age", 
               label = "How old are you?", 
               value = 20),
  
  # Create a text input with ID "name" and label of 
  # "What is your name?"
  textInput(inputId = "name", label = "What is your name?")
)

# Define the server logic
server <- function(input, output) {}

# Run the application
shinyApp(ui = ui, server = server)

# Adding placeholders for outputs
library(shiny)

# Define UI for the application
ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      # Create a text input with an ID of "name"
      textInput('name', "What is your name?", "Dean"),
      numericInput("num", "Number of flowers to show data for",
                   10, 1, nrow(iris))
    ),
    mainPanel(
      # Add a placeholder for a text output with ID "greeting"
      textOutput(outputId = "greeting"),
      # Add a placeholder for a plot with ID "cars_plot"
      plotOutput("cars_plot"),
      # Add a placeholder for a table with ID "iris_table"
      tableOutput('iris_table')
    )
  )
)

# Define the server logic
server <- function(input, output) {}

# Run the application
shinyApp(ui = ui, server = server)

# Constructing outpu objects 
# Load the shiny package
library(shiny)

# Define UI for the application
ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      textInput("name", "What is your name?", "Dean"),
      numericInput("num", "Number of flowers to show data for",
                   10, 1, nrow(iris))
    ),
    mainPanel(
      textOutput("greeting"),
      plotOutput("cars_plot"),
      tableOutput("iris_table")
    )
  )
)

# Define the server logic
server <- function(input, output) {
  # Create a plot of the "cars" dataset 
  output$cars_plot <- renderPlot({
    plot(cars)
  })
  
  # Render a text greeting as "Hello <name>"
  output$greeting <- renderText({
    paste("Hello", input$name)
  })
  
  # Show a table of the first n rows of the "iris" data
  output$iris_table <- renderTable({
    data <- iris[1:input$num, ]
    data
  })
}

# Run the application
shinyApp(ui = ui, server = server)
