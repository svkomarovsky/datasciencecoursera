library(data.table)
library(plyr)

download_data = function() {
  
  if (!file.exists("UCI HAR Dataset")) {
    # download the data
    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    zipfile="UCI HAR Dataset.zip"
    download.file(fileURL, destfile=zipfile, method="curl")
    unzip(zipfile)
  }
}

merge_datasets = function() {
  # Read data  
  training.x <- read.table("UCI HAR Dataset/train/X_train.txt")
  training.y <- read.table("UCI HAR Dataset/train/y_train.txt")
  training.subject <- read.table("UCI HAR Dataset/train/subject_train.txt")
  test.x <- read.table("UCI HAR Dataset/test/X_test.txt")
  test.y <- read.table("UCI HAR Dataset/test/y_test.txt")
  test.subject <- read.table("UCI HAR Dataset/test/subject_test.txt")
  # Merge
  merged.x <- rbind(training.x, test.x)
  merged.y <- rbind(training.y, test.y)
  merged.subject <- rbind(training.subject, test.subject)
  # merge train and test datasets and return
  list(x=merged.x, y=merged.y, subject=merged.subject)
}

extract_mean_std = function(df) {
  # Given the dataset (x values), extract only the measurements on the mean
  # and standard deviation for each measurement.
  # Read the feature list file
  features <- read.table("UCI HAR Dataset/features.txt")
  # Find the mean and std columns
  mean.col <- sapply(features[,2], function(x) grepl("mean()", x, fixed=T))
  std.col <- sapply(features[,2], function(x) grepl("std()", x, fixed=T))
  # Extract them from the data
  edf <- df[, (mean.col | std.col)]
  colnames(edf) <- features[(mean.col | std.col), 2]
  # Appropriately label the data set with descriptive variable names.
  # Change t to Time, f to Frequency, mean() to Mean and std() to STD,
  #Gyro to Gyroscope, Acc to Accelerometer, Mag to Magnitude, 
  #tBody to TimeBody, freq() to Frequency, angle to Angle, gravity to Gravity
  # Remove extra dashes
 
  names(edf) <- gsub("^t", "Time", names(edf))
  names(edf) <- gsub("^f", "Frequency", names(edf))
  names(edf) <- gsub("-mean\\(\\)", "Mean", names(edf))
  names(edf) <- gsub("-std\\(\\)", "STD", names(edf))
  names(edf) <- gsub("-freq\\(\\)", "Frequency", names(edf))
  names(edf) <- gsub("angle", "Angle", names(edf))
  names(edf) <- gsub("gravity", "Gravity", names(edf))
  names(edf) <- gsub("Acc", "Accelerometer", names(edf))
  names(edf) <- gsub("Gyro", "Gyroscope", names(edf))
  names(edf) <- gsub("Mag", "Magnitude", names(edf))
  names(edf) <- gsub("-", "", names(edf))
  edf
}
name_of_activities = function(df) {
  # Use descriptive activity names to name the activities in the dataset
  colnames(df) <- "activity"
  df$activity[df$activity == 1] = "WALKING"
  df$activity[df$activity == 2] = "WALKING_UPSTAIRS"
  df$activity[df$activity == 3] = "WALKING_DOWNSTAIRS"
  df$activity[df$activity == 4] = "SITTING"
  df$activity[df$activity == 5] = "STANDING"
  df$activity[df$activity == 6] = "LAYING"
  df
}

bind_data <- function(x, y, subjects) {
  # Combine mean-std values (x), activities (y) and subjects into one data
  # frame.
  cbind(x, y, subjects)
}
create_tidydataset = function(df) {
  # Given X values, y values and subjects, create an independent tidy dataset
  # with the average of each variable for each activity and each subject.
  tidy <- ddply(df, .(subject, activity), function(x) colMeans(x[,1:60]))
  tidy
}
clean_data = function() {
  # Download data
  download_data()
  # merge training and test datasets. merge.datasets function returns a list
  # of three dataframes: X, y, and subject
  merged <- merge_datasets()
  # Extract only the measurements of the mean and standard deviation for each
  # measurement
  cx <- extract_mean_std(merged$x)
  # Name activities
  cy <- name_of_activities(merged$y)
  # Use descriptive column name for subjects
  colnames(merged$subject) <- c("subject")
  # Combine data frames into one
  combined <- bind_data(cx, cy, merged$subject)
  # Create tidy dataset
  tidy <- create_tidydataset(combined)
  # Write tidy dataset as txt
  write.table(tidy, "activities_tidy.txt", row.names = FALSE)
}

