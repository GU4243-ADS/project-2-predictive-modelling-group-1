library(readr)
siftfeatures <- read.csv("~/Downloads/MATLAB_sift 2/output2/FileName.csv", header = F)
siftfeatures<-as.data.frame(t(siftfeatures))

BOWmatrix_50 <- read_csv("~/Downloads/BOWmatrix_std-200.csv")
BOWmatrix_50<-BOWmatrix_50[,-1]
bow<-as.matrix(BOWmatrix_50)

load("../output/feature_NN.RData")
load("../output/feature_HOG.RData")


set.seed(123)
s<-sample(1:2000, size=1500, replace=FALSE)

label_trainada<-label_train
label_trainada[which(label_trainada==0)] <--1

train.data  <- NN_values[s,]
train.label <- label_train[s]
test.data   <- NN_values[-s,]
test.label  <- label_train[-s]

train.data  <- hog_value[s,]
train.label <- label_train[s]
test.data   <- hog_value[-s,]
test.label  <- label_train[-s]


#TRY SVM

svm_100 =svm(x = train.data, y = train.label, kernel ="linear", cost=100,scale = TRUE)
summary(svm_100)

svm_1e04=svm(x = NN_values, y = label_train, kernel ="linear", cost=0.001, scale=TRUE)
summary(svm_1e04)

tune.out=tune(svm,train.x=train.data, train.y=train.label,kernel="linear",scale=T,
              ranges =list(cost=c(0.001,0.005,0.01,0.1,0.5,1,10)))
summary(tune.out)
best_svm =tune.out$best.model
summary(best_svm)

label.pred = predict(svm_1e04,NN_values)
save(svm_1e04, file = "../output/NN_SVM_fit_train.RData")


bestmatrix<-table(predict = label.pred,truth=test.label)
bestmatrix
accuracy = sum(bestmatrix[1,1]+bestmatrix[2,2])/500
accuracy

svmdata<-as.data.frame(cbind(NN_values,label_train))
svmdata$label_train<-as.factor(svmdata$label_train)

tune.out=tune(svm,train.x=train.data, train.y=train.label,kernel="linear",scale=T,
              ranges =list(cost=c(0.001,0.005,0.01,0.1,0.5,1,10)))
best_svm =tune.out$best.model
summary(best_svm)

svm_1e04=svm(label_train~.,svmdata, kernel ="linear", cost=0.001, scale=TRUE)
summary(svm_1e04)





train.data  <- NN_values[s,]
train.labelada <- label_trainada[s]
test.data   <- NN_values[-s,]
test.labelada  <- label_trainada[-s]

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


#try ada
fit_ada<-adaboost(train.data, y = train.labelada,
                  tree_depth = 5,
                  n_rounds = 100, verbose = F)

print(fit_ada)
yhat_ada = predict(fit_ada, test.data)

table(yhat_ada)
table(yhat_ada,test.labelada)

sum(yhat_ada==test.labelada)/500






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