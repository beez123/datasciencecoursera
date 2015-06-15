## Load all libraries
library(plyr) 
library(dplyr)


########################## Download file ######################
## Download source data file, not required if file is already downloaded and unzipped in current working directory
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
require(downloader)
download (fileURL, "source.zip", mode="wb")
unzip("source.zip")
dateDownloaded <- date()
maindir <- "./UCI HAR Dataset"
setwd(maindir)

##  Remove variables that are no longer required
    rm (fileURL)
    rm (maindir)


########################## Part 1 - Merges the training and the test sets to create one data set.  ###############

##Read in source data tables
##  Activity Names to match the labels in the y_test and y_train sets
    activityLabels <- read.table("activity_labels.txt")
##  Features to match the X_test and X_train sets
    features <- read.table("features.txt")

##  Read in Test Data set
    testSetSource <- read.table("./test/X_test.txt")
    testSubjectSource <- read.table("./test/subject_test.txt")
    testLabelSource <- read.table("./test/y_test.txt")

##  Read in Training Data set
    trainSetSource <- read.table("./train/X_train.txt")
    trainSubjectSource <- read.table("./train/subject_train.txt")
    trainLabelSource <- read.table("./train/y_train.txt")    


##  Select Columns and Combine
##  Activity Labels, **V1 = Number, **V2 = Text activity
##  Features, V1 = Number, **V2 = Feature name
##  Subjects, **V1 = Test Subject Number
##      Rename the columns for added items
        colnames (activityLabels) <- c("Label.Number", "Activity.Name")
        colnames (features) <- c("Feature.Number", "Feature.Name")

##      Training Data Source
##          Rename the columns for added items
            colnames (testSubjectSource) <- c("Test.Subject.Number")
            colnames (testLabelSource) <- c("Activity.Label.Number")
            colnames (testSetSource) <- features$Feature.Name

##          Add the columns
            testSet <- cbind (testSetSource, testLabelSource, testSubjectSource)


##      Training Data Source
##          Rename the columns for added items
            colnames (trainSubjectSource) <- c("Test.Subject.Number")
            colnames (trainLabelSource) <- c("Activity.Label.Number")
            colnames (trainSetSource) <- features$Feature.Name

##          Add the columns
            trainSet <- cbind (trainSetSource, trainLabelSource, trainSubjectSource)

##  Combine Training & Test into one set
    dataSet <- rbind (testSet, trainSet)

##  Remove variables that are no longer required
    rm (trainSubjectSource)
    rm (trainLabelSource)
    rm (trainSetSource)
    rm (trainSet)

    rm (testSetSource)
    rm (testLabelSource)
    rm (testSubjectSource)
    rm (testSet)

########################## Part 2 - Extracts only the measurements on the mean and standard deviation for each measurement. ###############

##  Find only mean and std features
    ## Keep the unique column headers
    colUnique <- unique (features$Feature.Name)

    ## Find only those features with mean and standard deviation measures
    colKeep <- grep (("mean|std"), colUnique, value=TRUE)
    colKeep <- c(colKeep, "Activity.Label.Number", "Test.Subject.Number")

    ## Subset to keep only the matching columns
    meanStdSet <- dataSet[,colKeep]


########################## Part 3 - Uses descriptive activity names to name the activities in the data set. ###############


##  Match the activity names with the data set
    ## For each Name-Value pair in the Activity Names file match with the Activity Label Number in the dataset
    i <- 1
    for (i in activityLabels$Label.Number) {        
    #   Pull descriptive label
        txt <- activityLabels$Activity.Name[i]
    #   Assign descriptive label based upon Activity Number
        meanStdSet$Activity.Label.Number <- gsub (i,txt,meanStdSet$Activity.Label.Number)            
    } ## end for

    ## Removing variables no longer required
    rm (dataSet)
    rm (colKeep)
    rm (colUnique)
    rm (i)
    rm (txt)

########################## Part 4 - Appropriately labels the data set with descriptive variable names.   ###############
    ##Rename column to match content

    #names (meanStdSet)[names(meanStdSet)=="Activity.Label.Number"] <- "Activity.Name"
    meanStdSet <- rename (meanStdSet, c("Activity.Label.Number"="Activity.Name"))
    names(meanStdSet) <- gsub("-", " ", names(meanStdSet)) 
    names(meanStdSet) <- gsub("+BodyBody", "Body", names(meanStdSet)) 
    names(meanStdSet) <- gsub("^t", "Time Signal ", names(meanStdSet)) 
    names(meanStdSet) <- gsub("^f", "FFT ", names(meanStdSet)) 
    names(meanStdSet) <- gsub("+Jerk", " Jerk", names(meanStdSet)) 
    names(meanStdSet) <- gsub("+Mag", " Magnitude", names(meanStdSet)) 
    names(meanStdSet) <- gsub("+BodyAcc", "Body Accelerometer", names(meanStdSet))
    names(meanStdSet) <- gsub("+BodyGyro", "Body Gyroscope", names(meanStdSet)) 
    names(meanStdSet) <- gsub("+GravityAcc", "Gravity Accelerometer", names(meanStdSet))
    names(meanStdSet) <- gsub("+GravityGyro", "Gravity Gyroscope", names(meanStdSet))    
    names(meanStdSet) <- gsub("mean\\(\\)", "Mean", names(meanStdSet)) 
    names(meanStdSet) <- gsub("std\\(\\)", "Standard Deviation", names(meanStdSet)) 
    names(meanStdSet) <- gsub("[mM]ean[fF]req\\(\\)", "Mean Frequency", names(meanStdSet)) 
    names(meanStdSet) <- gsub("X$", "X Direction", names(meanStdSet)) 
    names(meanStdSet) <- gsub("Y$", "Y Direction", names(meanStdSet)) 
    names(meanStdSet) <- gsub("Z$", "Z Direction", names(meanStdSet)) 

    ## Remove variables no longer required
    rm (activityLabels)
    rm (features)


########################## Part 5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.   ###############

    meanStdSet <- tbl_df (meanStdSet)
    
    tidyDataSet <- meanStdSet %>%
        group_by (Test.Subject.Number, Activity.Name) %>%
        summarise_each (funs(mean))
     
    ## Output format as requested in rubric
    write.table(tidyDataSet, file="tidyData.txt", row.name=FALSE)
    ## Output format that is more easily read
    write.table(tidyDataSet, file="tidyData.csv", row.name=FALSE, sep=",")

##  Remove variables that are no longer required
    rm(meanStdSet)

###########  Support ###########
codeBook <- names (tidyDataSet)
write (codeBook, file="CodeBook.txt")
rm (codeBook)
