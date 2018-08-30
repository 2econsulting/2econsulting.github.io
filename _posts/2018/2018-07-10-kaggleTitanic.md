---
layout: post
title: [HOW-TO]Kaggle Titanic Competition TOP 3%
category: [Kaggle] 
tags: [Kaggle]
no-post-nav: true
---

캐글(Kaggle)은 전세계에서 가장 큰 데이터 분석 경진 대회입니다.

https://www.kaggle.com/

<br>

> 캐글은 2010년 설립된 예측모델 및 분석 대회 플랫폼이다. 기업 및 단체에서 데이터와 해결과제를 등록하면, 데이터 과학자들이 이를 해결하는 모델을 개발하고 경쟁한다. 2017년 3월 구글에 인수되었다. (위키피디아)

<br>

<h4>Titanic Competition 소개</h4>

Titanic Competition은 데이터 분석 입문자들을 위한 캐글 데이터 분석 대회입니다.
Titanic Competition은 1912년 4월 15일 타이타닉 침몰 사고의 실제 데이터 입니다.
데이터셋에는 객실 등급, 나이, 성별, 항만, 티켓번호 이름 등의 정보가 있고 이를 사용해서 승객의 생존을 예측하는 경진 대회입니다.

DS랩도 Titanic Competition에 참여헸고 결과는 다음과 같습니다. 

<img src="https://raw.githubusercontent.com/2econsulting/2econsulting.github.io/master/_img/kaggle_titanic.png">

<img src="https://raw.githubusercontent.com/2econsulting/2econsulting.github.io/master/_img/kaggle_titanic2.png">

<br>

<h4>사용한 머신러닝 알고리즘</h4>

Titanic Competition 경진대회에서 사용한 분석 방법은 다음과 같습니다. (RANK TOP 3%)

* 사용한 머신러닝 알고리즘 : CatBoost, H2O XGBoost, H2O Light GBM
* CatBoost, (H2O) XGBoost, (H2O) Light GBM in R and Python 모델 튜닝 코드 (https://github.com/2econsulting/Kaggle)

|  file name | accuracy | threshold |
| ------------ | ------------ | ------------ |
|  R_TEST_CATBOOST_TUNE_P1.csv | 0.82296 | >0.5 |
|  R_TEST_CATBOOST_TUNE_CVP1.csv | 0.81818 | >0.5 |
|  R_TEST_H2OXGB_TUNE_CVP1.csv | 0.81339 | >0.5 |
|  R_TEST_CATBOOST_TUNE_CVP1_78.csv | 0.81339 | >0.5 |
|  R_TEST_H2OLGB_TUNE_CVP1.csv | 0.81818 | >0.5 | 

단일 모델로는 CatBoot의 0.82296(AUC)으로 가장 높았습니다.

CatBoost, H2O XGBoost, H2O Light GBM의 예측값을 다수결 방식으로 결합한 Stacking 모델은 0.83253(AUC)을 얻었습니다. 

<img src="https://raw.githubusercontent.com/2econsulting/2econsulting.github.io/master/_img/kaggle_titanic3.png" style="width: 50%">

<br>

