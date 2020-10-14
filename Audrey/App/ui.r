
#Package
library(shiny)
library(colourpicker)
library(leaflet)
library(ggplot2)
library(shinythemes)
library(DT)
library(dygraphs)


setwd(dirname(rstudioapi::getActiveDocumentContext()$path)) # Répertoire de travail = répertoire du fichier R (où on doit mettre les data, du coup)


source("analyse_textuelle.r")
source("carte.r")
source("summary.R")
source("etude_temporelle.R")



# Define UI for application that draws a histogram
shinyUI(
  navbarPage("Observations d'OVNIs", theme = shinytheme(theme = "darkly"),
             
             
             
             tabPanel("Accueil",
                      div("Test", align = "center", size="200%"),
                      tags$q("Test", style=("font-size: 200%; color: #FFFFFF; ")  )
             ),
             # Description du jeu de données (dans une fenêtre où scroller ?), décrire notre groupe (On fait ca dans le cadre d'un projet...)
             # Nos objectifs ? Mettre un sommaire ? 
             
             
             
             #Donnees
             tabPanel("Donnees",
                      
                      column(4,
                             selectInput("table_shape",
                                         "Forme : ",
                                         c("All",
                                           unique(as.character(data$shape))
                                         )
                             )
                      ),
                      
                      DT::dataTableOutput("table")
             ),
             
             
             
             # Carte
             tabPanel("Carte du monde",
                      navlistPanel(widths= c(1,11),
                                   tabPanel("Carte 1",
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
                                   tabPanel("Carte 2",
                                            fluidRow(
                                              column(width=3,
                                                     wellPanel(
                                                       
                                                     )
                                              ),
                                              column(width=9,
                                                     leafletOutput("carte.carte_monde")
                                                     
                                              )
                                            )
                                   )
                      )
             ),
             
             
             
             # Etude des Données
             navbarMenu("Etude des données",
                        tabPanel("Résumé du jeu de données"
                                 
                        ),
                        
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
                        
                        tabPanel("Répartition par état/pays",
                                 fluidRow(
                                   column(width = 12/3,
                                          plotOutput("hist_forme_countrystate"),
                                          div("Occurrence des apparitions d'OVNIs par état/pays", align="center")
                                   )
                                   
                                 )
                        ),
                        
                        tabPanel("Etude temporelle des données",
                                 
                                 fluidRow(
                                   column(width = 12/3,
                                          wellPanel(
                                            radioButtons("etude_tempo_echelle",
                                                         "Choix de l'échelle d'observation :",
                                                         c("Année" = "echelle_annee",
                                                           "Mois" = "echelle_mois",
                                                           "Jour" = "echelle_jour") 
                                            )
                                            
                                          )
                                   ),
                                   
                                   column(width = 12/2,
                                          plotlyOutput("etude_tempo")
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
                        
                        tabPanel("Truc3",
                                 navlistPanel(
                                   tabPanel("sous-Truc3",
                                            
                                   ),
                                   tabPanel("Sous-Truc 2 de 3",
                                            
                                   )
                                   
                                   
                                   
                                 )
                                 
                        ),
                        tabPanel("Etude temporelle des données", 
                                 fluidRow(
                                   dygraphOutput("dygraph")
                                 )
                        )
             ),
             
             
             
             # Analyse Textuelle
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
             
             
             
             #Credit
             tabPanel("Credit",
                      fluidPage(
                        HTML('<iframe width="560" height="315" src="https://www.youtube.com/embed/pSb7PxPbi6k" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')
                      )
                      
             )
  )
)