---
layout: post
title: 추천 시스템 R패키지 비교 연구  
category: recommenderSystem 
tags: [recommenderSystem, R]
no-post-nav: true
---

추천 R패키지 속도 및 성능 비교 연구 결과입니다.
* 데이터셋 : MovieLense (100만행)

<br>

#### 패키지 목록

|  package name | package description  |
| ------------ | ------------ |
| Myrrix | Real-Time, Scalable Clustering and Recommender System, Evolved from Apache Mahout |
| recommenderlab | Lab for Developing and Testing Recommender Algorithms |
| recosystem | Recommender System using Matrix Factorization |
| rrecsys | Environment for Evaluating Recommender Systems |
| slimrec | Sparse Linear Method to Predict Ratings and Top-N Recommendations |

<br>

#### 패키지 성능 비교 

| package name | algorithm | time(min) | RMSE |
|------------- | ----------| --------- | ---- |
|recommenderlab|Most Popular| 4.27| 0.9725 |
|| User-Based CF| 5.03| 1.0464 |
|| Item-based CF| 7.11| 1.5074 |
|| SVD| 5.52| 1.0204 |
|| Funk SVD| 13.91| 0.9106 |
|| Random| 3.49| 1.3832 |
|| ALS| 13.14| 0.9032 |
|rrecsys| itemAverage| 7.37| 0.9614 |
|| userAverage| 6.95| 1.0140 |
|| globalAverage| 6.22| 1.0913 |
|| IBKNN| 7.53| 1.0853 |
|| UBKNN| 37.49| 1.0196 |
|| FunkSVD| 31.36| 1.0811 |
|| SlopeOne| 15.48| 0.9028 |
|recosystem|Matrix Factorization|0.68| 0.8529 |
|slimrec| Sparse LInear Method| 25.52| 2.2196 |
|SVDApproximation| SVDApproximation| 4.92| 0.9313 |
|SmartCat-Labs's Git R code)| ibcf| 0.64| 0.8971 |
|| ubcf| 1.14| 0.9028 |

<br>

### 전체 분석 코드

* [Comparison of Recommend system packages in R](https://github.com/2econsulting/2econsulting.github.io/blob/master/_posts_w_code/Comparison_Of_RecommendSystem.R)

<br>