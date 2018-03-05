# Spring2018


# Project 2: Predictive Modelling

----


### [Project Description](doc/)

Term: Spring 2018

+ Project title: [a title]
+ Team Number: 1
+ Team Members: David Arredondo,
                Yujie Hu,
                Yang He,
                Judy Cheng,
                Huijun Cui
                
+ Project summary: After analyzing several combinations of models and feature extractors, our team concluded that an AdaBoost model with
Neural Network derived features offers the best of both performance and speed.

Contribution statement: [default](doc/a_note_on_contributions.md) David ran the ORB features, and wrote the README files. All team members contributed equally in all stages of this project. All team members approve our work presented in this GitHub repository including this contributions statement.

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

 Classifer \\Feature (with time)| SIFT (600s)| ORB (3180s)| HOG (85s)| NN (277s) 
---|---| ---|--- |--- 
 Gradient Boosting              | Acc:70.5%  | Acc: 68.5%| Acc: 72.9%| Acc:
 Random Forest                  | Acc:70.5% | Acc: 68%| Acc: | Acc:
 SVM                            | Acc:81.25% (3s) | Acc: 70%| Acc: | Acc:
 Adaboost                       | Acc: | Acc: | Acc: | Acc:
 KNN                            | Acc: 76.75%| Acc: 67%| Acc: | Acc:

### Choosing Our Model

We choose the AdaBoost Model with Nerual Network dervied features. This model has the best combination of accuracy and performance time.
The above table shows our experiementation with other models.

