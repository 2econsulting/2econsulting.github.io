library(rvest)
library(dplyr)
library(stringr)
library(data.table)
library(R2HTML)
library(htmlwidgets)
library(NLP)
library(openNLP)
require(devtools)
# install_github("lchiffon/wordcloud2")
library(wordcloud2)

KeywordExtract <- function(tmp_text, ...){
  s <- as.String(tmp_text)
  word_token_annotator <- Maxent_Word_Token_Annotator()
  a2 <- Annotation(1L, "sentence", 1L, nchar(s))
  a2 <- annotate(s, word_token_annotator, a2)
  a3 <- annotate(s, Maxent_POS_Tag_Annotator(), a2)
  a3w <- a3[a3$type == "word"]
  POStags <- unlist(lapply(a3w$features, `[[`, "POS"))
  POStagged <- paste(sprintf("%s/%s", s[a3w], POStags), collapse = " ")
  Tag <- list(POStagged = POStagged, POStags = POStags)
  Sys.sleep(3)
  prp1 <- str_extract_all(Tag$POStagged,"\\w+/NNS\\$?")
  prp2 <- str_extract_all(Tag$POStagged,"\\w+/NNP\\$?")
  prp3 <- str_extract_all(Tag$POStagged,"\\w+/NN\\$?")
  prp1 <- str_replace(unlist(prp1), "/NNS\\$?", "")
  prp2 <- str_replace(unlist(prp2), "/NNP\\$?", "")
  prp3 <- str_replace(unlist(prp3), "/NN\\$?", "")
  tmp <- list(prp1, prp2, prp3)
  freq_table  <- as.data.frame.table(table(unlist(tmp)))
  names(freq_table) <- c("Keyword", "Frequency")
  freq_table$Keyword <- as.character(freq_table$Keyword)
  freq_table <- subset(freq_table, nchar(Keyword) > 2)
  freq_table <- freq_table[with(freq_table, order(-Frequency)),][1:10,]
  rownames(freq_table) <- 1:nrow(freq_table)
  return(freq_table)
}

###### Local ############################################################
path <- "D:/2e_seo/2econsulting/"

from <- substr(as.character(format(Sys.time()-(14*24*60*60), "%Y-%m-%d %H:%M:%00")),1, 10)
to   <- substr(as.character(format(Sys.time(), "%Y-%m-%d %H:%M:%00")), 1, 10)

# analyticsvidhya ----
# Get the url 
i <- "https://www.analyticsvidhya.com/blog-archive/"
tmp_time  <- read_html(i) %>% html_nodes('.entry-date') %>% html_text()
tmp_time <- gsub("\n","",tmp_time)
tmp_time <- gsub("\n ","",tmp_time)
tmp_time <- gsub(paste0(substr(from, 1, 4), " "),"2018",tmp_time)
tmp_time <- gsub(paste0(substr(to, 1, 4), " "),"2018",tmp_time)
tmp_time <- gsub(",","",tmp_time)
tmp_time <- gsub(" J","J",tmp_time)

# 일자 변수 변환: format에서 %B가 안되기 때문에 숫자로 변환 후 %m 이용 
tmp_time <- gsub("January", 1, tmp_time)
tmp_time <- gsub("February", 2, tmp_time)
tmp_time <- gsub("March", 3, tmp_time)
tmp_time <- gsub("April", 4, tmp_time)
tmp_time <- gsub("May", 5, tmp_time)
tmp_time <- gsub("June", 6, tmp_time)
tmp_time <- gsub("July", 7, tmp_time)
tmp_time <- gsub("August", 8, tmp_time)
tmp_time <- gsub("September", 9, tmp_time)
tmp_time <- gsub("October", 10, tmp_time)
tmp_time <- gsub("November", 11, tmp_time)
tmp_time <- gsub("December", 12, tmp_time)
tmp_time <- as.Date(tmp_time, format = '%m %d %Y')

# Get the title
tmp_head <- read_html(i) %>% html_nodes('.entry-title') %>% html_text()
tmp_head <- tmp_head[!(tmp_head %in% tmp_head[[1]])]
tmp_head <- gsub("\n\n","",tmp_head)
tmp_head <- gsub(" \n","",tmp_head)
# tmp_head <- gsub("– ","",tmp_head)

# Get the url
tmp_url <- read_html(i) %>% html_nodes('.entry-title a') %>% html_attr('href')

# make data frame
vidhya <- data.frame(date = tmp_time, headline = tmp_head, url_address = tmp_url)
vidhya <- as.data.table(unique(vidhya))

# Get the valid information 
vidhya <- vidhya[from < vidhya$date & to >= vidhya$date, ]

# Collect the data from valid url
tmp_text <- c()
for (i in vidhya[["url_address"]]){
  tmp <- read_html(i) %>% html_nodes('p') %>% html_text() 
  #tmp_text <- read_html(i) %>% html_nodes('.text-content') %>% html_text() 
  tmp <- tmp[1:(length(tmp)-11)] # remove advertisement
  tmp <- tmp[str_length(tmp)>1] # remove empty line
  #tmp <- tmp[!(tmp %in% rm_ment)]
  tmp <- paste(unlist(tmp), collapse =" ")
  tmp_text <- c(tmp_text, tmp)
  Sys.sleep(3)
}

vidhya$text <- tmp_text
filename <- paste0(path,"data/newsletter/input/",gsub("-", "", substr(Sys.time(), 1, 10)),"_vidhya.csv")
write.csv(vidhya, filename, row.names = FALSE)

html <- paste0('<ul><li><a href="',vidhya$url_address,'">',vidhya$headline,'</a></li></ul>')
write.table(html, paste0(path,"data/newsletter/input/html/vidhya_out.html"), row.names = FALSE, col.names = FALSE, quote = FALSE)
write.csv(html, "out.csv")


###### Server ############################################################ 
freq_table <- KeywordExtract(tmp_text)

# Save into the output folder
dfname_html <- paste0(path,"data/newsletter/output/",gsub("-", "", substr(Sys.time(), 1, 10)),"_vidhya",".html")
R2HTML::HTML(freq_table,file= dfname_html)
Sys.sleep(1)

# Display
dfname_html <- paste0(path,"data/newsletter/input/html/vidhya_table",".html")
if (file.exists(dfname_html)) file.remove(dfname_html)
R2HTML::HTML(freq_table, file= dfname_html)


# kaggle blog ----
# Get the url
i <- "http://blog.kaggle.com/"
tmp_time  <- read_html(i) %>% html_nodes('.entry-date') %>% html_text()
Sys.sleep(3)
tmp_time <- as.Date(tmp_time, format = '%m. %d. %Y')

# Get the title
tmp_head <- read_html(i) %>% html_nodes('.entry-title') %>% html_text()
tmp_head <- gsub("\n      ","",tmp_head)
tmp_head <- gsub("\n    ","",tmp_head)

# Get the url
tmp_url <- read_html(i) %>% html_nodes('.entry-featured a') %>% html_attr('href')

# make data frame
kaggle <- data.frame(date = tmp_time, headline = tmp_head, url_address = tmp_url)
kaggle <- as.data.table(unique(kaggle))

# Get the valid information 
kaggle <- kaggle[from < kaggle$date & to >= kaggle$date, ]

# Collect the data from valid url
tmp <- c()
for (i in kaggle[["url_address"]]){
  if (length(kaggle) !=  0)
  tmp <- read_html(i) %>% html_nodes('p') %>% html_text() 
  tmp <- tmp[2:(length(tmp)-9)] # remove advertisement
  tmp <- tmp[str_length(tmp)>1] # remove empty line
  tmp <- paste(unlist(tmp), collapse =" ")
  Sys.sleep(3)
  tmp_text <- c(tmp_text, tmp)
}
kaggle$text <- tmp_text
filename <- paste0(path,"data/newsletter/input/",gsub("-", "", substr(Sys.time(), 1, 10)),"_kaggle.csv")
write.csv(kaggle, filename, row.names = FALSE)

html <- paste0('<ul><li><a href="',kaggle$url_address,'">',kaggle$headline,'</a></li></ul>')
write.table(html, paste0(path,"data/newsletter/input/html/kaggle_out.html"), row.names = FALSE, col.names = FALSE, quote = FALSE)

###### Server ############################################################ 
freq_table <- KeywordExtract(tmp_text)

# Save into the output folder
dfname_html <- paste0(path,"data/newsletter/output/",gsub("-", "", substr(Sys.time(), 1, 10)),"_kaggle",".html")
R2HTML::HTML(freq_table,file= dfname_html)
Sys.sleep(1)

# Display
dfname_html <- paste0(path,"data/newsletter/input/html/kaggle_table",".html")
if (file.exists(dfname_html)) file.remove(dfname_html)
R2HTML::HTML(freq_table, file= dfname_html)


# datacamp blog ----
# Get the time
i <- "https://www.datacamp.com/community/blog"
tmp_time  <- read_html(i) %>% html_nodes('.jsx-566588255 a .date') %>% html_text()

# 일자 변수 변환: format에서 %B가 안되기 때문에 숫자로 변환 후 %m 이용 
tmp_time <- gsub("st","",tmp_time)
tmp_time <- gsub("nd","",tmp_time)
tmp_time <- gsub("rd","",tmp_time)
tmp_time <- gsub("th","",tmp_time)

tmp_time <- gsub("January", 1, tmp_time)
tmp_time <- gsub("February", 2, tmp_time)
tmp_time <- gsub("March", 3, tmp_time)
tmp_time <- gsub("April", 4, tmp_time)
tmp_time <- gsub("May", 5, tmp_time)
tmp_time <- gsub("June", 6, tmp_time)
tmp_time <- gsub("July", 7, tmp_time)
tmp_time <- gsub("August", 8, tmp_time)
tmp_time <- gsub("September", 9, tmp_time)
tmp_time <- gsub("October", 10, tmp_time)
tmp_time <- gsub("November", 11, tmp_time)
tmp_time <- gsub("December", 12, tmp_time)
tmp_time <- as.Date(tmp_time, format = '%m %d, %Y')

# Get the title
tmp_head <- read_html(i) %>% html_nodes('h2') %>% html_text()

# Get the url
tmp_url <- read_html(i) %>% html_nodes('h2 a') %>% html_attr('href')
url_list <- c()
for (i in tmp_url){
  tmp <- paste0("https://www.datacamp.com",i)
  url_list <- c(url_list, tmp)
}

# make data frame
datacamp <- data.frame(date = tmp_time, headline = tmp_head, url_address = url_list)
datacamp <- as.data.table(unique(datacamp))

# Get the valid information 
datacamp <- datacamp[from < datacamp$date & to >= datacamp$date, ]

# Collect the data from valid url
tmp_text <- c()
for (i in datacamp[["url_address"]]){
  tmp <- read_html(i) %>% html_nodes('p') %>% html_text() 
  tmp <- tmp[str_length(tmp)>1] # remove empty line
  tmp <- tmp[2:(length(tmp))] # remove advertisement
  #tmp <- tmp[!(tmp %in% rm_ment)]
  tmp <- paste(unlist(tmp), collapse =" ")
  tmp_text <- c(tmp_text, tmp)
  Sys.sleep(3)
}

datacamp$text <- tmp_text
filename <- paste0(path,"data/newsletter/input/",gsub("-", "", substr(Sys.time(), 1, 10)),"_datacamp.csv")
write.csv(datacamp, filename, row.names = FALSE)

html <- paste0('<ul><li><a href="',datacamp$url_address,'">',datacamp$headline,'</a></li></ul>')
write.table(html, paste0(path,"data/newsletter/input/html/datacamp_out.html"), row.names = FALSE, col.names = FALSE, quote = FALSE)

###### Server ############################################################ 
freq_table <- KeywordExtract(tmp_text)

# Save into the output folder
dfname_html <- paste0(path,"data/newsletter/output/",gsub("-", "", substr(Sys.time(), 1, 10)),"_datacamp",".html")
R2HTML::HTML(freq_table,file= dfname_html)
Sys.sleep(1)

# Display
dfname_html <- paste0(path,"data/newsletter/input/html/datacamp_table",".html")
if (file.exists(dfname_html)) file.remove(dfname_html)
R2HTML::HTML(freq_table, file= dfname_html)

# machine learning mastery ----
# Get the valid url (time limit : one week) 
i <- "https://machinelearningmastery.com/blog/"
Sys.sleep(3)
tmp_time <- read_html(i) %>% html_nodes('abbr') %>% html_attr("title")
tmp_time <- as.Date(substr(as.character(tmp_time),1,10), "%Y-%m-%d")

# Get the title
tmp_head <- read_html(i) %>% html_nodes('h2') %>% html_text()

# Get the url
tmp_url <- read_html(i) %>% html_nodes('h2 a') %>% html_attr('href')

# make data frame
mastery <- data.frame(date = tmp_time, headline = tmp_head, url_address = tmp_url)
mastery <- as.data.table(unique(mastery))

# Get the valid information 
mastery <- mastery[from < mastery$date & to >= mastery$date, ]

# Collect the data from valid url
tmp_text <- c()
for (i in mastery[["url_address"]]){
  tmp <- read_html(i) %>% html_nodes('p') %>% html_text() 
  #tmp_text <- read_html(i) %>% html_nodes('.text-content') %>% html_text() 
  tmp <- tmp[2:(length(tmp)-7)] # remove advertisement
  tmp <- tmp[str_length(tmp)>1] # remove empty line
  tmp <- paste(unlist(tmp), collapse =" ")
  tmp_text <- c(tmp_text, tmp)
  Sys.sleep(3)
}
mastery$text <- tmp_text
filename <- paste0(path,"data/newsletter/input/",gsub("-", "", substr(Sys.time(), 1, 10)),"_mastery.csv")
write.csv(mastery, filename, row.names = FALSE)

html <- paste0('<ul><li><a href="',mastery$url_address,'">',mastery$headline,'</a></li></ul>')
write.table(html, paste0(path,"data/newsletter/input/html/mastery_out.html"), row.names = FALSE, col.names = FALSE, quote = FALSE)

###### Server ############################################################ 
freq_table <- KeywordExtract(tmp_text)

# Save into the output folder
dfname_html <- paste0(path,"data/newsletter/output/",gsub("-", "", substr(Sys.time(), 1, 10)),"_mastery",".html")
R2HTML::HTML(freq_table,file= dfname_html)
Sys.sleep(1)

# Display
dfname_html <- paste0(path,"data/newsletter/input/html/mastery_table",".html")
if (file.exists(dfname_html)) file.remove(dfname_html)
R2HTML::HTML(freq_table, file= dfname_html)

###### Wordcloud ############################################################ 
graph <- letterCloud(demoFreq,"2e Data Science")
# Make the graph
wordcloud2(demoFreq, size=clsize, color =clcolor, backgroundColor =clbgcolor, figPath = "fig2e.png")
my_graph=letterCloud(demoFreq, word = "2e")
saveWidget(my_graph,"tmp.html",selfcontained = F)
webshot::webshot("tmp.html", file = "Rplot.png", cliprect = "viewport")

letterCloud(demoFreq, word = "2e", size = 3)

my_graph=wordcloud2(demoFreq, figPath = "fig2e.png", size = 3)
saveWidget(my_graph,"1.html",selfcontained = FALSE)
webshot::webshot("1.html","fig_1.pdf",vwidth = 480, vheight = 480, delay =60)


png("test.png")
wordcloud2(demoFreq, figPath = "fig2e.png", size = 3)
dev.off()
