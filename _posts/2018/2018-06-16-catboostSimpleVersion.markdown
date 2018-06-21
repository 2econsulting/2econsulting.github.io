---
layout: post
title: CatBoost in R & Python (simple version)
category: CatBoost 
tags: [CatBoost, R, Python]
no-post-nav: true
---

새로운 머신러닝 알고리즘 CatBoost가 등장했습니다. 러시아 과학자가 개발한 CatBoost는 Tree Boosting 계열의 최신 머신러닝 알고리즘 입니다. 최근 들어 Tree Boosting 계열의 머신러닝 알고리즘이 활발하게 연구되고 있습니다. 이는 아마도 XGBoost가 캐글 대회에서 수차례 winning solution으로 검증되면서 많은 과학자들이 XGBoost와 같은 Tree Boosting 머신러닝 기법에 많은 관심을 갖고 있는 것 같습니다.  

<br>

#### Tree Boosting 머신러닝 변천사 

![02](https://raw.githubusercontent.com/2econsulting/2econsulting.github.io/master/_img/catboostlightgbmxgb.png)

<br>

#### CatBoost의 장점 [link](https://www.analyticsvidhya.com/blog/2017/08/catboost-automated-categorical-data/)
특히 CatBoost의 full name은 Categorical Boost으로 범주형 변수가 많은 데이터셋에서 예측 성능이 우수하다고 합니다. 
* 높은 예측 성능 
* 범주형 변수를 자동으로 전처리
* 모델 튜닝이 간소화 (범주형 변수를 자동으로 전처리 해주니깐 그 부분에 대해서 따로 튜닝을 할 필요가 없습니다. GBM의 경우 항목이 많은 범주형 변수로 학습하는 경우 과적합이 쉽게 발생하는데 CatBoost는 이러한 문제를 보완한 알고리즘입니다.)
* R 그리고 Python과 연동  

<br>

#### CatBoost의 장점 (추가) [link](https://tech.yandex.com/catboost/doc/dg/concepts/parameter-tuning-docpage/#trees-number)
* CatBoost 개발자에 의하면 모델 튜닝 없이 default값으로만 좋은 성능을 보여준다고 합니다. 또한 튜닝을 통해서 얻을 수 있는 효과는 크지 않다고 합니다. 

> CatBoost gives great results with default values of the training parameters. In most cases parameter tuning does not significantly affect the resulting quality of the model and therefore is unnecessary. However, CatBoost provides a very flexible interface for parameter tuning and can be configured to suit different tasks.

<br>

#### 성능비교 (RF vs GBM vs CatBoost)
Tree기반의 대표적인 머신러닝 알고리즘에는 Random Forest(RF)와 Gradient Boosting Machine(GBM)이 존재합니다. 
CatBoost가 RF와 GBM과 비교해서 속도 및 예측 성능의 차이를 비교하였습니다. 

|  model | time(sec) | AUC | Logloss |
| ------------ | ------------ | ------------ | ------------ |
| H2ORF in Python | 0.73 | 0.9153 | 0.3039 |
| H2OGBM in Python | 0.49 | 0.9118 | 0.1954 |
| CatBoost in Python | 22.50 | 0.9539 | 0.1148 |
| H2ORF in R | 1.57 | 0.9170 | 0.3607 |
| H2OGBM in R | 1.69 | 0.9160 | 0.1931 |
| CatBoost in R | 29.73 | 0.9259 | 0.1565 |

<br>

#### 학습 데이터 소개 [link](https://github.com/yhat/demo-churn-pred/blob/master/model/churn.csv)
* churn dataset 
* 3333 rows
* Y is binary, X consists of 15 numeric and 4 categorical features

<br>

#### CatBoost 설치 방법 및 전체 분석 코드 
* [CatBoost in Python](https://github.com/2econsulting/2econsulting.github.io/blob/master/_posts_w_code/CatBoostPy.py)
* [CatBoost in R](https://github.com/2econsulting/2econsulting.github.io/blob/master/_posts_w_code/CatBoostR.R)

<br>