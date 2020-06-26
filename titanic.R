## clean environment
rm(list = ls())

#load libraries
library(tidyverse)
library(ggthemes)
library(ggrepel)
library(gridExtra)
library(mice)
library(outliers)
library(dataPreparation)
library(corrplot)
library(C50)
library(caret)
library(randomForest)
library(e1071)

##load datasets

train <- read_csv("train-titanic.csv")
test <- read_csv("test-titanic.csv")

#we have total 891 observations and 12 features in train dataset
# and total 418 observations and 11 features in test dataset

str(train)

# remove PassengerId column as it is showing only indexing
train <- select(train,-"PassengerId") 
test <- select(test,-"PassengerId")

# convert some features to their respective class

train$Survived <- as.factor(train$Survived)
train$Pclass <- as.factor(train$Pclass)
train$Sex <- as.factor(train$Sex)
train$SibSp <- as.factor(train$SibSp)
train$Parch <- as.factor(train$Parch)
train$Embarked <- as.factor(train$Embarked)

str(train)


#### DATA CLEANING AND PREPROCESSING ####

### missing value analysis ###
md.pattern(train, rotate.names = TRUE)

# we have total 866 missing values in our train dataset in plot
#remove cabin feature as it is having more than 70% of missing data

train <- select(train,-Cabin)

# now we can impute these missing values using mean and mode imputation

train$Age[is.na(train$Age)] <- mean(train$Age, na.rm = T) 

#now remove NAs from embarked column
train<- na.omit(train)

###outlier detection and deletion
train_numerical <- train %>% select(where(is.numeric))
boxplot(train_numerical)

## there are outliers in age and Fare


#### EXPLOTAORY DATA ANALYSIS ####

#See distribution of target variable
