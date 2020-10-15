# Titre : Application Shiny OVNIs UI
# Auteurs : Valentin Avit, Audrey Bony, Axel Fischer
# Date : 15/10/2020

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

#Import des donnees ----
source("carte.r")
source("summary.R")

#Librairies ----
library(shiny)
library(colourpicker)
library(leaflet)
library(ggplot2)
library(shinythemes)
library(DT)
library(dygraphs)
library(sp)
library(viridis)
library(wordcloud2)
library(plotly)


# UI ----
shinyUI(
  
  navbarPage("Observations d'OVNIs", theme = shinytheme(theme = "darkly"),
             
             #Onglet accueil
             tabPanel("Accueil",
                      
                      #Zone 1
                      splitLayout(
                        tags$div(
                          h1("Bienvenue !"),
                          hr(),
                          p("Cette application shiny a vu le jours dans le cadre d\'un projet de Master 2 Datascience a Agrocampus Ouest."),
                          p("Nous sommes trois etudiants a avoir travaille sur le sujet : Valentin Avit, Axel Fischer et Audrey Bony."),
                          tags$img(src = "photo1.jpg",  height = "279px", width = "495px")
                        )
                      ),
                      
                      #Zone 2
                      splitLayout(
                        tags$div(
                          h1("Presentation des donnees"),
                          hr(),
                          p("Nous avons trouvé notre jeu sur kaggle", "(", tags$a(href = "https://www.kaggle.com/NUFORC/ufo-sightings", "Cliquez ici pour voir le jeu de donnees"), ")" ),
                          p("Celui-ci recense les observations d\'OVNIs sur le siecle dernier principalement aux Etats-Unis."),
                          tags$div("Pourquoi avoir choisi des donnees sur les OVNIs me direz-vous ?", 
                                   tags$br(),
                                   "Bien qu\'il y ait un cote surprenant a ce jeu de données, celui-ci presente des données aussi bien geographiques que",
                                   "textuelles qui nous ont semble interessantes a traiter dans le cadre de ce projet Shiny. En effet, celles-ci permettent",
                                   tags$br(),
                                   "la création de cartes qui est un aspect intéressant de la visualisation de donnees que nous voulions aborder. Ensuite ",
                                   "c\'était l\'occasion de travailler sur des donnees textuelles."),
                          p("Le jeu de données brutes comprend 80 331 observations pour 11 variables. Ces variables contiennent tout d\'abord des informations",
                            "sur la localisation de l\'évenement (longitude et latitude de la ville la plus proche du lieu d\'observations.",
                            tags$br(),
                            "Nous avons ensuite diverses informations temporelles : la date estimées des évenements d\'observations d\'OVNIs, la date de report de l\'evenement.",
                            "Chaque apparition est décrite par la forme du vehicule extra-terrestre observée,",
                            tags$br(),
                            "la duree de l\'apparition et un témoignage sur l\'apparition."),
                          p("Nous avons réalise un travail de nettoyage de données afin de récupérer les informations sur les pays ou se sont deroulés les évenements.",
                            "C\'est un travail qui est rarement fait. En effet, ce jeu de données a été souvent analysé mais",
                            tags$br(),
                            "bien souvent seules les données recoltées aux Etats-Unis et aux Royaumes-Unis sont utilisées car nombreuses et plus completes (informations sur l\'Etat ou la région d\'apparition).")
                        )
                      )
             ),
             
             

             # Donnees
             tabPanel("Données",
                      
                      #Widget selection forme
                      column(4,
                             selectInput("table_shape",
                                         "Forme : ",
                                         c("All",
                                           unique(as.character(data_clean$shape))
                                         )
                             )
                      ),
                      
                      #Widget selection du pays
                      column(4, 
                             selectInput("table_country",
                                         "Pays : ",
                                         c("All",
                                           unique(as.character(data_clean$country))
                                         )
                             )
                      ),
                      
                      #Affichage du tableau de donnees
                      DT::dataTableOutput("table")
             ),
             
             
             
             # Carte
             tabPanel("Carte du monde",
                      navlistPanel(widths= c(1,11),
                        
                        #Carte des occurences          
                        tabPanel("Carte USA",
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
                        
                        #Carte des formes
                        tabPanel("Carte monde",
                                 fluidRow(
                                   
                                   column(width=3,
                                          wellPanel(
                                            
                                          )
                                   ),
                                   
                                   #Affichage de la carte
                                   column(width=9,
                                          leafletOutput("carte.carte_monde")
                                   )
                                 )
                        )
                      )
             ),
             
             
             
             # Etude des Données
             navbarMenu("Etude des données",
                        
                        #Onglet 1 : Histogramme des formes
                        tabPanel("Répartition par forme",
                                 
                                 fluidRow(
                                   
                                   #Plot
                                   column(width = 8,
                                          plotOutput("hist_forme"), br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),
                                          div("Répartition des différentes formes d'OVNIs", align="center")
                                   ),
                                   
                                   #Widget selection des formes 
                                   column(width = 4, 
                                          checkboxGroupInput("hist_checkGroup", 
                                                             h3("Sélectionnez les formes"), 
                                                             choices = levels(as.factor(data_clean$shape)),
                                                             selected = c("NA", "light", "triangle", "circle", "fireball", "hexagon", "egg")
                                          )
                                   )
                                 )
                        ),
                        
                        #Onglet 2 : Histogramme par pays
                        tabPanel("Répartition par pays",
                                 fluidRow(
                                   
                                   #Plot
                                   column(width = 8,
                                          plotOutput("hist_forme_country"), br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),
                                          div("Occurrence des apparitions d'OVNIs par pays", align="center")
                                   ),
                                   
                                   #Widget selection des pays
                                   column(width = 4,
                                          checkboxGroupInput("hist_checkGroup_country",
                                                             h3("Sélectionnez les pays"),
                                                             choices = levels(as.factor(data_clean$country))
                                                             ,
                                                             selected = c("United States", "Australia", "United Kingdom", "France", "Canada")
                                          )
                                   )
                                 )
                        ),
                        
                        #Onglet 3
                        tabPanel("Etude temporelle des données",
                                 fluidRow(
                                   
                                   #Widget selection de l'echelle temporelle
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
                                   
                                   #Plot
                                   column(width = 12/2,
                                          plotlyOutput("etude_tempo")
                                   )
                                 )
                        ),
                        
                        #Onglet 4
                        tabPanel("Etude temporelle des données par forme",
                                 
                                 #Plot
                                 wellPanel(style = "background: #f6f6f6",
                                   dygraphOutput("dygraph")
                                 )
                        )
             ),
             
             
             
             # Analyse Textuelle
             tabPanel("Analyse textuelle",
                      fluidRow(
                        
                        #Widget : selection de la precision
                        column(width=2,
                               wellPanel(
                                 sliderInput("anatextu.min.freq",
                                             "Précision du nuage de mots :",
                                             min = 2,
                                             max = 50,
                                             value=5
                                 )
                               )
                        ),
                        
                        #Plot du wordcloud
                        column(width=10,
                               wordcloud2Output("anatextu.carte", height="1000px")
                        )
                      )
             ),
             
             
             
             # Credit
             tabPanel("Crédits",
                      fluidRow(
                        
                        #Video
                        column(width=8,
                               HTML('<iframe width="1120" height="630" src="https://www.youtube.com/embed/pSb7PxPbi6k" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')
                        ),
                        
                        #Gif
                        column(width=4,
                               fluidPage(
                                 
                                 titlePanel("Extraterrestre"),
                                 fluidRow(
                                   
                                   #Widget : selection du Gif
                                   column(4,
                                          wellPanel(
                                            radioButtons("picture", "Observation :",
                                                         c("En vol", "A pied"))
                                          )
                                   ),
                                   
                                   #Affichage du Gif
                                   column(4,
                                          imageOutput("image2", height = 300 )
                                   )
                                 )
                               )
                        )
                      )
             )
  )
)
