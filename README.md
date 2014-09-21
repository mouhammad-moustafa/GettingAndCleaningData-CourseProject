GettingAndCleaningData-CourseProject
====================================

The purpose of this project is to demonstrate your ability to collect, work with, and clean data collected from the accelerometers from the Samsung Galaxy S smartphone.

The run_analysis.R script is saved in the a folder containing the following data:
CourseProject
	test
		subject_test.txt
		X_test.txt
		y_test.txt
	train
		subject_test.txt
		X_test.txt
		y_test.txt
	activity_labels.txt
	features.txt
	run_analysis.R

functions documentation is detailed at the bottom.	
	
The goal fo this project is to prepare tidy data. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. 

Data Set README file explains clearly how the experiment data has been collected:

> The experiments have been carried out with a group of **30 volunteers** within an age bracket of 19-48 years. 
Each person performed **six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)** wearing a smartphone (Samsung Galaxy S II) on the waist. 
> For each record it is provided:
======================================
- **Triaxial acceleration** from the accelerometer (total acceleration) and the estimated body acceleration.
- **Triaxial Angular velocity** from the gyroscope. 
- A **561-feature** vector with time and frequency domain variables. 
- Its **activity label**. 
- An **identifier of the subject** who carried out the experiment.

> The obtained dataset has been randomly partitioned into two sets where:
	* 70% of the volunteers was selected for generating the **training data** 
	* and 30% the **test data**.
	
The first question is:
###1. Merges the training and the test sets to create one data set. short answer: mergeData function

To answer this question let's have a deeper look at the data:

 Training data are stored in train folder with following files:
 - 'train/X_train.txt': Training experiment set.
 - 'train/y_train.txt': Training activity data. Its a range from 1 to six
 - 'train/subject_train.txt': Each row identifies the subject id who performed the activity for each window sample. Its range is from 1 to 30. 

 Test data are stored in train folder with following files:
 - 'test/X_test.txt': Test experiment set.
 - 'test/y_test.txt': Test activity data. Its a range from 1 to six
 - 'test/subject_test.txt': Each row identifies the subject id who performed the activity for each window sample. Its range is from 1 to 30. 

 First step Let's start exploring files:
 - Test and Train data have the following structure:
 -- "X", "y" and "subject" prefix files names.
 -- Different folders "train/test" and different suffix "train/test"
 
 Second step let's read files data into different data frames (R functions are document at the bottom):
	Experiment test and training data are read using **readExperimentData** into **expTestData** and **expTrainData** respectively.
	using dim we have the following results: 
		dim(expTestData)	dim(expTrainData)
		2947  	561			7352  	561
	So we can deduce that experiment columns corresponds to the 561 features. 
	**readExperimentData** funtion reads experiment data into a data frame.

	In addition activity test and training data are read into **activityTestData** and **activityTrainData** respectively:
	**readActivityData** function reads activity data into a data frame with a single column "activity_id" 
	using dim we have the following results:
		dim(activityTestData)	dim(activityTrainData)
		2947  		1		    7352  		1
		
	Finally subject test and training data are read into **subjectTestData** and **subjectTrainData**
	**readSubjectData** function reads activity data into a data frame with a single column "activity_id" 
		dim(subjectTestData)	dim(subjectTrainData)
		2947  		1		    7352  		1
		
	As we can see all test data(activity, experiment and subject) have the same number of rows(2947) as well as for train data(7352)

 Third Step is about merging test and training data:
	* **mergeActivityData** merges activity training and test data using rbind function and returns a data frame with 10299 rows and 1 column.
	* **mergeExperimentData** merges experiment training and test data using rbind function and returns a data frame with 10299 rows and 561 column.
	* **mergeSubjectData** merges subject training and test data using rbind and returns a data frame with 10299 rows and 1 column.
	
 Finally In the absence of linking Id between activity, experiment and subject data, we assume it must be the implicit order of row numbers, 
 it is basically the only way everything fits together:
	**mergeData** functions merges experiment, activity and subject data using cbind function applied to merged experiment, activity and subject data. 
				  this function returns one data set that merges the training and the test sets.


The second question is:
###2. Extracts only the measurements on the mean and standard deviation for each measurement. short answer: **extractMeanAndStd** function
	Mean and standard deviation are estimated from the following signals:
	
	tBodyAcc-XYZ 		(3 different signals X, Y, Z)  		the feature names are tBodyAcc-mean()-X(Y, Z), tBodyAcc-std()-X(Y, Z)
	tGravityAcc-XYZ		(3 different signals X, Y, Z)		the feature names are tGravityAcc-mean()-X(Y, Z), tGravityAcc-std()-X(Y, Z)
	tBodyAccJerk-XYZ	(3 different signals X, Y, Z)		the feature names are tBodyAccJerk-mean()-X(Y, Z), tBodyAccJerk-std()-X(Y, Z)
	tBodyGyro-XYZ		(3 different signals X, Y, Z)		the feature names are tBodyGyro-mean()-X(Y, Z), tBodyGyro-std()-X(Y, Z)
	tBodyGyroJerk-XYZ	(3 different signals X, Y, Z)		the feature names are tBodyGyroJerk-mean()-X(Y, Z), tBodyGyroJerk-std()-X(Y, Z)
	tBodyAccMag												the feature names are tBodyAccMag-mean(), tBodyAccMag-std()
	tGravityAccMag											the feature names are tGravityAccMag-mean(), tGravityAccMag-std()
	tBodyAccJerkMag											the feature names are tBodyAccJerkMag-mean(), tBodyAccJerkMag-std()
	tBodyGyroMag											the feature names are tBodyGyroMag-mean(), tBodyGyroMag-std()
	tBodyGyroJerkMag										the feature names are tBodyGyroJerkMag-mean(), tBodyGyroJerkMag-std()
	fBodyAcc-XYZ		(3 different signals X, Y, Z)		the feature names are fBodyAcc-mean()-X(Y, Z), fBodyAcc-std()-X(Y, Z)
	fBodyAccJerk-XYZ	(3 different signals X, Y, Z)		the feature names are fBodyAccJerk-mean()-X(Y, Z), fBodyAccJerk-std()-X(Y, Z)
	fBodyGyro-XYZ		(3 different signals X, Y, Z)		the feature names are fBodyGyro-mean()-X(Y, Z), fBodyGyro-std()-X(Y, Z)
	fBodyAccMag												the feature names are fBodyAccMag-mean(), fBodyAccMag-std()
	fBodyAccJerkMag											the feature names are fBodyAccJerkMag-mean(), fBodyAccJerkMag-std()
	fBodyGyroMag											the feature names are fBodyGyroMag-mean(), fBodyGyroMag-std()
	fBodyGyroJerkMag										the feature names are fBodyGyroJerkMag-mean(), fBodyGyroJerkMag-std()

	to answer this quaestion according to previous rationale we will extract all features where feature name contains "mean()" or "std()" (66 measurments).
	**grep** function applied to feature labels returns features index.
	Assuming column indexes are the same for features and expermient data frame (561 columns), then grep result can be used to subset experiment data.
	
	**extractMeanAndStd** function applied to merged data set returns a data frame with 10299 rows and 68 columns.

The third question is:
###3. Uses descriptive activity names to name the activities in the data set. short answer: **fillActivityLabel** function
	Activity labels can be read from activity_labels.txt file using readActivityLabels functions. Then **fillActivityLabel** adds new column "activity_label"
	to data set then removes "activity_id".
	
The fourth question is:
###4. Appropriately labels the data set with descriptive variable names. short answer: **setVariableNames**
	data set is composed of std and mean variables extracted from features along with "activity_label" and "subject_id".
	features names can be used after replacing non alphanumeric by '_' using gsub.

### Documentation
		
 - readActivityData:
 -- Description
	Reads Activity data stored in "y" file in table format and creates a data frame from it, with activities corresponding to lines and a single column "activity_id" 
 -- Usage
	readActivityData(test = TRUE)
 -- Arguments
	test			logical. if TRUE then "test" activity data will be read and returned as data frame.
							 else "training" activity data will be read and returned as data frame.
 -- Detail
    This function reads activity data stored in "y" files using read.table() with the following paramater:
		* file=dataPath("y", test): builds file path according to "test" argument:
		* stringsAsFactors = FALSE
		* col.names = "activity_id"
 -- Value
	A single column "activity_id" data frame containing activity data.
	
 -- Examples
	readActivityData(): Reads test activity data.
	readActivityData(test = FALSE): Reads training activity data.
	
 - readExperimentData:
 -- Description
	Reads Experiments data stored in "X" file in table format and creates a data frame from it, with experiments corresponding to lines and 561 columns representing the features.
 
 -- Usage
	readExperimentData(test = TRUE)
 
 -- Arguments
	test			logical. if TRUE then "test" experiment data will be read and returned as data frame.
							 else "training" experiment data will be read and returned as data frame.
 -- Detail
    This function reads experiment data stored in "X" files using read.table() with the following paramater:
		* file=dataPath("X", test): builds file path according to "test" argument:
		* stringsAsFactors = FALSE
 -- Value
	A data frame containing Experiment data as rows and 561 columns.
	
 -- Examples
	readExperimentData(): Reads test Experiment data.
	readExperimentData(test = FALSE): Reads training Experiment data.

- dataPath:
 -- Description:
	builds file path according to test argument.
	
 -- Usage
	dataPath(fileName, test).
	
 -- Arguments
    fileName: character.The file name prefix(ex: "X", "y", "subject").
    test: logical. if TRUE then file path is built from test folder with "_test" as suffix. "./test/" + fileName + "_test.txt"
					else file path is built from training folder with "_train" as suffix. "./train/" + fileName + "_train.txt"
					
 -- Value
	The file path.
	
 -- Examples
	dataPath("y", test = TRUE): builds the test activity data file path: "./test/y_test.txt"
	dataPath("X", test = FALSE): builds the training data set file path as: "./train/X_train.txt"
	
 	
	
 - readActivityLabels:
 -- Description
	Reads activity ids and Labels as dataframe with two columns "activity_id" and "activity_label" from 
 
 -- Usage
	readActivityLabels()
 
 -- Detail
    This function reads from activity_labels.txt file using read.table() with the following paramater:
		* file="activity_labels.txt":
		* stringsAsFactors = FALSE
		* col.names = col.names = c("activity_id", "activity_label")
 -- Value
	A data frame with two columns:
	   activity_id     activity_label
           1            WALKING
           2   			WALKING_UPSTAIRS
           3 			WALKING_DOWNSTAIRS
           4            SITTING
           5           	STANDING
           6            LAYING

- readFeatures:
 -- Description
	Reads features ids and Labels as dataframe with two columns "feature_id" and "feature_label" from features.txt file.
 
 -- Usage
	readFeatures()
 
 -- Detail
    This function reads from features.txt file using read.table() with the following paramater:
		* file="features.txt":
		* stringsAsFactors = FALSE
		* col.names = col.names = c("feature_id", "feature_label")
 -- Value
	A data frame with two columns "feature_id" and feature_label
           
 -- Examples:
	features <- readFeatures()
	head(features, 5)
		feature_id     	feature_label
	1          1 	  tBodyAcc-mean()-X
	2          2 	  tBodyAcc-mean()-Y
	3          3      tBodyAcc-mean()-Z
	4          4      tBodyAcc-std()-X
	5          5      tBodyAcc-std()-Y
	
- readSubjectData:
 -- Description
	Reads Subject data stored in "subject" file in table format and creates a data frame from it, with a single column "subject_id" 
 -- Usage
	readSubjectData(test = TRUE)
 -- Arguments
	test			logical. if TRUE then subject "test" data will be read and returned as data frame.
							 else subject "training" data will be read and returned as data frame.
 -- Detail
    This function reads subject data stored in "subject" files using read.table() with the following paramater:
		* file=dataPath("subject", test): builds file path according to "test" argument:
		* stringsAsFactors = FALSE
		* col.names = "subject_id"
 -- Value
	A single column "subject_id" data frame containing subject data. Its range is from 1 to 30.
	
 -- Examples
	readSubjectData(): Reads test subject data.
	readSubjectData(test = FALSE): Reads training subject data.
