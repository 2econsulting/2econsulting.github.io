# title : Comparison of Recommender Systems 
# author : Hyunseo Kim

#library(devtools)
#install_github(repo = "SVDApproximation", username = "tarashnot")
library(data.table)
library(recommenderlab)
library(recosystem)
library(SVDApproximation) 
library(rrecsys)
library(slimrec)
# 1M MovieLense dataset.
ratings <- fread("../data/movielense.csv")
class(ratings)

# Data preparation: tidy format data is converted to spars matrix 
sparse_ratings <- sparseMatrix(
  i = ratings$user, 
  j = ratings$item, 
  x = ratings$rating, 
  dims = c(length(unique(ratings$user)), 
           length(unique(ratings$item))),
  dimnames = list(paste("u", 1:length(unique(ratings$user)), 
                        sep = ""),
                  paste("m", 1:length(unique(ratings$item)), 
                        sep = "")
  )
)

# recommenderlab ----
# Check the available algorithms
names(
  recommenderRegistry$get_entries(
    dataType = "realRatingMatrix")
)

# Data formatting
real_ratings <- new(
  "realRatingMatrix", 
  data = sparse_ratings)
real_ratings

# Data splitting for validation 
set.seed(1)
eval <- evaluationScheme(
  real_ratings, 
  method="split", 
  train=0.7, 
  given=-5)

# function : make model -> predict -> calculate RMSE ----
RecoCreate <- function(data, method){
  Type <- c()
  Time <- c()
  rmse <- c()
  for (i in method){
    set.seed(1)
    start <- Sys.time()
    model <- Recommender(
      getData(data, "train"), 
      method = i
    )
    prediction <- recommenderlab::predict(
      model, 
      getData(data, "known"), 
      type="ratings"
    )
    RMSE_tmp <- calcPredictionAccuracy(
      prediction, 
      getData(data, "unknown"))[1]
    end <- Sys.time()
    Type <- c(Type, i)
    Time <- c(Time, end - start)
    rmse <- c(rmse, RMSE_tmp)
  }
  result <- data.frame(RecType = Type, RunTime = Time, RMSE = rmse)
  print(result)
  return(result)
}
method <- c("POPULAR", "SVD", "UBCF", "IBCF", "SVDF", "RANDOM", "ALS")
result <- RecoCreate(eval, method)

# recosystem ----
ratings <- fread("../data/movielense.csv")
in_train <- rep(TRUE, nrow(ratings))
in_train[sample(1:nrow(ratings), 
                size = round(0.2 * length(unique(ratings$user)), 
                             0) * 5)] <- FALSE

ratings_train <- ratings[(in_train)]
ratings_test <- ratings[(!in_train)]

write.table(ratings_train, file = "trainset.txt", sep = " ", row.names = FALSE, col.names = FALSE)
write.table(ratings_test, file = "testset.txt", sep = " ", row.names = FALSE, col.names = FALSE)

recc = Reco()
start <- Sys.time()
opts <- recc$tune(
  "trainset.txt", 
  opts = list(dim = c(5, 10, 20, 30), # latent factor
              lrate = c(0.05), # gradient descent step rate
              costp_l1 = 0,
              costq_l1 = 0,
              nthread = 1, 
              niter = 50, 
              nfold = 3, 
              verbose = FALSE)
)

start <- Sys.time()
recc$train(
  "trainset.txt", 
  opts = c(opts$min, 
           nthread = 1, 
           niter = 50, 
           verbose = FALSE)
)
outfile = tempfile()

recc$predict(
  "testset.txt", 
  outfile)

scores_real <- read.table(
  "testset.txt", 
  header = FALSE, 
  sep = " ")$V3
scores_pred <- scan(outfile)

rmse_mf <- sqrt(mean((scores_real-scores_pred) ^ 2))
rmse_mf
end <- Sys.time()
end - start

# SVDApproximation ----
ratings <- fread("../data/movielense.csv")
set.seed(1)
start <- Sys.time()
mtx <- split_ratings(ratings_table = ratings, 
                     proportion = c(0.7, 0.15, 0.15))
model <- svd_build(mtx)
model_tunes <- svd_tune(model, r = 2:50)
model_tunes$train_vs_valid
rmse_svd <- svd_rmse(model, r = model_tunes$r_best, rmse_type = c("test"))
end <- Sys.time()
rmse_svd
end - start

# rrecsys ----
ratings <- fread("../data/movielense.csv")
sparse_ratings <- sparseMatrix(
  i = ratings$user, 
  j = ratings$item, 
  x = ratings$rating, 
  dims = c(length(unique(ratings$user)), 
           length(unique(ratings$item))),
  dimnames = list(paste("u", 1:length(unique(ratings$user)), 
                        sep = ""),
                  paste("m", 1:length(unique(ratings$item)), 
                        sep = "")
  )
)

sparse_ratings[is.na(sparse_ratings)] <- 0
sparse_ratings <- as.matrix(sparse_ratings)
sparse_ratings <- defineData(sparse_ratings)

RecoCreate <- function(data, method){
  Type <- c()
  Time <- c()
  rmse <- c()
  grobal_rmse <- c()
  eval <- evalModel(data, folds = 3)
  for (i in method){
    set.seed(1)
    start <- Sys.time()
    if (i == "wALS") {
      result <- evalPred(eval, i, scheme = "co")
    } else {
      result <- evalPred(eval, i)
    }
    end <- Sys.time()
    Type <- c(Type, i)
    Time <- c(Time, end - start)
    rmse <- c(rmse, result$RMSE[4])
    grobal_rmse <- c(grobal_rmse, result$globalRMSE[4])
  }
  result <- data.frame(RecType = Type, 
                       RunTime = Time, 
                       RMSE = rmse, 
                       GlobalRMSE = grobal_rmse)
  print(result)
  return(result)
}
method <- c("itemAverage", "userAverage", "globalAverage", 
            "IBKNN", "UBKNN", "funkSVD", "wALS", "BPR", "SlopOne")
result <- RecoCreate(sparse_ratings, method)

# slimrec ----
ratings <- fread("../data/movielense.csv")
sparse_ratings <- sparseMatrix(
  i = ratings$user, 
  j = ratings$item, 
  x = ratings$rating, 
  dims = c(length(unique(ratings$user)), 
           length(unique(ratings$item))),
  dimnames = list(paste("u", 1:length(unique(ratings$user)), 
                        sep = ""),
                  paste("m", 1:length(unique(ratings$item)), 
                        sep = "")
  )
)
mtx <- as.matrix(sparse_ratings@data)
mtx[is.na(mtx)] <- 0
dgCmtx <- as(mtx, "dgCMatrix")
gc()
set.seed(1)
start <- Sys.time()
model <- slim(dgCmtx,
              alpha = 0.5, 
              nonNegCoeff = TRUE, 
              coeffMat = TRUE, 
              returnMat = TRUE, 
              computeRMSE = TRUE, 
              nproc = 1L,
              progress = TRUE, 
              check = TRUE, 
              cleanup = FALSE)
end <- Sys.time()
end - start
model$nonZeroRMSE

# SmartCat-labs’s Git R code ----
source("../_posts_w_code/cf_algorithm.R")

ratings <- fread("../data/movielense.csv")
sparse_ratings <- sparseMatrix(
  i = ratings$user, 
  j = ratings$item, 
  x = ratings$rating, 
  dims = c(length(unique(ratings$user)), 
           length(unique(ratings$item))),
  dimnames = list(paste("u", 1:length(unique(ratings$user)), 
                        sep = ""),
                  paste("m", 1:length(unique(ratings$item)), 
                        sep = "")
  )
)

RecoCreate <- function(data, method){
  Type <- c()
  Time <- c()
  rmse <- c()
  for (i in method){
    set.seed(1)
    start <- Sys.time()
    result <- evaluate_cf(ratings_matrix, number_of_folds = 10, alg_method = i, normalization = TRUE, 
                          similarity_metric = cal_cos, k = 300, make_positive_similarities = FALSE, 
                          rowchunk_size = 1000, columnchunk_size = 2000)
    end <- Sys.time()
    Type <- c(Type, i)
    Time <- c(Time, end - start)
    rmse <- c(rmse, result[[2]])
  }
  result <- data.frame(RecType = Type, 
                       RunTime = Time, 
                       RMSE = rmse)
  print(result)
  return(result)
}

method <- c("ibcf", "ubcf")
result <- RecoCreate(ratings_matrix, method)
