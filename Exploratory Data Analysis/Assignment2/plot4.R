##Plot 4

library(ggplot2)

## Change it to the correct path of your working directory
wd <- "C:\\Users\\mfreire\\Documents\\BigData\\Coursera\\WD\\Assignments\\ExploratoryDataAnalysis_project2"
setwd(wd)

## read the data sets
## This first line will likely take a few seconds. Be patient!
## Assuming that the data set is in a directory Data inside of your working directory
NEI <- readRDS(".\\data\\summarySCC_PM25.rds")
SCC <- readRDS(".\\data\\Source_Classification_Code.rds")

#filtering Coal combustion related
SCC <- SCC[grep("Coal",SCC$Short.Name),]

#merge the datasets
NEI <- merge(NEI,SCC,by.x="SCC", by.y="SCC")
rm(SCC) ##releases memory

# Consolidates the total of Emissions by Year e polluent
N <- aggregate(list(Emissions=NEI$Emissions),by=list(Years=NEI$year,Type=NEI$type,SCC.Name=NEI$SCC.Level.One),sum)
rm(NEI) ##releases memory``

## generates the plot
png(file="plot4.png")
qplot(N$Years,N$Emissions,data=N,color=N$SCC.Name)+geom_line()
dev.off()

rm(list=ls()) ##releases memory
