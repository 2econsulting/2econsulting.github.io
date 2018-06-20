# title : 9_실습코드
# author : 2e Consulting
# data desc : http://www.bigdatalab.ac.cn/benchmark/bm/dd?data=Ta-Feng 

# 패키지 설치 
install.packages("data.table")
library(data.table)

# data.table사용해서 데이터 읽기 
shopping <- data.table::fread("https://raw.githubusercontent.com/2econsulting/2econsulting.github.io/master/data/shopping.csv")
shopping <- read.csv("https://raw.githubusercontent.com/2econsulting/2econsulting.github.io/master/data/shopping_1000.csv")
shopping <- as.data.frame(shopping)

# 데이터 조회 
head(shopping)

# date 
# year, month, day 
shopping$year <- substring(shopping$date, 1, 4)
shopping$month <- substring(shopping$date, 6, 7)
shopping$yearmonth <- substring(shopping$date, 1, 7)
shopping$day <- substring(shopping$date, 9, 10)
shopping$dayOfWeek <- weekdays(as.Date(shopping$date))
head(shopping)

# age_group
# A <25,B 25-29,C 30-34,D 35-39,E 40-44,F 45-49,G 50-54,H 55-59,I 60-64,J >65
table(shopping$age_group)
head(shopping$age_group)
shopping$age_group <- gsub(" ","",shopping$age_group)
shopping$age[shopping$age_group=="A"] <- 22
shopping$age[shopping$age_group=="B"] <- 27
shopping$age[shopping$age_group=="C"] <- 32
shopping$age[shopping$age_group=="D"] <- 37
shopping$age[shopping$age_group=="E"] <- 42
shopping$age[shopping$age_group=="F"] <- 47
shopping$age[shopping$age_group=="G"] <- 52
shopping$age[shopping$age_group=="H"] <- 57
shopping$age[shopping$age_group=="I"] <- 62
shopping$age[shopping$age_group=="J"] <- 67
head(shopping)

# address
# A-F: zipcode area: 105,106,110,114,115,221,G: others, H: Unknown
# Distance to store, from the closest: 115,221,114,105,106,110
table(shopping$address)
shopping$address <- gsub(" ","",shopping$address)
shopping$address[shopping$address=="A"] <- "105"
shopping$address[shopping$address=="B"] <- "106"
shopping$address[shopping$address=="C"] <- "110"
shopping$address[shopping$address=="D"] <- "114"
shopping$address[shopping$address=="E"] <- "115"
shopping$address[shopping$address=="F"] <- "221"
shopping$address[shopping$address=="G"] <- "others"
shopping$address[shopping$address=="H"] <- "Unknown"
shopping$distance[shopping$address=="105"] <- 4
shopping$distance[shopping$address=="106"] <- 5
shopping$distance[shopping$address=="110"] <- 6
shopping$distance[shopping$address=="114"] <- 3
shopping$distance[shopping$address=="115"] <- 1
shopping$distance[shopping$address=="221"] <- 2
shopping$distance[shopping$address=="others"] <- NA
shopping$distance[shopping$address=="Unknown"] <- NA
head(shopping)

# discount
shopping$discount_amount <- shopping$asset - shopping$price
shopping$discount_amount[shopping$discount_amount<0] <- 0
shopping$discount_total_amount <- shopping$discount_amount * shopping$quantity
shopping$discount_rate <- round(abs(shopping$discount_amount)/shopping$asset, 2)
head(shopping[,c("asset","price","discount_amount","discount_rate")])

# profit 
shopping$profit <- (shopping$asset - shopping$price) * shopping$quantity
head(shopping)

# total_sales
shopping$total_sales <- shopping$price * shopping$quantity
head(shopping)

# product_class
shopping$product_class <- substring(shopping$product_subclass, 1, 2)
head(shopping)

# [profit] 
# profit이 가장 높은/낮은 상품은?
# profit이 가장 높은/낮은 지역은?
# profit이 가장 높은/낮은 연령대는? 
# profit이 가장 높은/낮은 월은? 
# profit이 가장 높은/낮은 요일은? 
tmp <- aggregate(shopping$profit, by=list(shopping$product_subclass), sum)
tmp <- tmp[order(tmp$x, decreasing = T), ]
head(tmp)

# [quantity]
# 가장 많이 팔린 상품은? 
# 지역별로 가장 많이 팔린 상품은? 
# 연령대별로 가장 많이 팔린 상품은? 
# 월별로 가장 많이 팔린 상품은? 
# 요일별로 가장 많이 팔린 상품은? 
tmp <- aggregate(shopping$quantity, by=list(shopping$product_subclass), sum)
tmp <- tmp[order(tmp$x, decreasing = T), ]
head(tmp)

# [discount]
# 할인 상품을 가장 많이 사는 연령대는? 
# 할인 상품을 가장 많이 사는 지역은?
# 할인 상품이 가장 많이 팔리는 월은?
# 할인 상품이 가장 많이 팔리는 요일은? 
shopping$discount_index[shopping$discount_rate > 0] <- 1
shopping$discount_index[shopping$discount_rate ==0] <- 0
shopping$discount_index[is.na(shopping$discount_rate)] <- 0
tmp <- aggregate(shopping$discount_index, by=list(shopping$age), sum)
tmp <- tmp[order(tmp$x, decreasing = T), ]
head(tmp)

# [distance]
# 거리별 profit은?
# 거리별 sales는? 
# 거리별 가장 많이 팔리는 상품은? 
tmp <- aggregate(shopping$profit, by=list(shopping$distance), sum)
tmp <- tmp[order(tmp$x, decreasing = T), ]
head(tmp)







