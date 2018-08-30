---
layout: post
title: Bayesian Optimization using R and H2O
category: gridSearch 
tags: [gridSearch, R, H2O]
no-post-nav: true
---

rBayesianOptimization을 사용한 h2o.gbm 튜닝 코드입니다. 모델 튜닝은 최적의 하이퍼 파라미터를 찾는 행위이고 이를 grid search라고 합니다.

가장 많이 사용되고 있는 grid search 방법으로는 모든 가능한 경우를 테스트하는 Cartesian grid search방법과, 모든 가능한 경우 중 일부를 랜덤하게 선택하여 테스트하는 Random grid search방법이 존재합니다.

Bayesian grid search방법은 기존의 Random, Cartesian방법 보다 더 고급진 grid search방법입니다.

> Bayesian Optimization helped us find a hyperparameter configuration that is better than the one found by Random Search for a neural network on the San Francisco Crimes dataset. [link](https://arimo.com/data-science/2016/bayesian-optimization-hyperparameter-tuning/)

Bayesian grid search의 특징은 최적의 하이퍼 파라미터를 찾는데 이전의 탐색 결과를 참고합니다. 이전에 탐색 결과를 다음 탐색에 참고하기 때문에 랜덤하게 탐색하는 것보다 더 효율적이라고 말할 수 있습니다.

<br>

```r
# bayesGridFun
bayesGridFun <- function(max_depth, min_rows, sample_rate, col_sample_rate){
  gbm <- h2o.gbm(
    x = x, y = y, seed = 1234,
    training_frame = h2o.rbind(train_hex, valid_hex),
    nfolds = 3,
    score_each_iteration = TRUE,
    stopping_metric = "logloss",
    ntrees = 10000,
    stopping_rounds = autoGBM_BestParams$stopping_rounds,
    stopping_tolerance = autoGBM_BestParams$stopping_tolerance,
    categorical_encoding = autoGBM_BestParams$Random_categorical_encoding,
    learn_rate = autoGBM_BestParams$Random_learn_rate,
    max_depth = max_depth,
    min_rows = min_rows,
    sample_rate = sample_rate,
    col_sample_rate = col_sample_rate
  )
  score <- h2o.auc(gbm, xval = T)
  list(Score = score, Pred  = 0)
}

# bayesGridOptions
max_depth <- autoGBM_BestParams$Random_max_depth
sample_rate <- autoGBM_BestParams$Random_sample_rate
col_sample_rate <- autoGBM_BestParams$Random_col_sample_rate
min_rows <- autoGBM_BestParams$Random_min_rows
bayesGridOptions <- list(
  max_depth = as.integer(c(max(2, max_depth-1), max_depth+1)),
  min_rows  = as.integer(c(max(1, min_rows-5), min_rows+5)),
  sample_rate = c(sample_rate-0.1, min(sample_rate+0.1, 1)),
  col_sample_rate = c(col_sample_rate-0.1, min(col_sample_rate+0.1, 1))
)

# bayesGridSearch
set.seed(1234)
bayesGridSearch <- rBayesianOptimization::BayesianOptimization(
  FUN = bayesGridFun,
  bounds = bayesGridOptions,
  init_points = init_points,
  n_iter = n_iter,
  acq = "ucb",
  kappa = 2.576,
  eps = 0.0,
  verbose = TRUE
)

# H2OGBM_Bayesian
H2OGBM_Bayesian <- h2o.gbm(
  x = x, y = y, seed = 1234,
  model_id = "H2OGBM_Bayesian",
  training_frame = train_hex,
  validation_frame = valid_hex,
  score_each_iteration = TRUE,
  stopping_metric = "logloss",
  ntrees = 10000,
  stopping_rounds = autoGBM_BestParams$stopping_rounds,
  stopping_tolerance = autoGBM_BestParams$stopping_tolerance,
  categorical_encoding = autoGBM_BestParams$Random_categorical_encoding,
  learn_rate = autoGBM_BestParams$Random_learn_rate,
  max_depth = as.numeric(bayesGridSearch$Best_Par["max_depth"]),
  min_rows = as.numeric(bayesGridSearch$Best_Par["min_rows"]),
  sample_rate = as.numeric(bayesGridSearch$Best_Par["sample_rate"]),
  col_sample_rate = as.numeric(bayesGridSearch$Best_Par["col_sample_rate"])
)

autoGBM_Models["H2OGBM_Bayesian"] <- list(h2o.getModel("H2OGBM_Bayesian"))
h2o.auc(h2o.performance(autoGBM_Models["H2OGBM_Bayesian"][[1]], newdata = test_hex))
saveRDS(autoGBM_Models['H2OGBM_Bayesian'], file.path(model_path, "H2OGBM_Bayesian.rda"))
autoGBM_BestParams['Bayes_max_depth'] <- as.numeric(bayesGridSearch$Best_Par["max_depth"])
autoGBM_BestParams['Bayes_min_rows'] <- as.numeric(bayesGridSearch$Best_Par["min_rows"])
autoGBM_BestParams['Bayes_sample_rate'] <- as.numeric(bayesGridSearch$Best_Par["sample_rate"])
autoGBM_BestParams['Bayes_col_sample_rate'] <- as.numeric(bayesGridSearch$Best_Par["col_sample_rate"])

```

<br>