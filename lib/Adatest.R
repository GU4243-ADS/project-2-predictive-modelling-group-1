######################################################
### Fit the classification model with testing data ###
######################################################

### Author: Yujie Hu
### Project 2
### ADS Spring 2018

test <- function(fit_train, dat_test){
  
  ### Fit the classfication model with testing data
  
  ### Input: 
  ###  - the fitted classification model using training data
  ###  -  processed features from testing images 
  ### Output: training model specification
  
  ### load libraries
  
  library("JOUSBoost")

  pred <- predict(fit_train$fit, dat_test)
  return(pred)
}
