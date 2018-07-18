# title : newsletter
# author : Hyunseo Kim
# depends : rvest, dplyr, stringr, data.table, R2HTML, NLP, openNLP


# machine learning mastery ----

# Get the valid url
baseHTML <- get_baseHTML("https://machinelearningmastery.com/blog/")
Sys.sleep(3)

# 시간을 추출하는 형식이 달라 함수 적용 안함
timeHTML <- html_nodes(baseHTML, 'abbr')
timeHTML <- html_attr(timeHTML, "title")
timeHTML <- as.Date(substr(as.character(timeHTML),1,10), "%Y-%m-%d")

# Get the title
titleHTML <- get_title(baseHTML, 'h2')

# Get the url
urlHTML <- get_url(baseHTML, 'h2 a', 'href')

# make data frame
mastery <- data.frame(
  site = "mastery", 
  date = timeHTML, 
  headline = titleHTML, 
  url_address = urlHTML)
mastery <- as.data.table(unique(mastery))

# Get the valid information 
mastery <- mastery[from < mastery$date & to >= mastery$date, ]

# Save .csv & .html after collecting the data from valid url(different condition among sites)
mastery <- mksave_data(mastery, "mastery", 2, 7)

gc()