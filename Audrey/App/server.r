library(shiny)
library(colourpicker)
library(leaflet)
library(ggplot2)

source("analyse_textuelle.r")
source("carte.r")
source("summary.R")

 # Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  #Carte
  output$carte.carte <- renderLeaflet({
    xy <- data_xy[sighting >input$carte.min.sighting, .(longitude, latitude, city, sighting)]
    #summary(xy)

    points <- data.frame(longitudes = xy$longitude,
                         latitudes = xy$latitude,
                         labels = xy$city,
                         sighting = xy$sighting)
    #summary(points)

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
  
  #Analyse Textuelle
  output$anatextu.carte <- renderPlot({

    x=texte
    wordcloud(x, min.freq = input$anatextu.min.freq, scale = c(4, 0.5), random.order = FALSE,
              random.color = TRUE, rot.per = 0.1, colors = brewer.pal(8, "Dark2"))
  })

  #Summary
  output$hist_forme <- renderPlot({
     ggplot(data_hist_ord[as.numeric(input$hist_checkGroup),], aes(x = shape, y = n, fill = shape)) +
        geom_bar(stat = "identity", alpha = .6, width = .4) +
        theme(axis.title.x=element_blank(), axis.text.x=element_blank(), axis.ticks.x=element_blank()) 
      
  })

  

})
