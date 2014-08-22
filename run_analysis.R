# DataScience- Johns Hopkins Coursera sequence
# Course--Getting and Cleaning Data
# Galaxy phone project- JCWeaver

# Clear cache and confirm working directory
rm(list=ls())
ls()
getwd()

# Load Data into R
# Human Activity Recognition Using Smartphones Dataset, V1.0
# J. Reyes-Ortiz, D. Anguito, and A. Luca
# IMPORTANT-- confirm that files are extracted from .zip folder and that the
 # folder "UCI HAR Dataset" is in the working directory
dateDownloaded<-date()

# Load test data
subject.test<- read.table("./UCI HAR Dataset/test/subject_test.txt", header=FALSE, col.names="subject")
activity.test<- read.table("./UCI HAR Dataset/test/y_test.txt", header=FALSE, col.names="activity")
X.test<- read.table("./UCI HAR Dataset/test/X_test.txt", header=FALSE)
test<- cbind(X.test, subject.test, activity.test)
# Load train data
subject.train<- read.table("subject_train.txt", header=FALSE, col.names="subject")
activity.train<- read.table("y_train.txt", header=FALSE, col.names="activity")
X.train<- read.table("X_train.txt", header=FALSE)
train<- cbind(X.train, subject.train, activity.train)

# Load the features into R as a character vector
# Remove invalid characters, and verify that names are valid with make.names
features<- read.table("features.txt", header=FALSE, colClasses="character")
featureName<-features$V2
featureNames<-tolower(featureName)
featureNames<-gsub("-", ".", featureNames)
featureNames<-gsub(",", ".", featureNames)
featureNames<-gsub("\\()", "", featureNames)
featureNames<-gsub("\\(", ".", featureNames)
featureNames<-gsub("\\)", "", featureNames)
featureValid<- make.names(featureNames, unique = TRUE, allow_ = FALSE)

# Use regular expressions to extract column variables of interest
 # (that is, the means and standard deviation measures) from valid feature names
means<- grep(".mean", featureValid, fixed=TRUE)
stds<- grep(".std", featureValid, fixed=TRUE)
# Create an indexing vector to subset columns
subsetCols<- sort(append(means,stds))
# Subset column names
colNames<-featureValid[subsetCols]   # 79 valid feature names
subsetCols<- append(subsetCols, c(562,563)) # 81 valid columns to subset
colNames<-append(colNames, c("subject","activity"))

# Requested deliverables of the R script file
# Step 1--create one dataset from both test and train datasets
dataset<- rbind(train, test)

# Step 2--subset dataset with desired columns with the measures of mean and
 # standard deviation for each measurement
 # dataset2 is a dataframe of 10299 obs. and  81 variables
dataset2<- dataset[,subsetCols]

# Step 3--make activity and subject factor variables and rename levels of
# activity to descriptive activity names using the revalue function in the
# R Package "plyr"
dataset2$activity<- as.factor(dataset2$activity)
dataset2$subject<- as.factor(dataset2$subject)
library(plyr)
dataset2$activity<-revalue(dataset2$activity, c("1"="walking", "2"="walking_upstairs", "3"="walking_downstairs", "4"="sitting", "5"="standing", "6"="laying"))

# Step 4--Rename the variable labels in dataset2 with descriptive variable names
# Write current column names (colNames) to a .csv file so that descriptive names
 # can be created in Excel
write.csv(colNames, file="colNames.csv", quote=FALSE)
# Read descriptive variable names from .csv file
colDescpNames<- read.csv("colDescpNames.csv", header=FALSE, sep=',', colClasses="character")
# Rename the variable labels in the subset dataset with descriptive varible names
names(dataset2)<- colDescpNames$V1

# Step 5-- create a tidy dataset with the average of each variable for each activity and each subject
 # datasetAvg is a dataframe of the mean of each variable for each activity, for each subject
 # datasetAvg has 180 observations and 81 variables
datasetAvg<- ddply(dataset2, .(activity,subject), numcolwise(mean))
# Write this dataframe to a text file "datasetAverages.txt" for submission to Coursera
write.table(datasetAvg, quote=FALSE, row.names=FALSE, col.names=TRUE, sep=' ',file="datasetAverages.txt")