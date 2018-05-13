#setting our wd, downloading and upzipping the data
setwd("C:/Users/ahilal/Desktop/Coursera R course/Getting and cleaning data/Final project")
if(!file.exists("./data")) {dir.create("./data")}
dataUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file (dataUrl,destfile = "./data/Dataset.zip")
unzip(zipfile = "./data/Dataset.zip",exdir = "./data")

#To check the files we have in our wd
ls() 

#first we are loading train tables
X_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("./data/UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

#then we load testing tables
X_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("./data/UCI HAR Dataset/test/Y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

#3rd thing is we load the features file
features <- read.table("./data/UCI HAR Dataset/features.txt")

#last we load the activity file
activityLabels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

#Assiging columns names
colnames(X_train) <- features[,2];
colnames(Y_train) <- "activityId";
colnames(subject_train) <- "subjectId";
colnames(X_test) <- features[,2];
colnames(Y_test) <- "activityId";
colnames(subject_test) <- "subjectId";
colnames(activityLabels) <- c("activityId","activityType")

#Merging data
mrg_train <- cbind(Y_train,subject_train,X_train);
mrg_test <- cbind(Y_test,subject_test,X_test);
DF <- rbind(mrg_test,mrg_train);
colNames <- colnames(DF)

#Extracting only means and standard deviations:
mean_and_std <- (grepl("activityId", colNames) | grepl ("subjectId", colNames) | grepl("mean..", colNames) | grepl("std..",colNames))

#subsetting for means and standard deviations:
setForMeanAndStd <- DF [, mean_and_std == TRUE]

#Naming the activities in the data set
setWithActivityNames <- merge(setForMeanAndStd,activityLabels,by="activityId",all.x=TRUE)

#setting a second independent tidy data
secTidyset <- aggregate(.~subjectId + activityId, setWithActivityNames,mean)
secTidyset <- secTidyset[order(secTidyset$subjectId,secTidyset$activityId),]
write.table(secTidyset,"secTidyset.txt",row.names = FALSE)

