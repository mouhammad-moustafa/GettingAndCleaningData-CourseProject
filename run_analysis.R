## This Code answers the following question:
##1. Merges the training and the test sets to create one data set.
answer1 <- function(){
        activitydata <- mergeActivityData()
        subjectdata <- mergeSubjectData()
        experimentdata <- mergeExperimentData()
        data <- cbind(experimentdata, activitydata, subjectdata)
        data
}

## This Code answers the following question:
## Extracts only the measurements on the mean and standard deviation for each measurement. 
answer2 <- function(){
        data <- answer1()
        ## concat mean, std, activity and subject column indices
        extractIndices = c(extractMeanAndStdFeatures(), 562, 563)
        data <- data[, extractIndices]
        data
}

## This Code answers the following question:
## Uses descriptive activity names to name the activities in the data set
answer3 <- function(){
        data <- answer2()
        ## read features as a data frame with two columns activity Id and activity Label
        # activity_id     activity_label
        #  1                    WALKING
        #  2           		WALKING_UPSTAIRS
        #  3 			WALKING_DOWNSTAIRS
        #  4                    SITTING
        #  5           	        STANDING
        #  6                    LAYING
        activityLabels <- read.table("activity_labels.txt", stringsAsFactors = FALSE, col.names = c("activity_id", "activity_label"))
        
        ## add activity_label to data computed from activity_id by extract the correspoding value from activityLabels
        data <- merge(x = data, y = activityLabels, by.x = "activity_id", by.y = "activity_id")
        ## remove activity_id column
        data <- subset(data, select = -c(activity_id))
        data
}

## This Code answers the following question:
## Appropriately labels the data set with descriptive variable names. 
answer4 <- function(){
        data <- answer3()
        featureIndices <- extractMeanAndStdFeatures()
        featureLabels <- readFeatures()
        ## extract feature labels correspoding to std and mean
        labels <- featureLabels[featureIndices, 2]
        
        ## Names of variables should be:
        ### All Lower case when possible
        labels <- tolower(labels)
        
        ##Not have underscores or dots or white spaces
        ## remove non aplhanumeric characters
        names <- c(gsub("[^[:alnum:] ]", "", labels), "activitylabel", "subjectid")
        colnames(data) <- names
        data
}

## This Code answers the following question:
## From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(dplyr)
answer5 <- function(){
        data <- answer4()
        ## Compute the average of each variable for each activity and each subject using group_by and summarize_each from dplyr library.
        data <- data %>%
                group_by(activitylabel, subjectid) %>%
                summarise_each(funs(mean))
        write.table(data, file = "finaldata.txt", row.names = FALSE)
        data
}

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
# feature_id             feature_label
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
# Reads Activity data from "test" and "train" folders stored in "y" file in table format and creates a data frame from it, 
# with activities corresponding to lines and a single column "activity_id" 
# -- Usage
# mergeActivityData()

# -- Detail
# This function reads activity data stored in "y" files using read.table() with the following paramater:
#         * file=dataPath("y", test): builds file path according to "test" argument:
#         * stringsAsFactors = FALSE
# * col.names = "activity_id"
# -- Value
# A single column "activity_id" data frame containing activity data.
# 
mergeActivityData <- function(){
        ## reads y data from test folder
        testdata <- read.table(file=dataPath("y", TRUE), 
                               stringsAsFactors = FALSE, col.names = "activity_id")
        ## reads y data from train folder
        trainingdata <- read.table(file=dataPath("y", FALSE), 
                                   stringsAsFactors = FALSE, col.names = "activity_id")
        ## merge training and test data using rbind
        data <- rbind(trainingdata, testdata)
        data
}

# -- Description
# Reads Experiments from "test" and "train" data stored in "X" file in table format and creates a data frame from it, 
## with experiments corresponding to lines and 561 columns representing the features.
# 
# -- Usage
# mergeExperimentData()
# 
# -- Detail
# This function reads experiment data stored in "X" files using read.table() with the following paramater:
#         * file=dataPath("X", test): builds file path according to "test" argument:
#         * stringsAsFactors = FALSE
# -- Value
# A data frame containing Experiment data as rows and 561 columns.
#
mergeExperimentData <- function(){
        ##reads X data from test folder
        testdata <- read.table(file=dataPath("X", TRUE), 
                               stringsAsFactors = FALSE)
        ## reads X data from train folder
        trainingdata <- read.table(file=dataPath("X", FALSE), 
                                   stringsAsFactors = FALSE)
        ## merges training and test data using rbind
        data <- rbind(trainingdata, testdata)
        data
}

# -- Description
# Reads Subject data stored in "subject" file in table format and creates a data frame from it, with a single column "subject_id" 
# -- Usage
# mergeSubjectData()
# -- Detail
# This function reads subject data stored in "subject" files using read.table() with the following paramater:
#         * file=dataPath("subject", test): builds file path according to "test" argument:
#         * stringsAsFactors = FALSE
# * col.names = "subject_id"
# -- Value
# A single column "subject_id" data frame containing subject data. Its range is from 1 to 30.
#
mergeSubjectData <- function(){
        # reads subject data from test folder 
        testdata <- read.table(file=dataPath("subject", TRUE), 
                               stringsAsFactors = FALSE, col.names = "subject_id")
        ## reads subject data from train folder
        trainingdata <- read.table(file=dataPath("subject", FALSE), 
                                   stringsAsFactors = FALSE, col.names = "subject_id")
        ## merges subject data using rbind
        data <- rbind(trainingdata, testdata)
        data
}

## extracts the mean and standard deviation from 
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

