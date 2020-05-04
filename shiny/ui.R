

# Define UI for application that draws a histogram
shinyUI(navbarPage(theme = shinytheme("slate"),
  
  # Application title
  title = "Optimal roulette strategy!",
    tabPanel("Setings",
      sidebarLayout(
        sidebarPanel(width = 6,
          fileInput("file", "Continue with previous game"),
          actionButton("load", "Load")
        ),
        mainPanel(width = 6,
          textOutput("start")
        )
      ),
      sidebarLayout(
        sidebarPanel(width = 6,
          radioButtons("type", "What type of roulette do you want to play?", c("European" = TRUE, "American" = FALSE)),
          radioButtons("currency", "In what currency", c("Euro", "Dollar")),
          radioButtons("knownProb", "Do you want to know probability?", c("Yes" = TRUE, "No" = FALSE)),
          actionButton("apply", "Apply")
        ),
        mainPanel(width = 6,
          print("All set!")
        )
      ),
      sidebarLayout(
        sidebarPanel(width = 6,
          radioButtons("currency", "Choose a currency", choices = c("Euro", "Dollar"), inline = TRUE),
          textInput("value", "How much money do you want to put in?", value = "0"),
          actionButton("insert", "Insert")
        ),
        mainPanel(width = 6,
          textOutput("money", inline = TRUE)
        )
      )
    ),
  
 tabPanel("Play it yourself",
          sidebarLayout(sidebarPanel(
            textOutput("On what do you want to bet?", inline = TRUE),
            checkboxGroupInput("betOn", "I'm going to bet on:", choices = c("Number", "Color", "Odd or even")),
            actionButton("set", "Set")
          ),
          mainPanel(
            imageOutput("image")
         )),
   sidebarLayout(
     sidebarPanel(
       textOutput("status", inline = TRUE),
       selectInput("segment", "On what will you bet?", choices = names(izbira_ame), selected = "Number"),
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
 ),
 
 tabPanel(title = "Simulate")

#  fluidRow(
#    column(12,
 #          actionButton('start','Start'),
  #         actionButton('stop','Stop'),
   #        textOutput('timeleft')),
    
#  )
  
  )
)
