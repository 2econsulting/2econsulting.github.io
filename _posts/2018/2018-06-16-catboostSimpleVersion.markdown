---
layout: post
title: CatBoost in R & Python (simple version)
category: CatBoost 
tags: [CatBoost, R, Python]
no-post-nav: true
---

새로운 머신러닝 알고리즘 CatBoost가 등장했습니다. ![Image](./_img/catboost.jpg)

러시아 과학자가 개발한 CatBoost는 Tree Boosting 계열의 머신러닝 알고리즘 입니다. 

Tree Boosting 계열의 머신러닝 알고리즘은 최근 가장 활발하게 연구되고 있는 분야입니다. 
(GBM -> XGBoost -> Light GBM -> CatBoost)  

특히 CatBoost의 full name은 Categorical Boost으로 범주형 변수가 많은 데이터셋에서 예측 성능이 우수하다고 합니다. 

### CatBoost의 장점
* 높은 예측 성능 
* 범주형 변수를 자동으로 전처리
* 모델 튜닝이 간소화 (범주형 변수를 자동으로 전처리 해주니깐 그 부분에 대해서 따로 튜닝을 할 필요가 없습니다. GBM의 경우 항목이 많은 범주형 변수로 학습하는 경우 과적합이 쉽게 발생하는데 CatBoost는 이러한 문제를 보완한 알고리즘입니다.)
* R 그리고 Python과 연동  
* 출처 : https://www.analyticsvidhya.com/blog/2017/08/catboost-automated-categorical-data/

Tree기반의 대표적인 머신러닝 알고리즘에는 Random Forest(RF)와 Gradient Boosting Machine(GBM)이 존재합니다. 
CatBoost가 RF와 GBM과 비교해서 속도 및 예측 성능의 차이를 비교하였습니다. 

### 성능비교 (RF vs GBM vs CatBoost)
|  model | time(sec) | AUC | Logloss |
| ------------ | ------------ | ------------ | ------------ |
| H2ORF in Python | 0.73 | 0.9153 | 0.3039 |
| H2OGBM in Python | 0.49 | 0.9118 | 0.1954 |
| CatBoost in Python | 22.50 | 0.9539 | 0.1148 |
| H2ORF in R | 1.57 | 0.9170 | 0.3607 |
| H2OGBM in R | 1.69 | 0.9160 | 0.1931 |
| CatBoost in R | 29.73 | 0.9259 | 0.1565 |

학습 데이터 소개입니다. 

### 학습 데이터 
* churn dataset 
* 3333 rows
* Y is binary, X consists of 15 numeric and 4 categorical features
* 출처 : yhat (https://github.com/yhat/demo-churn-pred/blob/master/model/churn.csv)

CatBoost 설치 방법 및 전체 분석 코드 입니다. 

### Python
* 설치 방법

  `pip install catboost`

* 학습 (예측성능, 속도) 비교 (아래 Jupyter notebook 첨부)

  [CatBoost in Python](https://github.com/2econsulting/2econsulting.github.io/blob/master/_posts_w_code/CatBoost.ipynb)

### R
* 설치방법
  * 아래 Jupyter notebook 참고
* 학습 (예측성능, 속도) 비교 (아래 Jupyter notebook 첨부)

  [CatBoost in R](https://github.com/2econsulting/2econsulting.github.io/blob/master/_posts_w_code/CatBoost in R.ipynb)



