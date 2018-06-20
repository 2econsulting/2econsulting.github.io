---
layout: post
title: CatBoost 튜닝 in R (using caret패키지)
category: CatBoost 
tags: [CatBoost, R, Python]
no-post-nav: true
---

caret패키지를 사용한 CatBoost 튜닝 v0.01 (random grid search)

```r
# library 
library(catboost)
library(caret)
library(titanic)

# load data
data <- as.data.frame(as.matrix(titanic::titanic_train), stringsAsFactors=TRUE)

# handle missing value
age_levels <- levels(data$Age)
most_frequent_age <- which.max(table(data$Age))
data$Age[is.na(data$Age)] <- age_levels[most_frequent_age]

# set x and y 
drop_columns = c("PassengerId", "Survived", "Name", "Ticket", "Cabin")
x <- data[,!(names(data) %in% drop_columns)]
y <- data[,c("Survived")]

# use caret for grid search 
fit_control <- caret::trainControl(
  method = "cv", 
  number = 3, 
  search = "random",
  classProbs = TRUE
)

# set grid options
grid <- expand.grid(
  depth = c(4, 6, 8),
  learning_rate = 0.1,
  l2_leaf_reg = 0.1,
  rsm = 0.95,
  border_count = 64,
  iterations = 10
)

# train catboost
model <- caret::train(
  x = x, 
  y = as.factor(make.names(y)),
  method = catboost.caret,
  metric = "Accuracy",
  maximize = TRUE,
  preProc = NULL,
  tuneGrid = grid, 
  tuneLength = 30, 
  trControl = fit_control
)
print(model)

# variable importance
importance <- varImp(model, scale = FALSE)
print(importance)
```





