# --------------------------------------------------- 
# Building Dashboards with shinydashboard - Building Static Dashboards 
# 02 dez 2020 
# VNTBJR 
# --------------------------------------------------- 
#
# Dashboard structure overview  -------------------------------------------
# header <- dashboardHearder()
# sidebar <- dashboardSidebar()
# body <- dashboardBody()
# ui <- dashbaordPage(header, seidebar, body)
# server <- function(input, output) {}
# shiny::shinyApp(ui, server)

# Create empty Header, Sidebar, and Body
library(shinydashboard)

# Create an empty header
header <- dashboardHeader()

# Create an empty sidebar
sidebar <- dashboardSidebar()

# Create an empty body
body <- dashboardBody()

# Create an empty Shiny Dashboard
# Create the UI using the header, sidebar, and body
ui <- dashboardPage(header, sidebar, body)

server <- function(input, output) {}

shinyApp(ui, server)

# Dashboard Header overview  -------------------------------------------
# Items of dropdown menu - to create dropdown menus, use the 
# dropdownMenu() function
# Messages - to create messages, use the messageItem() function
# header <- dashboardHeader(
# type = "messages",
# messageItem(
# from = ,
# message = ,
# href = 
# )
# )
# )
# Notifications - to create notifications, use notificationItem() function
# header <- dashboardHeader(
# type = "notifications",
# notificationItem(
# text = ,
# href = 
# )
# )
# )
# Tasks - to set tasks, use taskItem() function
# header <- dashboardHeader(
# type = "tasks",
# taskItem(
# text = ,
# value = 
# )
# )
# )

# Create message menus
header <- dashboardHeader(
  dropdownMenu(
    type = "messages",
    messageItem(
      from = "Lucy",
      message = "You can view the International Space Station!",
      href = "https://spotthestation.nasa.gov/sightings/"
    ),
    # Add a second messageItem() 
    messageItem(
      from = "Vitor",
      message = "Learn more about the International Space Station",
      href = "https://spotthestation.nasa.gov/faq.cfm"
    )
  )
)

ui <- dashboardPage(header = header,
                    sidebar = dashboardSidebar(),
                    body = dashboardBody()
)
shinyApp(ui, server)

# Create notification menus
header <- dashboardHeader(
  # Create a notification drop down menu
  dropdownMenu(
    type = "notifications",
    notificationItem(
      text = "The International Space Station is overhead!"
    )
  )
)

# Use the new header
ui <- dashboardPage(header = header,
                    sidebar = dashboardSidebar(),
                    body = dashboardBody()
)
shinyApp(ui, server)

# Create task menus
header <- dashboardHeader(
  # Create a tasks drop down menu
  dropdownMenu(
    type = "tasks",
    taskItem(
      text = "Mission Learn Shiny Dashboard",
      value = 10
    )
  )
)

# Use the new header
ui <- dashboardPage(header = header,
                    sidebar = dashboardSidebar(),
                    body = dashboardBody()
)
shinyApp(ui, server)

# Dashboard Sidebar and Body overview  -------------------------------------------
# Add tabs to your sidebar using the siderbarMenu() function
# sidebar <- dashboardSidebar(
# sidebarMenu(
# menuItem("Data",
# tabName = "data"), 
# menuItem("Dashboard",
# tabName = "dashboard")
#)
#)
# Create tabs that will match the ones we created in the sidebar using
# the tabItem() function
# body <- dashboardBody(
# tabItems(
#  tabItem(tabName = "data"),
#  tabItem(tabName = "daashboard")
#)
#)
# You can add a tabBox() using the shiny::tabPanel() function directly 
# to the dashboardBody() or place it within a tabItem()

# Create Sidebar tabs
sidebar <- dashboardSidebar(
  sidebarMenu(
    # Create two `menuItem()`s, "Dashboard" and "Inputs"
    menuItem(
      text = "Dashboard",
      tabName = "dashboard"
    ),
    menuItem(
      text = "Inputs",
      tabName = "inputs"
    )
  )
)

# Use the new sidebar
ui <- dashboardPage(header = dashboardHeader(),
                    sidebar = sidebar,
                    body = dashboardBody()
)
shinyApp(ui, server)

# Create Body tabs
body <- dashboardBody(
  tabItems(
    # Add two tab items, one with tabName "dashboard" and one with tabName "inputs"
    tabItem(tabName = "dashboard"),
    tabItem(tabName = "inputs")
  )
)

# Use the new body
ui <- dashboardPage(header = dashboardHeader(),
                    sidebar = sidebar,
                    body = body
)
shinyApp(ui, server)

# Create tab boxes
library("shiny")
body <- dashboardBody(
  # Create a tabBox
  tabItems(
    tabItem(
      tabName = "dashboard",
      tabBox(
        title = "International Space Station Fun Facts",
        tabPanel(title = "Fun Fact 1"),
        tabPanel(title = "Fun Fact 2")
      )
    ),
    tabItem(tabName = "inputs")
  )
)

ui <- dashboardPage(header = dashboardHeader(),
                    sidebar = sidebar,
                    body = body
)
shinyApp(ui, server)
