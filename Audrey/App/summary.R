#### Summary

# Import Dataset ----
require(data.table)
library(readr)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path)) # Répertoire de travail = répertoire du fichier R (où on doit mettre les data, du coup)
data_tot <- read_csv("scrubbed.csv", col_types = cols(comments = col_skip(),`date posted` = col_skip(), datetime = col_skip(),
                                                                                `duration (hours/min)` = col_skip(),
                                                                                `duration (seconds)` = col_skip(), shape = col_character(),
                                                                                state = col_skip()), locale = locale())
data_na <- na.omit(data_tot)
data_na <- as.data.table(data_na)
data_hist <- data_na[, list(n = .N), by = shape]

data_hist
#On enl?ve les donnees manquante
data_hist <- data_hist[-15,]
#On rassemble circle et disk
data_hist$n[data_hist$shape == "circle"] <- data_hist$n[data_hist$shape == "circle"] + data_hist$n[data_hist$shape == "disk"]
data_hist <- data_hist[-5,]
# On rassemble changing et changed
data_hist <- data_hist[-28,]
data_hist$n[data_hist$shape == "changing"] <- data_hist$n[data_hist$shape == "changing"] + 1

#Order
data_hist <- data_hist[order(n, decreasing = T)]
data_hist$shape = with(data_hist, reorder(shape, n, mean))

