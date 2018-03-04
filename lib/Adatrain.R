#########################################################
### Train a classification model with training images ###
#########################################################

### Author: Yujie Hu
### Project 2
### ADS Spring 2018


train <- function(dat_train, label_train, par = NULL){
  
  ### Train a Adabossting using processed features from training images
  
  ### Input: 
  ###  -  processed features from images 
  ###  -  class labels for training images
  ### Output: training model specification
  
  ### load libraries
  library("JOUSBoost")
  
  ### Train with gradient boosting model
  if(is.null(par)){
    depth <- 3
  } else {
    depth <- par$depth
  }
  
  fit_ada<-adaboost(dat_train, y = label_train,
                    tree_depth = depth,
                    n_rounds = 100, verbose = F)
  
  return(list(fit = fit_ada))
}
