---
title: "Getting and Cleaning Data Project Cod Book"
output: github_document
---


The purpose of this document is to provide a description of the data,variables and code used in this project.

The source data for this project is from the UCI Human Activity Recognition Using Smartphones Data Set, a full description is available at: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones


## Description of Data

The UCI HAR dataset contains a number of files, in addition to the README.txt and features_info.txt which provide detailed information about the data and variables. We are primarily interested in the following files: 

- X_train.txt
- Y_train.txt
- subject_train.txt
- X_test.txt
- Y_test.txt
- subject_test.txt
- features.txt
- activity_labels.txt

The "X_..." files for contain testing and training accelerometer data for each subject,variables are in columns and each observation is in rows. The "Y_..." files contain the activity type code (i.e which activity is being completed) for each observation. The "Subject_" files contain the subject code (i.e which subject/person) for each observation. "activity_labels.txt" links the activity code in the "Y_" files with a description i.e sitting, standing, walking etc. and the "features.txt" provides descriptive names for each of the variables in the "X_" files more information about each variable is given in the features_info.txt file  

## Description of R Script and Variables

The R script ```run_analysis.R```  performs collecting and cleaning of the data in a number of steps which will be descriped below:

- Checks to see if a data folder and UCI HAR data set exists in the current working R directory and if not it downloads and extracts them ready to be loaded into R, this is to save re-downloading the data each time the script is run.

- Loads the relevant data files into R using ```read.table``` this data consists of test and training  data with corresponding x,y and subject files for each which correspond to the accelerometer data, activity type and subject respectively. Additionally there is a features file which provides names for each variable for the accelerometer data.

- Once the training and test sets of data are read into R they are combined. First the training x data is combined with the test x data, then the  y and subject data are combined with their respective training and test data. this makes three "long" datasets ```x_data```, ```y_data```and  ```subjects_data```. This is done so that the columns can be easily labeled which is the next step. 
- The three columns are labeled using the ```features``` data we imported earlier. Now the three data sets can be combined into one big table ```combinedTable``` using the ```cbind``` function

- Now that the data has been combined into one table we can subset and summaries to get the data we actually want. This involves first finding only the columns with mean and standard deviation data in them which is done using the ```grepl``` function which creates a list of indices containing "mean and "std" ```mean_std_indices```. We then subset the ```combinedTable``` into ```sub_combinedTable``` using these ```mean_std_indices``` and keeping the associated activity and subject ID's.

- With a subset dataset the script then adds descriptive activity names using the ```merge``` function to combine the ```activity_labels``` table with the ```sub_combinedTable``` table creating the ```sub_desc_act``` table.

- Finally using the ```aggregate``` function the script calculates an mean for each variable for each activity and each subject to create the ```tidydata``` table and prints the data to a test file```TidyData.txt```  

