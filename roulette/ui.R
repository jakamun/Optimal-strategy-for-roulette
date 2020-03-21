library(shiny)
library(shinythemes)

# Define UI for application that draws a histogram
shinyUI(fluidPage(theme = shinytheme("slate"),
  
  # Application title
  titlePanel("Optimal roulette strategy!"),
  
  fluidRow(
    column(6, 
           wellPanel(
             h3("Podajte stavo"),
             sliderInput(inputId = "bet",
                         label = "Bet", sep = "",
                         value = 0, min = 0, max = 10, step = 1),
             br(),
             selectInput(inputId = "number",
                         label = "Number",
                         choices = c("00", "0", c(1:36)),
                         multiple = FALSE),
             br(),
             actionButton("stava", "Stavi")
           )),
    column(6, 
           wellPanel(
             textOutput("sta"))),
    column(12, 
           wellPanel(
             actionButton("roll", "Roll the whell!")
           )),
    column(12, 
           textOutput("num"))
  )
  
  )
)
