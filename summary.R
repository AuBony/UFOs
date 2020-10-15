#### Summary

# Import Dataset ----
require(data.table)
library(readr)
library(lubridate)

library(countrycode)
library(lubridate)
library(dplyr)
library(ggplot2)

data_clean <- read.csv("~/Cours/TD AudeAxel/Audrey/data_clean.csv", na.strings="", dec=".", sep=";")
data_clean$shape=as.factor(data_clean$shape)
data_clean$shape2=as.factor(data_clean$shape2)
data_clean$datetime=ymd_hms(data_clean$datetime)
data_clean <- as.data.table(data_clean)



# Pour Etude des données -> Répartition par forme
data_hist <- data_clean[, list(n = .N), by = shape]
data_hist <- data_hist[order(n, decreasing = T)] #Order
data_hist$shape = with(data_hist, reorder(shape, n, mean))




# Pour étude des données -> Répartition par pays
data_hist_country <- data_clean[, list(n = .N), by = country]
data_hist_country <- data_hist_country[order(n, decreasing = T)]
data_hist_country$country = with(data_hist_country, reorder(country, n, mean))





