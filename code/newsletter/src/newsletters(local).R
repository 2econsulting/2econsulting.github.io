# writer : Hyunseo Kim


# library
library(rvest)
library(dplyr)
library(stringr)
library(data.table)
library(R2HTML)
library(NLP)
library(openNLP)
options(timeout= 4000000)

# path
path_local <- "C:/Users/user/Documents/ds/2econsulting/newsletter/"
path_git <- "C:/Users/user/Documents/2econsulting.github.io/data/newsletter/"

# necessary function
filename <- paste0(path_local,"src/function_craweling.R")
source(filename)

# limit time (1 week)
from <- substr(as.character(format(Sys.time()-(7*24*60*60), "%Y-%m-%d %H:%M:%00")),1, 10)
to   <- substr(as.character(format(Sys.time(), "%Y-%m-%d %H:%M:%00")), 1, 10)

# analyticsvidhya ----
filename <- paste0(path_local,"src/vidhya.R")
source(filename)


# kaggle blog ----
filename <- paste0(path_local,"src/kaggle.R")
source(filename)


# datacamp blog ----
filename <- paste0(path_local,"src/datacamp.R")
source(filename)

# machine learning mastery ----
filename <- paste0(path_local,"src/mastery.R")
source(filename)


# total data
total <- rbind(kaggle, datacamp, mastery, vidhya)
filename <- paste0(path_git,"input/total_",gsub("-", "", Sys.Date()),".csv")
write.csv(total, filename, row.names = FALSE)

rm(list = ls())
