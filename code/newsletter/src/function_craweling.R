# title : newsletter
# author : Hyunseo Kim
# depends : rvest, dplyr, stringr, data.table, R2HTML, NLP, openNLP


get_baseHTML <- function(url){
  for (i in url){
    baseHTML <- try(read_html(i), silent = TRUE)
    if(inherits(baseHTML, "tye-error"))
    {
      baseHTML <- read_html(i)
      next
    }
    print("Done")
  }
  baseHTML <- read_html(url)
  return(baseHTML)
}

get_time <- function(baseHTML, element){
  timeHTML <- html_nodes(baseHTML, element)
  timeHTML <- html_text(timeHTML)
  return(timeHTML)
}

# Get the title
get_title <- function(baseHTML, element){
  titleHTML <- html_nodes(baseHTML, element)
  titleHTML <- html_text(titleHTML)
  return(titleHTML)
}

# Get the url
get_url <- function(baseHTML, element1, element2){
  urlHTML <- html_nodes(baseHTML, element1)
  urlHTML <- html_attr(urlHTML, element2)
  return(urlHTML)
}

# 영문 월 단어를 숫자로 변환(%B 의 불안정성 때문)
Month2Num <- function(timeHTML){
  timeHTML <- gsub("January", 1, timeHTML)
  timeHTML <- gsub("February", 2, timeHTML)
  timeHTML <- gsub("March", 3, timeHTML)
  timeHTML <- gsub("April", 4, timeHTML)
  timeHTML <- gsub("May", 5, timeHTML)
  timeHTML <- gsub("June", 6, timeHTML)
  timeHTML <- gsub("July", 7, timeHTML)
  timeHTML <- gsub("August", 8, timeHTML)
  timeHTML <- gsub("September", 9, timeHTML)
  timeHTML <- gsub("October", 10, timeHTML)
  timeHTML <- gsub("November", 11, timeHTML)
  timeHTML <- gsub("December", 12, timeHTML)
  return(timeHTML)
}

# url 접속해 text 수집(최신 글이 없으면 수집 안함) 후 .csv 와 .html 작성
mksave_data <- function(data, data_name, start_line, advertisement){
  for (j in 1){
    if (nrow(data) == 0){
      data <- data.frame(matrix(vector(), 0, 5,
                                dimnames = list(c(), c("site", "date","headline","url_address","text"))),
                         stringsAsFactors = FALSE)
      data$site <- as.factor(data$site)
      data$date <- as.Date(data$date)
      data$headline <- as.factor(data$headline)
      data$url_address <- as.factor(data$url_address)
      data$text <- as.factor(data$text)
      html <- paste0('<li>','no new article','</li>')
      write.table(html, paste0(path_git,"input/html/",data_name,"_out.html"), row.names = FALSE, col.names = FALSE, quote = FALSE)
    }
    else{
      tmp_text <- c()
      for (url in data[["url_address"]]){
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
        tmp <- tmp[start_line:(length(tmp)-advertisement)] # remove advertisement
        tmp <- tmp[str_length(tmp)>1] # remove empty line
        tmp <- paste(unlist(tmp), collapse =" ")
        tmp_text <- c(tmp_text, tmp)
        Sys.sleep(2)
      }
      data$text <- tmp_text
      filename <- paste0(path_git,"input/", data_name, "_",gsub("-", "", Sys.Date()),".csv")
      write.csv(data, filename, row.names = FALSE)
      
      data <- TopKeywordExtract(data)
      html <- paste0('<ul><li><a href="',data$url_address,'">',data$headline,'</a></li></ul><p style = "margin-left: 0 px">',data$keyword,'</p>')
      fileName <- paste0(path_git,"input/html/",data_name, "_out.html")
      if (file.exists(fileName)) file.remove(fileName)
      write.table(html, fileName, row.names = FALSE, col.names = FALSE, quote = FALSE)
    }
  }
  return(data)
}

