# title : newsletter
# author : Hyunseo Kim
# depends : wordcloud, htmlwidgets, stringr, data.table, NLP, openNLP, pluralize


# library 
library(wordcloud)
library(htmlwidgets)
library(stringr)
library(data.table)
library(NLP)
library(openNLP)
library(pluralize)

# path 
path_local <- "https://github.com/2econsulting/2econsulting.github.io/code/newsletter/"
path_git <- "https://github.com/2econsulting/2econsulting.github.io/data/newsletter/"

# necessary function
filename <- paste0(path_local,"src/text_mining_function.R")
source(filename)

# load data
fileName <- paste0(path_git,"input/total_",gsub("-", "", Sys.Date()),".csv")
total <- read.csv(fileName)

# load dictionary
fileName <- paste0(path_local,"input/dictionary.csv")
dictionary <- read.csv(fileName)

# data
tmp_text <- total$text
freq_table <- KeywordExtract(tmp_text)

# filtering
freq_table <- as.data.table(freq_table)
freq_table <- freq_table[!(freq_table$word %in% dictionary$rm_word), ]

# front img save
fileName <- paste0(path_git,"input/png/wordcloud.png")
if (file.exists(fileName)) file.remove(fileName)
png(fileName, width = 5, height = 5, unit = 'in', res = 500)
wordcloud(freq_table$word, freq_table$freq, min.freq = 1, max.words = 200, rot.per = 0.1, random.order = FALSE, colors = brewer.pal(8, "Dark2"), scale = c(4, 0.5))
dev.off()

# weekly img save
fileName <- paste0(path_git,"output/report/wordcloud_",gsub("-", "", Sys.Date()),".png")
if (file.exists(fileName)) file.remove(fileName)
png(fileName, width = 5, height = 5, unit = 'in', res = 500)
wordcloud(freq_table$word, freq_table$freq, min.freq = 1, max.words = 200, rot.per = 0.1, random.order = FALSE, colors = brewer.pal(8, "Dark2"), scale = c(4, 0.5))
dev.off()
