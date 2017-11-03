#Introduction

The purpose of this file is to explain how the run_analysis.R handles the dataset, describes the variables, the data, and any transformations or work that you performed to clean up it.

##Pre requisites
You should download the dataset in a directory named "UCI HAR Dataset" under your working directory.

##Data variables
The script begins setting the working directory. Here are the list of the variables created:
<ol>
  <li><b>trDataset</b> - Contains the path of the Train DataSet</li>
  <li><b>teDataset</b> - Contains the path of the Test DataSet </li>
  <li><b>f</b> - It is the features file </li>
  <li><b>a</b> - It is the activities file </li>
  <li><b>s</b> - It is the subjects file. (s.tr - Train; s.te - Test; s.full - Combined) </li>
  <li><b>l</b> - It is the label file. (l.tr - Train; l.te - Test; l.full - Combined) </li>
  <li><b>x</b> - It is the data set file. (x.tr - Train; x.te - Test; x.full - Combined) </li>
  <li><b>fr</b> - It is a subset of the features file containing just the Mean and Standard Deviation features</li>
  <li><b>x.MeanStd</b> - Subset of the x.full containing just the Mean and Standard Deviation features</li>
  <li><b>x.Average</b> - Subset of the x.MeanStd containing the mean of each feature by Activity and Subject</li>
</ol>
##Transformations
The script perform the following transformations:
<ol>
  <li><b>Line 11 </b> - Sets the working directory</li>
  <li><b>Line 26 </b> - Combine the subject files </li>
  <li><b>Line 32 </b> - Combine the label files</li>
  <li><b>Line 38 </b> - Combine the datasets</li>
  <li><b>Line 44 </b> - Filter the Mean and Standard Deviations filter </li>
  <li><b>Line 47 </b> - Clean special characters from the features names </li>
  <li><b>Line 49 </b> - Creates a new dataset contaning only the means and Std features </li>
  <li><b>Line 54 </b> - Decorates the dataset with the subject information </li>
  <li><b>Line 55 </b> - Decorates the dataset with the label ID </li>
  <li><b>Line 57 </b> - Decorates the dataset with the activity information </li>
  <li><b>Line 61 </b> - Calculates the average by activity and subject </li>
</ol>

##Outputs
The script generates the following outputs inside the folder Output:
<ol>
 <li><b>Item 1 - </b>item_1_MergedDataSet.txt - Contains the train and test combined dataset (all variables)</li>
 <li><b>Item 2 - </b>item_2_MeanStdDataSet.txt - Contains the train and test combined dataset (Means and Std features)</li>
 <li><b>Item 3 and 4 - </b>item_3_4_MeanStdDataSet_Labels.txt - Contains the dataset decorated</li>
 <li><b>Item 5 - </b>item_5_tidyDataSet.txt - Contains the tidy dataset decorated</li>
</ol>

