#### Carte

# Package ----
require(leaflet)
require(data.table)

# Import Dataset ----
library(readr)
data_tot <- read_csv("~/Cours/TD AudeAxel/complete.csv", col_types = cols(comments = col_skip(),`date posted` = col_skip(), datetime = col_skip(),
                                                                          `duration (hours/min)` = col_skip(),
                                                                          `duration (seconds)` = col_skip(), shape = col_character(),
                                                                          state = col_skip()), locale = locale())
# Modification du jeu de donnees ----
data_tot$latitude <- as.numeric(as.character(data_tot$latitude))
data_tot <- as.data.table(data_tot)

data_us <- data_tot[country == "us"] #selection des data us
data_xy <- unique(data_us[, sighting := .N , by = list(latitude, longitude)]) # agregation du nombre de vue aux us
