# writer : Hyunseo Kim


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

# Collect the data from valid url
for (j in 1){
  if (nrow(datacamp) == 0){
    datacamp <- data.frame(matrix(vector(), 0, 5,
                                  dimnames = list(c(), c("site", "date","headline","url_address","text"))),
                           stringsAsFactors = FALSE)
    datacamp$site <- as.factor(datacamp$site)
    datacamp$date <- as.Date(datacamp$date)
    datacamp$headline <- as.factor(datacamp$headline)
    datacamp$url_address <- as.factor(datacamp$url_address)
    datacamp$text <- as.factor(datacamp$text)
    html <- paste0('<li>','no new article','</li>')
    write.table(html, paste0(path_git,"input/html/datacamp_out.html"), row.names = FALSE, col.names = FALSE, quote = FALSE)
    rm(timeHTML, titleHTML, urlHTML, html, i, j)
  }
  else {
    tmp_text <- c()
    for (url in datacamp[["url_address"]]){
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
      tmp <- tmp[str_length(tmp)>1] # remove empty line
      tmp <- tmp[2:(length(tmp))] # remove advertisement
      tmp <- paste(unlist(tmp), collapse =" ")
      tmp_text <- c(tmp_text, tmp)
      Sys.sleep(3)
    }
    datacamp$text <- tmp_text
    filename <- paste0(path_git,"input/datacamp_",gsub("-", "", substr(Sys.time(), 1, 10)),".csv")
    write.csv(datacamp, filename, row.names = FALSE)
    
    html <- paste0('<ul><li><a href="',datacamp$url_address,'">',datacamp$headline,'</a></li></ul>')
    write.table(html, paste0(path_git,"input/html/datacamp_out.html"), row.names = FALSE, col.names = FALSE, quote = FALSE)
    rm(baseHTML, timeHTML, titleHTML, urlHTML, tmp, tmp_base, tmp_text, url, i, j, html, url_list)
  }
}
gc()