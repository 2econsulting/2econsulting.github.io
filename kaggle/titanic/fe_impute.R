

fe_impute <- function(data){
  for(i in names(which(sapply(data, is.numeric)))){
    miss_index <- which(is.na(data[,i]))
    data[miss_index, i] <- median(data[, i], na.rm=TRUE)
  }
  return(data)
}