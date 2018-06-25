"""
# title : GBM vs Light GBM in Python
# author : Heo Sung Wook
# depends :  h2o,  pandas,  time
"""
from h2o.estimators import H2OXGBoostEstimator  ## it doesn't work on Windows environment
from h2o.estimators import H2OGradientBoostingEstimator
import h2o
import pandas as pd
import time

# before using h2o, 'h2o.init()' must be needed.
h2o.init()

# read data set
churn = pd.read_csv("../data/churn.csv")

# for using h2o, data must be "h2o.frame.H2OFrame"
churn_hex = h2o.H2OFrame(churn)

# check
type(churn_hex) # h2o.frame.H2OFrame

# split data, train:valid:test = 6:2:2
train, valid, test = churn_hex.split_frame([0.6, 0.2], seed=1234)

# define independent variable name
X = churn_hex.col_names[:-1]

# define dependent varialbe name
y = churn_hex.col_names[-1]  

# for comparing with LightGBM, parameter is default, same as LightGBM.
start_time = time.time()
ml_GBM = H2OGradientBoostingEstimator(seed = 1234)
ml_GBM.train(X, y, training_frame=train, validation_frame=valid)
time.time() - start_time # check time

# check model performance by using test data set
performance_GBM = ml_GBM.model_performance(test_data=test)

# In h2o, there is no specific module for LightGBM yet.
# Instead, using "tree_method='hist'" and "grow_policy='lossguide'" in H2OXGBoostEstimator offer "LightGBM algorithm"to us 
# you can find detail information in h2o website => http://docs.h2o.ai/h2o/latest-stable/h2o-docs/data-science/xgboost.html
# parameter = default
start_time = time.time()
ml_LGB = H2OXGBoostEstimator(tree_method="hist", grow_policy="lossguide", seed = 1234)
ml_LGB.train(X, y, training_frame=train, validation_frame=valid)
time.time() - start_time


# check model performance by using test data set
performance_LGB = ml_LGB.model_performance(test_data=test)

# check AUC
print("GBM AUC is : {}".format(performance_GBM.auc()))        # 0.9118117071438436
print("LightGBM AUC is : {}".format(performance_LGB.auc())) # 0.9234419081815851

print("GBM Logloss is : {}".format(performance_GBM.logloss()))       #  0.19535343851362647
print("LightGBM Logloss is : {}".format(performance_LGB.logloss())) #  0.1694313270809276
#







