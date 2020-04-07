library(shiny)
library(shinythemes)
library(lubridate)

# Define UI for application that draws a histogram
shinyUI(fluidPage(theme = shinytheme("slate"),
  
  # Application title
  titlePanel("Optimal roulette strategy!"),
  
  sidebarLayout(
 #   titlePanel("Chose between options below"),
    sidebarPanel(
      fileInput("load", "Continue with previous game"),
      actionButton("apply", "Apply")
    ),
    mainPanel(
      textOutput("start")
    )
  ),
 sidebarLayout(
   sidebarPanel(
     radioButtons("currency", "Choose a currency", choices = list("Euro", "Dollar"), inline = TRUE),
     textInput("value", "How much money do you want to put in?"),
     actionButton("insert", "Insert")
   ),
   mainPanel(
     textOutput("money")
   )
 ),
 
# denar <-  
 
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("numbers", "Choose numbers:", inline = TRUE, #width = validateCssUnit("105%"), 
                         choices = c("Green 00", "Green 0", "Red 1", "Black 2", "Red 3", "Black 4", "Red 5", "Black 6",
                                     "Red 7", "Black 8", "Red 9", "Black 10", "Black 11", "Red 12", "Black 13", "Red 14", 
                                     "Black 15", "Red 16", "Black 17", "Red 18", "Red 19", "Black 20", "Red 21",
                                     "Black 22", "Red 23", "Black 24", "Red 25", "Black 26", "Red 27", "Black 28", "Black29",
                                     "Red 30", "Black 31", "Red 32", "Black 33", "Red 34", "Black 35", "Red 36")),
      selectInput("col", "Choose color", c("Red", "Black"), selected = NULL),
      actionButton("reset", "Reset bet"),
      actionButton("resetAll", "Reset all bets"),
      actionButton("bet", "Place bet")
    ),
    mainPanel(textOutput("num"))
  ),

  fluidRow(
    column(1,
           wellPanel(checkboxInput("bet3", "No. 3"),
                     style="background: firebrick")),
    column(1, 
           wellPanel(checkboxInput("bet6", "No. 6"), 
                     style="background: black")),
    column(1, 
           wellPanel(checkboxInput("bet9", "No. 9"),
                     style="background: firebrick")),
    column(1, 
           wellPanel(checkboxInput("bet12", "No. 12"),
                     style="background: firebrick")),
    column(1, 
           wellPanel(checkboxInput("bet15", "No. 15"),
                     style="background: black")),
    column(1, 
           wellPanel(checkboxInput("bet18", "No. 18"),
                     style="background: firebrick")),
    column(1, 
           wellPanel(checkboxInput("bet21", "No. 21"),
                     style="background: firebrick")),
    column(1, 
           wellPanel(checkboxInput("bet24", "No. 24"),
                     style="background: black")),
    column(1, 
           wellPanel(checkboxInput("bet27", "No. 27"),
                     style="background: firebrick")),
    column(1, 
           wellPanel(checkboxInput("bet30", "No. 30"),
                     style="background: firebrick")),
    column(1, 
           wellPanel(checkboxInput("bet33", "No. 33"),
                     style="background: black")),
    column(1, 
           wellPanel(checkboxInput("bet36", "No. 36"),
                     style="background: firebrick")),
    column(1, 
           wellPanel(checkboxInput("bet2", "No. 2"),
                     style="background: black")),
    column(1, 
           wellPanel(checkboxInput("bet5", "No. 5"),
                     style="background: firebrick")),
    column(1, 
           wellPanel(checkboxInput("bet8", "No. 8"),
                     style="background: black")),
    column(1, 
           wellPanel(checkboxInput("bet11", "No. 11"),
                     style="background: black")),
    column(1, 
           wellPanel(checkboxInput("bet14", "No. 14"),
                     style="background: firebrick")),
    column(1, 
           wellPanel(checkboxInput("bet17", "No. 17"),
                     style="background: black")),
    column(1, 
           wellPanel(checkboxInput("bet20", "No. 20"),
                     style="background: black")),
    column(1, 
           wellPanel(checkboxInput("bet23", "No. 23"),
                     style="background: firebrick")),
    column(1, 
           wellPanel(checkboxInput("bet26", "No. 26"),
                     style="background: black")),
    column(1, 
           wellPanel(checkboxInput("bet29", "No. 29"),
                     style="background: black")),
    column(1, 
           wellPanel(checkboxInput("bet32", "No. 32"),
                     style="background: firebrick")),
    column(1, 
           wellPanel(checkboxInput("bet35", "No. 35"),
                     style="background: black")),
    column(1, 
           wellPanel(checkboxInput("bet1", "No. 1"),
                     style="background: firebrick")),
    column(1, 
           wellPanel(checkboxInput("bet4", "No. 4"),
                     style="background: black")),
    column(1, 
           wellPanel(checkboxInput("bet7", "No. 7"),
                     style="background: firebrick")),
    column(1, 
           wellPanel(checkboxInput("bet10", "No. 10"),
                     style="background: black")),
    column(1, 
           wellPanel(checkboxInput("bet13", "No. 13"),
                     style="background: black")),
    column(1, 
           wellPanel(checkboxInput("bet16", "No. 16"),
                     style="background: firebrick")),
    column(1, 
           wellPanel(checkboxInput("bet19", "No. 19"),
                     style="background: firebrick")),
    column(1, 
           wellPanel(checkboxInput("bet22", "No. 22"),
                     style="background: black")),
    column(1, 
           wellPanel(checkboxInput("bet25", "No. 25"),
                     style="background: firebrick")),
    column(1, 
           wellPanel(checkboxInput("bet28", "No. 28"),
                     style="background: black")),
    column(1, 
           wellPanel(checkboxInput("bet31", "No. 31"),
                     style="background: black")),
    column(1, 
           wellPanel(checkboxInput("bet34", "No. 34"),
                     style="background: firebrick")),
    column(2, 
           wellPanel(numericInput("betEven", "Bet on even", value = 0, min=0, max=100))),
    column(2, 
           wellPanel(numericInput("betRed", "Bet on red", value = 0, min=0, max=100),
                     style="background: firebrick")),
    column(2, 
           wellPanel(numericInput("bet00", "Bet on 00", value = 0, min=0, max=100),
                     style="background: green")),
    column(2, 
           wellPanel(numericInput("bet0", "Bet on 0", value = 0, min=0, max=100),
                     style="background: green")),
    column(2, 
           wellPanel(numericInput("betBlack", "Bet on black", value = 0, min=0, max=100),
                     style="background: black")),
    column(2, 
           wellPanel(numericInput("betOdd", "Bet on odd", value = 0, min=0, max=100)))
  ),
  hr(),
  fluidRow(
    column(12,
           actionButton('start','Start'),
           actionButton('stop','Stop'),
           textOutput('timeleft')),
    column(6, 
           wellPanel(
             h3("Podajte stavo"),
             sliderInput(inputId = "bet",
                         label = "Bet", sep = "",
                         value = 0, min = 0, max = 10, step = 1),
             br(),
             selectInput(inputId = "Number",
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
             actionButton("roll", "Roll the whell!"), 
             textOutput("num")
           ))
  )
  
  )
)
