library(shiny)
library(colourpicker)
library(leaflet)
library(ggplot2)
library(DT)
library(dygraphs)
library(sp)
library(viridis)
library(wordcloud2)
library(gapminder)
library(gganimate)
library(lubridate)
library(xts)
library(tidyverse)
library(plotly)
theme_set(theme_bw())


setwd("C:/Users/Valentin/Documents/Cours/TD AudeAxel/Audrey")
source("data_clean.r")
source("carte.r")
source("summary.R")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  
  
  # Donnees
  output$table <- DT::renderDataTable(
    DT::datatable(
      {d <- data_clean
      if(input$table_shape != "All") {
        d <- d[d$shape == input$table_shape,]
      }
      if(input$table_country != "All") {
        d <- d[d$country == input$table_country,]
      }
      d}
    ) %>% formatStyle(names(d), color = 'black')
  )
  
  
  
  # Carte
  # >Carte1
  output$carte.carte <- renderLeaflet({
    xy <- data_xy[sighting >input$carte.min.sighting, .(longitude, latitude, city, sighting)]
    
    points <- data.frame(longitudes = xy$longitude,
                         latitudes = xy$latitude,
                         labels = xy$city,
                         sighting = xy$sighting)
    
    leaflet(points) %>% addTiles() %>%
      setView(lng = -98, lat = 38.963290, zoom = 3.5) %>%
      addCircles(lng = ~longitudes,
                 lat = ~latitudes,
                 radius = ~30*(sighting)*input$carte.min.sighting/sqrt(input$carte.min.sighting),
                 popup = ~paste(labels, ":", sighting),
                 weight = 1,
                 fillOpacity =  0.2,
                 color = "#a500a5")
  })
  
  # >Carte2
  output$carte.carte_monde <- renderLeaflet({
    # Generates the map.
    temp=data.frame(shape2= spdf$shape2)
    pal <- colorFactor(palette = viridis(7), levels = levels(temp$shape2))
    
    leaflet(spdf) %>%
      leaflet::addLegend(position ="topright", pal = pal, opacity = 1, values=temp$shape2, labels=levels(temp$shape2)) %>%
      addTiles() %>%
      addAwesomeMarkers(data=spdf,
                        group=~shape2,
                        icon = icons,
                        clusterOptions = markerClusterOptions(
                          iconCreateFunction =
                            JS(jsscript3))) # %>%
    
  })
  
  
  
  # Etude des données
  # >Répartition par forme
  output$hist_forme <- renderPlot({
    back <- "gray13"
    ggplot(data_hist[which(data_hist$shape %in% input$hist_checkGroup),], aes(x = shape, y = n, fill = shape)) +
      geom_bar(stat = "identity", alpha = .6, width = .4) +
      geom_text(aes(label = n), size = 3.5, vjust = -1, color = "gold")+
      theme(axis.title.x=element_blank(), axis.text.x = element_text(color= "gold", angle = 45),
            axis.ticks.x=element_blank(),
            axis.title.y = element_blank(), 
            axis.text.y = element_text(color = "gold"),
            legend.background = element_rect(fill = back),
            legend.text = element_text(color = "gold"),
            legend.title = element_blank(),
            plot.background = element_rect(fill = back, colour = back),
            panel.background = element_rect(fill = back),
            panel.grid.major = element_line(colour = "gray42", lineend = "round"), 
            panel.grid.minor = element_line(colour = "gray42", lineend = "round"))
  }, height=600 )
  
  # >Répartition par pays
  output$hist_forme_country <- renderPlot({
    back <- "gray13"
    ggplot(data_hist_country[which(data_hist_country$country %in% input$hist_checkGroup_country),], aes(x = country, y = n, fill = country)) +
      geom_bar(stat = "identity", alpha = .6, width = .4) +
      geom_text(aes(label = n), size = 3.5, vjust = -1, color = "gold")+
      theme(axis.title.x=element_blank(), axis.text.x = element_text(color= "gold", angle = 45),
            axis.ticks.x=element_blank(),
            axis.title.y = element_blank(),
            axis.text.y = element_text(color = "gold"),
            legend.background = element_rect(fill = back),
            legend.text = element_text(color = "gold"),
            legend.title = element_blank(),
            plot.background = element_rect(fill = back, colour = back),
            panel.background = element_rect(fill = back),
            panel.grid.major = element_line(colour = "gray42", lineend = "round"),
            panel.grid.minor = element_line(colour = "gray42", lineend = "round"))
  }, height=600 )

  # >Etude temporelle des données
  output$etude_tempo <- renderPlotly({
    if (input$etude_tempo_echelle == "echelle_annee"){
      # Observations par an
      data_clean %>%
        count(floor_date(datetime, "year")) %>%
        arrange(`floor_date(datetime, "year")`) %>%
        plot_ly(x = ~`floor_date(datetime, "year")`, y = ~n) %>%
        add_lines() %>%
        layout(title = "<b>Evolution du nombre d'OVNIs par an <b>",
               xaxis = list(title = "<b> Année <b>"),
               yaxis = list(title = "<b> Nombre d'OVNIs <b>"))
    }
    else if (input$etude_tempo_echelle == "echelle_mois"){
      # Observations par mois
      data_clean %>%
        count(month(datetime)) %>%
        arrange(`month(datetime)`) %>%
        plot_ly(x = ~`month(datetime)`, y = ~n) %>%
        add_lines() %>%
        layout(title = "<b> Evolution du nombre d'OVNIs par mois <b>",
               xaxis = list(title = "<b> Mois <b>"),
               yaxis = list(title = "<b> Nombre d'OVNIs <b>"))
    }
    else {
      # Observations par heure
      data_clean %>%
        count(hour(datetime)) %>%
        arrange(`hour(datetime)`) %>%
        plot_ly(x = ~`hour(datetime)`, y = ~n) %>%
        add_lines() %>%
        layout(title = "<b> Evolution du nombre d'OVNIs par heure <b>",
               xaxis = list(title = "<b> Heure <b>"),
               yaxis = list(title = "<b> Nombre d'OVNIs <b>"))
    }
  })
  
  # >Etude temporelle des données par forme
  output$dygraph <- renderDygraph({
    d <- as.data.frame.matrix(table(data_clean$date, data_clean$shape2))
    d$date <- rownames(d)
    d$date <- ymd(d$date)
    don <- xts(x = d[,-1], order.by = d$date)
    dygraph(don) %>%
      dyRangeSelector(height = 20)
  })
  
  
  
  # Analyse Textuelle
  output$anatextu.carte <- renderWordcloud2({
    set.seed(1234)
    wordcloud2(tableau_clean, size = 2, shape = 'star', minSize = input$anatextu.min.freq)
  })
  
  
  
  # Crédits
  output$image2 <- renderImage({
    if (is.null(input$picture))
      return(NULL)
    
    if (input$picture == "A pied") {
      return(list(
        src = "C:/Users/Valentin/Documents/Cours/TD AudeAxel/Audrey/alienrun1W.gif",
        contentType = "image/gif",
        alt = "Alien qui court" # Texte si l'image ne charge pas
        ))
    } else if (input$picture == "En vol") {
      return(list(
        src = "C:/Users/Valentin/Documents/Cours/TD AudeAxel/Audrey/751.gif",
        filetype = "image/gif",
        alt = "Soucoupe qui tourne"
      ))
    }
  })
  
})
