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
     textInput("value", "How much money do you want to put in?", value = "0"),
     actionButton("insert", "Insert")
   ),
   mainPanel(
     textOutput("money", inline = TRUE)
   )
 ),
  sidebarLayout(
    sidebarPanel(
      textOutput("status", inline = TRUE),
      selectInput("segment", "On what will you bet?", choices = c("Numbers", "Color", "Odd or even")),
      uiOutput("buttons"),
      uiOutput("slider"),
      actionButton("reset", "Reset bet"),
      actionButton("clear", "Clear all bets"),
      actionButton("bet", "Place bet"),
      actionButton("spin", "Spin the wheel")
    ),
    mainPanel(
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
    )
  ),
 verticalLayout(
   wellPanel(
     textOutput("num")
   )
 )
#  fluidRow(
#    column(12,
 #          actionButton('start','Start'),
  #         actionButton('stop','Stop'),
   #        textOutput('timeleft')),
    
#  )
  
  )
)
