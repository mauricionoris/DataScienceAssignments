

##Plot 3

library(ggplot2)

## Change it to the correct path of your working directory
wd <- "C:\\Users\\mfreire\\Documents\\BigData\\Coursera\\WD\\Assignments\\ExploratoryDataAnalysis_project2"
setwd(wd)

## This first line will likely take a few seconds. Be patient!
## read the data sets
## Assuming that the data set is in a directory Data inside of your working directory
NEI <- readRDS(".\\data\\summarySCC_PM25.rds")

#filter only Baltimore
NEI <- NEI[NEI$fips == 24510 ,c("year","Emissions", "type")]

# Consolidates the total of Emissions by Year
N <- aggregate(list(Emissions=NEI$Emissions),by=list(Years=NEI$year,Type=NEI$type),sum)

rm(NEI) ##releases memory

## generates the plot
png(file="plot3.png")
qplot(N$Years, N$Emissions, data=N, color=N$Type)+geom_line()
dev.off()

rm(list=ls()) ##releases memory
