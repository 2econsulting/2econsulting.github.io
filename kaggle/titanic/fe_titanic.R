

fe_titanic <- function(data){
  
  data$Embarked <- replace(data$Embarked, which(is.na(data$Embarked)), 'S')
  
  names <- data$Name
  title <-  gsub("^.*, (.*?)\\..*$", "\\1", names)
  data$title <- title
  data$title[data$title == 'Mlle']  <- 'Miss' 
  data$title[data$title == 'Ms']    <- 'Miss'
  data$title[data$title == 'Mme']   <- 'Mrs' 
  data$title[data$title == 'Lady']  <- 'Miss'
  data$title[data$title == 'Dona']  <- 'Miss'
  data$title[data$title == 'Capt']  <- 'Officer' 
  data$title[data$title == 'Col']   <- 'Officer' 
  data$title[data$title == 'Major'] <- 'Officer'
  data$title[data$title == 'Dr']    <- 'Officer'
  data$title[data$title == 'Rev']   <- 'Officer'
  data$title[data$title == 'Don']   <- 'Officer'
  data$title[data$title == 'Sir']   <- 'Officer'
  data$title[data$title == 'the Countess']   <- 'Officer'
  data$title[data$title == 'Jonkheer']       <- 'Officer'
  
  data$FamilySize <-data$SibSp + data$Parch + 1 
  data$FamilySized[data$FamilySize == 1] <- 'Single' 
  data$FamilySized[data$FamilySize < 5 & data$FamilySize >= 2] <- 'Small' 
  data$FamilySized[data$FamilySize >= 5] <- 'Big' 
  data$FamilySized=as.factor(data$FamilySized)
  
  ticket.unique <- rep(0, nrow(data))
  tickets <- unique(data$Ticket)
  for (i in 1:length(tickets)) {
    current.ticket <- tickets[i]
    party.indexes <- which(data$Ticket == current.ticket)
    for (k in 1:length(party.indexes)) {
      ticket.unique[party.indexes[k]] <- length(party.indexes)
    }
  }
  
  data$ticket.unique <- ticket.unique
  data$ticket.size[data$ticket.unique == 1]   <- 'Single'
  data$ticket.size[data$ticket.unique < 5 & data$ticket.unique>= 2]   <- 'Small'
  data$ticket.size[data$ticket.unique >= 5]   <- 'Big'
  
  data$Sex <- as.factor(data$Sex)
  data$ticket.size <- as.factor(data$ticket.size)
  data$title <- as.factor(data$title)
  data$Embarked <- as.factor(data$Embarked)
  data$Cabin <- as.factor(substring(gsub(" ","",data$Cabin),1,1))
  data$Pclass <- as.factor(data$Pclass)
  data$SibSp <- as.numeric(data$SibSp)
  data$Parch <- as.numeric(data$Parch)
  
  data$PassengerId <- NULL
  data$Ticket <- NULL
  data$Name <- NULL
  
  str(data)
  
  return(data)
}