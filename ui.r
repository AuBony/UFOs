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
library(DT)
library(dygraphs)
library(sp)
library(viridis)
library(wordcloud2)
library(plotly)


setwd(dirname(rstudioapi::getActiveDocumentContext()$path)) # Répertoire de travail = répertoire du fichier R (où on doit mettre les data, du coup)


source("carte.r")
source("summary.R")



# Define UI for application that draws a histogram
shinyUI(
  navbarPage("Observations d'OVNIs", theme = shinytheme(theme = "darkly"),
             
             tabPanel("Accueil",
                      splitLayout(
                        tags$div(
                          h1("Bienvenue !"),
                          hr(),
                          p("Cette application shiny a vu le jours dans le cadre d\'un projet de Master 2 Datascience a Agrocampus Ouest."),
                          p("Nous sommes trois etudiants a avoir travaille sur le sujet : Valentin Avit, Axel Fisher et Audrey Bony."),
                          tags$img(src = "photo1.jpg",  height = "279px", width = "495px")
                        )
                      ),
                      splitLayout(
                        tags$div(
                          h1("Presentation des donnees"),
                          hr(),
                          p("Nous avons trouve notre jeu sur kaggle", "(", tags$a(href = "https://www.kaggle.com/NUFORC/ufo-sightings", "Cliquez ici pour voir le jeu de donnees"), ")" ),
                          p("Celui-ci recense les observations d\'OVNIs sur le siecle dernier principalement aux Etats-Unis."),
                          tags$div("Pourquoi avoir choisi des donnees sur les OVNIs me direz-vous ?", 
                                   tags$br(),
                                   "Bien qu\'il y ait un cote surprenant a ce jeu de donnees, celui-ci presente des donnees aussi bien geographiques que",
                                   "textuelles qui nous ont semble interessantes a traiter dans le cadre de ce projet Shiny. En effet, celles-ci permettent",
                                   tags$br(),
                                   "la creation de cartes qui est un aspect interessant de la visualisation de donnees que nous voulions aborder. Ensuite ",
                                   "c\'etait l\'occasion de travailler sur des donnees textuelles."),
                          p("Le jeu de donnees brutes comprend 80 331 observations pour 11 variables. Ces variables contiennent tout d\'abord des informations",
                            "sur la localisation de l\'evenement (longitude et latitude de la ville la plus proche du lieu d\'observations.",
                            tags$br(),
                            "Nous avons ensuite diverses informations temporelles : la date estimees des evenements d\'observations d\'OVNIs, la date de report de l\'evenement.",
                            "Chaque apparition est decrite par la forme du vehicule extra-terrestre observee,",
                            tags$br(),
                            "la duree de l\'apparition et un temoignage sur l\'apparition."),
                          p("Nous avons realise un travail de nettoyage de donnees afin de recuperer les informations sur les pays ou se sont deroules les evenements.",
                            "C\'est un travail qui est rarement fait. En effet, ce jeu de donnees a ete souvent analyse mais",
                            tags$br(),
                            "bien souvent seules les donnees recoltees aux Etats-Unis et aux Royaumes-Unis sont utilisees car nombreuses et plus completes (informations sur l\'Etat ou la region d\'apparition).")
                          
                          
                        )
                      )
             ),
             
             

             # Données
             tabPanel("Données",
                      column(4,
                             selectInput("table_shape",
                                         "Forme : ",
                                         c("All",
                                           unique(as.character(data_clean$shape))
                                         )
                             )
                      ),
                      column(4, 
                             selectInput("table_country",
                                         "Pays : ",
                                         c("All",
                                           unique(as.character(data_clean$country))
                                         )
                             )
                      ),
                      DT::dataTableOutput("table")
             ),
             
             
             
             # Carte
             tabPanel("Carte du monde",
                      navlistPanel(widths= c(1,11),
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
                        tabPanel("Carte monde",
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
                        tabPanel("Répartition par forme",
                                 
                                 fluidRow(
                                   
                                   column(width = 8,
                                          plotOutput("hist_forme"), br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),
                                          div("Répartition des différentes formes d'OVNIs", align="center")
                                   ),
                                   column(width = 4, 
                                          checkboxGroupInput("hist_checkGroup", 
                                                             h3("Sélectionnez les formes"), 
                                                             choices = levels(as.factor(data_clean$shape)),
                                                             selected = c("NA", "light", "triangle", "circle", "fireball", "hexagon", "egg")
                                          )
                                   )
                                   
                                 )
                        ),
                        
                        tabPanel("Répartition par pays",
                                 fluidRow(
                                   column(width = 8,
                                          plotOutput("hist_forme_country"), br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),
                                          div("Occurrence des apparitions d'OVNIs par pays", align="center")
                                   ),
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
                        
                        tabPanel("Etude temporelle des données par forme",
                                 wellPanel(style = "background: #D5D6E7",
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
                                             "Précision du nuage de mots :",
                                             min = 2,
                                             max = 50,
                                             value=5
                                 )
                               )
                        ),
                        column(width=10,
                               wordcloud2Output("anatextu.carte", height="1000px")
                        )
                      )
             ),
             
             
             
             # Credit
             tabPanel("Crédits",
                      fluidRow(
                        column(width=8,
                               HTML('<iframe width="1120" height="630" src="https://www.youtube.com/embed/pSb7PxPbi6k" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>')
                        ),
                        column(width=4,
                               fluidPage(
                                 titlePanel("Extraterrestre"),
                                 fluidRow(
                                   column(4,
                                          wellPanel(
                                            radioButtons("picture", "Observation :",
                                                         c("En vol", "A pied"))
                                          )
                                   ),
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
