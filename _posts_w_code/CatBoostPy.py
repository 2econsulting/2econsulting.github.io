# title : CatBoost in Python
# author : jacob
# depends : catboost, h2o, sklearn, pandas, numpy, time

# libraries
from catboost import CatBoostClassifier, Pool
from sklearn.model_selection import train_test_split
from h2o.estimators.gbm import H2OGradientBoostingEstimator 
from h2o.estimators.random_forest import H2ORandomForestEstimator 
import pandas as pd
import numpy as np
import time
import h2o

# start h2o 
h2o.init()
h2o.remove_all()

# load data 
churn = pd.read_csv("https://raw.githubusercontent.com/2econsulting/2econsulting.github.io/master/data/churn.csv")
churn.info()

# convert fake_num to factor
churn.columns = churn.columns.str.replace(".","_")
churn.Area_Code = churn.Area_Code.astype("category")

# convert data.frame to hex
churn_hex = h2o.H2OFrame(churn)

# split dataset
train_hex, valid_hex, test_hex = churn_hex.split_frame([0.5, 0.3], seed=1234)

# set x and y 
y = "Churn_"
X = churn.columns[churn.columns != y].tolist()

# train H2ORF
start = time.time()
H2ORF = H2ORandomForestEstimator(seed = 1234)
H2ORF.train(X, y, training_frame=train_hex, validation_frame=valid_hex)
H2ORF_Runtime = time.time() - start

# performance H2ORF
H2ORF_Logloss = H2ORF.model_performance(test_data=test_hex)["logloss"]
H2ORF_AUC = H2ORF.model_performance(test_data=test_hex)["AUC"]

# train H2OGBM
start = time.time()
H2OGBM = H2OGradientBoostingEstimator(seed = 1234)
H2OGBM.train(X, y, training_frame=train_hex, validation_frame=valid_hex)
H2OGBM_Runtime = time.time() - start

# performance H2OGBM
H2OGBM_Logloss = H2OGBM.model_performance(test_data=test_hex)["logloss"]
H2OGBM_AUC = H2OGBM.model_performance(test_data=test_hex)["AUC"]

# CatBoost ---- 

# set x and y for CatBoost
X = churn.drop(['Churn_'], axis=1)
y = churn['Churn_']

# CatBoost package needs {1, 0} target values for binary classification
y = np.where(y == "True.", 1, 0)

# split dataset
X_train, X_validTest, y_train, y_validTest = train_test_split(X, y, train_size=0.5, test_size = 0.5, random_state=1234)
X_valid, X_test, y_valid, y_test = train_test_split(X_validTest, y_validTest, train_size = 0.6, test_size = 0.4, random_state = 1234)

# train CatBoost
start = time.time()
cat_features = np.where(X.dtypes.astype("str").isin(["category","object"]))[0]
CatBoost = CatBoostClassifier(random_seed = 1234)
CatBoost.fit(X = X_train, y = y_train, cat_features = cat_features, eval_set=(X_valid, y_valid))
CatBoost_Runtime = time.time() - start

# performance CatBoost
test_pool = Pool(X_test, y_test, cat_features=cat_features)
CatBoost_eval = CatBoost.eval_metrics(test_pool, ['AUC','Logloss'], plot=False)
maxAUC_index = np.argmax(CatBoost_eval['AUC'])
CatBoost_AUC = CatBoost_eval['AUC'][maxAUC_index ]
CatBoost_Logloss = CatBoost_eval['Logloss'][maxAUC_index]

# summary ----- 
d = {
 "model" : ["H2ORF", "H2OGBM", "CatBoost"],
 "runtime" : [H2ORF_Runtime, H2OGBM_Runtime, CatBoost_Runtime],
 "Logloss" : [H2ORF_Logloss, H2OGBM_Logloss, CatBoost_Logloss],
 "AUC" : [H2ORF_AUC, H2OGBM_AUC, CatBoost_AUC]
}
eval_metrics = pd.DataFrame(d, columns=['model', 'runtime', 'Logloss', 'AUC'])
eval_metrics 
#      model    runtime   Logloss       AUC
#0     H2ORF   1.138052  0.261905  0.918125
#1    H2OGBM   0.674695  0.200653  0.913656
#2  CatBoost  22.625454  0.109811  0.952381

