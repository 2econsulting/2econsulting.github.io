# writer : Hyunseo Kim


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

# Collect the data from valid url
for (j in 1){
  if (nrow(mastery) == 0){
    mastery <- data.frame(matrix(vector(), 0, 5,
                                 dimnames = list(c(), c("site", "date","headline","url_address","text"))),
                          stringsAsFactors = FALSE)
    mastery$site <- as.factor(mastery$site)
    mastery$date <- as.Date(mastery$date)
    mastery$headline <- as.factor(mastery$headline)
    mastery$url_address <- as.factor(mastery$url_address)
    mastery$text <- as.factor(mastery$text)
    html <- paste0('<li>','no new article','</li>')
    write.table(html, paste0(path_git,"input/html/mastery_out.html"), row.names = FALSE, col.names = FALSE, quote = FALSE)
    rm(timeHTML, titleHTML, urlHTML, html, j)
  }
  else{
    tmp_text <- c()
    for (url in mastery[["url_address"]]){
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
      tmp <- tmp[2:(length(tmp)-7)] # remove advertisement
      tmp <- tmp[str_length(tmp)>1] # remove empty line
      tmp <- paste(unlist(tmp), collapse =" ")
      tmp_text <- c(tmp_text, tmp)
      Sys.sleep(2)
    }
    mastery$text <- tmp_text
    filename <- paste0(path_git,"input/mastery_",gsub("-", "", substr(Sys.time(), 1, 10)),".csv")
    write.csv(mastery, filename, row.names = FALSE)
    
    html <- paste0('<ul><li><a href="',mastery$url_address,'">',mastery$headline,'</a></li></ul>')
    write.table(html, paste0(path_git,"input/html/mastery_out.html"), row.names = FALSE, col.names = FALSE, quote = FALSE)
    rm(baseHTML, timeHTML, titleHTML, urlHTML, tmp, tmp_base, tmp_text, url, i, j, html)
  }
}
gc()