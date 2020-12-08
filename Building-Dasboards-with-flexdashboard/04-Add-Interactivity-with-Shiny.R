# --------------------------------------------------- 
# Building Dashboards with flexdashboard - Adding Interactivity with Shiny
# 08 dez 2020 
# VNTBJR 
# --------------------------------------------------- 
#
# Incorporating Shiny into Dashboards  -------------------------------------------
# To turn a flexdashboard into a shiny flexdashboard add:
# runtime: shiny
# in the yaml header

# The reactive dataframe pattern  -------------------------------------------
# Creating a sidebar
# Column {data-width=200 .sidebar}

# User inputs go in a flexdashboard column like any other dashboard
# component. The widgets don't need to appear within a page layout or
# UI section

# Reactive dataframe using reactive({})

# Using the reactive dataframe in renderFunctions({})

# There is no need to use outputFunctions()! 

# Five steps to making flexdashboard reactive
# 1. Create a sidebar column using {.sidebar}
# 2. Add user inputs to the sidebar using functionInput() Shiny widgets
# 3. Maka a dataframe that reacts to user inputs using reactive()
# 4. Replace the dataframe in the dashboard component code with the
# the reactive version
# 5. Wrap each dashboard output with the apporpriate renderFunction()

# Customized inputs for charts  -------------------------------------------
# Moving inputs into charts using fill layouts
# fillCol(height = 600, flex = c(NA, 1), 
#   inputPanel(
#     sliberInput("xyz_input")
#   ), 
#   plotOutput("xyzPlot", height = "100%")
# )
# output$xyz_input <- renderPlot({})

# One shortcut if you want to have Shiny inputs in a sidebar affect 
# some charts and not others is to have a mukti-page dashboard in which
# charts affected by the same set of user inputs are collected on a page
# together.
# fillRow()