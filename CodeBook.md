Code Book for the tidy data set produced by run_analysis.R
========

1. Subject ID
-------------

   Integer from 1:30 indicating the Id of the subject which this observation is for

2. Activity
-------------

   Factor variable with levels determined by the "activity_labels.txt" file in the data set.  Current values are:
   1. WALKING
   2. WALKING_UPSTAIRS
   3. WALKING_DOWNSTAIRS
   4. SITTING
   5. STANDING
   6. LAYING

3. FeatureName
---------------

   Factor variable defining the feature this observation summarizes.  The feature names are defined in the UCI HAR Dataset's "features.txt" file and "features_info.txt" files.  Only features that end in mean() or std() are included.

4. Function
----------------
   
   Factor variable defining which aggergation function this observation is for.

   1. mean
   2. sd   (standard deviation)

5. Measurement
-----------------

   Floating point number, this is the measurement applying the aggregation function in the Function column to all the measurements of the variable in the FeatureName column for all data points from the SubjectID on the Activity (given in those respective columns).