# --------------------------------------------------- 
# Case Studies: Building Web Applications with Shiny in R - Create your own 
# word cloud with Shiny in R
# 01 dez 2020 
# VNTBJR 
# --------------------------------------------------- 
#
# Word clouds in Shiny  -------------------------------------------
# This exercise needs an object not provided and the following code 
# will not work
create_wordcloud <- function(data, num_words = 100, background = "white") {
  
  # If text is provided, convert it to a dataframe of word frequencies
  if (is.character(data)) {
    corpus <- Corpus(VectorSource(data))
    corpus <- tm_map(corpus, tolower)
    corpus <- tm_map(corpus, removePunctuation)
    corpus <- tm_map(corpus, removeNumbers)
    corpus <- tm_map(corpus, removeWords, stopwords("english"))
    tdm <- as.matrix(TermDocumentMatrix(corpus))
    data <- sort(rowSums(tdm), decreasing = TRUE)
    data <- data.frame(word = names(data), freq = as.numeric(data))
  }
  
  # Make sure a proper num_words is provided
  if (!is.numeric(num_words) || num_words < 3) {
    num_words <- 3
  }  
  
  # Grab the top n most common words
  data <- head(data, n = num_words)
  if (nrow(data) == 0) {
    return(NULL)
  }
  
  wordcloud2(data, backgroundColor = background)
}
# load package
library(wordcloud2)

# Define UI for the application
ui <- fluidPage(
  h1("Word Cloud"),
  # Add the word cloud output placeholder to the UI
 wordcloud2Output(outputId = "cloud")
)

# Define the server logic
server <- function(input, output) {
  # Render the word cloud and assign it to the output list
  output$cloud <- renderWordcloud2({
    # Create a word cloud object
    create_wordcloud(artofwar)
  })
}

# Run the application
shinyApp(ui = ui, server = server)

# Change the word cloud parameters
# Load package
library(colourpicker)

ui <- fluidPage(
  h1("Word Cloud"),
  # Add a numeric input for the number of words
  numericInput(inputId = 'num', label = "Maximum number of words",
      value = 100, min = 5),
  # Add a color input for the background color
  colourInput(inputId = 'col', label = 'Background color', value = 'white'), 
  wordcloud2Output("cloud")
)

server <- function(input, output) {
  output$cloud <- renderWordcloud2({
    # Use the values from the two inputs as
    # parameters to the word cloud
    create_wordcloud(artofwar,
                     num_words = input$num, background = input$col)
  })
}

shinyApp(ui = ui, server = server)

# Add a layout
ui <- fluidPage(
  h1("Word Cloud"),
  # Add a sidebar layout to the UI
  sidebarLayout(
    # Define a sidebar panel around the inputs
    sidebarPanel(
      numericInput("num", "Maximum number of words",
                   value = 100, min = 5),
      colourInput("col", "Background color", value = "white")
    ),
    # Define a main panel around the output
    mainPanel(
      wordcloud2Output("cloud")
    )
  )
)

server <- function(input, output) {
  output$cloud <- renderWordcloud2({
    create_wordcloud(artofwar,
                     num_words = input$num, background = input$col)
  })
}

shinyApp(ui = ui, server = server)

# Adding word sources  -------------------------------------------
# Use your own words
ui <- fluidPage(
  h1("Word Cloud"),
  sidebarLayout(
    sidebarPanel(
      # Add a textarea input
      textAreaInput(inputId = "text", label = "Enter text", rows = 7),
      numericInput("num", "Maximum number of words",
                   value = 100, min = 5),
      colourInput("col", "Background color", value = "white")
    ),
    mainPanel(
      wordcloud2Output("cloud")
    )
  )
)

server <- function(input, output) {
  output$cloud <- renderWordcloud2({
    # Use the textarea's value as the word cloud data source
    create_wordcloud(data = input$text, num_words = input$num,
                     background = input$col)
  })
}

shinyApp(ui = ui, server = server)

# Upload a text file (ui)
ui <- fluidPage(
  h1("Word Cloud"),
  sidebarLayout(
    sidebarPanel(
      textAreaInput("text", "Enter text", rows = 7),
      # Add a file input
      fileInput(inputId = "file", label = "Select a file"),
      numericInput("num", "Maximum number of words",
                   value = 100, min = 5),
      colourInput("col", "Background color", value = "white")
    ),
    mainPanel(
      wordcloud2Output("cloud")
    )
  )
)

server <- function(input, output) {
  output$cloud <- renderWordcloud2({
    create_wordcloud(input$text, num_words = input$num,
                     background = input$col)
  })
}

shinyApp(ui = ui, server = server)

# Upload a text file (server)
ui <- fluidPage(
  h1("Word Cloud"),
  sidebarLayout(
    sidebarPanel(
      textAreaInput("text", "Enter text", rows = 7),
      fileInput("file", "Select a file"),
      numericInput("num", "Maximum number of words",
                   value = 100, min = 5),
      colourInput("col", "Background color", value = "white")
    ),
    mainPanel(
      wordcloud2Output("cloud")
    )
  )
)

server <- function(input, output) {
  # Define a reactive variable named `input_file`
  input_file <- reactive({
    if (is.null(input$file)) {
      return("")
    }
    # Read the text in the uploaded file
    readLines(input$file$datapath)
  })
  
  output$cloud <- renderWordcloud2({
    # Use the reactive variable as the word cloud data source
    create_wordcloud(data = input_file(), num_words = input$num,
                     background = input$col)
  })
}

shinyApp(ui = ui, server = server)