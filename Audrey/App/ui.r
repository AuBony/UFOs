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

setwd(dirname(rstudioapi::getActiveDocumentContext()$path)) # Répertoire de travail = répertoire du fichier R (où on doit mettre les data, du coup)


source("analyse_textuelle.r")
source("carte.r")
source("summary.R")



# Define UI for application that draws a histogram
shinyUI(
  navbarPage("Observations d'OVNIs", theme = shinytheme(theme = "darkly"),
             
             
             
             tabPanel("Accueil",
                      div("Test", align = "center", size="200%"),
                      tags$q("Test", style=("font-size: 200%; color: #FFFFFF; ")  )
             ),
             
             
             
             #Survol des Données
             navbarMenu("Survol des données",
                        tabPanel("Résumé du jeu de données"


                        ),

                        tabPanel("Etude des formes",
                                 fluidRow(
                                   column(width = 12/3,
                                          plotOutput("hist_forme"))
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
             
             
             
             tabPanel("Etude temporelle des données"
             ),
             
             
             
             tabPanel("AFM"
             )
             
             
             
  )
)
