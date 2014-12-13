---
title: "Codebook for assignment in Getting and Cleaning Data"
output: html_document
---

This data set is derived from the UCI HAR dataset, assumed to be available and
familiar to the reader. 

## Step-by-step description of my analysis
1. Using read.csv() I read into R six files of raw data: three kinds of files 
(containing subject labels, activity labels, and actual measurements) from two folders 
(called "test" and "train").  

2. I merged these six datasets into one set. Subject labels and activity labels
were added as columns in front of the measurements table with cbind(). 
Then, "test" and "train" sets were combined row-wise with rbind().  

3. The column labels of original data were stored in features.txt. I used 
partial text matching on features.txt to pinpoint all column names containing 
the strings "mean" and "std" using the grep() function.  

4. From features.txt, I also extracted the descriptive column names
(e.g. tBodyAcc-mean()-X)  

5. Original data had labeled activies with integers 1-6. I replaced these
integer with descriptive labels ("LAYING","SITTING", etc) taken from
activity_labels.txt.  

6. I used the cast-melt procedure to find the mean of each variable
per subject and activity. For example, the original data set contained 
multiple instances where subject #27 performed the activity of walking. 
I combined them into only one row for subject #27 + walking containing their
mean.  

7. The final data set is written into tidy_data.txt. Here is a sample of the
first few rows and columns of the final data set:

```r
final_set <- read.table("tidy_data.txt",header=TRUE)
```

```
## Warning in file(file, "rt"): cannot open file 'tidy_data.txt': No such
## file or directory
```

```
## Error in file(file, "rt"): cannot open the connection
```

```r
final_set[1:10,1:4]
```

```
##    SUBJECT           ACTIVITY tBodyAcc-mean()-X tBodyAcc-mean()-Y
## 1        1             LAYING         0.2215982      -0.040513953
## 2        1            SITTING         0.2612376      -0.001308288
## 3        1           STANDING         0.2789176      -0.016137590
## 4        1            WALKING         0.2773308      -0.017383819
## 5        1 WALKING_DOWNSTAIRS         0.2891883      -0.009918505
## 6        1   WALKING_UPSTAIRS         0.2554617      -0.023953149
## 7        2             LAYING         0.2813734      -0.018158740
## 8        2            SITTING         0.2770874      -0.015687994
## 9        2           STANDING         0.2779115      -0.018420827
## 10       2            WALKING         0.2764266      -0.018594920
```


## Description of final data set
The set tidy_data.txt consists of 180 observations of 81 variables.
The 180 observations are 30 human subjects, undergoing 6 different activities 
(hence 30x6=180).   

Description of variables:  
Col 1: "SUBJECT" - an integer between 1 and 30 that labels a person in the test 
  
Col 2: "ACTIVITY" - one of six activities "WALKING","WALKING_UPSTAIRS",
                    "WALKING_DOWNSTAIRS",
                   "SITTING","STANDING","LAYING"
                     
Columns 3-81: mean values for the particular person and particular activity
                of the means and standard deviations of the measurements.
                Column names are a subset of those given in features.txt of
                the original data set. Please refer to features.txt and 
                features_info.txt in the original data set for variable
                descriptions and units.  
