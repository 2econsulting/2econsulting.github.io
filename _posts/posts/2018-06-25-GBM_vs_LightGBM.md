---
layout: post
title: Light GBM in R and Python (GBM vs Light GBM)
category: LightGBM 
tags: [LightGBM, R]
no-post-nav: true
---

 Light GBM은 2014년 3월에 나온 XGBoost 알고리즘 이후, 2017년 1월에 발표된 알고리즘이다. GBM은 가지가 1번 분리될 때 2개씩 매번 분리가 되서 overfitting이 잘 일어난다. 하지만 LightGBM은 가지가 1번 분리(2개의 node 생성)될 때  모든 가지를 분리하지 않고 2개의 node 중 잘 맞는 node 기준으로만 나눈다. 전체적인 아키텍처는 다음과 같다.

<br>

#### Light GBM 구조

![Lightgbm](https://raw.githubusercontent.com/2econsulting/2econsulting.github.io/master/_img/lightgbm.png)

<br>

#### XGBoost 구조

![xgboost](https://raw.githubusercontent.com/2econsulting/2econsulting.github.io/master/_img/xgboost.png)

<br>

XGBoost와 GBM은 둘 다 위와 같은 구조로 되어 있다. 따라서 node가 많이 생기므로, 모델이 더 복잡해진다. 복잡해진 모델은 overfitting을 야기하기 쉽다. 반면, LightGBM은 그림과 같이 node가 비교적 적게 생긴다. 따라서 GBM이나 XGBoost보다 overfitting이 일어날 확률이 더 적어진다.  

 본 포스팅에서는 R과 Python 각각 GBM과 Light GBM을 비교해본다. 데이터는 "churn" 데이터이고 출처는 [데이터 출처(Github)](https://github.com/yhat/demo-churn-pred/blob/master/model/churn.csv) 이다. 현재 H2O로 Light GBM 모델링은 XGBoost에 parameter를 조정해서 사용한다. 하지만 현재 XGBoost 모듈은 __Windows 에는 지원을 하지 않으니__, 아래에 있는 코드를 돌리기 위해서는 _Mac OS_ 나 _linux_ 등 _Windows_ 이외의 환경에서 실행을 해야 한다. 

<br>

#### 성능비교 (GBM vs Light GBM in R & Python)

| model                   | time(sec) | AUC    | Logloss |
| ----------------------- | --------- | ------ | ------- |
| H2O GBM in python       | 0.98      | 0.9118 | 0.1954  |
| H2O Light GBM in python | 2.31      | 0.9234 | 0.1694  |
| H2O GBM in R            | 2.85      | 0.9118 | 0.1954  |
| H2O Light GBM in R      | 3.91      | 0.9234 | 0.1694  |

<br>

#### 전체 분석 코드

* [GBM vs Light GBM in R](https://github.com/2econsulting/2econsulting.github.io/blob/master/_posts_w_code/GBMvsLightGBM_R.r)
* [GBM vs Light GBM in Python](https://github.com/2econsulting/2econsulting.github.io/blob/master/_posts_w_code/GBMvsLightGBM_Python.py)

<br>