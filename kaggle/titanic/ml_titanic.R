# title : titanic from kaggle
# authro : jacob
# desc : apply rAutoML 
# remove.packages("rAutoML")
# library(devtools)
# install_github("2econsulting/rAutoML")

# settting
path = "C:/Users/jacob/Documents/Kaggle/titanic"
setwd(path)
source('fe_titanic.R')
library(rAutoML)
library(h2o)

# prepare data 
data <- read.csv("./input/train.csv")
data <- fe_titanic(data)
data$Survived <- as.factor(data$Survived)
h2o.init()
data_hex <- as.h2o(data)
y <- "Survived"
x <- setdiff(names(data_hex), y)
split_hex <- h2o.splitFrame(data = data_hex, ratios = c(0.5,0.3), seed = 1234)
train_hex <- split_hex[[1]]
valid_hex <- split_hex[[2]]
test_hex  <- split_hex[[3]]

# apply rAutoML  
ml <- autoGBM(
  x, y, 
  train_hex, 
  valid_hex, 
  test_hex, 
  model_path="./output"
)
ml['autoGBM_eval']
# $`autoGBM_eval`
# models       auc   logloss
# 1   H2OGBM_Default 0.8724854 0.4314237
# 2 H2OGBM_StopRules 0.8784059 0.4129305
# 3 H2OGBM_CatEncode 0.8955946 0.4013556
# 4  H2OGBM_MaxDepth 0.8962949 0.3991634
# 5    H2OGBM_Random 0.8934938 0.4027882
# 6  H2OGBM_Bayesian 0.8845811 0.4187242

# make submission 
newdata <- read.csv("./input/test.csv")
newdata <- fe_titanic(newdata)
newdata_hex <- as.h2o(newdata)
bestml <- ml['autoGBM_Models'][[1]]$H2OGBM_Bayesian
output <- predict(bestml, newdata=newdata_hex)
output <- as.data.frame(output)
submission <- read.csv("./output/submission.csv")
submission$Survived <- output$predict
write.csv(submission, "./output/submission.csv", row.names=FALSE)





