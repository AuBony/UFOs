library(lubridate)
# Observations par an 
mydata_etude_tempo <- read_csv("C:/Users/Valentin/Documents/Cours/TD AudeAxel/scrubbed.csv")
mydata_etude_tempo$datetime <- mdy_hm(mydata_etude_tempo$datetime)
library(plotly)


# Observations par an
mydata_etude_tempo %>%
  count(floor_date(datetime, "year")) %>%
  arrange(`floor_date(datetime, "year")`) %>%
  plot_ly(x = ~`floor_date(datetime, "year")`, y = ~n) %>%
  add_lines() %>%
  layout(title = "<b>Evolution du nombre d'OVNIs par an <b>",
         xaxis = list(title = "<b> Année <b>"),
         yaxis = list(title = "<b> Nombre d'OVNIs <b>"))

# Observations par mois
mydata_etude_tempo %>%
  count(month(datetime)) %>%
  arrange(`month(datetime)`) %>%
  plot_ly(x = ~`month(datetime)`, y = ~n) %>%
  add_lines() %>%
  layout(title = "<b> Evolution du nombre d'OVNIs par mois <b>",
         xaxis = list(title = "<b> Mois <b>"),
         yaxis = list(title = "<b> Nombre d'OVNIs total <b>"))


# Observations par heure
mydata_etude_tempo %>%
  count(hour(datetime)) %>%
  arrange(`hour(datetime)`) %>%
  plot_ly(x = ~`hour(datetime)`, y = ~n) %>%
  add_lines() %>%
  layout(title = "<b> Evolution du nombre d'OVNIs par heure <b>",
         xaxis = list(title = "<b> Heure <b>"),
         yaxis = list(title = "<b> Nombre d'OVNIs total <b>"))

