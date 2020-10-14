library(shiny)
library(colourpicker)
library(leaflet)
library(ggplot2)
library(DT)
library(dygraphs)


source("analyse_textuelle.r")
source("carte.r")
source("summary.R")
source("etude_temporelle.R")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # Carte
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
  
  output$carte.carte_monde <- renderLeaflet({
    # Generates the map.
    leaflet() %>%
      addTiles() %>%
      addAwesomeMarkers(data=spdf,
                        group=~shape,
                        icon = icons,
                        clusterOptions = markerClusterOptions(
                          iconCreateFunction =
                            JS(jsscript3)))
  })
  
  
  
  
  
  # Donnees
  output$table <- DT::renderDataTable(
    DT::datatable(
      {d <- data
      if(input$table_shape != "All") {
        d <- d[d$shape == input$table_shape,]
      }
      d}
    ) %>% formatStyle(names(d), color = 'black')
  )
  
  #Analyse Textuelle
  output$anatextu.carte <- renderPlot({
    
    x=texte
    set.seed(1234)
    wordcloud(x, min.freq = input$anatextu.min.freq, scale = c(12, 1.2), random.order = FALSE,
              random.color = TRUE, rot.per = 0.1, colors = brewer.pal(8, "Dark2"))
  })
  
  #Summary
  output$hist_forme <- renderPlot({
    back <- "gray13"
    ggplot(data_hist_ord[as.numeric(input$hist_checkGroup),], aes(x = shape, y = n, fill = shape)) +
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
  })
  
  
  
  
  
  output$hist_forme_countrystate <- renderPlot({
    ggplot(data_hist_countrystate, aes(x = countrystate, y = n, fill = countrystate)) +
      geom_bar(stat = "identity", alpha = .6, width = .4) +
      theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank()) 
    
  })
  
  
  output$etude_tempo <- renderPlotly({
    if (input$etude_tempo_echelle == "echelle_annee"){
      # Observations par an
      mydata_etude_tempo %>%
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
      mydata_etude_tempo %>%
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
      mydata_etude_tempo %>%
        count(hour(datetime)) %>%
        arrange(`hour(datetime)`) %>%
        plot_ly(x = ~`hour(datetime)`, y = ~n) %>%
        add_lines() %>%
        layout(title = "<b> Evolution du nombre d'OVNIs par heure <b>",
               xaxis = list(title = "<b> Heure <b>"),
               yaxis = list(title = "<b> Nombre d'OVNIs <b>"))
    }
  })

  
  # Analyse temporelle
  output$dygraph <- renderDygraph({
    lungDeaths <- cbind(mdeaths, fdeaths)
    dygraph(lungDeaths) %>%
      dySeries("mdeaths", label = "Male") %>%
      dySeries("fdeaths", label = "Female") %>%
      dyOptions(stackedGraph = TRUE) %>%
      dyRangeSelector(height = 20)
  })
})
