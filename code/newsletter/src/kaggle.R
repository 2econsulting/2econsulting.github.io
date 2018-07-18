# title : newsletter
# author : Hyunseo Kim
# depends : rvest, dplyr, stringr, data.table, R2HTML, NLP, openNLP


# kaggle blog ----

# Get the url
baseHTML <- get_baseHTML("http://blog.kaggle.com/")
Sys.sleep(3)

# Get the time
timeHTML <- get_time(baseHTML, '.entry-date')
timeHTML <- as.Date(timeHTML, format = '%m.%d.%Y')

# Get the title
titleHTML <- get_title(baseHTML, '.entry-title')
titleHTML <- gsub("\n      ","",titleHTML)
titleHTML <- gsub("\n    ","",titleHTML)

# Get the url
urlHTML <- get_url(baseHTML, '.entry-featured a', 'href')

# make data frame
kaggle <- data.frame(
  site = "kaggle", 
  date = timeHTML, 
  headline = titleHTML, 
  url_address = urlHTML)
kaggle <- as.data.table(unique(kaggle))

# Get the valid information 
kaggle <- kaggle[from < kaggle$date & to >= kaggle$date, ]

# Save .csv & .html after collecting the data from valid url(different condition among sites)
kaggle <- mksave_data(kaggle, "kaggle", 2, 9)

gc()