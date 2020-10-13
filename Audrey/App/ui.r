#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#Package
library(shiny)
library(colourpicker)
library(leaflet)
library(ggplot2)
library(shinythemes)


source("analyse_textuelle.r")
source("carte.r")
source("summary.R")



# Define UI for application that draws a histogram
shinyUI(
  navbarPage("Observations d'OVNIs", theme = shinytheme(theme = "darkly"),
             
             
             
             tabPanel("Accueil",
                      div("Test", align = "center", size="200%"),
                      tags$q("Test", style=("font-size: 200%; color: #FFFFFF; "))
             ),
             
             
             
             #Survol des Données
             navbarMenu("Survol des données",
                        tabPanel("Résumé du jeu de données"
                                 
                                 
                        ),
                        
                        #Summary
                        tabPanel("Formes des OVNIS",
                                 
                                 fluidRow(
                                   
                                   column(width = 12/2,
                                          plotOutput("hist_forme")
                                   ),
                                   
                                   column(width = 12/8
                                   ),
                                   
                                   column(width = 12/4, 
                                          checkboxGroupInput("hist_checkGroup", 
                                                             h3("Sélectionnez la forme"), 
                                                             choices = list("changing" = 10,
                                                                            "chevron" = 15,
                                                                            "cigar" = 9,
                                                                            "circle" = 2,
                                                                            "crescent" = 24,
                                                                            "cross" = 19,
                                                                            "cone" = 18,
                                                                            "cylinder" = 13,
                                                                            "diamond" = 14,
                                                                            "egg"= 17, 
                                                                            "fireball" = 5,
                                                                            "flare" = 22,
                                                                            "flash" = 12,
                                                                            "formation" = 8,
                                                                            "hexagon" = 23,
                                                                            "light" = 1,
                                                                            "oval" = 7,
                                                                            "pyramid" = 21,
                                                                            "rectangle" = 11,
                                                                            "round" = 20,
                                                                            "sphere" = 6,
                                                                            "teardrop" = 16,
                                                                            "triangle" = 4,
                                                                            "unknown" = 3
                                                             ),
                                                             selected = c(1, 4, 5, 6, 7, 11, 16, 23)
                                          )
                                   )
                                   
                                 )
                        ),


  
  tabPanel("Truc2",
           sidebarLayout(
             sidebarPanel(
               textInput("Truc", "truc", value="Tructruc"),
               br(), br(), br(), br(), br(), br(), br(), br(), br(), br(), br(), br(), br(), br(), br(), br(), br(), br(), br(), br(),
               br(), br(), br(), br(), br(), br(), br(), br(), br(), br(), br(), br(), br(), br(), br(), br(), br(), br(), br(), br(),
               width=2
             ),
             mainPanel(
               div("plopidou"),
               width=10
             )
           )
  ),
  tabPanel("Truc3"
           
  )
),



#Analyse Textuelle
tabPanel("Analyse textuelle",
         fluidRow(
           column(width=2,
                  wellPanel(
                    sliderInput("anatextu.min.freq",
                                "Minimum d'occurrence des mots pris en compte :",
                                min = 2,
                                max = 10,
                                value=5
                    )
                  )
           ),
           column(width=10,
                  #   tabPanel("Carte de mots",
                  plotOutput("anatextu.carte", height="1000px")
                  #  )
           )
         )
),



#Carte
tabPanel("Carte du monde",
         fluidRow(
           column(width=3,
                  wellPanel(
                    sliderInput("carte.min.sighting",
                                "Minimum d'observations dans la ville :",
                                min = 10,
                                max = 300,
                                value=100
                    )
                  )
           ),
           column(width=9,
                  leafletOutput("carte.carte")
                  
           )
         )
),



tabPanel("Etude temporelle des données", 
         fluidRow(
           plotOutput("dygraph")
         )
),



tabPanel("AFM"
)



)
)
