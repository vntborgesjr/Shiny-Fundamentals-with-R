# --------------------------------------------------- 
# Building Dashboards with flexdashboard - Dashboard Layouts 
# 04 dez 2020 
# VNTBJR 
# --------------------------------------------------- 
#
# Anatomy of a dashboard  -------------------------------------------

# Turning R Markdown into a flexdashboard

# ---
# title: "My dashboard"
# output:
# flexdashboard::flex_dashboard
# ---

# A flexdashboard is made of charts...

# Column
# -------------------------------------
#
# ### Chart 1
# ```{r}
#
# ``` 
#
# ### Chart 2
# ```{r}
#
# ``` 
#
# Chart 3
# ```{r}
#
# ``` 
#

# ... and charts are arrenged in columns (created with 14 dashes or more)

# ---
# title: "My dashboard"
# output:
#   flexdashboard::flex_dashboard
#     orientation: column
# ---
#
# Column 
# -------------------------------------
#
# ### Chart 1
# ```{r}
#
# ``` 
#
# ### Chart 2
# ```{r}
#
# ``` 
# Column 
# -------------------------------------
#
# Chart 3
# ```{r}
#
# ``` 
#

# Layout basics  -------------------------------------------
# data-width = set the column width. all the columns ned to have widths that add up
# to 1000
# To change the laytout mode from columns to rows, we make a change in the header
# to include the option orientation: rows
# # data-height = set the row height.
# You can make the dasboard page scrollable by using the header option -
# vertical_layout: scroll
# ATENTION: scrollable dashboard pages are not good practice!

# Advanced layouts  -------------------------------------------
# Expanding dashboards
# Multiple tabsets
# {.tabset} - allows you to use the same space for multiple charts that the viewer 
# can flip through.

# Multiple pages
# To create multiple pages you simple add the page designation indicated by 16 
# or more equals signs than group your columns or rows under each page
# {data-navmenu="menu name"} - to group pages under the same menu

# Setting the page orientation
# {data-orientation=rows} - it is used to cahnge the orientation of different pages
# i.e. if you want row orientation for smoe pages and column orientation for others
