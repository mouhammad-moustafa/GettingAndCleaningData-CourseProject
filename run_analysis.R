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

readExperimentData <- function(test = TRUE){
        res = read.table(file=dataPath("X", test), 
                       stringsAsFactors = FALSE)
        res
}

readActivityData <- function(test = TRUE){
        ydata = read.table(file=dataPath("y", test), 
                       stringsAsFactors = FALSE, col.names = "activity_id")
}

fillActivityLabel <- function(data){
        ## read activity labels
        activityLabels <- readActivityLabels()
        ## add activity_label to data computed from activity_id by extract the correspoding value from activityLabels  
        data$activity_label <- sapply(data$activity_id, FUN = function(x) activityLabels$activity_label[x])
        ## remove activity_id column
        res <- subset(data, select = -c(activity_id))
        res
}

readSubjectData <- function(test = TRUE){
        res = read.table(file=dataPath("subject", test), 
                       stringsAsFactors = FALSE, col.names = c("subject_id"))
        res
}

## read features as a data frame with two columns feature Id and feature Label
readFeatures <- function(){
        features <- read.table("features.txt", stringsAsFactors = FALSE, col.names = c("feature_id", "feature_label"))
        features
}

## read features as a data frame with two columns activity Id and activity Label
readActivityLabels <- function(){
        labels <- read.table("activity_labels.txt", stringsAsFactors = FALSE, col.names = c("activity_id", "activity_label"))
        labels
}

mergeActivityData <- function(){
        testdata <- readActivityData(TRUE)
        trainingdata <- readActivityData(FALSE)
        data <- rbind(trainingdata, testdata)
        data
}

mergeExperimentData <- function(){
        testdata <- readExperimentData(TRUE)
        trainingdata <- readExperimentData(FALSE)
        data <- rbind(trainingdata, testdata)
        data
}

mergeSubjectData <- function(){
        testdata <- readSubjectData(TRUE)
        trainingdata <- readSubjectData(FALSE)
        data <- rbind(trainingdata, testdata)
        data
}


mergeData <- function(){
        activitydata <- mergeActivityData()
        subjectdata <- mergeSubjectData()
        experimentdata <- mergeExperimentData()
        data <- cbind(experimentdata, activitydata, subjectdata)
        data
}

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

extractMeanAndStd <- function(data){
        ## concat mean, std, activity and subject column indices 
        extractIndices = c(extractMeanAndStdFeatures(), 562, 563)
        data[, extractIndices]
}

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

answer1 <- function(){
        mergeData()
}

answer2 <- function(){
        data <- answer1()
        data <- extractMeanAndStd(data)
        data
}

answer3 <- function(){
        data <- answer2()
        fillActivityLabel(data)
        data
}

answer4 <- function(){
        data <- answer3()
        data <- setVariableNames(data)
        data
}