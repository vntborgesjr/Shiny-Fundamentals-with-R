# --------------------------------------------------- 
# Building Dashboards with shinydashboard - Building Dynamic Dashboards 
# 02 dez 2020 
# VNTBJR 
# --------------------------------------------------- 
#
# Reactive expression refresher  -------------------------------------------
library(dplyr)

# Review selectInput and sliderInput
sidebar <- dashboardSidebar(
  # Add a slider
  sliderInput(inputId = "height", label = "Height",
              min = 66, max = 264, value = 264)
)

ui <- dashboardPage(header = dashboardHeader(),
                    sidebar = sidebar,
                    body = dashboardBody()
)
shinyApp(ui, server) 

# Reactive expression in practice
library(shiny)
sidebar <- dashboardSidebar(
  # Create a select list
  selectInput(inputId = "name", label = "Name",
              choices = starwars$name)
)

body <- dashboardBody(
  textOutput("name")
)

ui <- dashboardPage(header = dashboardHeader(),
                    sidebar = sidebar,
                    body = body
)

server <- function(input, output) {
  output$name <- renderText({
    input$name
  })
}

shinyApp(ui, server)

# Server-side dynamic how-to  -------------------------------------------
# Functions to read in real time data:
# reactiveFileReader( # checks the file's last modifeid time, if it has
# changed then the file is read again
# intervalMillis = determines how many mlliseconds to wait between checks 
# of the file's last modified time
# session = is the user session. Allows for specific control over a user's
# application session
# filePath = is the path to the file you are interested in resding
# readFunc = indicates which R function you'd like to use to read your file
#) 
# reactivePoll()

# Read in real-time data
library("shiny")
starwars_url <- "http://s3.amazonaws.com/assets.datacamp.com/production/course_6225/datasets/starwars.csv"

server <- function(input, output, session) {
  reactive_starwars_data <- reactiveFileReader(
    intervalMillis = 1000,
    session = session,
    filePath = starwars_url,
    readFunc = function(filePath) { 
      read.csv(url(filePath))
    }
  )
}

ui <- dashboardPage(header = dashboardHeader(),
                    sidebar = dashboardSidebar(),
                    body = dashboardBody()
)
shinyApp(ui, server)

# View real-time data
library(shiny)

server <- function(input, output, session) {
  reactive_starwars_data <- reactiveFileReader(
    intervalMillis = 1000,
    session = session,
    filePath = starwars_url,
    readFunc = function(filePath) { 
      read.csv(url(filePath))
    }
  )
  
  output$table <- renderTable({
    reactive_starwars_data()
  })
}

body <- dashboardBody(
  tableOutput("table")
)

ui <- dashboardPage(header = dashboardHeader(),
                    sidebar = dashboardSidebar(),
                    body = body
)
shinyApp(ui, server)

# Optimizing performance  -------------------------------------------

# UI dynamic how-to  -------------------------------------------
text <- c("find 20 hidden mickeys on the Tower of Terror",    
          "Find a paint brush on Tom Sawyer Island",
          "Meet Chewbacca")
value <- c(60, 0, 100)
task_data <- data.frame(text = text, value = value)

# Create reactive menu items
server <- function(input, output) {
  output$task_menu <- renderMenu({
    tasks <- apply(task_data, 1, function(row){
      taskItem(text = row[["text"]],
               value = row[["value"]])
    })
    dropdownMenu(type = "tasks", .list = tasks)
  })
}

header <- dashboardHeader(dropdownMenuOutput("task_menu"))

ui <- dashboardPage(header = header,
                    sidebar = dashboardSidebar(),
                    body = dashboardBody()
)
shinyApp(ui, server)

# Create reactive boxes
library("shiny")
sidebar <- dashboardSidebar(
  actionButton("click", "Update click box")
) 

server <- function(input, output) {
  output$click_box <- renderValueBox({
    valueBox(
      value = input$click,
      subtitle = "Click Box"
    )
  })
}

body <- dashboardBody(
  valueBoxOutput("click_box")
)


ui <- dashboardPage(header = dashboardHeader(),
                    sidebar = sidebar,
                    body = body
)
shinyApp(ui, server)

