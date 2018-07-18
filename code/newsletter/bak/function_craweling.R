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



