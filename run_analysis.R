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
