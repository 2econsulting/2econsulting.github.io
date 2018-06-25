# title : GBM vs Light GBM in R
# author : Heo Sung Wook
# depends :  h2o

library(h2o)

# before using h2o, 'h2o.init()' must be needed.
h2o.init()
h2o.removeAll()

# read data set
churn <- read.csv("./churn.csv")
churn <- rbind(churn, churn)

# for using h2o, data must be "h2o data frame"
churn_hex <- as.h2o(churn)

# split data, train:valid:test = 6:2:2
splits <- h2o.splitFrame(churn_hex, c(0.6,0.2), seed=1234)

# assign train, valid, test each
train <- h2o.assign(splits[[1]], "train.hex")   
valid <- h2o.assign(splits[[2]], "valid.hex")   
test <- h2o.assign(splits[[3]], "test.hex")

# 20's column is target('Churn.')
colnames(churn)

# parameter = default
start.time <- Sys.time()
ml_GBM <- h2o.gbm(training_frame = train,        
                  validation_frame = valid,
                  x=1:19,                  
                  y=20,
                  seed = 1234)

Sys.time() - start.time # check time

# check model performance by using test data set
# AUC = 0.9118117
# LogLoss = 0.1953534
h2o.performance(ml_GBM, newdata = test)


# In h2o, there is no specific module for LightGBM yet.
# Instead, using "tree_method='hist'" and "grow_policy='lossguide'" in H2OXGBoostEstimator offer "LightGBM algorithm"to us 
# you can find detail information in h2o website => http://docs.h2o.ai/h2o/latest-stable/h2o-docs/data-science/xgboost.html
# parameter = default
start.time <- Sys.time()
ml_LGB <- h2o.xgboost( training_frame = train,        
                       validation_frame = valid,      
                       x=1:19,                        
                       y=20,
                       tree_method="hist", 
                       grow_policy="lossguide",
                       seed = 1234)


Sys.time() - start.time # check time

# check model performance by using test data set
# AUC = 0.9234419
# LogLoss = 0.1694313
h2o.performance(ml_LGB, newdata = test)


