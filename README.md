# Spring2018


# Project 2: Predictive Modelling

----


### [Project Description](doc/)

Term: Spring 2018

+ Project title: Dog or Cat?
+ Team Number: 1
+ Team Members: David Arredondo, Yujie Hu, Yang He, Judy Cheng, Huijun Cui
                
+ Project summary: Our goal was to find an accurate and efficent model capable of classifing dog and cat images.
After analyzing several combinations of models and feature extractors, our team concluded that an AdaBoost model with neural network derived features offers the best of both performance and speed.

Contribution statement:

Yang extracted SIFT features and build a bag-of-word template for generating trainable matrices, cleaned up the repo, and buit a simple Convolutional Neural Network.

David ran the ORB features on the different models, some of the HOG features and wrote the README files. 

Yujie extracted HOG and Neural Network Features, checked Baseline model(GBM) on every feature we have and built Adaboost on NN feature.

Huijun Cui built SVM(Linear), KNN, Random Forest model and trained/tested them on NN features, HOG features and SIFT features. 

Following [suggestions](http://nicercode.github.io/blog/2013-04-05-projects/) by [RICH FITZJOHN](http://nicercode.github.io/about/#Team) (@richfitz). This folder is orgarnized as follows.

```
proj/
├── lib/
├── data/
├── doc/
├── figs/
└── output/
```

Please see each subfolder for a README file.

## Summary Table

 Classifer \\ Feature (with time)| SIFT (600s)| ORB (3180s)| HOG (85s)| NN (277s) 
---|---| ---|--- |--- 
 Gradient Boosting              | Acc:73.5%(991s)| Acc: 68.5% (8s)| Acc: 72.9% (521s)| Acc: 88.8% (667s)
 Random Forest                  | Acc:70.5% (2s)| Acc: 68% (1s)| Acc: 77.8% (23s) | Acc: 83.5% (4s)
 SVM                            | Acc:81.25% (3s)| Acc: 70% (1s)| Acc: 78.5% (24s) | Acc: 91%(45s)
 Adaboost                       | Acc: | Acc: 68.25% (1s)| Acc: 72% (153s)| Acc: 91.05% (127s)
 KNN                            | Acc: 76.75% (2s)| Acc: 60% (1s)| Acc: 74% (8s)| Acc:71.5% (7s)

### Choosing Our Model

We chose the AdaBoost Model with Nerual Network dervied features. This model has the best combination of accuracy and performance time.

The above table shows our experiementation with other models, of which we had mixed results. The neural network derived features provided the best results, but the HOG features were by far the fastest. Although the HOG features provided resable prediction accuracy and great speed, the nerual network features were fast enough to compete, and gave much better accuracy.

