# Titre : Application Shiny OVNIs - DATA CLEAN
# Auteurs : Valentin Avit, Audrey Bony, Axel Fischer
# Date : 15/10/2020

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

#Import des donnees ----
data_clean <- read.csv("./data_clean.csv", na.strings="", dec=".", sep=";")

#Modification des donnees ----
data_clean$shape=as.factor(data_clean$shape)
data_clean$shape2=as.factor(data_clean$shape2)
data_clean$datetime=ymd_hms(data_clean$datetime)
data_clean <- as.data.table(data_clean)