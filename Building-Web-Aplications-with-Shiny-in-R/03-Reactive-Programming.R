# --------------------------------------------------- 
# Building Web Applications with Shiny in R - Reactive Programming 
# 25 nov 2020 
# VNTBJR 
# --------------------------------------------------- 
#
# Reactive 101  -------------------------------------------
# Reactive sources - is an user input that comes through a browser 
# interface. It can be connected to multiple endpoints, and vice versa.
# For example we migh have a UI input widget to make a selection of our
# data, the selected data can be used in multiple ouputs like plots 
# and summaries.
# Reactive endpoints - is something that appears in browser window, such
# as a plot or a table. Endpoints are notified when the underlying value
# of one of its source dependencies change, and it updates in response
# to this signal. An example of reactive endpoints is observers.
# For example, an output object is a reactive observer. Under the hood 
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
# endpoint calls it.
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

# Add a reactive expression
server <- function(input, output, session) {
  # CODE BELOW: Add a reactive expression rval_bmi to calculate BMI
  rval_bmi <- reactive({
    input$weight/(input$height^2)
  })
  output$bmi <- renderText({
    # MODIFY CODE BELOW: Replace right-hand-side with reactive expression
    bmi <- rval_bmi()
    paste("Your BMI is", round(bmi, 1))
  })
  output$bmi_range <- renderText({
    # MODIFY CODE BELOW: Replace right-hand-side with reactive expression
    bmi <- rval_bmi()
    bmi_status <- cut(bmi, 
                      breaks = c(0, 18.5, 24.9, 29.9, 40),
                      labels = c('underweight', 'healthy', 'overweight', 'obese')
    )
    paste("You are", bmi_status)
  })
}
ui <- fluidPage(
  titlePanel('BMI Calculator'),
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

shinyApp(ui = ui, server = server)

# Understanding reactive expressions
ui <- fluidPage(
  numericInput('nrows', 'Number of Rows', 10, 5, 30),
  tableOutput('table'), 
  plotOutput('plot')
)
server <- function(input, output, session){
  cars_1 <- reactive({
    print("Computing cars_1 ...")
    head(cars, input$nrows)
  })
  cars_2 <- reactive({
    print("Computing cars_2 ...")
    head(cars, input$nrows*2)
  })
  output$plot <- renderPlot({
    plot(cars_1())
  })
  output$table <- renderTable({
    cars_1()
  })
}
shinyApp(ui = ui, server = server)

# Observers vs. reactives  -------------------------------------------
# Observers can access reactive sources and reactive expressions, but
# they don't return a value. Instead they are used primarily for their
# side effects, which typically involves sending data to the web 
# browser. It's important to remember that:
# - reactive() is for calculating values, without side effects;
# - observe() is for performing actions, with side effects.
# The key differences between observers and reactive expressions are:
# - Reactive expressions return values, but observers don't;
# - Observers eagerly respond to changes in their dependencies, while 
# reactive expressions are lazy.
# - Observers are primarily useful for their side effects, whereas, 
# reactive expressions must not have side effects.

# Add another reactive exrpession
server <- function(input, output, session) {
  rval_bmi <- reactive({
    input$weight/(input$height^2)
  })
  # CODE BELOW: Add a reactive expression rval_bmi_status to 
  # return health status as underweight etc. based on inputs
  rval_bmi_status <- reactive({
    cut(rval_bmi(),
        breaks = c(0, 18.5, 24.9, 29.9, 40),
        labels = c('underweight', 'healthy', 'overweight', 'obese'))
  })
  output$bmi <- renderText({
    bmi <- rval_bmi()
    paste("Your BMI is", round(bmi, 1))
  })
  output$bmi_status <- renderText({
    # MODIFY CODE BELOW: Replace right-hand-side with 
    # reactive expression rval_bmi_status
    bmi_status <- rval_bmi_status()
    paste("You are", bmi_status)
  })
}
ui <- fluidPage(
  titlePanel('BMI Calculator'),
  sidebarLayout(
    sidebarPanel(
      numericInput('height', 'Enter your height in meters', 1.5, 1, 2),
      numericInput('weight', 'Enter your weight in Kilograms', 60, 45, 120)
    ),
    mainPanel(
      textOutput("bmi"),
      textOutput("bmi_status")
    )
  )
)

shinyApp(ui = ui, server = server)

# Add an observere to display notifications
ui <- fluidPage(
  textInput('name', 'Enter your name')
)

server <- function(input, output, session) {
  # CODE BELOW: Add an observer to display a notification
  # 'You have entered the name xxxx' where xxxx is the name
  observe({showNotification(
    paste('You have entered the name ', input$name)
  )})
}

shinyApp(ui = ui, server = server)

# Stop - delay - trigger  -------------------------------------------
# Isolate actions - wrapping a reacting value inside isolate() makes
# it ready-only, and does not trigger re-execution when its value
# changes.

# Delaying actions - you can delay the evaluation of a reactive 
# expression by placing it inside eventReactive(), and specifying an
# event in response to which it should execute the expression.
# Suppose we want the greeting to be displayed only
# when the user clicks on a button. We can achieve this using 
# eventReactive(). The first argument to eventReative is the event 
# that should trigger the update (ex. the name of a button). The second
# argument is the expression it should return when the event is triggered

# Triggering actions - happens when you want to perform an action in
# response to an event. For example, you might want to display a 
# greeting as a modal dialog, in response to a click. You can achieve
# this using observeEvent(). The first argument is the event that 
# triggers the action, and the second argument being the action. 
# Unlike eventReactive(), observeEvent() is used only for its side-effects
# and does not return any value.

# Stop reactions with isolate()
server <- function(input, output, session) {
  rval_bmi <- reactive({
    input$weight/(input$height^2)
  })
  output$bmi <- renderText({
    bmi <- rval_bmi()
    # MODIFY CODE BELOW: 
    # Use isolate to stop output from updating when name changes.
    paste("Hi", isolate({input$name}), ". Your BMI is", round(bmi, 1))
  })
}
ui <- fluidPage(
  titlePanel('BMI Calculator'),
  sidebarLayout(
    sidebarPanel(
      textInput('name', 'Enter your name'),
      numericInput('height', 'Enter your height (in m)', 1.5, 1, 2, step = 0.1),
      numericInput('weight', 'Enter your weight (in Kg)', 60, 45, 120)
    ),
    mainPanel(
      textOutput("bmi")
    )
  )
)

shinyApp(ui = ui, server = server)

# Delay reactions with eventReactive()
server <- function(input, output, session) {
  # MODIFY CODE BELOW: Use eventReactive to delay the execution of the
  # calculation until the user clicks on the show_bmi button (Show BMI)
  rval_bmi <- eventReactive(input$show_bmi, {
    input$weight/(input$height^2)
  })
  output$bmi <- renderText({
    bmi <- rval_bmi()
    paste("Hi", input$name, ". Your BMI is", round(bmi, 1))
  })
}
ui <- fluidPage(
  titlePanel('BMI Calculator'),
  sidebarLayout(
    sidebarPanel(
      textInput('name', 'Enter your name'),
      numericInput('height', 'Enter height (in m)', 1.5, 1, 2, step = 0.1),
      numericInput('weight', 'Enter weight (in Kg)', 60, 45, 120),
      actionButton("show_bmi", "Show BMI")
    ),
    mainPanel(
      textOutput("bmi")
    )
  )
)

shinyApp(ui = ui, server = server)

# Trigger ractions with observeEvent()
bmi_help_text <- "Body Mass Index is a simple calculation using a persons's
height and weight. The for,ula is BMI = kg/m2, where kg is a person's 
weight in kilograms and m2 is their height in meters squared. A BMI of 25.0
or more is overweight, while the healthy range is 18.5 to 24.9."

server <- function(input, output, session) {
  # MODIFY CODE BELOW: Wrap in observeEvent() so the help text 
  # is displayed when a user clicks on the Help button.
  observeEvent(input$show_help, {
    # Display a modal dialog with bmi_help_text
    # MODIFY CODE BELOW: Uncomment code
    showModal(modalDialog(bmi_help_text))
  })
  rv_bmi <- eventReactive(input$show_bmi, {
    input$weight/(input$height^2)
  })
  output$bmi <- renderText({
    bmi <- rv_bmi()
    paste("Hi", input$name, ". Your BMI is", round(bmi, 1))
  })
}

ui <- fluidPage(
  titlePanel('BMI Calculator'),
  sidebarLayout(
    sidebarPanel(
      textInput('name', 'Enter your name'),
      numericInput('height', 'Enter your height in meters', 1.5, 1, 2),
      numericInput('weight', 'Enter your weight in Kilograms', 60, 45, 120),
      actionButton("show_bmi", "Show BMI"),
      # CODE BELOW: Add an action button named "show_help"
      actionButton("show_help", "Help")
    ),
    mainPanel(
      textOutput("bmi")
    )
  )
)

shinyApp(ui = ui, server = server)

# Applying reactivity concepts  -------------------------------------------
# Reactive and observers

# Reactive sources are accessible through any input$x.
# Reactive conductors are good for slow or expensive calculations, and 
# are placed between sources and endpoints.
# Reactive endpoints are accessible through any output$y, and are observers,
# primarily used for their side effects, and not directly to calculate 
# things.

# Stop, delay, trigger
# Stop an action with isolate();
# Delay an action with eventReactive();
# Trigger a side-effect with observeEvent().

# Convert height from inches to centimeters
server <- function(input, output, session) {
  # MODIFY CODE BELOW: Delay the height calculation until
  # the show button is pressed
  rval_height_cm <- eventReactive(input$show_height_cm, {
    input$height * 2.54
  })
  
  output$height_cm <- renderText({
    height_cm <- rval_height_cm()
    paste("Your height in centimeters is", height_cm, "cm")
  })
}

ui <- fluidPage(
  titlePanel("Inches to Centimeters Conversion"),
  sidebarLayout(
    sidebarPanel(
      numericInput("height", "Height (in)", 60),
      actionButton("show_height_cm", "Show height in cm")
    ),
    mainPanel(
      textOutput("height_cm")
    )
  )
)

shinyApp(ui = ui, server = server)
