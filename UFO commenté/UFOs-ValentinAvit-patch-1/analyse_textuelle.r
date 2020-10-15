# Titre : Application Shiny OVNIs - ANALYSE TEXTUELLE
# Auteurs : Valentin Avit, Audrey Bony, Axel Fischer
# Date : 15/10/2020

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

## Import des donnees ----
source("data_clean.r")
data_clean_frag <- data_clean[sample(1:nrow(data_clean), 10000), ]#Echantillonne 10 000 données sur les 90 000 pour la rapiditÃ© d'exÃ©cution

## Librairies ----
require("tm") # Text mining
require("wordcloud") # ReprÃ©sentation du nuage de mots
require("SnowballC") # Racinisation des mots (on prend leur radical)
require("RColorBrewer") # Pour les couleurs


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
