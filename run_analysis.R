library(dplyr)

## read the training and test datasets, then join them
training <- read.table("./UCI HAR Dataset/train/X_train.txt", stringsAsFactors = FALSE)
test <- read.table("./UCI HAR Dataset/test/X_test.txt", stringsAsFactors = FALSE)
data <- full_join(training, test)

## find out where are the mean and std by looking at the documentation (features.txt)
## then select only the columns with mean and standard deviation
## we need to escape the parentheses -- \\(, \\) -- because they have a different meaning in regexs
feat <- read.table("./UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)
goodCol <- grepl("mean\\(\\)|std\\(\\)", feat[,2])
dataRdx <- data[, goodCol]

### give a readable name to the columns
colnames(dataRdx) <- feat[goodCol, 2]

### add the activity and the subject of the experiment, treated as factors
### it is necessary to do it after the joining because not all the factors are always present
trainingActivity <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "Activity")
testActivity <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = "Activity")
trainingSubject <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = "Subject")
testSubject <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "Subject")

dataActSub <- full_join(cbind(trainingActivity, trainingSubject), cbind(testActivity, testSubject))
dataActSub[,1] <- factor(dataActSub[,1])
dataActSub[,2] <- factor(dataActSub[,2])
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]
levels(dataActSub[,1]) <- activityLabels
dataRdx <- cbind(dataRdx, dataActSub)

### create a second df with the average of the columns for every subject and activity
res <- aggregate(. ~ Subject + Activity, dataRdx, mean)
