#### Summary

# Import Dataset ----
require(data.table)
library(readr)
data_tot <- read_csv("C:/Users/Valentin/Documents/Cours/TD AudeAxel/Audrey/scrubbed.csv", col_types = cols(comments = col_skip(),`date posted` = col_skip(), datetime = col_skip(),
                                                                                `duration (hours/min)` = col_skip(),
                                                                                `duration (seconds)` = col_skip(), shape = col_character(),
                                                                                state = col_skip()), locale = locale())
data_na <- na.omit(data_tot)
data_na <- as.data.table(data_na)
data_hist <- data_na[, list(n = .N), by = shape]

data_hist
#On enlève les donnees manquante
data_hist <- data_hist[-15,]

#On rassemble circle et disk
data_hist$n[data_hist$shape == "circle"] <- data_hist$n[data_hist$shape == "circle"] + data_hist$n[data_hist$shape == "disk"]
data_hist <- data_hist[-5,]

# On rassemble changing et changed
data_hist <- data_hist[-26,]
data_hist$n[data_hist$shape == "changing"] <- data_hist$n[data_hist$shape == "changing"] + 1

#On rassemble other et unknown
data_hist$n[data_hist$shape == "unknown"] <- data_hist$n[data_hist$shape == "unknown"] + data_hist$n[data_hist$shape == "other"]
data_hist <- data_hist[-8,]

#Order
data_hist_ord <- data_hist[order(n, decreasing = T)]
data_hist_ord$shape = with(data_hist_ord, reorder(shape, n, mean))







library(countrycode)
library(lubridate)
library(dplyr)
library(ggplot2)

complete <- read.csv("~/Cours/TD AudeAxel/complete.csv", na.strings="")
complete$datetime=mdy_hm(complete$datetime)
complete$latitude=as.numeric(as.character(complete$latitude))
complete$longitude=as.numeric(as.character(complete$longitude))


# temp=gsub( "^.* ", "", complete$datetime)
# complete$heure=gsub(":.*$", "", temp)      

complete$heure= hour(complete$datetime) # création de la colonne heure, qui donne l'heure à laquelle a lieu l'évènement
complete$date= floor_date( complete$datetime, unit = "day")


complete$countrystate = paste(complete$country, complete$state)

complete$countrystate[which(complete$countrystate=="NA al")] ="us al"
complete$countrystate[which(complete$countrystate=="NA ar")] ="us ar"
complete$countrystate[which(complete$countrystate=="NA ak")] ="us ak"
complete$countrystate[which(complete$countrystate=="NA az")] ="us az"
complete$countrystate[which(complete$countrystate=="NA ca")] ="us ca"
complete$countrystate[which(complete$countrystate=="NA co")] ="us co"
complete$countrystate[which(complete$countrystate=="NA ct")] ="us ct"
complete$countrystate[which(complete$countrystate=="NA dc")] ="us dc"
complete$countrystate[which(complete$countrystate=="NA de")] ="us de"
complete$countrystate[which(complete$countrystate=="NA fl")] ="us fl"
complete$countrystate[which(complete$countrystate=="NA ga")] ="us ga"
complete$countrystate[which(complete$countrystate=="NA hi")] ="us hi"
complete$countrystate[which(complete$countrystate=="NA ia")] ="us ia"
complete$countrystate[which(complete$countrystate=="NA id")] ="us id"
complete$countrystate[which(complete$countrystate=="NA il")] ="us il"
complete$countrystate[which(complete$countrystate=="NA in")] ="us in"
complete$countrystate[which(complete$countrystate=="NA ks")] ="us ks"
complete$countrystate[which(complete$countrystate=="NA ky")] ="us ky"
complete$countrystate[which(complete$countrystate=="NA la")] ="us la"
complete$countrystate[which(complete$countrystate=="NA ma")] ="us ma"
complete$countrystate[which(complete$countrystate=="NA md")] ="us md"
complete$countrystate[which(complete$countrystate=="NA me")] ="us me"
complete$countrystate[which(complete$countrystate=="NA mi")] ="us mi"
complete$countrystate[which(complete$countrystate=="NA mn")] ="us mn"
complete$countrystate[which(complete$countrystate=="NA mo")] ="us mo"
complete$countrystate[which(complete$countrystate=="NA ms")] ="us ms"
complete$countrystate[which(complete$countrystate=="NA mt")] ="us mt"
complete$countrystate[which(complete$countrystate=="NA nd")] ="us nd"
complete$countrystate[which(complete$countrystate=="NA ne")] ="us ne"
complete$countrystate[which(complete$countrystate=="NA nc")] ="us nc"
complete$countrystate[which(complete$countrystate=="NA nd")] ="us nd"
complete$countrystate[which(complete$countrystate=="NA nh")] ="us nh"
complete$countrystate[which(complete$countrystate=="NA nj")] ="us nj"
complete$countrystate[which(complete$countrystate=="NA nm")] ="us nm"
complete$countrystate[which(complete$countrystate=="NA ns")] ="us ns"
complete$countrystate[which(complete$countrystate=="NA nv")] ="us nv"
complete$countrystate[which(complete$countrystate=="NA ny")] ="us ny"
complete$countrystate[which(complete$countrystate=="NA oh")] ="us oh"
complete$countrystate[which(complete$countrystate=="NA ok")] ="us ok"
complete$countrystate[which(complete$countrystate=="NA or")] ="us or"
complete$countrystate[which(complete$countrystate=="NA pa")] ="us pa"
complete$countrystate[which(complete$countrystate=="NA pr")] ="us pr"
complete$countrystate[which(complete$countrystate=="NA ri")] ="us ri"
complete$countrystate[which(complete$countrystate=="NA sc")] ="us sc"
complete$countrystate[which(complete$countrystate=="NA sd")] ="us sd"
complete$countrystate[which(complete$countrystate=="NA ut")] ="us ut"
complete$countrystate[which(complete$countrystate=="NA vi")] ="us vi"
complete$countrystate[which(complete$countrystate=="NA vt")] ="us vt"
complete$countrystate[which(complete$countrystate=="NA tn")] ="us tn"
complete$countrystate[which(complete$countrystate=="NA tx")] ="us tx"
complete$countrystate[which(complete$countrystate=="NA va")] ="us va"
complete$countrystate[which(complete$countrystate=="NA wa")] ="us wa"
complete$countrystate[which(complete$countrystate=="NA wi")] ="us wi"
complete$countrystate[which(complete$countrystate=="NA wv")] ="us wv"
complete$countrystate[which(complete$countrystate=="NA wy")] ="us wy"


complete$countrystate[which(complete$countrystate=="NA ab")] ="ca ab"
complete$countrystate[which(complete$countrystate=="NA bc")] ="ca bc"
complete$countrystate[which(complete$countrystate=="NA mb")] ="ca mb"
complete$countrystate[which(complete$countrystate=="NA nb")] ="ca nb"
complete$countrystate[which(complete$countrystate=="NA nf")] ="ca nl" # pareil, nf et nl, m^endroit.
complete$countrystate[which(complete$countrystate=="NA nt")] ="ca nt"
complete$countrystate[which(complete$countrystate=="NA on")] ="ca on"
complete$countrystate[which(complete$countrystate=="NA pe")] ="ca pe"
complete$countrystate[which(complete$countrystate=="NA pq")] ="ca pq" #pq et qc sont les deux pour Québec (je crois)
complete$countrystate[which(complete$countrystate=="NA qc")] ="ca qc"
complete$countrystate[which(complete$countrystate=="NA sk")] ="ca sk"
complete$countrystate[which(complete$countrystate=="NA yk")] ="ca yk"
complete$countrystate[which(complete$countrystate=="NA yt")] ="ca yt"

complete$countrystate[which(complete$countrystate=="NA sa")] ="au sa"

unique(complete$countrystate)


complete=complete[-which(is.na(complete$city)),]


#Ajout
complete2=as.data.table(complete)
data_hist_countrystate <- complete2[, list(n = .N), by = countrystate]
data_hist_countrytate <- data_hist[order(n, decreasing = T)]
data_hist_countrystate$countrystate = with(data_hist_countrystate, reorder(countrystate, n, mean))
