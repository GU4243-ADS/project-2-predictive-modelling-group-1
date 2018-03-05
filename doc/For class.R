if(!require("EBImage")){
  source("https://bioconductor.org/biocLite.R")
  biocLite("EBImage")
}

if(!require("JOUSBoost")){
  install.packages("JOUSBoost")
  devtools::install_github("molson2/JOUSBoost")
}

if(!require("pbapply")){
  install.packages("pbapply")
}

library("EBImage")
library("JOUSBoost")
library("tidyverse")

#Train model
library("JOUSBoost")
source("../lib/Adatrain.R")
par_best <- list(depth = 5)
load(file = "../output/feature_NN.RData")

experiment_dir <- "../data/pets/" # This will be modified for different data sets.
img_train_dir  <- paste(experiment_dir, "train/", sep="")
label_train <- read.table(paste(experiment_dir, "train_label.txt", sep = ""), header = F)
label_train <- as.numeric(unlist(label_train) == "dog")
label_trainada<-label_train
label_trainada[which(label_trainada==0)] <--1

fit_train <- train(NN_values, label_trainada, par_best)

#extract feature from test
source("../lib/Neural_network_feature.R")
img_test_dir<-paste(experiment_dir, "test_for_fun/", sep="")

run.feature.test<-TRUE
tm_feature_test <- NA
if(run.feature.test){
  tm_feature_test <- system.time(dat_test <- feature(img_test_dir, export = TRUE))
}

#predict
pred <- predict(fit_train$fit, dat_test)

