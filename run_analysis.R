 fileURL<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
 #check if data folder exists if not create it
 if (!file.exists("data")){
     dir.create("data")
 }
 # check if UCI HAR dataset folder exists if not download it and extract contents
 if (!file.exists("./data/UCI HAR Dataset")){
     download.file(fileURL,"./data/Dataset.zip")
     unzip(zipfile = "./data/Dataset.zip",exdir = "./data")
    }
 
#read in training data 
x_training_data<- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_training_data<- read.table("./data/UCI HAR Dataset/train/Y_train.txt")
Subject_training_data<-read.table("./data/UCI HAR Dataset/train/subject_train.txt")

#read in test data 
x_test_data<- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test_data<- read.table("./data/UCI HAR Dataset/test/Y_test.txt")
subject_test_data<- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

#read in features ffir use as column names later
features<-read.table("./data/UCI HAR Dataset/features.txt")

#read in activity labels and define column names
activity_labels <-read.table("./data/UCI HAR Dataset/activity_labels.txt")
names(activity_labels)<-c("activityID","activityDescription")

#combine x data 
x_data<- rbind(x_test_data,x_training_data)
#combine y data 
y_data <- rbind(y_test_data, y_training_data)
#combine subject data
subject_data<-rbind(subject_test_data,Subject_training_data)

#assign column names (for x data use features as column names) 
names(y_data)<-"activityID"
names(subject_data)<-"subjectID"
names(x_data)<-features[[2]]

#combine into one data set
combinedTable<-cbind(subject_data,x_data,y_data)

#get indices of columns with "mean" in the title
mean_indices<-grep("mean",names(combinedTable))

#get indices of columns of standard devations
std_indices<-grep("std",names(combinedTable))

#combine mean and std columns indices with  of the activityID(col 1) and subjectID(col 563)indices
mean_std_indices<-c(1,mean_indices,std_indices,563)

#subset combined dataset using the indices
sub_combinedTable<-combinedTable[,mean_std_indices]

#add descriptive activity labels using the merge function  
sub_desc_act<-merge(sub_combinedTable,activity_labels, by = "activityID")

# get the average of each variable for seach subject and activity type
tidydata<-aggregate(. ~subjectID + activityDescription, sub_desc_act,mean)

#remove activityID column as it is duplicate data with the activity description column
tidydata <- within(tidydata, rm(activityID))

#write the data to txt file
write.table(tidydata,"./TidyData.txt",row.names = FALSE)
