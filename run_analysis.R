## 1. Combine data set
## Download six files containting train and test data (3 for each)

## Go to train data folder, get its three files
setwd("~/R/UCI HAR Dataset/train")
activitylabels_train <- read.table("y_train.txt")
data_train <- read.table("X_train.txt")
subject_train<-read.table("subject_train.txt")

## Go to test data folder, get its three files
setwd("~/R/UCI HAR Dataset/test")
activitylabels_test <- read.table("y_test.txt")
data_test <- read.table("X_test.txt")
subject_test <- read.table("subject_test.txt")

## For train and test, combine subject label, data and activity label.
## Because first column is always called "V1" and we don't want to end up
## with multiple columns of the same name, change some column names first.
colnames(activitylabels_train) <- "ACTIVITY"
colnames(activitylabels_test) <- "ACTIVITY"
colnames(subject_train) <- "SUBJECT"
colnames(subject_test) <- "SUBJECT"
train <- cbind(subject_train,activitylabels_train,data_train)
test <- cbind(subject_test,activitylabels_test,data_test)

## Combine train and test sets
combined_data <- rbind(train, test)

## 2. Get mean and sd data for each measurement. Download features.txt,
## which links current column name (V1, V2 etc) to a descriptive name.
setwd("~/R/UCI HAR Dataset")
columns<-read.table("features.txt")
columns[,2]<-as.character(columns[,2])

## Column 1 contains the column number. Shift it by two, because
## our data set has two extra sets in the front (subject, activity)
columns[,1]<-columns[,1]+2

## Do partial matching to find all columns with mean and std
means<-grep("mean",columns[,2])
stds<-grep("std",columns[,2])
col_index<-sort(c(means,stds))

## the indexes we want are in the first column of col_index.
## To filter, take all rows of combined_data but only specified columns
filtered_data <- combined_data[,c(1,2,columns[col_index,1])]


## 3. specify names of activities. These are given in activity_list.txt
## Because there are only six, I will type them by hand instead of 
## reading in the txt file. Replace integer with corresponding word
## in activity list.
activity_list <- c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS",
                   "SITTING","STANDING","LAYING")
filtered_data$ACTIVITY <- activity_list[filtered_data$ACTIVITY]

## 4. label data set with variable names. Take these from features.txt
## as in part 2. Columns 1 and 2 were already named in part 1. 
colnames(filtered_data)[3:81] <- columns[col_index,2]

## 5. Make new dataset with averages by subject and activity.
## Use the melt-cast procedure.4

library(reshape2)
library(dplyr)
new_set <- filtered_data ## make a copy of our filtered data

## Melt: produce a very very long data frame with 4 columns: subject, activity,
## variable name, variable value. 
new_set_melted <- melt(new_set,id=c("SUBJECT","ACTIVITY"))

## Cast: calculate the mean of each subject-activity combination
new_set_casted <- dcast(new_set_melted,SUBJECT+ACTIVITY ~ variable, mean)
final_set <- new_set_casted

## Write to file
write.table(final_set,file="tidy_data.txt",row.names=FALSE,col.names=TRUE)


