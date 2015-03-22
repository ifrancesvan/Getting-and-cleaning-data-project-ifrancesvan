library(RCurl)
library(plyr)
#Point 0 Read Data
if (!file.exists("UCI HAR Dataset")) {dir.create("UCI HAR Dataset")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
dir.create("UCI HAR Dataset")
download.file(fileUrl, "UCI-HAR-dataset.zip", method="curl")
unzip("./UCI-HAR-dataset.zip")

#Point 1 Merge Data Set
train_x <- read.table("./UCI HAR Dataset/train/X_train.txt")
test_x <- read.table("./UCI HAR Dataset/test/X_test.txt")
train_y <- read.table("./UCI HAR Dataset/train/y_train.txt")
test_y <- read.table("./UCI HAR Dataset/test/y_test.txt")
train_subj <- read.table("./UCI HAR Dataset/train/subject_train.txt")
test_subj <- read.table("./UCI HAR Dataset/test/subject_test.txt")
features_names <- read.table("./UCI HAR Dataset/features.txt")
x <- rbind(train_x, test_x)
y <- rbind(train_y, test_y)
subj <- rbind(train_subj, test_subj)
names(subj) <- c("subject")
names(y) <- c("activity")
names(x) <- features_names$V2
merge1 <- cbind(x,y)
Data <- cbind(subj,merge1)

# Point 3 Measurements mean, sd 
subset_names <- features_names$V2[grep("mean\\(\\)|std\\(\\)", features_names$V2)]
names <- c(as.character(subset_names), "subject", "activity")
Data <- subset(Data, select=names)

#Point 4 Label names data Set 
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

# Point 5 Indepent data set 
tidyData<-aggregate(. ~subject + activity, Data, mean)
tidyData<-tidyData[order(tidyData$subject,tidyData$activity),]
write.table(tidyData, file = "tidydata.txt",row.name=FALSE)