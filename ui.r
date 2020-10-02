#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#anatextu : Analyse Textuelle

library(shiny)
library(colourpicker)

# Define UI for application that draws a histogram
shinyUI(
  navbarPage("Observations d'OVNIs",
             
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
                                       plotOutput("anatextu.carte")
                            #  )
                        )
                      )
             ),
             tabPanel("Carte du monde",
                      fluidRow(
                        column(width=3,
                               wellPanel(
                                 sliderInput("carte.min.sighting",
                                             "Minimum d'observations dans la ville :",
                                             min = 10,
                                             max = 400,
                                             value=100
                                 )
                               )
                        ),
                        column(width=9,
                               leafletOutput("carte.carte")
                               
                        )
                      )
             )
  )
)
