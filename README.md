# coursera-gettingcleaningdata
Getting and Cleaning Data Course Project
=========
This project contains an analysis script that cleans and tidys the "UCI HAR Dataset" which represents data collected from the accelerometers from the Samsung Galaxy S smartphone.  A full description of this data set is given at:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The Setup section describes how to prepare to run the analysis script, and the execution section describes how to run the script.

This file and the code comments refer to the steps in the course project instructions.  These are repeated here for clarity:

1.    Merges the training and the test sets to create one data set.
2.    Extracts only the measurements on the mean and standard deviation for each measurement. 
3.    Uses descriptive activity names to name the activities in the data set
4.    Appropriately labels the data set with descriptive variable names. 
5.    From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


Setup
=========

1. Download the "UCI HAR Dataset"

     Data Set link (zip file):

     https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip      
 
2. Install the dplyr, tidyr, and reshape2 R packages if you have not.
	
     Note: You can get by without the "tidyr" package if you don't wish to install it, by commenting out the "gather" and "separate" lines from the tidy_step_5 method (and the library(tidyr) line.  This will cause the analysis to generate a wide data set instead of a tall data set.

3. Change your R working directory to the root of the extracted UCI HAR Dataset

4. Load the "run_analysis.R" script

Execution
=========

1. To run the full analysis, simply execute the full_analysis() function. full_analysis will return a tidy'd data frame:

<code>
> tidy <- full_analysis()
[1] "Found Dataset files, loading data..."
[1] "Loading labels"
[1] "Loading train data"
[1] "Read in train data: Dimensions: 7352" "Read in train data: Dimensions: 479" 
[1] "Loading labels"
[1] "Loading test data"
[1] "Read in test data: Dimensions: 2947" "Read in test data: Dimensions: 479" 
[1] "Merging training and test set"
> View(tidy)
> print(tidy)
Source: local data frame [23,760 x 5]

   SubjectID Activity          FeatureName Function Measurement
1          1  WALKING    tBodyAcc-mean()-X     mean  0.27733076
2          1  WALKING    tBodyAcc-mean()-Y     mean -0.01738382
3          1  WALKING    tBodyAcc-mean()-Z     mean -0.11114810
4          1  WALKING     tBodyAcc-std()-X     mean -0.28374026
5          1  WALKING     tBodyAcc-std()-Y     mean  0.11446134
6          1  WALKING     tBodyAcc-std()-Z     mean -0.26002790
7          1  WALKING tGravityAcc-mean()-X     mean  0.93522320
8          1  WALKING tGravityAcc-mean()-Y     mean -0.28216502
9          1  WALKING tGravityAcc-mean()-Z     mean -0.06810286
10         1  WALKING  tGravityAcc-std()-X     mean -0.97660964
..       ...      ...                  ...      ...         ...
</code>

This function also outputs the data into a text file named "tidy.UCIHARDataSet.txt" using write.table.

2. Alternatively, you can execute individual steps.  Step 0 loads all of the initial data into one large data frame.  This step also performs Steps 3 and 4 from the course project instructions (renaming the variables and substituting activity names for values)

<code>s0 <- step_0()</code>

1.  This step loads in the activity names from the data set "activity_labels.txt" file and uses those to convert the activity (y_train, y_test) columns into a factor variable (1 = WALKING, for example)

*  This step also loads in the feature names from "features.txt" and uses those as the column names

*  This step loads in both the train and test subdirectories and merges them together into one data frame, which is returned.

*  This step drops the set of columns that are duplicates.  Columns such as 303:343 are not unique.  Since these columns are not relevant for our analysis, they are simply removed here.  They would be removed in step_2 if we kept them around by renaming.

2. Step_2 selects only the columns that end in mean() or std().  This will remove variables like "angle(Y, gravityMean)".  The regular expression in step_2 can be edited, if the user desires a different meaning for which variables to keep for analysis.

3. Steps 3 and 4 from the course project description were performed in the step_0 function.

4. Step 5 is accomplished through the "tidy_step_5" method.  This summarizes the data grouped by SubjectID and Activity, and applys the functions "mean" and "sd".  This step also converts the data set into a tall data set instead of a wide data set.  If you instead want a wide data set, comment out the "gather" and "separate" likes.

5. The resulting tidy data set has one variable in each column, one observation on each row.