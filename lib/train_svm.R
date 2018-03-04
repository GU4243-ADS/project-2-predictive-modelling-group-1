#########################################################
### Train a classification model with training images ###
#########################################################

### Author: Huijun Cui
### Project 2
### ADS Spring 2018

train_svm <- function(Train.x,Train.y,cost){

    library(e1071)
    fit_svm<-svm(Train.x,Train.y,scale=F,kernel="linear",cost = cost)
    return(fit_svm)
}