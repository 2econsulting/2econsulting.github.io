# title : SAVE_PNG_WORDCOUD2
# author : jacob 

# library 
devtools::install_github("johndharrison/binman")
devtools::install_github("johndharrison/wdman")
devtools::install_github("ropensci/RSelenium")
library(wordcloud2)
library(htmlwidgets)
library(RSelenium)

# path 
path <- "C:/Users/jacob/Documents/newsletter/"

# data
data("demoFreq")
data <- demoFreq

# make wordcloud html 
wordcloud <- letterCloud(data, "ÅõÀÌ")
htmlwidgets::saveWidget(wordcloud, "wordcloud.html", selfcontained=F)
wordcloud
wordcloud
dev.off()
Sys.sleep(30)

# run selenium
rD <- rsDriver(browser="firefox")
remDr <- rD[["client"]]
remDr$navigate(paste0("file:///", path, "wordcloud.html")) 
remDr$navigate(paste0("file:///", path, "wordcloud.html")) 
Sys.sleep(30)
#remDr$maxWindowSize()
fileName <- paste0("wordcloud_",gsub("-","",Sys.Date()))
remDr$screenshot(file=paste0(path, fileName,'.png'))            
remDr$close()
rD[["server"]]$stop() 

cat(">> SAVE_PNG_WORDCOUD2 done! \n")

