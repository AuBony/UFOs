# Titre : Application Shiny OVNIs - SUMMARY
# Auteurs : Valentin Avit, Audrey Bony, Axel Fischer
# Date : 15/10/2020

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Import Dataset ----
source("data_clean.r")

#Librairies ----
require(data.table)
require(readr)
require(lubridate)
require(countrycode)
require(lubridate)
require(dplyr)
require(ggplot2)

#Modification des donnees ----

# Pour Etude des donnÃ©es -> RÃ©partition par forme
data_hist <- data_clean[, list(n = .N), by = shape]
data_hist <- data_hist[order(n, decreasing = T)] #Order
data_hist$shape = with(data_hist, reorder(shape, n, mean))

# Pour Ã©tude des donnÃ©es -> RÃ©partition par pays
data_hist_country <- data_clean[, list(n = .N), by = country]
data_hist_country <- data_hist_country[order(n, decreasing = T)]
data_hist_country$country = with(data_hist_country, reorder(country, n, mean))





