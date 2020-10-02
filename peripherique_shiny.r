### Analyse Textuelle


data <- read.csv("~/Cours/TD AudeAxel/scrubbed.csv")
mydata <- data[1:500,] #Echantillon avec les 500 premières lignes pour la rapidité d'exécution


## Appel des packages nécessaires
library("tm") # Text mining
library("wordcloud") # Représentation du nuage de mots
library("SnowballC") # Racinisation des mots (on prend leur radical)
library("RColorBrewer") # Pour les couleurs

## Chargement du texte de la colonne commentaires
texte <- Corpus(VectorSource(mydata$comments)) #VectorSource créé un ensemble de vecteurs de textes


## Nettoyage du texte

toSpace <- content_transformer(function (x , pattern ) gsub(pattern, " ", x)) # Caractères spéciaux en espace
texte <- tm_map(texte, toSpace, "/")
texte <- tm_map(texte, toSpace, "@")
texte <- tm_map(texte, toSpace, "\\|")


texte <- tm_map(texte, content_transformer(tolower)) # Texte en minuscule
texte <- tm_map(texte, removeNumbers) # Supprimer les nombres
texte <- tm_map(texte, removeWords, stopwords("english")) # Supprimer les mots vides
texte <- tm_map(texte, removeWords, c("mot1", "mot2")) # Supprimer des mots à définir
texte <- tm_map(texte, removePunctuation) # Supprimer la  ponctuation
texte <- tm_map(texte, stripWhitespace) # Supprimer les espaces vides supplémentaires

texte <- tm_map(texte, stemDocument) # Réduit les mots à leur racine (Text stemming)




#### Carte



require(leaflet)
require(data.table)
library(readr)
data_tot <- read_csv("~/Cours/TD AudeAxel/complete.csv", col_types = cols(comments = col_skip(),`date posted` = col_skip(), datetime = col_skip(), 
                                                                          `duration (hours/min)` = col_skip(), 
                                                                          `duration (seconds)` = col_skip(), shape = col_character(), 
                                                                          state = col_skip()), locale = locale())
data_tot$latitude <- as.numeric(as.character(data_tot$latitude))
data_tot <- as.data.table(data_tot)

data_us <- data_tot[country == "us"]
data_xy <- unique(data_us[, sighting := .N , by = list(latitude, longitude)])