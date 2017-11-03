rm(list=ls())
setwd("G:/R/RepData_PeerAssessment2")

localFile <- '' ##./data/repdata-data-StormData.csv' 

cols <- c("EVTYPE","FATALITIES", "INJURIES","PROPDMG", "PROPDMGEXP", "CROPDMG", "CROPDMGEXP","BGN_DATE")


if (localFile == "") {
  fileUrl <- "https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"
  dataFile <- tempfile()
  download.file(fileUrl, dataFile)
  data <- read.csv(bzfile(dataFile, "repdata-data-StormData.csv"))[,cols]
  unlink(dataFile)
} else {
  data <- read.csv(localFile)[,cols]
  
}

#data preparation
data$YEAR <- as.numeric(format(as.Date(data$BGN_DATE, format = "%m/%d/%Y %H:%M:%S"),"%Y"))
data$EVTYPE <- as.character(data$EVTYPE)
data$FATALITIES <- as.numeric(data$FATALITIES)
data$INJURIES <- as.numeric(data$INJURIES)
data$PROPDMG <- as.numeric(data$PROPDMG)
data$CROPDMG <- as.numeric(data$CROPDMG)

#removing events without any warm (health or economic)
data <- data[(data$FATALITIES + data$INJURIES + data$PROPDMG + data$CROPDMG) > 0,]

nColumn <- "EVTYPE2"

data[grepl("tstm|thunderstorm|tunderstorm|thunderstrom|thundeerstorm|thunderestorm|thundersnow|thunderstrom|thundertorm|thunerstorm",tolower(data$EVTYPE)) 
  & !grepl("marine|non", tolower(data$EVTYPE)), nColumn] <- "thunderstorm wind"

data[grepl("hurricane|typhoon", tolower(data$EVTYPE)), nColumn] <- "hurricane/typhoon"
data[grepl("rip current", tolower(data$EVTYPE)), nColumn] <- "rip current"
data[grepl("fire", tolower(data$EVTYPE)), nColumn] <- "wildfire"
data[grepl("(extreme|excessive|unusually|record) cold", tolower(data$EVTYPE)), nColumn] <- "extreme cold/wind chill"
data[grepl("cold", tolower(data$EVTYPE)) 
  & !grepl("^extreme cold", tolower(data$EVTYPE)), nColumn] <- "cold/wind chill"

data[grepl("(excessive|extreme|record) heat", tolower(data$EVTYPE)), nColumn] <- "excessive heat"
data[grepl("heat", tolower(data$EVTYPE)) 
  & !grepl("^excessive heat", tolower(data$EVTYPE)), nColumn] <- "heat"

data[grepl("storm surge", tolower(data$EVTYPE)), nColumn] <- "storm surge/tide"
data[grepl("hail", tolower(data$EVTYPE)) 
  & !grepl("marine", tolower(data$EVTYPE)), nColumn] <- "hail"

data[grepl("(heavy|record|excessive) snow", tolower(data$EVTYPE)), nColumn] <- "heavy snow"
data[grepl("(tornado|tornadoes|torndao|tornado f0|tornado f1|tornado f2| tornado f3)", tolower(data$EVTYPE)),nColumn] <- "tornado"
data[grepl("(coastal flood|coastal flooding|coastal flooding/erosion)", tolower(data$EVTYPE)),nColumn] <- "coastal flood"
data[grepl("(flash flood/flood|flash flooding/flood|ice storm/flash flood|flash flooding|flash floods|flash flood)", tolower(data$EVTYPE)),nColumn] <- "flash flood"
data[grepl("(Urban/sml Stream Fld|urban and small stream floodin|flood & heavy rain|flooding|flood/river flood|minor flooding|flood)", tolower(data$EVTYPE)),nColumn] <- "flood"
data[grepl("(avalanche|avalance)", tolower(data$EVTYPE)),nColumn] <- "avalanche"
data[grepl("(strong wind)", tolower(data$EVTYPE)),nColumn]  <-  "strong wind"
data[grepl("(dense fog)", tolower(data$EVTYPE)),nColumn]    <-  "dense fog"
data[grepl("(lightning)", tolower(data$EVTYPE)),nColumn]    <-  "lightning"
data[grepl("(winter storm)", tolower(data$EVTYPE)),nColumn] <- "winter storm"
data[grepl("(ice storm)", tolower(data$EVTYPE)),nColumn]    <-  "ice storm"
data[grepl("(high wind|wind)", tolower(data$EVTYPE)),nColumn]    <-  "high wind"
data[grepl("(blizzard)", tolower(data$EVTYPE)),nColumn] <-    "blizzard"
data[grepl("(dust storm)", tolower(data$EVTYPE)),nColumn] <-  "dust storm"
data[grepl("(fog)", tolower(data$EVTYPE)),nColumn] <-    "fog"
data[grepl("(heavy rain)", tolower(data$EVTYPE)),nColumn] <-    "heavy rain"
data[grepl("(high surf)", tolower(data$EVTYPE)),nColumn] <-    "high surf"
data[grepl("(tsunami)", tolower(data$EVTYPE)),nColumn] <-    "tsunami"
data[grepl("(dust storm)", tolower(data$EVTYPE)),nColumn] <-    "dust storm"
data[grepl("(winter weather)", tolower(data$EVTYPE)),nColumn] <-    "winter weather"
data[grepl("(tropical storm)", tolower(data$EVTYPE)),nColumn] <-    "tropical storm"


simpleCap <- function(x) {
  s <- strsplit(tolower(x), " ")[[1]]
  paste(toupper(substring(s, 1,1)), substring(s, 2),
        sep="", collapse=" ")
}

data$EVTYPE <- sapply(data$EVTYPE,simpleCap)
data$EVTYPE2 <- sapply(data$EVTYPE2,simpleCap)

# group every record in a event type called "other" to measure the error of the mapreduce process
data[data$EVTYPE2=="NANA",nColumn] <- "Other"

#double checks with any EVTYPE left without normalization
data.er  <- data[data$EVTYPE2=="Other",]
data.cor <- data[data$EVTYPE2!="Other",]

# measure the % of events to be removed from the analyses
summary(data.er)
summary(data.cor)

#1% of the records could not be classified according 
#to the EVTYPE domain and is present on the report with the "Others" classification.However, it is not so significative for the purpse of this report

##first question
data.VictimsByEventType <- aggregate(cbind(data$FATALITIES,data$INJURIES),list(data$EVTYPE2),FUN=sum)
colnames(data.VictimsByEventType) <- c("EVTYPE2","FATALITIES","INJURIES")  

data.er.Agg <- aggregate(cbind(data.er$FATALITIES,data.er$INJURIES),list(data.er$EVTYPE),FUN=sum)
colnames(data.er.Agg) <- c("EVTYPE","FATALITIES","INJURIES")  


##second question
###Cleaning the Exp fields
fExp <- function (x) { ifelse(x == "K", 10^3, ifelse(x == "M", 10^6, ifelse(x == "B", 10^9, 1))) }

#Computes the total amount
data[,"PROPDMGTOT"] <- data$PROPDMG*fExp(data$PROPDMGEXP)
data[,"CROPDMGTOT"] <- data$CROPDMG*fExp(data$CROPDMGEXP)

data.EconomicImpactsByEventType <- aggregate(cbind(data$PROPDMGTOT,data$CROPDMGTOT),list(data$EVTYPE2),FUN=sum)
colnames(data.EconomicImpactsByEventType) <- c("EVTYPE2","PROPDMGTOT","CROPDMGTOT")  


require(reshape2)
require(plyr)

##filtering to report just the top 10 event types
x <- data.VictimsByEventType
x$Total <- x$INJURIES + x$FATALITIES
x <- head(x[with(x,order(-Total)),],n=10)
x <- melt(x[,c("EVTYPE2","FATALITIES","INJURIES")], id.vars = "EVTYPE2")
x <- ddply(x, "EVTYPE2", transform, total=cumsum(value)- 0.5*value)

y <- data.EconomicImpactsByEventType
y$Total <- y$PROPDMGTOT + y$CROPDMGTOT
y <- head(y[with(y,order(-Total)),],n=10)
y <- melt(y[,c("EVTYPE2","PROPDMGTOT","CROPDMGTOT")], id.vars = "EVTYPE2")
y <- ddply(y, "EVTYPE2", transform, total=cumsum(value)- 0.5*value)


require(ggplot2)

fancy_scientific <- function(l) {
  # turn in to character string in scientific notation
  l <- format(l, scientific = TRUE)
  # quote the part before the exponent to keep all the digits
  l <- gsub("^(.*)e", "'\\1'e", l)
  # turn the 'e+' into plotmath format
  l <- gsub("e", "%*%10^", l)
  # return this as an expression
  parse(text=l)
}

ggplot(data=x, aes(x=EVTYPE2, y=value, fill=variable)) +
  geom_bar(stat="identity")+
  theme_minimal() + coord_flip() +
  scale_y_continuous(labels=fancy_scientific) 

ggplot(data=y, aes(x=EVTYPE2, y=value, fill=variable)) +
  geom_bar(stat="identity")+
  theme_minimal() + coord_flip() +
  scale_y_continuous(labels=fancy_scientific) 

