#### Summary

# Import Dataset ----
require(data.table)
library(readr)
library(lubridate)

library(countrycode)
library(lubridate)
library(dplyr)
library(ggplot2)

setwd("C:/Users/Valentin/Documents/Cours/TD AudeAxel/Audrey")
source("data_clean.r")



# Pour Etude des données -> Répartition par forme
data_hist <- data_clean[, list(n = .N), by = shape]
data_hist <- data_hist[order(n, decreasing = T)] #Order
data_hist$shape = with(data_hist, reorder(shape, n, mean))




# Pour étude des données -> Répartition par pays
data_hist_country <- data_clean[, list(n = .N), by = country]
data_hist_country <- data_hist_country[order(n, decreasing = T)]
data_hist_country$country = with(data_hist_country, reorder(country, n, mean))





