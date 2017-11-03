##Plot 1

## Change it to the correct path of your working directory
wd <- "C:\\Users\\mfreire\\Documents\\BigData\\Coursera\\WD\\Assignments\\ExploratoryDataAnalysis_project2"
setwd(wd)

## This first line will likely take a few seconds. Be patient!
## read the data sets
## Assuming that the data set is in a directory Data inside of your working directory
NEI <- readRDS(".\\data\\summarySCC_PM25.rds")[,c("year","Emissions")]

# Consolidates the total of Emissions by Year
N <- aggregate(NEI$Emissions,by=list(year=NEI$year),sum)

rm(NEI) ##releases memory

## generates the plot
png(file="plot1.png")
plot(N$year, N$x, type="l", main="Total Emissions by year",xlab="Year",  ylab="PM2.5 (in tons)")
dev.off()

rm(list=ls()) ##releases memory
