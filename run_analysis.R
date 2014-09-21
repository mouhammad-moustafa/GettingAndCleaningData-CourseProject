##Description:
##    builds file path according to test argument.

## Usage
## dataPath(fileName, test).

## Arguments
## fileName: character.The file name prefix(ex: "X", "y", "subject").
## test: logical. if TRUE then file path is built from test folder with "_test" as suffix. "./test/" + fileName + "_test.txt"
## else file path is built from training folder with "_train" as suffix. "./train/" + fileName + "_train.txt"

## Value
## The file path.

## -- Examples
## dataPath("y", test = TRUE): builds the test activity data file path: "./test/y_test.txt"
## dataPath("X", test = FALSE): builds the training data set file path as: "./train/X_train.txt"
dataPath <- function(fileName, test){
        
        if (test == TRUE){
                completeFileName <- paste(fileName, "test.txt", sep = "_")
                path <- paste("./test/", completeFileName, sep = "")
        }else{
                completeFileName <- paste(fileName, "train.txt", sep = "_")
                path <- paste("./train/", completeFileName, sep = "")
        }
        path
}

# -- Description
# Reads Experiments data stored in "X" file in table format and creates a data frame from it, with experiments corresponding to lines and 561 columns representing the features.
# 
# -- Usage
# readExperimentData(test = TRUE)
# 
# -- Arguments
# test			logical. if TRUE then "test" experiment data will be read and returned as data frame.
# else "training" experiment data will be read and returned as data frame.
# -- Detail
# This function reads experiment data stored in "X" files using read.table() with the following paramater:
#         * file=dataPath("X", test): builds file path according to "test" argument:
#         * stringsAsFactors = FALSE
# -- Value
# A data frame containing Experiment data as rows and 561 columns.
# 
# -- Examples
# readExperimentData(): Reads test Experiment data.
# readExperimentData(test = FALSE): Reads training Experiment data.

readExperimentData <- function(test = TRUE){
        res = read.table(file=dataPath("X", test), 
                       stringsAsFactors = FALSE)
        res
}

# -- Description
# Reads Activity data stored in "y" file in table format and creates a data frame from it, with activities corresponding to lines and a single column "activity_id" 
# -- Usage
# readActivityData(test = TRUE)
# -- Arguments
# test			logical. if TRUE then "test" activity data will be read and returned as data frame.
# else "training" activity data will be read and returned as data frame.
# -- Detail
# This function reads activity data stored in "y" files using read.table() with the following paramater:
#         * file=dataPath("y", test): builds file path according to "test" argument:
#         * stringsAsFactors = FALSE
# * col.names = "activity_id"
# -- Value
# A single column "activity_id" data frame containing activity data.
# 
# -- Examples
# readActivityData(): Reads test activity data.
# readActivityData(test = FALSE): Reads training activity data.
readActivityData <- function(test = TRUE){
        ydata = read.table(file=dataPath("y", test), 
                       stringsAsFactors = FALSE, col.names = "activity_id")
}

# -- Description
# Add Activity Label to data set calculated from activity_id and activity_labels data.
# -- Usage
# fillActivityLabel(data)
# -- Arguments
# data        		data.frame. the data set
# -- Detail
# This function reads activity labels stored in "activity_labels.txt" files using readActivityLabels 
# Then fills activity_label variable using activity_labels and activity_id
# -- Value
# the data set with activity_label column while removing activity_id.
# 
# -- Examples
# data <- answer2() 
# fillActivityLabel(data): activity_label is added to data
fillActivityLabel <- function(data){
        ## read activity labels
        activityLabels <- readActivityLabels()
        ## add activity_label to data computed from activity_id by extract the correspoding value from activityLabels  
        data$activity_label <- sapply(data$activity_id, FUN = function(x) activityLabels$activity_label[x])
        ## remove activity_id column
        res <- subset(data, select = -c(activity_id))
        res
}

# -- Description
# Reads Subject data stored in "subject" file in table format and creates a data frame from it, with a single column "subject_id" 
# -- Usage
# readSubjectData(test = TRUE)
# -- Arguments
# test			logical. if TRUE then subject "test" data will be read and returned as data frame.
# else subject "training" data will be read and returned as data frame.
# -- Detail
# This function reads subject data stored in "subject" files using read.table() with the following paramater:
#         * file=dataPath("subject", test): builds file path according to "test" argument:
#         * stringsAsFactors = FALSE
# * col.names = "subject_id"
# -- Value
# A single column "subject_id" data frame containing subject data. Its range is from 1 to 30.
# 
# -- Examples
# readSubjectData(): Reads test subject data.
# readSubjectData(test = FALSE): Reads training subject data.
readSubjectData <- function(test = TRUE){
        res = read.table(file=dataPath("subject", test), 
                       stringsAsFactors = FALSE, col.names = c("subject_id"))
        res
}

# -- Description
# Reads features ids and Labels as dataframe with two columns "feature_id" and "feature_label" from features.txt file.
# 
# -- Usage
# readFeatures()
# 
# -- Detail
# This function reads from features.txt file using read.table() with the following paramater:
#         * file="features.txt":
#         * stringsAsFactors = FALSE
# * col.names = col.names = c("feature_id", "feature_label")
# -- Value
# A data frame with two columns "feature_id" and feature_label
# 
# -- Examples:
#         features <- readFeatures()
# head(features, 5)
# feature_id     	feature_label
# 1          1 	  tBodyAcc-mean()-X
# 2          2 	  tBodyAcc-mean()-Y
# 3          3      tBodyAcc-mean()-Z
# 4          4      tBodyAcc-std()-X
# 5          5      tBodyAcc-std()-Y
readFeatures <- function(){
        features <- read.table("features.txt", stringsAsFactors = FALSE, col.names = c("feature_id", "feature_label"))
        features
}

# -- Description
# Reads activity ids and Labels as dataframe with two columns "activity_id" and "activity_label" from 
# 
# -- Usage
# readActivityLabels()
# 
# -- Detail
# This function reads from activity_labels.txt file using read.table() with the following paramater:
#         * file="activity_labels.txt":
#         * stringsAsFactors = FALSE
# * col.names = col.names = c("activity_id", "activity_label")
# -- Value
# A data frame with two columns:
# activity_id     activity_label
#  1                    WALKING
#  2   			WALKING_UPSTAIRS
#  3 			WALKING_DOWNSTAIRS
#  4                    SITTING
#  5           	        STANDING
#  6                    LAYING
readActivityLabels <- function(){
        labels <- read.table("activity_labels.txt", stringsAsFactors = FALSE, col.names = c("activity_id", "activity_label"))
        labels
}

# reads test and training acitivity data and merges them using rbind 
mergeActivityData <- function(){
        testdata <- readActivityData(TRUE)
        trainingdata <- readActivityData(FALSE)
        data <- rbind(trainingdata, testdata)
        data
}

# reads test and training Experiment data and merges them using rbind 
mergeExperimentData <- function(){
        testdata <- readExperimentData(TRUE)
        trainingdata <- readExperimentData(FALSE)
        data <- rbind(trainingdata, testdata)
        data
}

# reads test andd training Subject data and merges them using rbind 
mergeSubjectData <- function(){
        testdata <- readSubjectData(TRUE)
        trainingdata <- readSubjectData(FALSE)
        data <- rbind(trainingdata, testdata)
        data
}

# merge experiment, activity and Subject data using cbind. 
mergeData <- function(){
        activitydata <- mergeActivityData()
        subjectdata <- mergeSubjectData()
        experimentdata <- mergeExperimentData()
        data <- cbind(experimentdata, activitydata, subjectdata)
        data
}

# extracts mean and std feature Indices from features using grep 
extractMeanAndStdFeatures <- function(){
        features <- readFeatures()
        meanIndices <- grep("mean\\(\\)", features$feature_label)
        stdIndices <- grep("std\\(\\)", features$feature_label)
        ## concat mean, std, indices 
        extractIndices = c(meanIndices, stdIndices)
        ## sort Indices
        sort(extractIndices)
        extractIndices
}

# extrcats mean and std variables from data set along with activity_id andd subject_id 
extractMeanAndStd <- function(data){
        ## concat mean, std, activity and subject column indices 
        extractIndices = c(extractMeanAndStdFeatures(), 562, 563)
        data[, extractIndices]
}

# sets the data set column names extracted from features by replacing nonalphanumeric charcters by '_'
setVariableNames <- function(data){
        featureIndices <- extractMeanAndStdFeatures()
        featureLabels <- readFeatures()
        ## extract feature labels correspoding to std and mean
        labels <- featureLabels[featureIndices, 2]
        ## replace non aplhanumeric characters by '_'
        
        names <- c(gsub("[^[:alnum:] ]", "_", labels), "activity_label", "subject_id")
        colnames(data) <- names
        data
}

# returns the data set as expected by question1
answer1 <- function(){
        mergeData()
}

# calls answer1 then extracts mean and std variables
answer2 <- function(){
        data <- answer1()
        data <- extractMeanAndStd(data)
        data
}

#calls answer2 then fills activity labels
answer3 <- function(){
        data <- answer2()
        fillActivityLabel(data)
        data
}

#calls answer3 then sets variable names
answer4 <- function(){
        data <- answer3()
        data <- setVariableNames(data)
        data
}

# calls answer4 then creates a second, independent tidy data set with the average of each variable for each activity and each subject.
answer5 <- function(){
        data <- answer4()
        res <- aggregate(data, by=list(activity_gp=data$activity_label, subject_gp=data$subject_id), FUN = mean)
        res
}

