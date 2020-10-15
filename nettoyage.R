library(countrycode)
library(lubridate)
library(dplyr)
library(ggplot2)
library(maps)
library(countrycode)
library(tidyverse)

test <- read.csv("~/Cours/TD AudeAxel/Audrey/data_clean.csv", na.strings="", dec=".", sep=";")

complete <- read.csv("~/Cours/TD AudeAxel/complete.csv", na.strings="")
complete$datetime=mdy_hm(complete$datetime)
complete$latitude=as.numeric(as.character(complete$latitude))
complete$longitude=as.numeric(as.character(complete$longitude))


complete=rename(complete, duration_seconds = duration..seconds.)
complete=rename(complete, duration_character = duration..hours.min. )
complete=rename(complete, date_posted = date.posted )


complete$annee= gsub("-.*", "", complete$datetime)
complete$date= floor_date(complete$datetime, unit = "day")
complete$heure= hour(complete$datetime) # création de la colonne heure, qui donne l'heure à laquelle a lieu l'évènement


complete=complete[-which(is.na(complete$latitude)),] #Une des latitudes est un NA, et cause des pb si non retirée
complete$country = map.where(database="world", complete$longitude, complete$latitude)

complete$countrycode=countrycode(complete$country, origin = "country.name", destination = "iso3c")
complete$country=countrycode(complete$countrycode, origin = "iso3c", destination = "country.name")

unique(complete$shape2)
complete$shape2=complete$shape

complete$shape2=gsub("circle",      "disk",     complete$shape2)
complete$shape2=gsub("oval",      "disk",     complete$shape2)

complete$shape2=gsub("egg",      "sphere",     complete$shape2)
complete$shape2=gsub("round",      "sphere",     complete$shape2)

complete$shape2=gsub("cigar",      "cylinder",     complete$shape2)
complete$shape2=gsub("chevron",      "cylinder",     complete$shape2)
complete$shape2=gsub("rectangle",      "cylinder",     complete$shape2)

complete$shape2=gsub("delta",      "triangle",     complete$shape2)

complete$shape2=gsub("flash",      "light",     complete$shape2)
complete$shape2=gsub("flare",      "light",     complete$shape2)
complete$shape2=gsub("fireball",      "light",     complete$shape2)

complete$shape2=gsub("triangle",      "other",     complete$shape2)
complete$shape2=gsub("formation",      "other",     complete$shape2)
complete$shape2=gsub("changing",      "other",     complete$shape2)
complete$shape2=gsub("diamond",      "other",     complete$shape2)
complete$shape2=gsub("cross",      "other",     complete$shape2)
complete$shape2=gsub("teardrop",      "other",     complete$shape2)
complete$shape2=gsub("cone",      "other",     complete$shape2)
complete$shape2=gsub("pyramid",      "other",     complete$shape2)
complete$shape2=gsub("crescent",      "other",     complete$shape2)
complete$shape2=gsub("hexagon",      "other",     complete$shape2)
complete$shape2=gsub("dome",      "other",     complete$shape2)
complete$shape2=gsub("changed",      "other",     complete$shape2)


setwd("C:/Users/Valentin/Documents/Cours/TD AudeAxel/Audrey")
write.table(complete, "data_clean.csv", row.names=T, dec=".", sep=";")




  