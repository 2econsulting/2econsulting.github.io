# title : newsletter
# author : Hyunseo Kim


# path 
path_local <- "C:/Users/user/Documents/ds/2econsulting/newsletter/"
path_git <- "C:/Users/user/Documents/2econsulting.github.io/data/newsletter/"

# Set today and wordcloud's url, subject
today <- gsub("-","",Sys.Date())
fileName <- paste0(path_local, "input/text.csv")
text <- read.csv(fileName)
kor <- paste(text$word[1], text$word[2], text$word[3])
wordcloud <- paste0("https://raw.githubusercontent.com/2econsulting/2econsulting.github.io/master/data/newsletter/output/report/wordcloud_",today,".png")
subject <- paste0(gsub("-",".",Sys.Date()),". ",kor)

# load data
fileName <- paste0(path_git,"input/total_",today,".csv")
total <- read.csv(fileName)
total$X <- NULL

# necessary function
filename <- paste0(path_local,"src/text_mining_function.R")
source(filename)

# Get existing information
kaggle_info   <- exist_info(total, "kaggle")
datacamp_info <- exist_info(total, "datacamp")
vidhya_info   <- exist_info(total, "vidhya")
mastery_info  <- exist_info(total, "mastery")

# Make markdown code
kaggle_report   <- link_make(kaggle_info)
datacamp_report <- link_make(datacamp_info)
vidhya_report   <- link_make(vidhya_info)
mastery_report  <- link_make(mastery_info)

# Write the first paragragh
report_head <- paste0('---\n',
'layout: post\n',
'title: ', subject,'\n',
'category: weekly report\n',
'tags: [Machine learning, Data Science article]\n',
'no-post-nav: true\n',
'---\n\n',kor,' ([wordcloud](',wordcloud,'))\n')

# Write kaggle's markdown
kaggle_body <- paste0('\n<br>\n\n#### Kaggle Blog NEWS TITLE\n\n',
kaggle_report)

# Write datacamp's markdown
datacamp_body <- paste0('\n<br>\n\n#### Data Camp NEWS TITLE\n\n',
datacamp_report)

# Write vidhya's markdown
vidhya_body <- paste0('\n<br>\n\n#### Analytics Vidhya NEWS TITLE\n\n',
vidhya_report)

# Write mastery's markdown
mastery_body <- paste0('\n<br>\n\n#### Machine Learning Mastery NEWS TITLE\n\n',
mastery_report)

# Conbine all markdown
total_body <- paste0(report_head,kaggle_body,datacamp_body,vidhya_body,mastery_body,'\n<br>\n')

# Save markdown
fileName <- paste0("C:/Users/user/Documents/2econsulting.github.io/_posts/2018/",Sys.Date(),"-newsletter.md")
write.table(total_body, fileName, row.names = FALSE, col.names = FALSE, quote = FALSE, fileEncoding = "UTF-8")

gc()