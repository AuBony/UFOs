###################
#Analyse textuelle#
###################

## Chargement du jeu de donnÃ©es
setwd("C:/Users/Valentin/Documents/Cours/TD AudeAxel/Audrey")
source("data_clean.r")

data_clean_frag <- data_clean[sample(1:nrow(data_clean), 10000), ]#Echantillonne 10 000 données sur les 90 000 pour la rapiditÃ© d'exÃ©cution


## Appel des packages nÃ©cessaires
library("tm") # Text mining
library("wordcloud") # ReprÃ©sentation du nuage de mots
library("SnowballC") # Racinisation des mots (on prend leur radical)
library("RColorBrewer") # Pour les couleurs

## Chargement du texte de la colonne commentaires
texte <- Corpus(VectorSource(data_clean_frag$comments)) #VectorSource crÃ©Ã© un ensemble de vecteurs de textes


## Nettoyage du texte

toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x)) # CaractÃ¨res spÃ©ciaux en espace
texte <- tm_map(texte, toSpace, "/")
texte <- tm_map(texte, toSpace, "@")
texte <- tm_map(texte, toSpace, "\\|")
texte <- tm_map(texte, content_transformer(tolower)) # Texte en minuscule
texte <- tm_map(texte, removeNumbers) # Supprimer les nombres
texte <- tm_map(texte, removeWords, stopwords("english")) # Supprimer les mots vides
texte <- tm_map(texte, removeWords, c("mot1", "mot2")) # Supprimer des mots Ã  dÃ©finir
texte <- tm_map(texte, removePunctuation) # Supprimer la  ponctuation
texte <- tm_map(texte, stripWhitespace) # Supprimer les espaces vides supplÃ©mentaires
texte <- tm_map(texte, stemDocument) # RÃ©duit les mots Ã  leur racine (Text stemming)


## Matrice des mots (term-documents matrix), donne leur nombre d'occurence
dtm <- TermDocumentMatrix(texte)
m2 <- as.matrix(TermDocumentMatrix(texte))
m <- as.matrix(dtm) # Transforme en matrice
v <- sort(rowSums(m),decreasing=TRUE) # Trier par ordre dÃ©croissant
ana_text_tableau <- data.frame(word = names(v),freq=v) # Transforme en data frame

setwd("C:/Users/Valentin/Documents/Cours/TD AudeAxel/Audrey")
write.table(ana_text_tableau, "ana_text_tableau.csv", row.names=T, dec=".", sep=";")

# ### Wordcloud2 par pays
# # USA
# USA <- subset(data,country=="us")
# USA <- USA[sample(1:nrow(USA), 10000), ]
# USAcorpus <- Corpus(VectorSource(USA$comments))
# 
# toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x)) # CaractÃ¨res spÃ©ciaux en espace
# USAcorpus <- tm_map(USAcorpus, toSpace, "/")
# USAcorpus <- tm_map(USAcorpus, toSpace, "@")
# USAcorpus <- tm_map(USAcorpus, toSpace, "\\|")
# USAcorpus <- tm_map(USAcorpus, content_transformer(tolower)) # Texte en minuscule
# USAcorpus <- tm_map(USAcorpus, removeNumbers) # Supprimer les nombres
# USAcorpus <- tm_map(USAcorpus, removeWords, stopwords("english")) # Supprimer les mots vides
# USAcorpus <- tm_map(USAcorpus, removeWords, c("mot1", "mot2")) # Supprimer des mots Ã  dÃ©finir
# USAcorpus <- tm_map(USAcorpus, removePunctuation) # Supprimer la  ponctuation
# USAcorpus <- tm_map(USAcorpus, stripWhitespace) # Supprimer les espaces vides supplÃ©mentaires
# USAcorpus <- tm_map(USAcorpus, stemDocument)
# 
# USAdtm <- TermDocumentMatrix(USAcorpus)
# USAm2 <- as.matrix(TermDocumentMatrix(USAcorpus))
# USAm <- as.matrix(USAdtm) # Transforme en matrice
# USAv <- sort(rowSums(USAm),decreasing=TRUE) # Trier par ordre dÃ©croissant
# USAtableau <- data.frame(word = names(USAv),freq=USAv) # Transforme en data frame
# head(USAtableau, 10)
# wordcloud2(USAtableau, size = 0.7, shape = 'pentagon')
# # 
# # UK
# UK <- subset(data,country=="")
# UK <- UK[sample(1:nrow(UK), 10000), ]
# UKcorpus <- Corpus(VectorSource(UK$comments))
# 
# toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x)) # CaractÃ¨res spÃ©ciaux en espace
# UKcorpus <- tm_map(UKcorpus, toSpace, "/")
# UKcorpus <- tm_map(UKcorpus, toSpace, "@")
# UKcorpus <- tm_map(UKcorpus, toSpace, "\\|")
# UKcorpus <- tm_map(UKcorpus, content_transformer(tolower)) # Texte en minuscule
# UKcorpus <- tm_map(UKcorpus, removeNumbers) # Supprimer les nombres
# UKcorpus <- tm_map(UKcorpus, removeWords, stopwords("english")) # Supprimer les mots vides
# UKcorpus <- tm_map(UKcorpus, removeWords, c("mot1", "mot2")) # Supprimer des mots Ã  dÃ©finir
# UKcorpus <- tm_map(UKcorpus, removePunctuation) # Supprimer la  ponctuation
# UKcorpus <- tm_map(UKcorpus, stripWhitespace) # Supprimer les espaces vides supplÃ©mentaires
# UKcorpus <- tm_map(UKcorpus, stemDocument)
# 
# UKdtm <- TermDocumentMatrix(UKcorpus)
# UKm2 <- as.matrix(TermDocumentMatrix(UKcorpus))
# UKm <- as.matrix(UKdtm) # Transforme en matrice
# UKv <- sort(rowSums(UKm),decreasing=TRUE) # Trier par ordre dÃ©croissant
# UKtableau <- data.frame(word = names(UKv),freq=UKv) # Transforme en data frame
# head(UKtableau, 10)
# wordcloud2(UKtableau, size = 0.7, shape = 'diamond')
# wordcloud2(UKtableau, size = 0.7, shape = 'triangle-forward')
