# --------------------------------------------------- 
# Building Dashboards with shinydashboard - Customizing Style 
# 02 dez 2020 
# VNTBJR 
# --------------------------------------------------- 
#
# Bootstrap explanation  -------------------------------------------
# Row-based layout - wrap your boxes in a fluidRow() function to form each 
# row
# Column-based layout - use the column function within a flluid row to set
# the columns
# Mixed layout - is acombination of the row and column layout.

# Create body with row-based layout
library(shinydashboard)
library("shiny")

body <- dashboardBody(
  fluidRow(
  # Row 1
  box(width = 12,
      title = "Regular Box, Row 1",
      "Star Wars")),
  # Row 2
  fluidRow(box(width = 12,
      title = "Regular Box, Row 2",
      "Nothing but Star Wars")
  )
)

ui <- dashboardPage(header = dashboardHeader(),
                    sidebar = dashboardSidebar(),
                    body = body
)
shinyApp(ui, server)

# Create body with column-based layout
library("shiny")

body <- dashboardBody(
  fluidRow(
    # Column 1
    column(
      width = 6,
      infoBox(
        width = NULL,
        title = "Regular Box, Column 1", 
        subtitle = "Gimme those Star Wars"
      )
    ),
    # Column 2
    column(width = 6,
           infoBox(
             width = NULL,
             title = "Regular Box, Column 2",
             subtitle = "Don't let them end"
           ))
  )
)

ui <- dashboardPage(header = dashboardHeader(),
                    sidebar = dashboardSidebar(),
                    body = body
)
shinyApp(ui, server)

# Create body with mixed layout
library("shiny")

body <- dashboardBody(
  fluidRow(
    # Row 1
    box(
      width = 12,
      title = "Regular Box, Row 1",
      subtitle = "Star Wars, nothing but Star Wars"
    )
  ),
  fluidRow(
    # Row 2, Column 1
    column(width = 6,
           infoBox(
             width = NULL,
             title = "Regular Box, Row 2, Column 1",
             subtitle = "Gimme those Star Wars"
           )),
    # Row 2, Column 2
    column(width = 6,
           infoBox(
             width = NULL,
             title = "Regular Box, Row 2, Column 2",
             subtitle = "Don't let them end"
           ))
    )
)

ui <- dashboardPage(header = dashboardHeader(),
                    sidebar = dashboardSidebar(),
                    body = body
)
shinyApp(ui, server)

# Customizing the appearance  -------------------------------------------
# Change the appearance of the dashboard
# Update the skin
ui <- dashboardPage(
  skin = "purple",
  header = dashboardHeader(),
  sidebar = dashboardSidebar(),
  body = body)

# Run the app
shinyApp(ui, server)

# Customize the body with CSS
library("shiny")

body <- dashboardBody(
  # Update the CSS
  tags$head(
    tags$style(
      HTML('
      h3 {
           font-weight: bold
           }
           ')
    )
  ),
  fluidRow(
    box(
      width = 12,
      title = "Regular Box, Row 1",
      "Star Wars, nothing but Star Wars"
    )
  ),
  fluidRow(
    column(width = 6,
           infoBox(
             width = NULL,
             title = "Regular Box, Row 2, Column 1",
             subtitle = "Gimme those Star Wars"
           )
    ),
    column(width = 6,
           infoBox(
             width = NULL,
             title = "Regular Box, Row 2, Column 2",
             subtitle = "Don't let them end"
           )
    )
  )
)

ui <- dashboardPage(
  skin = "purple",
  header = dashboardHeader(),
  sidebar = dashboardSidebar(),
  body = body)
shinyApp(ui, server)

# Incorporate icons
library("shiny") 

header <- dashboardHeader(
  dropdownMenu(
    type = "notifications",
    notificationItem(
      text = "The International Space Station is overhead!",
      icon = icon("rocket")
    )
  )
)
ui <- dashboardPage(header = header,
                    sidebar = dashboardSidebar(),
                    body = dashboardBody()
)
shinyApp(ui, server)

# Add some life to your layouts
library("shiny")

body <- dashboardBody(
  tags$head(
    tags$style(
      HTML('
      h3 {
        font-weight: bold;
      }
      ')
    )
  ),
  fluidRow(
    box(
      width = 12,
      title = "Regular Box, Row 1",
      "Star Wars, nothing but Star Wars",
      # Make the box red
      status = "danger"
    )
  ),
  fluidRow(
    column(width = 6,
           infoBox(
             width = NULL,
             title = "Regular Box, Row 2, Column 1",
             subtitle = "Gimme those Star Wars",
             # Add a star icon
             icon = icon("star")
           )
    ),
    column(width = 6,
           infoBox(
             width = NULL,
             title = "Regular Box, Row 2, Column 2",
             subtitle = "Don't let them end",
             # Make the box yellow
             color = "yellow"
           )
    )
  )
)

ui <- dashboardPage(
  skin = "purple",
  header = dashboardHeader(),
  sidebar = dashboardSidebar(),
  body = body)
shinyApp(ui, server)
