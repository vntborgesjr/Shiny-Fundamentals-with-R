# -------------------------------------------------
# Building Web Applications with Shine in R - Inputs, Outputs, and Layouts
# 20 nov 2020
# VNTBJR
# ------------------------------------------------
# 
# Inputs ------------------------------------------------
# Exemples of input
# textInput() - allow users to input text that was utilized in the server to 
# update the graph
# sliderInput() - allow users to select a value of a variable using a slide selector 
# selectInput() - allows for a selection from a list of fixed options
# numericalInput() - allows to provide a range of numbers users can choose from,
# which they can increase or decrease using the little arrows
# dateRangeInput() - allows to provide users with a set of dates, and a calendar 
# dropdown appears when they click so they can select a specific one

# Add a select input
ui <- fluidPage(
  titlePanel("What's in a Name?"),
  # CODE BELOW: Add select input named "sex" to choose between "M" and "F"
  selectInput(inputId = "sex", label = "Choase a gender", 
              choices = c("M", "F"), selected = "F"),
  # Add plot output to display top 10 most popular names
  plotOutput('plot_top_10_names')
)

server <- function(input, output, session){
  # Render plot of top 10 most popular names
  output$plot_top_10_names <- renderPlot({
    # Get top 10 names by sex and year
    library(tidyverse)
    top_10_names <- babynames %>% 
      # MODIFY CODE BELOW: Filter for the selected sex
      filter(sex == input$sex) %>% 
      filter(year == 1900) %>% 
      top_n(10, prop)
    # Plot top 10 names by sex and year
    ggplot(top_10_names, aes(x = name, y = prop)) +
      geom_col(fill = "#263e63")
  })
}

shinyApp(ui = ui, server = server)

# Add a slider input to select year
ui <- fluidPage(
  titlePanel("What's in a Name?"),
  # Add select input named "sex" to choose between "M" and "F"
  selectInput('sex', 'Select Sex', choices = c("F", "M")),
  # CODE BELOW: Add slider input named 'year' to select years  (1900 - 2010)
  sliderInput(inputId = 'year', label = 'Select a year: ', 
              min = 1900, max = 2010, value = 1900),
  # Add plot output to display top 10 most popular names
  plotOutput('plot_top_10_names')
)

server <- function(input, output, session){
  # Render plot of top 10 most popular names
  output$plot_top_10_names <- renderPlot({
    # Get top 10 names by sex and year
    top_10_names <- babynames %>% 
      filter(sex == input$sex) %>% 
      # MODIFY CODE BELOW: Filter for the selected year
      filter(year == input$year) %>% 
      top_n(10, prop)
    # Plot top 10 names by sex and year
    ggplot(top_10_names, aes(x = name, y = prop)) +
      geom_col(fill = "#263e63")
  })
}

shinyApp(ui = ui, server = server)
