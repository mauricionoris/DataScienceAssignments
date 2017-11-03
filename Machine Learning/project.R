
library(caret)
library(rpart)
library(rpart.plot)
library(RColorBrewer)
library(rattle)
library(randomForest)
library(knitr)

set.seed(555)

data.train.path <- "G:/R/MachineLearning/data/pml-training.csv"
data.test.path <- "G:/R/MachineLearning/data/pml-testing.csv"

data.train <- read.csv(data.train.path, na.strings=c("NA","#DIV/0!",""))
data.test  <- read.csv(data.test.path , na.strings=c("NA","#DIV/0!",""))

data.train.partition <- createDataPartition(data.train$classe, p=0.7, list=FALSE)

data.train.partition.train  <- data.train[ data.train.partition,]
data.train.partition.test   <- data.train[-data.train.partition,]

dim(data.train.partition.train)
dim(data.train.partition.test)


##Clean
nvz <- nearZeroVar(data.train.partition.train)
data.train.partition.train    <-  data.train.partition.train[, -nvz]
data.train.partition.test     <-  data.train.partition.test[, -nvz]

mostlyNA <- sapply(data.train.partition.train, function(x) mean(is.na(x))) > 0.90

data.train.partition.train    <- data.train.partition.train[, mostlyNA==FALSE]
data.train.partition.test     <-  data.train.partition.test[,  mostlyNA==FALSE]

#removing irrelevant columns
data.train.partition.train    <- data.train.partition.train[, -(1:5)]
data.train.partition.test     <-  data.train.partition.test[, -(1:5)]

##Random forest
mod.rf.control <- trainControl(method="cv", number=3, verboseIter=F)
mod.rf.fit     <- train(classe ~ ., data=data.train.partition.train, method="rf", trControl=mod.rf.control)


mod.rf.fit$finalModel
mod.rf.prediction <- predict(mod.rf.fit, newdata=data.train.partition.test)
confusionMatrix(data.train.partition.test$classe,mod.rf.prediction)



# Retrain
nzv <- nearZeroVar(data.train)
data.train <- data.train[, -nzv]
data.test <- data.test[, -nzv]

mostlyNA <- sapply(data.train, function(x) mean(is.na(x))) > 0.95
data.train <- data.train[, mostlyNA==F]
data.test <- data.test[, mostlyNA==F]

data.train <- data.train[, -(1:5)]
data.test <- data.test[, -(1:5)]

# re-fit model using full training set (ptrain)
mod.ref.fit2 <- train(classe ~ ., data=data.train, method="rf", trControl=mod.rf.control)
mod.rf.prediction2 <- predict(mod.ref.fit2, newdata=data.test)


# create function to write predictions to files
pml_write_files <- function(x) {
  n <- length(x)
  for(i in 1:n) {
    filename <- paste0("problem_id_", i, ".txt")
    write.table(x[i], file=filename, quote=F, row.names=F, col.names=F)
  }
}

# create prediction files to submit
pml_write_files(as.character(mod.rf.prediction2))






