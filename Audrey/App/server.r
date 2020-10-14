library(shiny)
library(colourpicker)
library(leaflet)
library(ggplot2)
library(DT)

source("analyse_textuelle.r")
source("carte.r")
source("summary.R")

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  #Donnees
  output$table <- DT::renderDataTable(
    DT::datatable(
      {d <- data
      
      if(input$table_shape != "All") {
        d <- d[d$shape == input$table_shape,]
      }
      
      if(input$table_country != "All") {
        d <- d[d$country == input$table_country,]
      }
      d}
      ) %>% formatStyle(names(d), color = 'black')
    )
  
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
  
  #Analyse temporelle
  output$dygraph <- renderPlot({
    library(dygraphs)
    lungDeaths <- cbind(mdeaths, fdeaths)
    dygraph(lungDeaths) %>%
      dySeries("mdeaths", label = "Male") %>%
      dySeries("fdeaths", label = "Female") %>%
      dyOptions(stackedGraph = TRUE) %>%
      dyRangeSelector(height = 20)
  })
  
})