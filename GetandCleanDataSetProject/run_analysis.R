
## Items
# 1) Merges the training and the test sets to create one data set.
# 2) Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3) Uses descriptive activity names to name the activities in the data set
# 4) Appropriately labels the data set with descriptive variable names. 
# 5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Change it to the correct path of your working directory
  wd <- "C:\\Users\\mfreire\\Documents\\BigData\\Coursera\\WD\\Assignments\\GetAndCleandDataProject"
  setwd(wd)

#Path for each DataSet - The data set is inside the directory UCI HAR DataSet under the working directory
  trDataset <- ".\\UCI HAR Dataset\\train\\"
  teDataset <- ".\\UCI HAR Dataset\\test\\"

  # features file
  f <- read.table(".\\UCI HAR Dataset\\features.txt", header=FALSE, as.is=TRUE, col.names=c("ID", "Name"))

  #Activity file
  a <- read.table(".\\UCI HAR Dataset\\activity_labels.txt", header=F, col.names=c("Act", "ActName"))

  #subject files
  s.tr  <- read.table(paste(trDataset,"subject_train.txt",sep=""), header=FALSE, col.names=c("SID"))
  s.te  <- read.table(paste(teDataset,"subject_test.txt",sep="") , header=FALSE, col.names=c("SID"))
  s.full <- rbind(s.tr, s.te)

  #label files
  l.tr <- read.table(paste(trDataset,"y_train.txt",sep=""), header=FALSE, col.names=c("Act"))
  l.te <- read.table(paste(teDataset, "y_test.txt",sep=""), header=FALSE, col.names=c("Act"))
  l.full <- rbind(l.tr, l.te)

  #test and training sets. (large files)
  x.tr <- read.table(paste(trDataset,"x_train.txt",sep=""), header=FALSE, sep="", col.names=f$Name)
  x.te <- read.table(paste(teDataset, "x_test.txt",sep=""), header=FALSE, sep="", col.names=f$Name)

# 1) Merges the training and the test sets to create one data set.
  x.full <- rbind(x.tr, x.te)
  write.table(x.full, file = ".\\output\\item_1_MergedDataSet.txt", sep = ",", col.names = NA, qmethod = "double")

# 2) Extracts only the measurements on the mean and standard deviation for each measurement. 

  #vector of variables to keep 
  fr <- f[c(grep("mean()",f$Name),grep("std()",f$Name)),]
  
  #remove specital characters to match the columun names
  fr$Name <-   gsub("\\-",".",gsub("\\)",".",gsub("\\(", ".", fr$Name)))

  x.MeanStd <- x.full[,colnames(x.full) %in% fr$Name]
  write.table(x.MeanStd, file = ".\\output\\item_2_MeanStdDataSet.txt", sep = ",", col.names = NA, qmethod = "double")

# 3) Uses descriptive activity names to name the activities in the data set
# 4) Appropriately labels the data set with descriptive variable names 
  x.MeanStd <- cbind(x.MeanStd,s.full)
  x.MeanStd <- cbind(x.MeanStd,l.full)
  a$ActName <- as.factor(a$ActName)
  x.MeanStd$Act <- factor(x.MeanStd$Act, levels = 1:6, labels = a$ActName)
  write.table(x.MeanStd, file = ".\\output\\item_3_4_MeanStdDataSet_Labels.txt", sep = ",", col.names = NA, qmethod = "double")

# 5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
  x.Average <- aggregate(x=x.MeanStd[fr$Name],by=list(SubjectID=x.MeanStd$SID,ActivityName=x.MeanStd$Act),mean)
  write.table(x.MeanStd, file = ".\\output\\item_5_tidyDataSet.txt", sep = ",", row.name=FALSE, qmethod = "double")

  rm(list=ls()) ##releases memory
