---
layout: post
title: 추천 시스템 R패키지 비교 연구  
category: recommenderSystem 
tags: [recommenderSystem, R]
no-post-nav: true
---

### 추천시스템 R패키지에서 제공하는 추천 엔진 속도 및 성능 비교 연구

|  package name | package description  |
| ------------ | ------------ |
| Myrrix | Real-Time, Scalable Clustering and Recommender System, Evolved from Apache Mahout |
| recommenderlab | Lab for Developing and Testing Recommender Algorithms |
| recosystem | Recommender System using Matrix Factorization |
| rrecsys | Environment for Evaluating Recommender Systems |
| slimrec | Sparse Linear Method to Predict Ratings and Top-N Recommendations |

### 추천시스템 R패키지 성능비교

100만 행이 넘는 MovieLense 데이터셋을 이용해 추천 알고리즘 R 패키지들 중 recommenderlab, recosystem, rrecsys, slimrec, SVDApproximation 의 성능을 비교해 보면 다음과 같습니다.

#### recommenderlab
| Algorithm               | time(min) | RMSE   |
| ----------------------- | --------- | ------ |
| Most Popular            | 4.27      | 0.9725 |
| User-Based CF           | 5.03      | 1.0464 |
| Item-based CF           | 7.11      | 1.5074 |
| SVD                     | 5.52      | 1.0204 |
| Funk SVD                | 13.91     | 0.9106 |
| Random                  | 3.49      | 1.3832 |
| ALS                     | 13.14     | 0.9032 |

#### recosystem
| Algorithm               | time(sec) | RMSE   |
| ----------------------- | --------- | ------ |
| Matrix Factorization    | 36.35     | 0.8512 |

#### rrecsys
| Algorithm               | time(min) | RMSE   |
| ----------------------- | --------- | ------ |
| itemAverage             | 4.92      | 0.9313 |
| itemAverage             | 7.37      | 0.9614 |
| userAverage             | 6.95      | 1.0140 |
| globalAverage           | 6.22      | 1.0913 |
| IBKNN                   | 7.53      | 1.0853 |
| UBKNN                   | 37.49     | 1.0196 |
| FunkSVD                 | 31.36     | 1.0811 |
| SlopeOne                | 15.48     | 0.9028 |

#### slimrec
| Algorithm               | time(min) | RMSE   |
| ----------------------- | --------- | ------ |
| Sparse LInear Method    | 25.52     | 2.2196 |

#### SVDApproximation
| Algorithm               | time(min) | RMSE   |
| ----------------------- | --------- | ------ |
| SVDApproximation        | 4.92      | 0.9313 |


### 전체 분석 코드

* [Comparison of Recommend system packages in R](https://github.com/2econsulting/2econsulting.github.io/blob/master/_posts_w_code/Comparison_Of_RecommendSystem.R)
