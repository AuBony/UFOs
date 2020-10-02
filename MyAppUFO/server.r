library(shiny)
library(colourpicker)

source("analyse_textuelle.r")
source("carte.r")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

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
                 radius = ~(sighting)^2,
                 popup = ~paste(labels, ":", sighting),
                 weight = 1,
                 fillOpacity =  0.2,
                 color = "#a500a5")
  })

  output$anatextu.carte <- renderPlot({

    x=texte
    wordcloud(x, min.freq = input$anatextu.min.freq, scale = c(4, 0.5), random.order = FALSE,
              random.color = TRUE, rot.per = 0.1, colors = brewer.pal(8, "Dark2"))
  })


})
