#### Summary

# Import Dataset ----
require(data.table)
library(readr)
data_tot <- read_csv("E:/Cours/M2_Stat/UFOs/App/scrubbed.csv", col_types = cols(comments = col_skip(),`date posted` = col_skip(), datetime = col_skip(),
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

