# title : CatBoost in R
# author : jacob
# depends : rAutoFE, catboost, h2o, knitr

# libraries 
# devtools::install_github('catboost/catboost', subdir = 'catboost/R-package')
# devtools::install_github("2econsulting/rAutoFE")
# install.packages("knitr")
rm(list=ls())
library(rAutoFE)
library(catboost)
library(h2o)
library(knitr)

# start h2o 
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

# convert data.frame to hex
train_hex <- as.h2o(train)
test_hex  <- as.h2o(test)

# set x and y 
target_idx <- grep("Churn.", colnames(churn))
y <- colnames(train)[target_idx]
x <- colnames(train)[-target_idx]

# H2ORF
start <- Sys.time()
H2ORF <- h2o.randomForest(         
  training_frame = train_hex,
  x=x,                        
  y=y,  
  seed = 1234
)               
H2ORF_Runtime <- Sys.time() - start

# H2OGBM
start <- Sys.time()
H2OGBM <- h2o.gbm(         
  training_frame = train_hex,   
  x=x,                        
  y=y,  
  seed = 1234
)             
H2OGBM_Runtime <- Sys.time() - start

# performance H2ORF and H2OGBM 
H2ORF_eval <- h2o.performance(H2ORF, newdata = test_hex)@metrics[c("logloss", "AUC")]
H2OGBM_eval <- h2o.performance(H2OGBM, newdata = test_hex)@metrics[c("logloss", "AUC")]

# CatBoost ----

# CatBoost package needs {1, 0} target values for binary classification 
train[,target_idx] <- ifelse(train[,target_idx] == "True.", 1, 0)
test[,target_idx] <- ifelse(test[,target_idx] == "True.", 1, 0)

# convert train data.frame to catboost.pool 
train_pool <- catboost.load_pool(
  data = train[,-target_idx],
  label = train[,target_idx],
  cat_features = which(sapply(churn[, x], is.factor))
)

# convert test data.frame to catboost.pool 
test_pool <- catboost.load_pool(
  data = test[,-target_idx], 
  label = test[,target_idx], 
  cat_features = which(sapply(churn[, x], is.factor))
)

# train catboost
start <- Sys.time()
params <- list(
  loss_function = 'Logloss',
  random_seed = 1234,
  custom_loss = "AUC",
  train_dir = "CatBoost_output"
)
CatBoost <- catboost.train(learn_pool=train_pool, test_pool=test_pool, params=params)
CatBoost_Runtime <- Sys.time() - start

# performance CatBoost
test_error <- read.table("CatBoost_output/test_error.tsv", sep = "\t", header = TRUE)
CatBoost_eval <- test_error[which.max(test_error$AUC), c("Logloss", "AUC")]

# summary ---- 
eval_metrics <- data.frame(
  model = c("H2ORF", "H2OGBM", "CatBoost"),
  runtime = c(H2ORF_Runtime, H2OGBM_Runtime, CatBoost_Runtime),
  Logloss = c(H2ORF_eval$logloss, H2OGBM_eval$logloss, CatBoost_eval$Logloss),
  AUC = c(H2ORF_eval$AUC, H2OGBM_eval$AUC, CatBoost_eval$AUC)
)
kable(eval_metrics, format = "markdown")
kable(eval_metrics, format = "pandoc", caption="default trainining result")
# Table: default trainining result
# 
# model      runtime             Logloss         AUC
# ---------  ---------------  ----------  ----------
# H2ORF      1.387038 secs     0.3894338   0.9105410
# H2OGBM     1.348170 secs     0.2061134   0.9007459
# CatBoost   28.865551 secs    0.1586252   0.9300781

