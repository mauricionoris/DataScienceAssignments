library(shiny)

# Define UI for dataset viewer application
shinyUI(fluidPage(
  

  # Application title
  titlePanel("Find a private school"),
  
  sidebarLayout(
    sidebarPanel(
      uiOutput("CityControl"),
      uiOutput("CEPControl")
      
    ),
    
    
    
    
    # Show the caption, a summary of the dataset and an HTML 
    # table with the requested number of observations
    mainPanel(
      h3(textOutput("Municipio", container = span)),
      p(textOutput("CEP")),
      dataTableOutput("summary"), 
      plotOutput("plot")
    )
  )
))
