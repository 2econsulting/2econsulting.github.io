# writer : Hyunseo Kim


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

# Collect the data from valid url
for (j in 1){
  if (nrow(kaggle) == 0){
    kaggle <- data.frame(matrix(vector(), 0, 5,
                                dimnames = list(c(), c("site", "date","headline","url_address","text"))),
                         stringsAsFactors = FALSE)
    kaggle$site <- as.factor(kaggle$site)
    kaggle$date <- as.Date(kaggle$date)
    kaggle$headline <- as.factor(kaggle$headline)
    kaggle$url_address <- as.factor(kaggle$url_address)
    kaggle$text <- as.factor(kaggle$text)
    html <- paste0('<li>','no new article','</li>')
    write.table(html, paste0(path_git,"input/html/kaggle_out.html"), row.names = FALSE, col.names = FALSE, quote = FALSE)
    rm(timeHTML, titleHTML, urlHTML, html, j)
  }
  else{
    tmp_text <- c()
    for (url in kaggle[["url_address"]]){
      for (i in url){
        tmp_base <- try(read_html(i), silent = TRUE)
        if(inherits(tmp_base, "tye-error"))
        {
          tmp_base <- read_html(i)
          next
        }
        print("Done")
      }
      tmp <- read_html(url)
      Sys.sleep(3)
      tmp <- html_nodes(tmp, 'p') 
      tmp <- html_text(tmp) 
      Sys.sleep(3)
      tmp <- tmp[2:(length(tmp)-9)] # remove advertisement
      tmp <- tmp[str_length(tmp)>1] # remove empty line
      tmp <- paste(unlist(tmp), collapse =" ")
      Sys.sleep(2)
      tmp_text <- c(tmp_text, tmp)
    }
    kaggle$text <- tmp_text
    filename <- paste0(path_git,"input/kaggle_",gsub("-", "", substr(Sys.time(), 1, 10)),".csv")
    write.csv(kaggle, filename, row.names = FALSE)
    
    html <- paste0('<ul><li><a href="',kaggle$url_address,'">',kaggle$headline,'</a></li></ul>')
    write.table(html, paste0(path_git,"input/html/kaggle_out.html"), row.names = FALSE, col.names = FALSE, quote = FALSE)
    rm(baseHTML, timeHTML, titleHTML, urlHTML, tmp, tmp_base, tmp_text, url, i, j, html)
  }
}
gc()