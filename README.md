---
title: "README"
author: "Student 11025756"
date: "Tuesday, June 16, 2015"
output: html_document
---

##  Summary of run_analysis.R  

The run_analysis.R performs the following steps in creating the tidy data set.

1.  Download the .zip file and Unzip it.
2.  Read in the following files for processing:
    > activity_labels.txt
	> features.txt
	> X_test.txt
	> subject_test.txt
	> y_test.txt
	> X_train.txt
	> subject_train.txt
	> y_train.txt
3.   Rename columns for activities and features so that they are more 
descriptive.
4.   Rename columns for test subjects and activity label numbers so that they 
are more descriptive.
5.   Combine the test source and the related activities and test subject 
numbers.
6.   Combine the training source and the related activities and test subject 
numbers.
7.   Combine the updated training and test sources into one data frame.
8.   Identify the column headers that contain either the text mean or std.
9.   Select those columns, and the activity label number and test subject 
number and place them into a new dataframe.
10.  Replace the label numbers with the label names from the activity labels.
11.  Rename the columns for the measures to be more descriptive.
12.  Group the data by Test Subject Number and then Activity Name.
13.  Calculate the mean for each of the measures.
14.  Output file into formats (text per rubric, and csv for readability).
15.  Output the column headers to support the codebook development.