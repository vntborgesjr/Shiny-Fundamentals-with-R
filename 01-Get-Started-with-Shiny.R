# --------------------------------------------------- 
# Building Web Applications with Shiny in R - Get Started with Shiny 
# 19 nov 2020 
# VNTBJR 
# --------------------------------------------------- 
#
# Build a "Hello, world" Shiny app  -------------------------------------------
# Parts of a Shiny app
# Load Shiny
library(shiny)
# Create th UI with a HTML function
ui <- fluidPage()
# Define a custom function to create the server
server <- function(input, outpu, session){
  
}
# Run the app
library(shiny)
shinyApp(ui = ui, server = server)

# Build a "Hello, world" Shiny app
library(shiny)

ui <- fluidPage(
  "Hello, word!!!"
)

server <- function(input, output, session) {
  
}

shinyApp(ui, server)

# "Hello, world" app input (UI/Server)
ui <- fluidPage(
  # CODE BELOW: Add a text input "name"
  # Make sure to add a comma after textInput()
  textInput("name", "Please, enter your name: "),
  textOutput("greeting")
  
)

server <- function(input, output) {
  #Code Below: Render a text output, greeting
  output$greeting <- renderText({
    paste("Hello, ", input$name)
  })
}

shinyApp(ui = ui, server = server)

# Building a babynames explorer Shiny app  -------------------------------------------
# Add input (UI)
ui <- fluidPage(
  # CODE BELOW: Add a text input "name"
  textInput("name", "Enter your name: ", "Vitor")
)
server <- function(input, output, session) {
  
}
shinyApp(ui = ui, server = server)

# Add output (UI;Server)
library(ggplot2)

ui <- fluidPage(
  textInput('name', 'Enter Name', 'David'),
  # CODE BELOW: Display the plot output named 'trend'
  plotOutput("trend")
  
)
server <- function(input, output, session) {
  # CODE BELOW: Render an empty plot and assign to output named 'trend'
  output$trend <- renderPlot(ggplot())
  
  
}
shinyApp(ui = ui, server = server)

# Update layout (UI)
ui <- fluidPage(
  titlePanel("Baby Name Explorer"),
  # CODE BELOW: Add a sidebarLayout, sidebarPanel, and mainPanel
  sidebarLayout(sidebarPanel(textInput('name', 
                                         'Enter Name', 
                                         'David')),
                mainPanel(plotOutput('trend')))
)

server <- function(input, output, session) {
  output$trend <- renderPlot({
    ggplot()
  })
}
shinyApp(ui = ui, server = server)

# Update output (server)
library(tidyverse)
babynames <- readRDS("Datasets/babynames.rds")
babynames <- babynames %>% 
  group_by(name) %>% 
  mutate(prop = number/sum(number))

ui <- fluidPage(
  titlePanel("Baby Name Explorer"),
  sidebarLayout(
    sidebarPanel(textInput('name', 'Enter Name', 'David')),
    mainPanel(plotOutput('trend'))
  )
)
server <- function(input, output, session) {
  output$trend <- renderPlot({
    # CODE BELOW: Update to display a line plot of the input name
    ggplot(data = subset(babynames, name == input$name)) + 
      geom_line(aes(x = year, y = prop))
  })
}
shinyApp(ui = ui, server = server)

