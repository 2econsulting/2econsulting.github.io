---
layout: post
title: CatBoost Tuninig Strategy in R & Python (hyper-parameter grid search)
category: CatBoost 
tags: [CatBoost, R, Python]
no-post-nav: true
---

연구 중, 업로드 예정일 2018년 6월 29일

0. pre-train
- make baseline default model
- choose stopping rules

1. one step
- cartesian top3 categorical_encoding
- cartesian top3 max depth

2. two step
- random grid search
- bayesian grid search
