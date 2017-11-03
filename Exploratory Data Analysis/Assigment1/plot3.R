##Plot 3

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
filteredData <- data[data$Date  %in% as.Date(c("01/02/2007","02/02/2007"),format = "%d/%m/%Y"),] ##Filter the date

rm(data) ##releases memory

filteredData["DateTime"] <- as.POSIXct(paste(filteredData$Date, filteredData$Time), format="%Y-%m-%d %H:%M:%S")  

## generates the plot
png(file="plot3.png")

plot(filteredData$DateTime, filteredData$Sub_metering_1, type="l",xlab="",  ylab="Energy sub metering", cex.lab=0.9, cex.axis=0.9)
  lines(filteredData$DateTime,filteredData$Sub_metering_2,col = "red",type = 'l')
  lines(filteredData$DateTime,filteredData$Sub_metering_3,col = "blue",type = 'l')
  legend("topright", legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),lwd=2,col=c("black","red","blue"), cex=0.8)

dev.off()
rm(list=ls()) ##releases memory




