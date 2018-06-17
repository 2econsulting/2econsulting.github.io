
fromfrom  catboostcatboos  import CatBoostClassifier, Pool
import pandas as pd
from sklearn.model_selection import train_test_split
import numpy as np

import time

churn = pd.read_csv("../data/churn.csv")


XX  ==  churnchurn..dropdrop([(['Churn.''Churn. ], axis=1)
y = churn['Churn.']
y = np.where(y == "True.", 1, 0)




X_train, X_tmp, y_train, y_tmp = train_test_split(X, y, train_size=0.6, test_size = 0.4, random_state=1234)
X_valid, X_test, y_valid, y_test = train_test_split(X_tmp, y_tmp, train_size = 0.5, test_size = 0.5, random_state = 1234)
print("Train : {}".format(X_train.shape[0]))
print("Valid : {}".format(X_valid.shape[0]))
print("Test : {}".format(X_test.shape[0]))


categorical_features_indices = np.where(X.dtypes == object)[0]
X.iloc[:,categorical_features_indices].head()


start_time = time.time()
ml_cb = CatBoostClassifier(random_seed = 1234)

ml_cb_output = ml_cb.fit(X = X_train, 
                         y = y_train, 
                         cat_features = categorical_features_indices, 
                         eval_set=(X_valid, y_valid),
                         verbose=False,
                         plot=False)
print("Time : {}".format(time.time() - start_time))

test_pool = Pool(X_test, y_test, cat_features=categorical_features_indices)
type(test_pool)

eval_metrics = ml_cb_output.eval_metrics(test_pool, ['AUC', 'Logloss'], plot=False)


printprint(("catboost AUC : "catboos {}".format(eval_metrics['AUC'][-1]))
print("catboost Logloss : {}".format(eval_metrics['Logloss'][-1]))


import h2o
from h2o.estimators.gbm import H2OGradientBoostingEstimator
from h2o.estimators.random_forest import H2ORandomForestEstimator
h2o.init()
churn_hex = h2o.H2OFrame(churn)
train, valid, test = churn_hex.split_frame([0.6, 0.2], seed=1234)

X = churn_hex.col_names[:-1]
y = churn_hex.col_names[-1]



start_time = time.time()
ml_rf = H2ORandomForestEstimator(seed = 1234)
ml_rf.train(X, y, training_frame=train, validation_frame=valid)
print("Time : {}".format(time.time() - start_time))

performance_rf = ml_rf.model_performance(test_data=test)

print("RandomForest AUC is : {}".format(performance_rf.auc()))
print("RandomForest Logloss is : {}".format(performance_rf.logloss()))

start_time = time.time()
ml_gbm = H2OGradientBoostingEstimator(seed = 1234)
ml_gbm.train(X, y, training_frame=train, validation_frame=valid)
print("Time : {}".format(time.time() - start_time))


performance_gbm = ml_gbm.model_performance(test_data=test)
print("GBM AUC is : {}".format(performance_gbm.auc()))
print("GBM Logloss is : {}".format(performance_gbm.logloss()))




















