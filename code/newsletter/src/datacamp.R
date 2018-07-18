# title : newsletter
# author : Hyunseo Kim
# depends : rvest, dplyr, stringr, data.table, R2HTML, NLP, openNLP


# datacamp blog ----

# Get the time
baseHTML <- get_baseHTML("https://www.datacamp.com/community/blog")
Sys.sleep(3)

# Get the title
timeHTML <- get_time(baseHTML, '.jsx-566588255 a .date')

# 일자 변수 변환: format에서 %B가 안되기 때문에 숫자로 변환 후 %m 이용 
timeHTML <- gsub("st","",timeHTML)
timeHTML <- gsub("nd","",timeHTML)
timeHTML <- gsub("rd","",timeHTML)
timeHTML <- gsub("th","",timeHTML)
timeHTML <- Month2Num(timeHTML)
timeHTML <- as.Date(timeHTML, format = '%m %d, %Y')

# Get the title
titleHTML <- get_title(baseHTML, 'h2')

# Get the url
urlHTML <- get_url(baseHTML, 'h2 a', 'href')
url_list <- c()
for (i in urlHTML){
  tmp <- paste0("https://www.datacamp.com",i)
  url_list <- c(url_list, tmp)
}

# make data frame
datacamp <- data.frame(
  site = "datacamp", 
  date = as.Date(timeHTML), 
  headline = as.character(titleHTML), 
  url_address = as.character(url_list))
datacamp <- as.data.table(unique(datacamp))

# Get the valid information 
datacamp <- datacamp[from < datacamp$date & to >= datacamp$date, ]

# Save .csv & .html after collecting the data from valid url(different condition among sites)
datacamp <- mksave_data(datacamp, "datacamp", 2, 0)

gc()