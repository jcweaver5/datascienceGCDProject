datascienceGCDProject
=====================

Johns Hopkins DataScience course "Geting and Cleaning Data" project-- Samsung Galaxy S smartphone data

## Johns Hopkins DataScience Sequence
### Course:  Getting and Cleaning Data
### Course Project:  Collect, work with and clean a dataset
### Dataset:  Human Activity Recognition Using Smartphones Dataset
#### Jorge Reyes-Ortiz et al., Smartlab-Non Linear Complex Systems Laboratory,
#### DITTEN- Universita degli Studi di Genova
#### Data url  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

#### Summary of Dataset
Reyes-Ortiz et al. carried out experiments with a group of 30 volunteers, ages 19-48 years. Each person performed six activities:  walking, walking_upstairs, walking_downstairs, sitting, standing, and laying while wearing a Samsung Galaxy SII smartphone on the waist. Using the phone's embedded accelerometer and gyroscope, 3-axial linear acceleration measurements and 3-axial angular velocity measurements at a constant rate of 50Hz were obtained.  The data were randomly partitioned into two sets, a training set with 21 volunteers and a test set with 9 volunteers.

The signals from each sensor (accelerometer or gyroscope) were sampled in a fixed-width sliding window.  The accelerometer signals were separated into two components, a low frequency gravitational component and a higher frequency body component.  The body linear acceleration and angular velocity were derived in time to obtain Jerk signals, and the magnitude of these signals was calculated using the Euclidean norm.  Further, a Fast Fourier Transform was applied to some of these signals.

These signals were then used to estimate variables of the feature vector for each pattern.  The combination of signals from the two sensors (accelerometer and gyroscope), separated into high and low frequency components (body and gravity), measured in the time or frequency domain (t of f) , in three axial directions (X, Y, Z), together with summary statistics such as mean and standard deviation results in a 561 feature vector.  That is, a vector of 561 variables for each person performing each activity.  Each feature value is normalized and bounded within [-1,1].

#### Reading the data into R
The dataset is downloaded from the website as a zip file.  After extraction, the files are located in a folder called “UCI HAR Dataset.”  This folder contains the test and training data as well as subject and activity labels in subfolders called test and train, and a “features” text file containing all 561 variable names.  These files MUST BE placed in R’s working directory.  The files are then read into R using the read.table() function.  Test and Train data frames are then created by column binding the data with the subject and activity labels.

#### Cleaning the “features” variable names data
The variable names given to the features by Reyes-Ortiz et al. contain invalid characters for R variable names.  These invalid characters are removed using the gsub() function.  The make.names() function is then used to create a valid and unique set of variable names for the 561 features.

#### Using regular expressions to extract column variables of interest
The Project Assignment requests that only measurements of the mean and standard deviation of the features be further analyzed.  Thus, only a subset of the 561 features is required.  Regular expressions for “.mean” and “.std” via the grep() function are used to create an index vector from the variable names vector so that this sub-setting can be accomplished.  The index vector is used both to subset the dataset and to subset the variable names vector that will subsequently be used for the column names of the dataset.  After sub-setting, the data set contains 79 features representing only the mean and standard deviation measures of the collected features.  Please note that the features obtained by averaging the signals in a signal sample window on the angle variable (columns 555 through 561 in the original dataset) are NOT included in the subset.

#### The five requested deliverables in the project assignment
Step 1:  The train and test datasets are combined into a single data set by row binding the two data frames.

Step 2:  Extract only the measurements on the mean and standard deviation from the feature set
The desired data subset is obtained by sub-setting the combined dataset using the index vector created from the variable names vector.

Step 3:  Use descriptive activity names to name the activities in the dataset
The activity variable is made into a factor variable.  Then, using the revalue() function from the “plyr” package, the activity factor levels are renamed as,
c("1"="walking", "2"="walking_upstairs", "3"="walking_downstairs", "4"="sitting", "5"="standing", "6"="laying")

Step 4:  Use descriptive variable names for the columns of the subset dataset
There are 79 “features” in the subset dataset that must be given descriptive names.  This is best done in a text editor like Excel.  Thus, these 79 column names are written to a .csv file, modified in Excel to be more descriptive, and then read back into R to be used as the variable name labels in the subset dataset.
Note that these 79 feature variables are very complex; each represents a condition with many different factors—acceleration versus angular velocity, time domain versus frequency domain, body versus gravity acceleration etc.  Being both descriptive and accurate in a variable name that is not excessively long is very difficult.  Thus, these descriptive variable names should not be considered as precise representations of the feature variable and its conditions.

Step 5:  Create a tidy dataset with the average of each feature variable for each activity and for each subject
This calculation is done with the ddply() function from the “plyr” package.  The function numcolwise(mean) from this package is used to calculate the average for each numeric variable in the dataset, and this is done for each individual within each activity.  The resulting “tidy dataset” has 180 observations (30 subjects by 6 activities), and 81 columns, 79 of which are the “feature” variables for the mean or standard deviation of the measurements.  Each entry in the dataset is thus an average of the mean or standard deviation of the feature.  The tidy dataset is written to a text file by the write.table() function.
