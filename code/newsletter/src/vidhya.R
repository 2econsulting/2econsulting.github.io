# writer : Hyunseo Kim


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

# Collect the data from valid url(different condition among sites)
for (j in 1){
  if (nrow(vidhya) == 0){
    vidhya <- data.frame(matrix(vector(), 0, 5,
                                dimnames = list(c(), c("site", "date","headline","url_address","text"))),
                         stringsAsFactors = FALSE)
    vidhya$site <- as.factor(vidhya$site)
    vidhya$date <- as.Date(vidhya$date)
    vidhya$headline <- as.factor(vidhya$headline)
    vidhya$url_address <- as.factor(vidhya$url_address)
    vidhya$text <- as.factor(vidhya$text)
    html <- paste0('<li>','no new article','</li>')
    write.table(html, paste0(path_git,"input/html/vidhya_out.html"), row.names = FALSE, col.names = FALSE, quote = FALSE)
    rm(baseHTML, timeHTML, titleHTML, urlHTML, html, j)
  }
  else{
    tmp_text <- c()
    for (url in vidhya[["url_address"]]){
      for (i in url){
        tmp_base <- try(read_html(i), silent = TRUE)
        if(inherits(tmp_base, "tye-error"))
        {
          tmp_base <- read_html(i)
          next
        }
        print("Done")
      }
      tmp <- read_html(i)
      Sys.sleep(3)
      tmp <- html_nodes(tmp, 'p')
      tmp <- html_text(tmp) 
      Sys.sleep(3)
      tmp <- tmp[1:(length(tmp)-11)] # remove advertisement
      tmp <- tmp[str_length(tmp)>1] # remove empty line
      tmp <- paste(unlist(tmp), collapse =" ")
      tmp_text <- c(tmp_text, tmp)
      Sys.sleep(2)
    }
    vidhya$text <- tmp_text
    filename <- paste0(path_git,"input/vidhya_",gsub("-", "", substr(Sys.time(), 1, 10)),".csv")
    write.csv(vidhya, filename, row.names = FALSE)
    
    html <- paste0('<ul><li><a href="',vidhya$url_address,'">',vidhya$headline,'</a></li></ul>')
    write.table(html, paste0(path_git,"input/html/vidhya_out.html"), row.names = FALSE, col.names = FALSE, quote = FALSE)
    rm(baseHTML, timeHTML, titleHTML, urlHTML, tmp, tmp_base, tmp_text, url, i, j, html)
  }
}
gc()