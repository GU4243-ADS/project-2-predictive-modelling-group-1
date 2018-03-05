#########################################################
### Train a classification model with training images ###
#########################################################

### Author: Yuting Ma
### Project 3
### ADS Spring 2016


gbm_train <- function(dat_train, label_train, par = NULL){
  
  ### Train a Gradient Boosting Model (GBM) using processed features from training images
  
  ### Input: 
  ###  -  processed features from images 
  ###  -  class labels for training images
  ### Output: training model specification
  
  ### load libraries
  library("gbm")
  
  ### Train with gradient boosting model
  if(is.null(par)){
    depth <- 3
  } else {
    depth <- par$depth
  }
  fit_gbm <- gbm.fit(x = dat_train, y = label_train,
                     n.trees = 2000,
                     distribution = "bernoulli",
                     interaction.depth = depth, 
                     bag.fraction = 0.5,
                     verbose = FALSE)
  best_iter <- gbm.perf(fit_gbm, method = "OOB", plot.it = FALSE)

  return(list(fit = fit_gbm, iter = best_iter))
}

ada_train <- function(dat_train, label_train, par = NULL){
  
  ### Train a Adabossting using processed features from training images
  
  ### Input: 
  ###  -  processed features from images 
  ###  -  class labels for training images
  ### Output: training model specification
  
  ### load libraries
  library("JOUSBoost")
  
  ### Train with AdaBoosting model
  if(is.null(par)){
    depth <- 3
  } else {
    depth <- par$depth
  }
  
  fit_ada<-adaboost(dat_train, y = label_train,
                    tree_depth = depth,
                    n_rounds = 100, verbose = F)
  
  return(fit_ada)
}
