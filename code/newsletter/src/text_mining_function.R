# title : newsletter
# author : Hyunseo Kim
# depends : rvest, dplyr, stringr, data.table, R2HTML, NLP, openNLP


# function for extracting noun and making frequency table
KeywordExtract <- function(tmp_text, ...){
  # make the text data as strings 
  tmp_text <- gsub("[^\x01-\x7F]","",tmp_text)
  s <- as.String(tmp_text)
  s <- tolower(s)
  
  # token maker
  word_token_annotator <- Maxent_Word_Token_Annotator()
  
  # text mining
  a2 <- Annotation(1L, "sentence", 1L, nchar(s))
  a2 <- annotate(s, word_token_annotator, a2)
  
  # text tag (NN, NNS, NNP, IN, VBG,...)
  a3 <- annotate(s, Maxent_POS_Tag_Annotator(), a2) 
  a3w <- a3[a3$type == "word"]
  
  # attach type symbor into each word
  POStags <- unlist(lapply(a3w$features, `[[`, "POS"))
  POStagged <- paste(sprintf("%s/%s", s[a3w], POStags), collapse = " ")
  Sys.sleep(3)
  
  # extract Noun (NN, NNS, NNP)
  prp1 <- str_extract_all(POStagged,"\\w+/NNS\\$?")
  prp2 <- str_extract_all(POStagged,"\\w+/NNP\\$?")
  prp3 <- str_extract_all(POStagged,"\\w+/NN\\$?")
  
  # detach type symbor
  prp1 <- str_replace(unlist(prp1), "/NNS\\$?", "")
  prp2 <- str_replace(unlist(prp2), "/NNP\\$?", "")
  prp3 <- str_replace(unlist(prp3), "/NN\\$?", "")
  
  # get the final noun frequency table
  tmp <- unlist(prp1, prp2, prp3)
  tmp <- singularize(tmp)
  freq_table  <- as.data.frame.table(table(tmp))
  names(freq_table) <- c("word", "freq")
  
  freq_table$freq <- as.numeric(freq_table$freq)
  freq_table$word <- as.character(freq_table$word)
  freq_table$word <- gsub("datum", "data", freq_table$word)
  freq_table$word <- gsub("analytic", "analytics", freq_table$word)
  freq_table$word <- gsub("statistic", "statistics", freq_table$word)
  
  # remove nchar 2 word
  freq_table <- subset(freq_table, nchar(word) > 2)
  freq_table$word <- as.factor(as.character(freq_table$word))
  rownames(freq_table) <- freq_table$word 
  return(freq_table)
}

TopKeywordExtract <- function(data){
    keyword <- c()
    for (i in 1:nrow(data)){
            freq_table <- KeywordExtract(data[["text"]][i])
            freq_table <- as.data.table(freq_table)
            freq_table <- freq_table[!(freq_table[["word"]] %in% dictionary[["rm_word"]]), ]
            freq_table <- freq_table[order(-freq_table[["freq"]]),][1:10]
            rownames(freq_table) <- 1:nrow(freq_table)
            tmp_keyword <- paste0('Keyword(freq): ',
                                  freq_table[[1]][1],'(',freq_table[[2]][1],'), ',
                                  freq_table[[1]][2],'(',freq_table[[2]][2],'), ',
                                  freq_table[[1]][3],'(',freq_table[[2]][3],'), ',
                                  freq_table[[1]][4],'(',freq_table[[2]][4],'), ',
                                  freq_table[[1]][5],'(',freq_table[[2]][5],'), ',
                                  freq_table[[1]][6],'(',freq_table[[2]][6],'), ',
                                  freq_table[[1]][7],'(',freq_table[[2]][7],'), ',
                                  freq_table[[1]][8],'(',freq_table[[2]][8],'), ',
                                  freq_table[[1]][9],'(',freq_table[[2]][9],'), ',
                                  freq_table[[1]][10],'(',freq_table[[2]][10],')')
            keyword <- c(keyword, tmp_keyword)
    }
    data[["keyword"]] <- keyword
    return(data)
}

exist_info <- function(data, site_name){
  if (any(data$site == site_name)){
    subject <- data$headline[data$site == site_name]
    url <- data$url_address[data$site == site_name]
    keyword <- data$keyword[data$site == site_name]
  } else {
    subject <- "no new article"
    url <- NA
    keyword <- NA
  }
  tmp <- data.frame(subject = subject,
                    url = url,
                    keyword = keyword)
  return(tmp)
}

link_make <-function (data_info){
  if (any(data_info[["subject"]]=="no new article")){
    info <- "* no new article\n\n\n"
  } else {
    info <- c()
    for (i in 1:nrow(data_info)){
      tmp <- paste0('* [',data_info[[1]][i],'](',data_info[[2]][i],')\n<br>',data_info[[3]][i],'\n')
      info <- c(info, tmp)
      if (length(info) > 1) {
        info <- paste(unlist(info),collapse = "\n")
      }
    }
  }
  return(info)
}
