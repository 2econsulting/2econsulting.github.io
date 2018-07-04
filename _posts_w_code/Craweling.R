library(rvest)
library(ggplot2)
library(dplyr)
library(stringr)
library(data.table)
library(plotly)
library(htmlwidgets)
library(RColorBrewer)
library(R2HTML)
library(tm)

# test
# getwd()
# path <- ""

# 환경, 키워드 조건 세팅 ----
path <- "./2econsulting/"

args = (commandArgs(TRUE))
if(length(args)==0){
  print("No arguments supplied.")
  ##supply default values
  keyword = c("machine learning", 
              "Deep learning",
              "R error",
              "R problem",
              "kaggle competition",
              "h2o",
              "python",
              "R package",
              "useful",
              "efficient")
}else{
  for(i in 1:length(args)){
    eval(parse(text=args[[i]]))
  }
}
print(keyword)

tmp_keyword <- c()
for (i in keyword){
  tmp <- gsub(" ", "%20", i)
  tmp_keyword <- c(tmp_keyword, tmp)
  keyword <- tmp_keyword
}

# 데이터 수집 ----
# Get the all url(limit: 5 pages) for keyword 
page <- c("","page=2&","page=3&","page=4&","page=5&")
total_url <- list()
for (j in keyword){
  total_url[[j]] <- list(paste0(j,"_url"))
  each_url <- c()
  for (i in page){
    tmp_url  <- paste0("https://stackoverflow.com/search?",i,"tab=Newest&q=",j)
    each_url <- c(each_url, tmp_url)
    total_url[[j]] <- each_url
  }
}

# Get the time limited url (within 24hour)
for (j in keyword){
  time <- c()
  use_url <- c()
  for (i in total_url[[j]]) {
    print(i)
    tmp <- read_html(i) %>% html_nodes('.relativetime') %>% html_text()
    use_url <- c(use_url, i)
    if (any(stringr::str_detect(tmp, 'hour') %in% FALSE)) { break }
    Sys.sleep(3)
  }
  total_url[[j]] <- use_url
}

# Get the text data
Sys.sleep(3)
total_result <- data.frame(keyword = character(), 
                           time = character(), 
                           title = character(), 
                           stringsAsFactors=FALSE)
for (j in keyword){
  time <- c()
  title <- c()
  for (i in total_url[[j]]) {
    print(i)
    tmp_time  <- read_html(i) %>% html_nodes('.relativetime') %>% html_text()
    Sys.sleep(3)
    tmp_title <- read_html(i) %>% html_nodes('.result-link') %>% html_text()
    time <- c(time, tmp_time)
    title <- c(title, tmp_title)
    Sys.sleep(3)
    result <- data.frame(keyword = as.character(j),
                         time = as.character(time), 
                         title = as.character(title))
  }
  total_result <- rbind(total_result, result)
}

# Clean the text
rm_term <- c("\r\n                \r\n\r\n    \r\n", 
             "\r\n    \r\n\r\n            ",
             "    \r\n\r\n            ",
             "        ",
             "Q: ",
             "A: ")
for (i in rm_term) {
  total_result$title <- gsub(i, "", total_result$title)
}

# Get the time limited text
total_result <- as.data.table(total_result)
total_result <- total_result[stringr::str_detect(total_result$time, 'hour') == TRUE,]

filename <- paste0(path,"data/newsletter/input/",gsub("-", "", substr(Sys.time(), 1, 10)),".csv")
write.csv(total_result, filename, row.names = FALSE)

# 시각화(표와 차트) ----
# Frequency table
corpus <- Corpus(VectorSource(total_result$title))

skipWords <- function(x) removeWords(x, stopwords("english"))
corpus <- tm_map(corpus, FUN = tm_reduce, tmFuns = list(tolower))
corpus <- tm_map(corpus, FUN = tm_reduce, tmFuns = list(skipWords, removePunctuation, stripWhitespace, removeNumbers, stemDocument))

dtm <- DocumentTermMatrix(corpus)
tdm <- TermDocumentMatrix(corpus)

freq_words <- colnames(t(findMostFreqTerms(dtm, n = 10, INDEX = rep(1, dtm$nrow))[[1]]))
freq_words

m <- t(as.matrix(dtm)) 
freq_table <- data.frame(term = rownames(m), 
                         freq = rowSums(m), 
                         row.names = NULL)
freq_table <- freq_table[order(-freq_table$freq),][1:10,]
rownames(freq_table) <- 1:nrow(freq_table)

# Save
dfname_html <- paste0(path,"data/newsletter/output/",gsub("-", "", substr(Sys.time(), 1, 10)),"_table",".csv")
write.csv(freq_table, dfname_html, row.names = FALSE)
Sys.sleep(1)

# Frequency bar plot
title <- paste0("Word Frequency Top 10", " (", substr(Sys.time(), 1, 10), " )\n")
ggplot(freq_table, aes(x =reorder(term, freq), y = freq, fill = term)) + 
  geom_bar(stat="identity", show.legend=F) +
  scale_fill_hue(c=45, l=80) +
  coord_flip() +
  geom_text(aes(label = freq), vjust = 0.5, size = 4) +
  labs(y = "Frequency", title = title) +
  theme(plot.title = element_text(hjust = 0.5),
        axis.ticks=element_blank(),
        axis.title.y=element_blank(),
        legend.position="none",
        panel.background=element_blank())

# Save
chartname <- paste0(path,"data/newsletter/output/",gsub("-", "", substr(Sys.time(), 1, 10)),"_chart",".png")
ggplot2::ggsave(chartname)
Sys.sleep(1)

# Display
chartname <- paste0(path,"chart",".png")
if (file.exists(chartname)) file.remove(chartname)
ggplot2::ggsave(chartname)
