Getting and Cleaning Data Course 

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should create one R script called run_analysis.R that does the following.

Merges the training and the test sets to create one data set.
Extracts only the measurements on the mean and standard deviation for each measurement.
Uses descriptive activity names to name the activities in the data set
Appropriately labels the data set with descriptive variable names.
From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
Good luck!

## Codes

##Set the folder of "UCI HAR Dataset" as the working directory
library(data.table)

##Read features and activity_labels tables
##Extract mean and standard deviation measurements from features table
features<-read.table("features.txt")
activity<-read.table("activity_labels.txt")
index<-features[grep("mean|std",features[,2]),]

##Read test data including subject, activity and required measurements (with descriptive column names)
subject_test<-read.table("./test/subject_test.txt",col.names = c("subject"))
x_test<-fread("./test/X_test.txt",select=index[,1],col.names=as.character(index[,2]))
y_test<-read.table("./test/y_test.txt",col.names = c("activity"))

##Read train data including subject, activity and required measurements (with descriptive column names)
subject_train<-read.table("./train/subject_train.txt",col.names = c("subject"))
x_train<-fread("./train/X_train.txt",select=index[,1],col.names=as.character(index[,2]))
y_train<-read.table("./train/y_train.txt",col.names = c("activity"))

#Merge test and train and update activity codes with activity names
##"all"is the final merged tidy data
test<-cbind(subject_test,y_test,x_test)
train<-cbind(subject_train,y_train,x_train)
all<-rbind(test,train)
all$activity<-activity[,2][match(all$activity,activity[,1])]
write.table(all,file="all.txt",row.name=FALSE)

##Generate a second tidy data set with the average of each variable for each activity and each subject
##"all_mean" is the second final tidy data
library(dplyr)
all_mean<-group_by(all,subject,activity) %>% summarise_each(funs(mean))
write.table(all_mean,file="all_mean.txt",row.name=FALSE)
