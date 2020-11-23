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

# Load data
library(babynames)

# Add select input
library(tidyverse)
library(shiny)

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

# Outputs  -------------------------------------------
# Render functions
# Render functions are used to build outputs in the server based on 
# and possible other things, like other parrts of a character string.

# Other render functions examples
# renderTable() - create a table as an output
# renderImage() - create an image as an output
# renderPlot() - create a plot as an output

# Output functions
# Output functions are used back in the UI to display the outputs 
# built in the server with render functions. Examples:
# textOutput() - 
# tableOutput() - 
# dataTableOutput() - 
# imageOutput() - 
# plotOutput() -

# Non-Shiny output and render functions
# There are packages outside of shiny that provide ways to built
# outputs with render and output function. Packages such as DT,
# leaflet,and plotly allow tyou to build interactive data tables, 
# maps, and plots as Shiny outputs. For example, the DT packages
# allows you to build interactive data tables versus static ones.
# Example: build an appp creating an interactive data table version
# of a random 10% of the babynames dataset
ui <- fluidPage(
  DT::DTOutput("babynames_table")
)

server <- function(input, output) {
  output$babynames_table <- DT::renderDT({
    babynames %>% 
      sample_frac(0.1)
  })
}

shinyApp(ui = ui, server = server)

# Add a table output
ui <- fluidPage(
  titlePanel("What's in a Name?"),
  # Add select input named "sex" to choose between "M" and "F"
  selectInput('sex', 'Select Sex', choices = c("F", "M")),
  # Add slider input named "year" to select year between 1900 and 2010
  sliderInput('year', 'Select Year', min = 1900, max = 2010, value = 1900),
  # CODE BELOW: Add table output named "table_top_10_names"
  tableOutput(outputId = "table_top_10_names")
)
server <- function(input, output, session){
  # Function to create a data frame of top 10 names by sex and year 
  top_10_names <- function(){
    top_10_names <- babynames %>% 
      filter(sex == input$sex) %>% 
      filter(year == input$year) %>% 
      top_n(10, prop)
  }
  # CODE BELOW: Render a table output named "table_top_10_names"
  output$table_top_10_names <- renderTable({
    top_10_names()
  })
  
}
shinyApp(ui = ui, server = server)

# Add an interactive table output
ui <- fluidPage(
  titlePanel("What's in a Name?"),
  # Add select input named "sex" to choose between "M" and "F"
  selectInput('sex', 'Select Sex', choices = c("M", "F")),
  # Add slider input named "year" to select year between 1900 and 2010
  sliderInput('year', 'Select Year', min = 1900, max = 2010, value = 1900),
  # MODIFY CODE BELOW: Add a DT output named "table_top_10_names"
  DT::DTOutput('table_top_10_names')
)
server <- function(input, output, session){
  top_10_names <- function(){
    babynames %>% 
      filter(sex == input$sex) %>% 
      filter(year == input$year) %>% 
      top_n(10, prop)
  }
  # MODIFY CODE BELOW: Render a DT output named "table_top_10_names"
  output$table_top_10_names <- DT::renderDT({
    DT::datatable(top_10_names())
  })
}
shinyApp(ui = ui, server = server)

# Add interactive plot output
# Generate data table
top_trendy_names <- babynames %>% 
  select(name, sex, n) %>% 
  group_by(name, sex) %>% 
  mutate(total = sum(n), max = max(n), 
         trendiness = max(n)/sum(n)) %>% 
  select(name, sex, total, max, trendiness) %>% 
  distinct() %>% 
  arrange(name, sex)
babynames[babynames$name == "Christop",]
nb_years <- babynames %>% 
  group_by(sex) %>% 
  count(name) %>% 
  arrange(name, sex)

top_trendy_names$nb_years <- nb_years$n
top_trendy_names <- top_trendy_names %>% 
  select(name, sex, total, max, nb_years, trendiness) %>% 
  filter(total > 1024 & total < 5858) %>% 
  arrange(desc(trendiness))

ui <- fluidPage(
  selectInput('name', 'Select Name', top_trendy_names$name),
  # CODE BELOW: Add a plotly output named 'plot_trendy_names'
  plotly::plotlyOutput("plot_trendy_names")
)
server <- function(input, output, session){
  # Function to plot trends in a name
  plot_trends <- function(){
    babynames %>% 
      filter(name == input$name) %>% 
      ggplot(aes(x = year, y = n)) +
      geom_col()
  }
  # CODE BELOW: Render a plotly output named 'plot_trendy_names'
  output$plot_trendy_names <- plotly::renderPlotly({
    plot_trends()
  })
}
shinyApp(ui = ui, server = server)

# Layouts and themes  -------------------------------------------
ui <- fluidPage(
  # MODIFY CODE BELOW: Wrap in a sidebarLayout
  sidebarLayout(
    # MODIFY CODE BELOW: Wrap in a sidebarPanel
    sidebarPanel(selectInput('name', 'Select Name', top_trendy_names$name)
    ,),
    # MODIFY CODE BELOW: Wrap in a mainPanel
    mainPanel(plotly::plotlyOutput('plot_trendy_names'),
              DT::DTOutput('table_trendy_names'))
    )
)
# DO NOT MODIFY
server <- function(input, output, session){
  # Function to plot trends in a name
  plot_trends <- function(){
    babynames %>% 
      filter(name == input$name) %>% 
      ggplot(aes(x = year, y = n)) +
      geom_col()
  }
  output$plot_trendy_names <- plotly::renderPlotly({
    plot_trends()
  })
  
  output$table_trendy_names <- DT::renderDT({
    babynames %>% 
      filter(name == input$name)
  })
}
shinyApp(ui = ui, server = server)

# Tab layouts
ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput('name', 'Select Name', top_trendy_names$name)
    ),
    mainPanel(
      # MODIFY CODE BLOCK BELOW: Wrap in a tabsetPanel
      tabsetPanel(
        # MODIFY CODE BELOW: Wrap in a tabPanel providing an appropriate label
        tabPanel("Plot",
          plotly::plotlyOutput('plot_trendy_names')),
        # MODIFY CODE BELOW: Wrap in a tabPanel providing an appropriate label
        tabPanel("Table",
          DT::DTOutput('table_trendy_names'))
      ) 
      )
  )
)
server <- function(input, output, session){
  # Function to plot trends in a name
  plot_trends <- function(){
    babynames %>% 
      filter(name == input$name) %>% 
      ggplot(aes(x = year, y = n)) +
      geom_col()
  }
  output$plot_trendy_names <- plotly::renderPlotly({
    plot_trends()
  })
  
  output$table_trendy_names <- DT::renderDT({
    babynames %>% 
      filter(name == input$name)
  })
}
shinyApp(ui = ui, server = server)

# Themes
ui <- fluidPage(
  # CODE BELOW: Add a titlePanel with an appropriate title
  titlePanel("Trends in the popularity of babynames in the U.S."),
  # REPLACE CODE BELOW: with theme = shinythemes::shinytheme("<your theme>")
  theme = shinythemes::shinytheme("paper"),
  sidebarLayout(
    sidebarPanel(
      selectInput('name', 'Select Name', top_trendy_names$name)
    ),
    mainPanel(
      tabsetPanel(
        tabPanel('Plot', plotly::plotlyOutput('plot_trendy_names')),
        tabPanel('Table', DT::DTOutput('table_trendy_names'))
      )
    )
  )
)
server <- function(input, output, session){
  # Function to plot trends in a name
  plot_trends <- function(){
    babynames %>% 
      filter(name == input$name) %>% 
      ggplot(aes(x = year, y = n)) +
      geom_col()
  }
  output$plot_trendy_names <- plotly::renderPlotly({
    plot_trends()
  })
  
  output$table_trendy_names <- DT::renderDT({
    babynames %>% 
      filter(name == input$name)
  })
}
shinyApp(ui = ui, server = server)

# Building apps  -------------------------------------------
# Standard 4 steps process to build shiny apps
# 1. Add inputs in the UI;
# 2. Add outputs in the UI and Server;
# 3. Update the app layout in the UI;
# 4. Update the outputs in the serevr to incorporate user inputs.

# App 1: Multilingual greeting
ui <- fluidPage(
  selectInput(inputId = "greeting", label = "Select greeting",
              choices = c("Hello", "Bonjour")),
  textInput(inputId = "name", label = "Enter your name", value = ""),
  textOutput(outputId = "greeting")
)

server <- function(input, output, session) {
  output$greeting <- renderText({
    paste(input$greeting, input$name)
  })
}

shinyApp(ui = ui, server = server)

# App2: Popular Baby Names
get_top_names <- function(.year, .sex) {
  babynames %>% 
    filter(year == .year) %>% 
    filter(sex == .sex) %>% 
    top_n(10) %>% 
    mutate(name = forcats::fct_inorder(name))
}

ui <- fluidPage(
  titlePanel("Top 10 babynames in the U.S. from 1880 to 2017"),
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "sex", label = "Choose gender: ", 
                  choices = c("F", "M"), selected = "F"),
      sliderInput(inputId = "year", label = "Choose an year: ",
                  min = 1880, max = 2017, value = 1880)
      ),
    mainPanel(plotOutput("top_10_names")))
  )

server <- function(input, output, session) {
  output$top_10_names <- renderPlot({
    d <- get_top_names(.year = input$year, .sex = input$sex)
    ggplot(d, aes(x = name, y = prop)) + 
      geom_col()
  })
}
shinyApp(ui = ui, server = server)

# App 3: Popular baby names redux
get_top_names <- function(.year, .sex) {
  babynames %>% 
    filter(year == .year) %>% 
    filter(sex == .sex) %>% 
    top_n(10) %>% 
    mutate(name = forcats::fct_inorder(name))
}

ui <- fluidPage(
  titlePanel("Top 10 babynames in the U.S. from 1880 to 2017"),
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "sex", label = "Choose gender: ", 
                  choices = c("F", "M"), selected = "F"),
      sliderInput(inputId = "year", label = "Choose an year: ",
                  min = 1880, max = 2017, value = 1880)
    ),
    mainPanel(
      tabsetPanel(tabPanel("Plot", plotOutput("top_10_names")),
              tabPanel("Table", tableOutput("top_10_table"))))
    )
)

server <- function(input, output, session) {
  output$top_10_names <- renderPlot({
    d <- get_top_names(.year = input$year, .sex = input$sex)
    ggplot(d, aes(x = name, y = prop)) + 
      geom_col()
  })
  
  output$top_10_table <- renderTable({
    get_top_names(.year = input$year, .sex = input$sex)
  })
}
shinyApp(ui = ui, server = server)
