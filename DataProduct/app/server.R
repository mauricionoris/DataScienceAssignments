library(shiny)
library(ggplot2)
library(ggmap)
library(ggrepel)

options(warn=-1)

#fileURL <- 'https://dl.dropboxusercontent.com/u/56099385/DataProduct/CADASTRO_MATRICULAS_REGIAO_SUDESTE_SP_2012.csv'
#data <- repmis::source_data(fileURL,sep = ";", header = TRUE, skip=11)

#get data from the file
filePath='./app/Data/CADASTRO_MATRICULAS_REGIAO_SUDESTE_SP_2012.csv'
data <- read.csv(filePath, TRUE, sep=";")

features <- c('Nome_Escola','REDE','CATESCPRIVADA','Localizacao','UF','Municipio','Endereco','Nr_Endereco','Complemento_Endereco','Bairro','CEP','DDD','Telefone','Correio_Eletronico','Situacao_Funcionamento','ID_LATITUDE','ID_LONGITUDE','NUM_SALAS_EXISTENTES','NUM_SALAS_UTILIZADAS','INTERNET','BANDA_LARGA')
filters <- c(data$REDE == 'Privada' & data$Situacao_Funcionamento == 'Em Atividade' & data$INTERNET == 'Sim')
data <- data[filters,features]

#Prepare the dataset
data$loc <- paste(data$Nome_Escola, paste(data$Endereco,data$Nr_Endereco, data$Municipio,'CEP:', data$CEP, sep=" "), data$Correio_Eletronico, sep='\n')

lack_of_coordenates <- c(data$ID_LATITUDE == '' & data$ID_LONGITUDE == '')

data.Unlocated <- data[lack_of_coordenates, ]
data.Located <-data[!lack_of_coordenates, ]

data.Located.ByCity <- levels(unique(data.Located$Municipio))
data.Located.ByLocation <- unique(data.Located[data.Located$Municipio=="SAO PAULO",'CEP'])

#data cleaning
data.Located$ID_LATITUDE <- as.numeric(gsub(",",".",data.Located$ID_LATITUDE))
data.Located$ID_LONGITUDE <- as.numeric(gsub(",",".",data.Located$ID_LONGITUDE))


# Define server logic required to summarize and view the selected
# dataset
shinyServer(function(input, output, session) {
  
  # By declaring datasetInput as a reactive expression we ensure 
  # that:
  #
  #  1) It is only called when the inputs it depends on changes
  #  2) The computation and result are shared by all the callers 
  #	  (it only executes a single time)
  #
#   datasetInput <- reactive({
#     switch(input$dataset,
#            "rock" = rock,
#            "pressure" = pressure,
#            "cars" = cars)
#   })
  
      ListOfZips <- reactive({data.Located.ByLocation <- unique(data.Located[data.Located$Municipio==input$Municipio,'CEP'])})
      dataset    <- reactive({data.Located[data.Located$Municipio==input$Municipio & data.Located$CEP==input[['CEP']],]})
        
  output$Municipio <- renderText({
    paste("Selected City", input$Municipio,sep=":")
  })
  
  output$CEP <- renderText({
    
    paste("Selected Zip", input[['CEP']],sep=":")
  })

  output$CityControl <- renderUI({
    selectInput("Municipio", "Choose City", choices = data.Located.ByCity, selected = 'SAO PAULO')
  })
    
  output$CEPControl <- renderUI({
     selectInput("CEP", "Choose ZipCode", choices = ListOfZips())
  })
  

  output$summary <- renderDataTable(dataset())
    
  output$plot <- renderPlot({
    mydataset <- dataset()
    
    d <- data.frame(
      lon=mydataset$ID_LONGITUDE
      , lat=mydataset$ID_LATITUDE
      , loc=mydataset$loc
    )
    #print(d)
    map <- get_map(location=c(lon = mean(d$lat), lat = mean(d$lon)), zoom = 12, maptype = "roadmap", source = "google")
    p <- ggmap(map) + geom_point(data=d, aes(x=lat, y=lon),colour = 'red', size = 2, alpha = .6) + geom_label_repel(data=d, aes(x=lat, y=lon, label=loc),fontface='bold');
    
    print(p)
    
  }, height=700)
  


})




