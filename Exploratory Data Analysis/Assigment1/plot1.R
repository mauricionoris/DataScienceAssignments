  ##Plot 1

  ## Change it to the corret path of your working directory
  wd <- "C:\\Users\\mfreire\\Documents\\BigData\\Coursera\\WD\\Assignments\\ExploratoryDataAnalysis"
  setwd(wd)
  
  ## Assuming that the dataset is in a directory Data inside of your working directory
  sourceFile <- ".\\data\\household_power_consumption.txt"
  
  ## read the dataset
  data <- read.table(sourceFile, header = TRUE
                               , sep = ";"
                               , dec = "."
                               , na.strings = c("?"))
                               
  data$Date <- as.Date(data$Date, format="%d/%m/%Y") ##Change the field to Date type
  filteredData <- data[data$Date %in% as.Date(c("01/02/2007","02/02/2007"),format = "%d/%m/%Y"),] ##Filter the date
  rm(data) ##releases memory
  
  ## generates the plot
  png(file="plot1.png")
  hist(filteredData$Global_active_power, col = "red",main="Global Active Power",xlab="Global Active Power(kilowatts)", cex.lab=0.8, cex.axis=0.8, cex.main = 0.8)
  dev.off()

  rm(list=ls()) ##releases memory

  

