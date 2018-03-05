########################
### Cross Validation ###
########################

### Author: Yuting Ma
### Project 3
### ADS Spring 2016


cv.function.ada <- function(X.train, y.train, d, K) {
  
  n        <- length(y.train)
  n.fold   <- floor(n/K)
  s        <- sample(rep(1:K, c(rep(n.fold, K-1), n-(K-1)*n.fold)))  
  cv.error <- rep(NA, K)
  
  for (i in 1:K){
    train.data  <- X.train[s != i,]
    train.label <- y.train[s != i]
    test.data   <- X.train[s == i,]
    test.label  <- y.train[s == i]
    
    par  <- list(depth = d)
    fit  <- ada_train(train.data, train.label, par)
    pred <- ada_test(fit, test.data)  
    cv.error[i] <- mean(pred != test.label)  
    
  }			
  return(c(mean(cv.error), sd(cv.error)))
}

cv.function.gbm <- function(X.train, y.train, d, K) {
  
  n        <- length(y.train)
  n.fold   <- floor(n/K)
  s        <- sample(rep(1:K, c(rep(n.fold, K-1), n-(K-1)*n.fold)))  
  cv.error <- rep(NA, K)
  
  for (i in 1:K){
    train.data  <- X.train[s != i,]
    train.label <- y.train[s != i]
    test.data   <- X.train[s == i,]
    test.label  <- y.train[s == i]
    
    par  <- list(depth = d)
    fit  <- gbm_train(train.data, train.label, par)
    pred <- gbm_test(fit, test.data)  
    cv.error[i] <- mean(pred != test.label)  
    
  }			
  return(c(mean(cv.error), sd(cv.error)))
}