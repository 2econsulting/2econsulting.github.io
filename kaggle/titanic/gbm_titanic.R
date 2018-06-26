# title : titanic from kaggle
# authro : jacob
# desc : apply rAutoML 
# remove.packages("rAutoML")
# library(devtools)
# install_github("2econsulting/rAutoML")

# settting
path = "C:/Users/jacob/Documents/Kaggle/titanic"
setwd(path)
savePath <- "./output"
source('fe_titanic.R')
source('fe_impute.R')
library(rAutoML)
library(rAutoFE)
library(rAutoFS)
library(data.table)
library(h2o)

# prepare data 
data <- read.csv("./input/train.csv")
data <- fe_titanic(data)
data$Survived <- as.factor(data$Survived)
data <- fe_impute(data)
setDT(data)
splits <- splitFrame(dt=data, ratio = c(0.5, 0.3), seed=1234)
train <- splits[[1]]
valid <- splits[[2]]
test  <- splits[[3]]
y <- "Survived"
x = colnames(train)[colnames(train)!=y]
h2o.init()
train_hex <- as.h2o(train)
valid_hex <- as.h2o(valid)
test_hex  <- as.h2o(test)
ml <- autoGBM(x, y, train_hex, valid_hex, test_hex, model_path="./output",init_points = 20, n_iter = 5)
ml['autoGBM_eval']






# make submission 
newdata <- read.csv("./input/test.csv")
newdata <- fe_titanic(newdata)
newdata_hex <- as.h2o(newdata)
bestml <- ml['autoGBM_Models'][[1]]$H2OGBM_Random
output <- predict(bestml, newdata=newdata_hex)
output <- as.data.frame(output)
submission <- read.csv("./output/submission.csv")
submission$Survived <- output$predict
write.csv(submission, "./output/submission.csv", row.names=FALSE)


