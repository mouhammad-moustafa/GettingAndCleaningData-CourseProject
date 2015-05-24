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

each answer function uses the previous answer results and applies the transformation requested in the corresponding question.

- answer1 function returns the data set as requested by question1.
- answer2 function returns the data set as requested by question2.
- answer3 function returns the data set as requested by question3.
- answer4 function returns the data set as requested by question4.
- answer5 function returns the data set as requested by question5.
	
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

1.1 To answer this question let's have a deeper look at the data:

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
 
1.2 Second step let's read files data into different data frames (R functions are document at the bottom):
	Experiment test and training data are read and merged using **mergeExperimentData** into **expData**.
	using dim we have the following results: 
		dim(expData)
		10299  	561
	So we can deduce that experiment columns corresponds to the 561 features. 
	**mergeExperimentData** funtion merges experiment data into a data frame.

	In addition activity test and training data are read and merged into **activityData**:
	**mergeActivityData** function reads activity data into a data frame with a single column "activity_id" 
	using dim we have the following results:
		dim(activityData)
		10299  		1	
		
	Finally subject test and training data are read and merged into **subjectData**
	**mergeSubjectData** function reads and merges activity data into a data frame with a single column "activity_id" 
		dim(subjectData)
		10299  		1
		
	As we can see all data(activity, experiment and subject) have the same number of rows(10299)


1.4 Finally In the absence of linking Id between activity, experiment and subject data, we assume it must be the implicit order of row numbers, 
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

 To answer this question according to previous rationale we will extract all features where feature name contains "mean()" or "std()" (66 measurments).
 **grep** function applied to feature labels returns features index.
 Assuming column indexes are the same for features and expermient data frame (561 columns), then grep result can be used to subset experiment data.
 **extractMeanAndStd** function applied to merged data set returns a data frame with 10299 rows and 68 columns.

The third question is:
###3. Uses descriptive activity names to name the activities in the data set. short answer: **answer3** function
	Activity labels can be read from activity_labels.txt file using readActivityLabels functions. Then add new column "activity_label"
	to data set then removes "activity_id".
	
The fourth question is:
###4. Appropriately labels the data set with descriptive variable names. short answer: **answer4**
	data set is composed of std and mean variables extracted from features along with "activitylabel" and "subjectid".
	Names of variables should be:
	All Lower case when possible
	Not have underscores or dots or white spaces
	features names can be used after replacing removing alphanumeric using gsub.
	
the fith question is:
###5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
	the Acc and Gyro are the first measure
	't' and 'f' values could be values of Domain variable
	X, Y and Z could be values of Axis variable

	Compute the average of each variable for each activity and each subject using group_by and summarize_each from dplyr library.
	the final result set contains 180 rows (6 activities * 30 subjects).

