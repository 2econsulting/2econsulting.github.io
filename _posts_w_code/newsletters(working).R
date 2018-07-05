library(rvest)
library(dplyr)
library(stringr)
library(data.table)
library(tm)
Sys.setlocale("LC_COLLATE", "C")

from <- format(Sys.time()-(7*24*60*60), "%Y-%m-%d %H:%M:%00")
to   <- format(Sys.time(), "%Y-%m-%d %H:%M:%00")

# analyticsvidhya ----
# Get the valid url (time limit : one week) 
i <- "https://www.analyticsvidhya.com/blog-archive/"
tmp_time  <- read_html(i) %>% html_nodes('.entry-date') %>% html_text()
tmp_time <- gsub("\n","",tmp_time)
tmp_time <- gsub("\n ","",tmp_time)
tmp_time <- gsub(paste0(substr(from, 1, 4), " "),"2018",tmp_time)
tmp_time <- gsub(paste0(substr(to, 1, 4), " "),"2018",tmp_time)
tmp_time <- gsub(",","",tmp_time)

tmp_time <- gsub("")
month <- seq(1, 12, 1)
as.Date(tmp_time, format = '%B %d %Y')




library(zoo) #this is a little more forgiving:
as.yearmon(c('07-2002'), "%m-%Y")
as.yearmon(c('Aug-2002'), "%b-%Y")


base::as.Date("1947 5 1", format="%Y %m %d")
??as.Date

tmp_head <- read_html(i) %>% html_nodes('.entry-title') %>% html_text()
tmp_url <- read_html(i) %>% html_nodes('.entry-title a') %>% html_attr('href')

# Collect the data from valid url
i <- "https://www.analyticsvidhya.com/blog/2018/07/top-github-reddit-data-science-machine-learning-june-2018/"
tmp_text <- read_html(i) %>% html_nodes('.text-content') %>% html_text() 


# read the last 700 characters
substr(tmp_text, start = nchar(tmp_text)-700, stop = nchar(tmp_text))
## [1] " 2010). \"Intellectual Property: Website Terms of Use\". Issue 26: June 2010. LK Shields Solicitors Update. p. 03. Retrieved 2012-04-19. \n^ National Office for the Information Economy (February 2004). \"Spam Act 2003: An overview for business\" (PDF). Australian Communications Authority. p. 6. Retrieved 2009-03-09. \n^ National Office for the Information Economy (February 2004). \"Spam Act 2003: A practical guide for business\" (PDF). Australian Communications Authority. p. 20. Retrieved 2009-03-09. \n^ \"Web Scraping: Everything You Wanted to Know (but were afraid to ask)\". Distil Networks. 2015-07-22. Retrieved 2015-11-04. \n\n\nSee also[edit]\n\nData scraping\nData wrangling\nKnowledge extraction\n\n\n\n\n\n\n\n\n"

# clean up text
tmp_text %>%
  str_replace_all(pattern = "\n", replacement = " ") %>%
  str_replace_all(pattern = "[\\^]", replacement = " ") %>%
  str_replace_all(pattern = "\"", replacement = " ") %>%
  str_replace_all(pattern = "\\s+", replacement = " ") %>%
  str_trim(side = "both") %>%
  substr(start = nchar(tmp_text)-700, stop = nchar(tmp_text))

"\nIntroduction\n"
" " <- "\n"

# http://blog.kaggle.com/ ----
# Get the valid url (time limit : one week) 
i <- "http://blog.kaggle.com/"
Sys.sleep(3)
tmp_time  <- read_html(i) %>% html_nodes('.entry-date') %>% html_text()
tmp_head <- read_html(i) %>% html_nodes('.entry-title') %>% html_text()
tmp_url <- read_html(i) %>% html_nodes('.entry-featured a') %>% html_attr('href')

# Collect the data from valid url
i <- "http://blog.kaggle.com/2018/06/21/open-source-datasets-with-kaggle/"
tmp_text <- read_html(i) %>% html_nodes('p') %>% html_text()

# datacamp blog ----
i <- "https://www.datacamp.com/community/blog"
tmp_time  <- read_html(i) %>% html_nodes('.jsx-566588255 a .date') %>% html_text()
tmp_head <- read_html(i) %>% html_nodes('h2') %>% html_text()
tmp_url <- read_html(i) %>% html_nodes('h2 a') %>% html_attr('href')
url_list <- c()
for (i in tmp_url){
  tmp <- paste0("https://www.datacamp.com",i)
  url_list <- c(url_list, tmp)
}

# Collect the data from valid url
i <- "https://www.datacamp.com/community/blog/machine-learning-github"
tmp_text <- read_html(i) %>% html_nodes('p') %>% html_text()

# machine learning mastery ----
# Get the valid url (time limit : one week) 
i <- "https://machinelearningmastery.com/blog/"
Sys.sleep(3)
tmp_time  <- read_html(i) %>% html_nodes('abbr') %>% html_attr("title")
tmp_head <- read_html(i) %>% html_nodes('h2') %>% html_text()
tmp_url <- read_html(i) %>% html_nodes('h2 a') %>% html_attr('href')

# Collect the data from valid url
i <- "https://machinelearningmastery.com/how-to-generate-random-numbers-in-python/"
tmp_text <- read_html(i) %>% html_nodes('p') %>% html_text()








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