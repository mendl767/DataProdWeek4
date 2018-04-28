#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that fits and plots a linear model based on 
# user specified model factors.
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Dynamic Linear Model Modification and Fitting"),
  
  fluidRow(
    column(3,
           checkboxGroupInput("factors", "Select Model Factor(s) to Include:",
                              c("Sepal Width"="Sepal.Width", "Petal Length"="Petal.Length", 
                                "Petal Width"="Petal.Width", "Species"="Species"), selected=c("Sepal.Width"))
           ),
    column(3,
           checkboxInput("interact", "Select to Include Factor Interactions in Model")
           ),
    column(3,
           br(), 
           br(),
           submitButton("Submit"))
    ),
  hr(),
  
  plotOutput("plot")
  )
)
