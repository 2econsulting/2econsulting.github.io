# writer : Hyunseo Kim


# function for extracting noun and making frequency table
KeywordExtract <- function(tmp_text, ...){
  # make the text data as strings 
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
  tmp <- list(prp1, prp2, prp3)
  freq_table  <- as.data.frame.table(table(unlist(tmp)))
  names(freq_table) <- c("word", "freq")
  
  freq_table$freq <- as.numeric(freq_table$freq)
  freq_table$word <- as.character(freq_table$word)
  
  # remove nchar 2 word
  freq_table <- subset(freq_table, nchar(word) > 2)
  freq_table$word <- as.factor(as.character(freq_table$word))
  rownames(freq_table) <- freq_table$word 
  rm(POStags, POStagged, prp1, prp2, prp3, s, word_token_annotator, a2, a3, a3w)
  return(freq_table)
}