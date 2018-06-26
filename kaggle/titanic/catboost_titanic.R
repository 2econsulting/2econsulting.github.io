# title : titanic from kaggle
# authro : jacob
# desc : apply rAutoML 
remove.packages("rAutoML")
library(devtools)
install_github("2econsulting/rAutoML")

# settting
path = "C:/Users/jacob/Documents/Kaggle/titanic"
setwd(path)
source('fe_titanic.R')
library(rAutoML)
library(rAutoFE)
library(catboost)

# prepare data 
data <- read.csv("./input/train.csv")
data <- fe_titanic(data)
data$Survived <- as.numeric(data$Survived)


# Transform categorical features to numeric.
for (i in cat_features){
  data[,i] <- as.numeric(factor(data[,i]))
}


target_idx <- which(colnames(data)=="Survived")
splits <- rAutoFE::splitFrame(dt=data, ratio=c(0.5, 0.3), seed=1234)
train  <- rbind(splits[[1]], splits[[2]])
test   <- splits[[3]]
str(train)



# convert train data.frame to catboost.pool 
train_pool <- catboost.load_pool(
  data = train[,-target_idx],
  label = train[,target_idx],
  cat_features = which(sapply(train[,-target_idx], is.factor))
)

# convert test data.frame to catboost.pool 
test_pool <- catboost.load_pool(
  data = test[,-target_idx], 
  label = test[,target_idx], 
  cat_features = which(sapply(test[,-target_idx], is.factor))
)

# train catboost
params <- list(
  loss_function = 'Logloss',
  random_seed = 1234,
  custom_loss = "AUC",
  train_dir = "CatBoost_output"
)
CatBoost <- catboost.train(learn_pool=train_pool, test_pool=test_pool, params=params)

# performance CatBoost
test_error <- read.table("CatBoost_output/test_error.tsv", sep = "\t", header = TRUE)
CatBoost_eval <- test_error[which.max(test_error$AUC), c("Logloss", "AUC")]
CatBoost_eval

# make submission 
newdata <- read.csv("./input/test.csv")
newdata <- fe_titanic(newdata)
newdata_pool <- catboost.load_pool(
  data = newdata[,-target_idx],
  cat_features = which(sapply(newdata[,-target_idx], is.factor))
)

str(newdata)
catboost.predict(CatBoost, newdata_pool,  prediction_type="Class")



bestml <- ml['autoGBM_Models'][[1]]$H2OGBM_Random
output <- predict(bestml, newdata=newdata_hex)
output <- as.data.frame(output)
submission <- read.csv("./output/submission.csv")
submission$Survived <- output$predict
write.csv(submission, "./output/submission.csv", row.names=FALSE)





