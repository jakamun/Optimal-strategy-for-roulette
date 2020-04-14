

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
      selectInput("segment", "On what will you bet?", choices = c("Number", "Color", "Odd or even")),
      uiOutput("buttons"),
      uiOutput("slider"),
      actionButton("clear", "Clear all bets"),
      actionButton("bet", "Place bet"),
      actionButton("spin", "Spin the wheel")
    ),
    mainPanel(
      column(6, tableOutput("bets")),
      column(6, tableOutput("strategy"))
    )
  ),
 verticalLayout(
   wellPanel(
     textOutput("roll"),
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
