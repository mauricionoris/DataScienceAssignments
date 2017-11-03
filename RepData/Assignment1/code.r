setwd("G:/R/RepData_PeerAssessment1")
act.Full <- read.csv(file="activity.csv",sep=",")
act.NALess <- act.Full[complete.cases(act.Full),]

act.ByDay <- aggregate(act.NALess$steps, list(act.NALess$date), sum)

hist(act.ByDay$x)

calcSummary <- function(x) {
    c(
      min = min(x)
    , max = max(x)
    , mean = mean(x)
    , median = median(x)
    , std = sd(x)
    )
}

act.Summary <- calcSummary(act.ByDay$x)

act.AvgByDay <- aggregate(act.NALess$steps, list(act.NALess$interval), mean)
plot(act.AvgByDay$Group.1,act.AvgByDay$x, type="l",xlab="",  ylab="Average Steps by Interval", cex.lab=0.9, cex.axis=0.9)

act.MaxStepsInterval <- act.AvgByDay[act.AvgByDay$x == max(act.AvgByDay$x),]

TotalNA <- nrow(act.Full) - nrow(act.NALess)

colnames(act.AvgByDay) <- c("interval", "steps_avg")

act.Full$steps <- ifelse(is.na(act.Full$steps) == TRUE, act.AvgByDay$steps_avg[act.AvgByDay$interval %in% act.Full$interval] ,act.Full$steps)

act.ByDay_Full <- aggregate(act.Full$steps, list(act.Full$date), sum)

hist(act.ByDay_Full$x)

act.Summary_Full <- calcSummary(act.ByDay_Full$steps)

colnames(act.ByDay_Full) <- c("date", "steps")

wk <- c('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday')
act.Full$date <- as.Date(act.Full$date)
act.Full$wDay <- c('weekend', 'weekday')[(weekdays(act.Full$date) %in% wk) +1L]


act.AvgByDayFull <- aggregate(act.Full$steps, list(act.Full$interval,act.Full$wDay), mean)
colnames(act.AvgByDayFull) <- c("interval","wday", "avg_steps")

par(mfrow = c(1, 2))

act.AvgByDayFull_weekday <- act.AvgByDayFull[act.AvgByDayFull$wday == 'weekday',]
act.AvgByDayFull_weekend <- act.AvgByDayFull[act.AvgByDayFull$wday == 'weekend',]

plot(act.AvgByDayFull_weekend$interval,act.AvgByDayFull_weekend$avg_steps, type="l",xlab="",  ylab="Weekend", cex.lab=0.9, cex.axis=0.9)

plot(act.AvgByDayFull_weekday$interval,act.AvgByDayFull_weekday$avg_steps, type="l",xlab="",  ylab="Weekday", cex.lab=0.9, cex.axis=0.9)




##  rm(list=ls()) ##releases memory
