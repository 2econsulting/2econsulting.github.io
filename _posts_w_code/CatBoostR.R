# title : CatBoost in R
# author : jacob
# desc : compare CatBoost with H2ORF and H2OGBM 


# library
devtools::install_github('catboost/catboost', subdir = 'catboost/R-package')
devtools::install_github("2econsulting/rAutoFE")
library(rAutoFE)
library(catboost)
library(h2o)
h2o.init()
h2o.removeAll()

# load data
data(churn, package = "rAutoFE")
head(churn)
str(churn)

# convert fake_num to factor 
churn$Area.Code <- as.factor(churn$Area.Code)

# split dataset
splits <- rAutoFE::splitFrame(dt = churn, ratio = c(0.7, 0.3), seed = 1234)
train <- splits[[1]]
test  <- splits[[2]]

# H2ORF & H2OGBM ----

# split dataset 
train_hex <- as.h2o(train)
test_hex  <- as.h2o(test)

# set x and y 
y <- colnames(train)[target_idx]
x <- colnames(train)[-target_idx]

# ml_rf
start <- Sys.time()
ml_rf <- h2o.randomForest(         
  training_frame = train_hex,
  x=x,                        
  y=y,  
  seed = 1234
)               
runtime_rf <- Sys.time() - start
cat(">> runtime_rf : ", runtime_rf, "\n")

# ml_gbm
start <- Sys.time()
ml_gbm <- h2o.gbm(         
  training_frame = train_hex,   
  x=x,                        
  y=y,  
  seed = 1234
)             
runtime_gbm <- Sys.time() - start
cat(">> runtime_gbm : ", runtime_gbm, "\n")

# compare CatBoost with H2ORF and H2OGBM 
h2o.performance(ml_rf, newdata = test_hex)
h2o.performance(ml_gbm, newdata = test_hex)

# CatBoost ----

# convert target data type 
churn[,target_idx] <- ifelse(churn[,target_idx] == "True.", 1, 0)
table(churn$Churn.)

# split dataset
splits <- rAutoFE::splitFrame(dt = churn, ratio = c(0.7, 0.3), seed = 1234)
train <- splits[[1]]
test  <- splits[[2]]

# set index 
target_idx <- grep("Churn.", colnames(churn))
category_index <- which(sapply(churn, is.factor))
interger_index <- which(sapply(churn, is.integer))

# convert inter to num 
churn[, interger_index] <- sapply(churn[, interger_index], as.numeric)

# train_pool
train_pool <- catboost.load_pool(
  data = train[,-target_idx],
  label = train[,target_idx],
  cat_features = category_index
)

# test_pool
test_pool <- catboost.load_pool(
  data = test[,-target_idx], 
  label = test[,target_idx], 
  cat_features = category_index
)

# train catboost
start <- Sys.time()
fit_params <- list(
  loss_function = 'Logloss',
  random_seed = 1234,
  custom_loss = "AUC",
  train_dir = "CatBoost_output"
)
ml_catboost <- catboost.train(learn_pool=train_pool, test_pool=test_pool, params=fit_params)
runtime_catboost <- Sys.time() - start
runtime_catboost

# variable importance 
ml_catboost$feature_importances

# predict
prediction <- catboost.predict(ml_catboost, test_pool)
head(prediction)

# performance
test_error <- read.table("CatBoost_output/test_error.tsv", sep = "\t", header = TRUE)
test_error[which.min(test_error$Logloss),]
test_error[which.max(test_error$AUC),]


