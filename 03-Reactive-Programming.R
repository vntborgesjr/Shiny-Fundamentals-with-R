# --------------------------------------------------- 
# Building Web Applications with Shiny in R - Reactive Programming 
# 25 nov 2020 
# VNTBJR 
# --------------------------------------------------- 
#
# Reactive 101  -------------------------------------------
# Reactive sources - is a user input that comes through a browser 
# interface.It can be connected to multiple endpoints, and vice versa.
# For example we migh have a UI input widget to make a selection of our
# data, the selected data cna be used in multiple ouputs like plots 
# and summaries.
# Reactive endpoints - is something that appears in browser window, such
# as a plot or a table. Endpoints are notified when the underlying value
# of one of its soulrce dependencies change, and it updates in response
# to this signal. An example of reactive endpoints is observers.
# For example, an aoutput object is a reactive observer. Under the hood 
# a render function returns a reactive expression, and when you assign
# this reactive expression to an output dollar value, Shiny automatically
# creates an observer that uses the reactive expression.
# Reactive conductor - is dependent on one or more reactive sources, 
# and is also a dependency of one or more reactive endpoints. It is often
# used to encapsulate repeated computations, that can be expensive.
# Reactive conductors can be used, for example, to compute the filtered
# data to be used. A reactive expression behaves just like a function, 
# but with two key differences:
# 1. It is lazy, meaning that it is evaluated only when a reactive 
#endpoint calls it.
# 2. It is cached, meaning that it is evaluated only when the value of 
# one of its underlying reactive sources changes.

# Source vs. Conductor vs. Endpoint
library(shiny)
# BMI Calculator
ui <- fluidPage(
  titlePanel('BMI Calculator'),
  theme = shinythemes::shinytheme('cosmo'),
  sidebarLayout(
    sidebarPanel(
      numericInput('height', 'Enter your height in meters', 1.5, 1, 2),
      numericInput('weight', 'Enter your weight in Kilograms', 60, 45, 120)
    ),
    mainPanel(
      textOutput("bmi"),
      textOutput("bmi_range")
    )
  )
)
server <- function(input, output, session) {
  rval_bmi <- reactive({
    input$weight/(input$height^2)
  })
  output$bmi <- renderText({
    bmi <- rval_bmi()
    paste("Your BMI is", round(bmi, 1))
  })
  output$bmi_range <- renderText({
    bmi <- rval_bmi()
    health_status <- cut(bmi, 
                         breaks = c(0, 18.5, 24.9, 29.9, 40),
                         labels = c('underweight', 'healthy', 'overweight', 'obese')
    )
    paste("You are", health_status)
  })
}
shinyApp(ui, server)
