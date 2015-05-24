# Step 0: Load in all the data
#  Assumptions: The UCI HAR Dataset is in the working directory, NOT under a "UCI HAR Dataset" subdirectory
#  Requires packages: dplyr, reshape2, tidyr
library(dplyr)
library(reshape2)
library(tidyr)

# Note: step_0 also does step 3 and 4
step_0 <- function() {
  # Make sure the current working directory is correct
  if (!file.exists("train/subject_train.txt")) {
    if (file.exists("UCI HAR Dataset")) {
       print("Your current working directory should be down one level, in the UCI HAR Dataset root")
       return(FALSE);
    } else {
       print("Download the UCI HAR Dataset first and change your current working directory to its root.")
       # Could download it automatically here and unzip, TODO for later
       return(FALSE);
    }
  }
  
  print("Found Dataset files, loading data...");
   # Read in the training data set
  train <- load_test_or_train("train");
  test <- load_test_or_train("test");
  
  # Merge into one data set
  print("Merging training and test set");
  fulldata <- rbind(train, test);
  fulldata
}

load_test_or_train <- function(directory) {
  # First read in the labels
  print("Loading labels");
  feature_names <- read.table("features.txt");
  activity_labels <- read.table("activity_labels.txt");
  
  print(sprintf("Loading %s data", directory));
  
  subject_train <- read.table(sprintf("%s/subject_%s.txt", directory, directory));
  colnames(subject_train) <- c("SubjectID");
  y_train <- read.table(sprintf("%s/y_%s.txt", directory, directory));
 
  # Lets change this to a factor variable, since we have the labels
  y_train <- factor(y_train[,1], activity_labels[,1], activity_labels[,2])
  
  # This is Step 3 in the assignment
  # Now y_train is a column of the factor values (LAYING, WALKING,...)
  
  x_train <- read.table(sprintf("%s/X_%s.txt", directory, directory));
  # x_train's column names are the feature names from features.txt
  
  # This is effectively Step 4 in the assignment
  colnames(x_train) <- feature_names[,2];
  # Some of these column names are duplicates! It's unclear what to do with these, however
  #  We don't need these columns for this analysis.  So we'll drop all duplicates here
  x_train <- x_train[,!duplicated(colnames(x_train))]
  
  # Bind the training data set into a single table
  train <- cbind(subject_train, y_train, x_train);
  # Rename the activity column, it's currently named y_train
  colnames(train)[2] <- "Activity";
  
  print(sprintf("Read in %s data: Dimensions: %s", directory, dim(train)));

  train
}
    
# Select only the columns that are measurements on the mean and standard dev
#  Assuming here that meanfreq() and the angle measurements don't count
#  The regular expression in the select can be edited if the user desires a different meaning
step_2 <- function(fulldata) {
  f1 <- select(fulldata, SubjectID, Activity)
  f2 <- select(fulldata, matches("mean\\(\\)|std\\(\\)"))
  cbind(f1, f2)
}

tidy_step_5 <- function(fulldata) {
  summaryFuncs <- funs(mean, sd);
  
  fulldata %>%
    # First we group by Subject ID and Activity
    group_by(SubjectID, Activity) %>%
    # Then we summarize each group two ways, mean and standard deviation
    summarise_each(summaryFuncs) %>%
    # Lets gather all the measurements into a single column of factors
    # this makes the data set tall instead of wide
    # Comment this line OUT of you would rather have a wide data set
    gather("Feature", "Measurement", 3:134) %>%
    # Separate the Function into a separate column (mean or sd)
    separate(Feature, into=c("FeatureName", "Function"), sep="_") %>%
    # And finally, arrange by activity ID, then subjectID
    arrange(Activity, SubjectID)
    
}

full_analysis <- function() {
   fulldata <- step_0();
   fulldata <- step_2(fulldata);
   tidy <- tidy_step_5(fulldata);
   write.table(tidy, file="tidy.UCIHARDataSet", row.name=FALSE);
   tidy;
}