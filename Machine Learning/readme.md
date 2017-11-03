# Project Practical Machine Learning
Mauricio Noris Freire  
March 19, 2016  

The goal of your project is to predict the manner in which they did the exercise. This is the "classe" variable in the training set. You may use any of the other variables to predict with. You should create a report describing how you built your model, how you used cross validation, what you think the expected out of sample error is, and why you made the choices you did. You will also use your prediction model to predict 20 different test cases.

##Data 

The data for this project comes from this original source: http://groupware.les.inf.puc-rio.br/har. 

The training data for this project are available here: 

https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv

The test data are available here:

https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv

##Loading the data


```r
library(caret)
```

```
## Loading required package: lattice
```

```
## Loading required package: ggplot2
```

```r
library(rpart)
library(rpart.plot)
library(RColorBrewer)
library(rattle)
```

```
## Rattle: A free graphical interface for data mining with R.
## Version 4.1.0 Copyright (c) 2006-2015 Togaware Pty Ltd.
## Type 'rattle()' to shake, rattle, and roll your data.
```

```r
library(randomForest)
```

```
## randomForest 4.6-12
```

```
## Type rfNews() to see new features/changes/bug fixes.
```

```
## 
## Attaching package: 'randomForest'
```

```
## The following object is masked from 'package:ggplot2':
## 
##     margin
```

```r
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
```

```
## [1] 13737   160
```

```r
dim(data.train.partition.test)
```

```
## [1] 5885  160
```

##Data Cleaning 


```r
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
```

## Applying Random Forests to see if this approach is effective


```r
##Random forest
mod.rf.control <- trainControl(method="cv", number=3, verboseIter=F)
mod.rf.fit     <- train(classe ~ ., data=data.train.partition.train, method="rf", trControl=mod.rf.control)


mod.rf.fit$finalModel
```

```
## 
## Call:
##  randomForest(x = x, y = y, mtry = param$mtry) 
##                Type of random forest: classification
##                      Number of trees: 500
## No. of variables tried at each split: 27
## 
##         OOB estimate of  error rate: 0.18%
## Confusion matrix:
##      A    B    C    D    E  class.error
## A 3906    0    0    0    0 0.0000000000
## B    7 2649    2    0    0 0.0033860045
## C    0    4 2391    1    0 0.0020868114
## D    0    0   10 2242    0 0.0044404973
## E    0    0    0    1 2524 0.0003960396
```

```r
mod.rf.prediction <- predict(mod.rf.fit, newdata=data.train.partition.test)
confusionMatrix(data.train.partition.test$classe,mod.rf.prediction)
```

```
## Confusion Matrix and Statistics
## 
##           Reference
## Prediction    A    B    C    D    E
##          A 1673    0    0    0    1
##          B    3 1135    1    0    0
##          C    0    3 1023    0    0
##          D    0    0    4  959    1
##          E    0    0    0    1 1081
## 
## Overall Statistics
##                                          
##                Accuracy : 0.9976         
##                  95% CI : (0.996, 0.9987)
##     No Information Rate : 0.2848         
##     P-Value [Acc > NIR] : < 2.2e-16      
##                                          
##                   Kappa : 0.997          
##  Mcnemar's Test P-Value : NA             
## 
## Statistics by Class:
## 
##                      Class: A Class: B Class: C Class: D Class: E
## Sensitivity            0.9982   0.9974   0.9951   0.9990   0.9982
## Specificity            0.9998   0.9992   0.9994   0.9990   0.9998
## Pos Pred Value         0.9994   0.9965   0.9971   0.9948   0.9991
## Neg Pred Value         0.9993   0.9994   0.9990   0.9998   0.9996
## Prevalence             0.2848   0.1934   0.1747   0.1631   0.1840
## Detection Rate         0.2843   0.1929   0.1738   0.1630   0.1837
## Detection Prevalence   0.2845   0.1935   0.1743   0.1638   0.1839
## Balanced Accuracy      0.9990   0.9983   0.9973   0.9990   0.9990
```
As the accuracy of 0.9976 is excelent, let´s procced with this model.


```r
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
```




