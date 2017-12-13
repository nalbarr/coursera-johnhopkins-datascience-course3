# Coursera - Getting and Cleaning Data
# Week 4 - Project
# Student:  Narciso Albarracin

# run_analyis.R

# 0. Set up pre-conditions and environment
# 1. Merge training and test data sets
# 2. For each measurement, only extract only mean and standard deviation
# 3. Name variables descriptively
# 4. Label datset with descriptive names
# 5. From #4, extract tidy data set representing average for each subject and each activity

### 0. Set up pre-conditions and environment

#setwd("c:/workspace-data-cleaning/coursera-getting-cleaning-data")
read.cwd <- function() {
  s <- readline(prompt="Enter current working directory: ")
  s <- as.character(s)
  if (is.na(s)) {
    s <- read.cwd()
  }
  s
}
path.cwd <- read.cwd()
setwd(path.cwd)
getwd()

rm(list=ls())
library(data.table)
library(dplyr)

path.cwd <- getwd()

### 1. Merge training and test data sets
### - 1a. Change working directory to process UCI HAR input data set files.
### - 1b. Read files into data frames.
### - 1c. Convert data frames into data tables
### - 1d. Rename key columns to prepare for merge training and test data tables
### - 1e. Create surrogate identity column for merging
### - 1f. For training data, merge data tables based on identity column
### - 1g. For test data, merge data tables based on identity column
### - 1h. Append training and test data tables

### 1a.
list.input.path.parts <- c(getwd(), "UCI HAR Dataset")
path.cwd2 <- paste(list.input.path.parts, collapse="/")
path.cwd2
setwd(path.cwd2)
getwd()

### 1b.
list.paths <- list(
  "features" = "./features.txt",
  "activities" = "./activity_labels.txt",

  "subjects.train" = "./train/subject_train.txt",
  "x.train" = "./train/x_train.txt",
  "y.train" = "./train/y_train.txt",

  "subjects.test" = "./test/subject_test.txt",
  "x.test" = "./test/x_test.txt",
  "y.test" = "./test/y_test.txt"
)
list.dfs <- lapply(list.paths, read.table)

### 1c.
list.dts <- lapply(list.dfs, data.table)

### 1d.
list.dts.col.maps <- list(
  "features" = list("V1"="feature.id", "V2"="feature.name"),     
  "activities" = list("V1"="activity.id", "V2"="activity.name"),
  "subjects.train" = list("V1"="subject.id"),       
  "x.train" = list("V1"="V1"),       
  "y.train" = list("V1"="activity.id"),       
  "subjects.test" = list("V1"="subject.id"),
  "x.test" = list("V1"="V1"),         
  "y.test" = list("V1"="activity.id")   
)
lapply(names(list.dts), function(x) {
  dt <- list.dts[[x]]
  dt.old.names <- names(list.dts.col.maps[[x]])
  dt.new.names <- unlist(list.dts.col.maps[[x]])
  setnames(dt, dt.old.names, dt.new.names)
})

### 1e
list.dts.train <- list.dts[c("subjects.train", "x.train", "y.train")]
list.dts.train <- lapply(list.dts.train, function(x) {
  x <- mutate(x, id = seq.int(nrow(x)))
})

list.dts.test <- list.dts[c("subjects.test", "x.test", "y.test")]
list.dts.test <- lapply(list.dts.test, function(x) {
  x <- mutate(x, id = seq.int(nrow(x)))
})

### 1f
dt.train.merge <- merge(list.dts.train$x.train, list.dts.train$y.train, by="id")
dt.train.merge2 <- merge(dt.train.merge, list.dts.train$subjects.train, by="id")

### 1g
dt.test.merge <- merge(list.dts.test$x.test, list.dts.test$y.test, by="id")
dt.test.merge2 <- merge(dt.test.merge, list.dts.test$subjects.test, by="id")

### 1h
dt1 <- rbind(dt.train.merge2, dt.test.merge2)

### 2. For each measurement, only extract only mean and standard deviation
### - 2a. Set up new data data table for intermediate processing
### - 2b. Map feature (descriptive) names to features ids
### - 2c. Subset combined data table based on logical vector for required column names
###   e.g., variable means and standard deviations

# 2a
dt2 <- dt1

# 2b
dt2.features <- list.dts$features
count(list.dts$features) # 561
list.features.indexes.old <- 1:561
list.features.names.old <- lapply(list.features.indexes.old, function(x) {
  x <- paste("V", x, sep = "")
})
vector.features.names.old <- unlist(list.features.names.old)

dt2.features.names.new <- select(dt2.features, feature.name)
vector.features.names.new <- as.vector(dt2.features.names.new$feature.name)

setnames(dt2, vector.features.names.old, vector.features.names.new)

# 2c
dt2.names <- names(dt2)
dt2.logical.names <- lapply(dt2.names, function(x) {
  b <- grepl("feature..", x) | 
    grepl("activity..", x) | 
    grepl("subject..", x) | 
    grepl("-mean..", x) & 
    !grepl("-meanFreq..", x) & 
    !grepl("mean..-", x) | 
    grepl("-std..", x) & 
    !grepl("-std()..-", x)
  b
})
dt2.names <- dt2.names[dt2.logical.names == TRUE]
dt2.names

# 2b
dt2 <- select(dt2, one_of(dt2.names))

### 3. Use descriptive activity names to name the activities in the data set
### - 3a.  Set up new data data table for intermediate processing
### - 3b.  Merge current data table with activities data table based on activity.id key

### 3a
dt3 <- dt2

### 3b
dt3.activities <- list.dts$activities
dt3 <- merge (dt3, dt3.activities, by ="activity.id", all.x = TRUE)

### 4. Label data set with descriptive names
### - 4a. Set up new data data table for intermediate processing
### - 4b. Use regular expressions to match unfriendly names and replace them with friendly names.
### - 4c. Rename data table columns

### 4a.
dt4 <- dt3

### 4b.
dt4.names <- names(dt4)
dt4.names <- lapply(dt4.names, function(x) {
  x <- gsub("\\()","", x)
  x <- gsub("-std$","StdDeviation", x)
  x <- gsub("-mean","Mean", x)
  x <- gsub("^(t)","time", x)
  x <- gsub("^(f)","freq", x)
  x <- gsub("([Gg]ravity)","Gravity", x)
  x <- gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body", x)
  x <- gsub("[Gg]yro","Gyro", x)
  x <- gsub("AccMag","AccMagnitude", x)
  x <- gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude", x)
  x <- gsub("JerkMag","JerkMagnitude", x)
  x <- gsub("GyroMag","GyroMagnitude", x)  
})
dt4.names <- unlist(dt4.names)

### 4c
colnames(dt4) <- dt4.names

### 5. From #4, extract tidy data set representing average for each subject and each activity
### - 5a. Set up new data data table for intermediate processing
### - 5b. Remove unncessary columns prior to computing mean (e.g., activity.name)
### - 5c. Compute mean for each measurement by subject.id and activity.id
### - 5d. Remove unnecessary columns (i.e., "subject.id", "activity.id")
### - 5e. Export tidy data set

### 5a
dt5 <- dt4

### 5b
dt5 = select(dt5, -one_of(c("activity.name")))

### 5c
dt5.groupby <- list("by.subject" = dt5$subject.id, "by.activity" = dt5$activity.id)
dt5 <- aggregate(dt5, by = dt5.groupby, mean)

### 5d
dt5 <- select(dt5, -one_of(c("activity.id", "subject.id")))
dt5.names.old <- names(dt5)
dt5.names.new <- lapply(dt5.names.old, function(x) {
  is.groupby.name <- 
    grepl(x, "by.subject") | 
    grepl(x, "by.activity")
  if (! is.groupby.name) {
    x <- paste("Mean-(", x, ")", sep = "")    
  } else {
    x
  }
})
dt5.names.new <- unlist(dt5.names.new)
colnames(dt5) <- dt5.names.new

### 5e
write.table(dt5, './tidy_out.txt', sep='\t')