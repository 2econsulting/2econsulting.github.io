---
layout: post
title: (Kaggle Home Credit) top 1% with only 2 submissions? how?    
category: [Kaggle] 
tags: [Kaggle]
no-post-nav: true
---

learning from arnowaczynski 

https://www.kaggle.com/c/home-credit-default-risk/discussion/64609

<br>

<img src="https://raw.githubusercontent.com/2econsulting/2econsulting.github.io/master/_img/kaggle_homecredit_top1%.jpg" style="width: 70%">

[[ 모델 블랜딩 전략 ]]

1. many CV runs with random seeds with different random split(10 folds)

2. simple average of top 30 models

3. ridge regression on top 60 models


<br>


<img src="https://raw.githubusercontent.com/2econsulting/2econsulting.github.io/master/_img/kaggle_homecredit_top1%_v2.jpg" style="width: 70%">

[[ 하이퍼 파라미터 탐색 전략 ]]

1. num_boost_round = 10000 with early_stopping_rounds=200

2. bagging_freq = 1 

3. tuning hyper-params(6):  learning_rate, num_leaves, max_depth, min_data_in_leaf, feature_fraction,  bagging_freq

4. random grid search 

- set discrete search space for each params 

- while searching, print every cv score with selected hyper-parameters 

- at any time, stop search and adjust the search space (make sure not same parames evaluated more than once) 

<br>