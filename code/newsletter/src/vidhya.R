# title : newsletter
# author : Hyunseo Kim
# depends : rvest, dplyr, stringr, data.table, R2HTML, NLP, openNLP

# analyticsvidhya ----

# Get the url
baseHTML <- get_baseHTML("https://www.analyticsvidhya.com/blog-archive/")

# Get the time
timeHTML <- get_time(baseHTML, '.entry-date')
timeHTML <- gsub("\n","",timeHTML)
timeHTML <- gsub("\n ","",timeHTML)
timeHTML <- gsub(paste0(substr(from, 1, 4), " "),"2018",timeHTML)
timeHTML <- gsub(paste0(substr(to, 1, 4), " "),"2018",timeHTML)
timeHTML <- gsub(",","",timeHTML)

# 일자 변수 변환: format에서 %B가 안되기 때문에 숫자로 변환 후 %m 이용 
timeHTML <- Month2Num(timeHTML)
timeHTML <- as.Date(timeHTML, format = '%m %d %Y')

# Get the title
titleHTML <- get_title(baseHTML, '.entry-title')
titleHTML <- titleHTML[!(titleHTML %in% titleHTML[[1]])]
titleHTML <- gsub("\n\n","",titleHTML)
titleHTML <- gsub(" \n","",titleHTML)

# Get the url
urlHTML <- get_url(baseHTML, '.entry-title a', 'href')

# make data frame
vidhya <- data.frame(
  site = "vidhya", 
  date = timeHTML, 
  headline = titleHTML, 
  url_address = urlHTML
)
vidhya <- as.data.table(unique(vidhya))

# Get the valid information 
vidhya <- vidhya[from < vidhya$date & to >= vidhya$date, ]

# Save .csv & .html after collecting the data from valid url(different condition among sites)
vidhya <- mksave_data(vidhya, "vidhya", 1, 11)

gc()