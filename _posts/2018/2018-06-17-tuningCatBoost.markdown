---
layout: post
title: CatBoost Tuninig Strategy in R & Python (hyper-parameter grid search)
category: CatBoost 
tags: [CatBoost, R, Python]
no-post-nav: true
---

연구 중, 업로드 예정일 2018년 6월 29일

0. pre-train
0.1 make baseline default model   
0.2 choose stopping rules

1. one step  
1.1 cartesian top3 categorical_encoding
1.2 cartesian top3 max_depth 

2. two step 
2.1 random grid search 
2.2 bayesian grid search 
