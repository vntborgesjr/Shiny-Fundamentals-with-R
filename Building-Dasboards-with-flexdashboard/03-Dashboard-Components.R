# --------------------------------------------------- 
# Building Dashboards with flexdashboard - Dashboard Components 
# 08 dez 2020 
# VNTBJR 
# --------------------------------------------------- 
#
# Highlighting single values  -------------------------------------------
# Two ways to display single values:
# Value box - best choice for unbounded values.
# valueBox(value = , caption = , icon = )
# Gauge box - good choices for values that fall within a defined range,
# specially if there are thresholds within that range 
# gauge(value = , min = , max = , sectors = gaugeSectors(success = ,
# warning = , danger = ), symbol = )
# To make valueBox and gauge linked, use the href argument to make the 
# caption linked and clickable

# Dashboard Tables  -------------------------------------------
# Web-friendly tables
# DT package - datatable() function
# Builds a table that is searchable, sortable, and paginated.
# datatable(my_data_df,
# rownames = FALSE, # eliminate row numbers
# options = list(pageLength = 15)) # changing rows per page

# datatable(my_data_df,
# rownames = FALSE, # eliminate row numbers
# extensions = "Buttons", # Adding buttons
# options = list(dom = "Bfrtip",
# buttons = c("copy", "csv", "excel", "pdf", "print")))

# Text for Dashboards  -------------------------------------------
# Captions - are added to a specific chart and will appear at the 
# bottom of that chart
# Captions are added with > followed by text, and must go outside of 
# the R chunk. There must to be an empty line between the end of the
# conde chunk and the caption

# Include R line code using `r code`

# Storyboard format
# Instead of components laid out to show multiple charts on a single 
# page, a storyboard presents one chart at a time in a specified order
# and allows the user to progress through them. Across the top, a short 
# description is show for each chart which can be selected for view or 
# navigated through with the arrows on left and right. The chart itself
# is show below this section, with an optional panel for aditional 
# commentary on the right as shown here.

# To make your dashboard a storyboard add "storyboard: true" to the 
# yaml header.

# What would have been the title of the chart become the desription in 
# cards at the top of the storyboard. To add more information on each
# chart, you can add commentary using a tripple asterisk (***). This 
# needs to be after the end of the R chunk for the chart. Text goes 
# bellow the asterisks. Including this line will automatically create 
# a right panel for this step of the story that will display the text 
# you provide.

# You can use multi-page dashboard, with some pages in storydashboard 
# format but not others.

# Ex
# Origin Destination Pairs {.storyboard}
# 
# ### O/D Flow
# 
# ```{r}
#
# ```
#
# Trip Raw Data
#
# ### Trip-Level Data
#
# ```{r}
#
# ```
#
