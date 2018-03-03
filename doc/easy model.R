library(readr)
siftfeatures <- read.csv("~/Downloads/MATLAB_sift 2/output2/FileName.csv", header = F)
siftfeatures<-as.data.frame(t(siftfeatures))

BOWmatrix_50 <- read_csv("~/Downloads/BOWmatrix_std-200.csv")
BOWmatrix_50<-BOWmatrix_50[,-1]
bow<-as.matrix(BOWmatrix_50)

load("../output/feature_NN.RData")


set.seed(123)
s<-sample(1:2000, size=1500, replace=FALSE)

train.data  <- NN_values[s,]
train.label <- label_train[s]
test.data   <- NN_values[-s,]
test.label  <- label_train[-s]

fit_gbm <- gbm.fit(x = train.data, y = train.label,
                   n.trees = 2000,
                   distribution = "bernoulli",
                   interaction.depth = 9, 
                   bag.fraction = 0.5,
                   verbose = FALSE)
best_iter <- gbm.perf(fit_gbm, method = "OOB", plot.it = FALSE)

fit<-list(fit = fit_gbm, iter = best_iter)

pred <- predict(fit$fit, newdata = test.data, 
                n.trees = fit$iter, type = "response")
summary(pred)
predicted<-as.numeric(pred > 0.5)

table(predicted,test.label)

sum(predicted==test.label)/500




cv.function <- function(X.train, y.train, d, K) {
  
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
    fit  <- train(train.data, train.label, par)
    pred <- test(fit, test.data)  
    cv.error[i] <- mean(pred != test.label)  
    
  }			
  return(c(mean(cv.error), sd(cv.error)))
}


if(run.cv){
  err_cv <- array(dim = c(length(model_values), 2))
  for(k in 1:length(model_values)){
    cat("k=", k, "\n")
    err_cv[k,] <- cv.function(siftfeatures, label_train, model_values[k], K)
  }