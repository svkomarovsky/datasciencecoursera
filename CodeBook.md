# Introduction

The script `run_analysis.R`
- downloads the data from
  [UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones )
* merges the training and test sets to create one data set
* replaces `activity` values in the dataset with descriptive activity names
* extracts only the measurements (features) on the mean and standard deviation
  for each measurement
* appropriately labels the columns with descriptive names
* creates a second, independent tidy dataset with an average of each variable
  for each each activity and each subject. 
* The processed tidy data set is exported as txt file.
  
# run_analysis.R

The script is parititioned into functions such that each function performs one of the
steps described above. To run whole cleaning procedure, call `clean_data`
function (clean_data()). The script assumes that `plyr` library and `data.table` library already installed.

# The original data set

The original data set is split into training and test sets (70% and 30%,
respectively) where each partition is also split into three files that contain
* measurements from the accelerometer and gyroscope
* activity label
* identifier of the subject

# Getting and cleaning data

If the data is not already available, it is downloaded
from UCI repository.

The first step of the preprocessing is to merge the training and test
sets. Two sets combined, there are 10,299 instances where each
instance contains 561 features (560 measurements and subject identifier). After
the merge operation the resulting data, the table contains 562 columns (560
measurements, subject identifier and activity label).

After the merge operation, mean and standard deviation features are extracted
for further processing. Out of 560 measurement features, 33 mean and 33 standard
deviations features are extracted, yielding a data frame with 68 features
(additional two features are subject identifier and activity label).

The data frame was than examined to replace the following accronms:
* ^t replaced with Time
* ^f replaced with Frequency
* Acc replaced with Accelerometer
* Gyro replaced with Gyroscope
* Mag replaced with Magnitude
* tBody replaced with TimeBody
* -mean() replaced with Mean
* -std was replaced with SDT
* -freq() was replaced with Frequency
* angle was replaced with Angle 
* gravity was replaced with Gravity
* extra dashes removed

Next, the activity labels are replaced with descriptive activity names, defined
in `activity_labels.txt` in the original data folder.

The final step creates a tidy data set with the average of each variable for
each activity and each subject.The tidy data set is exported to `activities_tidy.txt` where the first row is the header containing the names for each column.
