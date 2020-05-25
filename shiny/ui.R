

# Define UI for application that draws a histogram
shinyUI(navbarPage(theme = shinytheme("slate"),
  
  # Application title
  title = "Optimal roulette strategy",
    tabPanel("Setings",
      h3("Before you start playing please set some settings.", style = "color:lobster;font-style: italic;font-weight:bold;"),
      sidebarLayout(
        sidebarPanel(width = 6,
          radioButtons("type", "What type of roulette do you want to play?", c("European", "American")),
          radioButtons("currency", "In what currency", c("Euro", "Dollar")),
          radioButtons("knownProb", "Do you want to know probability?", c("Yes", "No")),
          actionButton("apply", "Apply")
        ),
        mainPanel(width = 6,
          verbatimTextOutput("start")
        )
      ),
      conditionalPanel(condition = "input.apply != '' ",
        sidebarLayout(
          sidebarPanel(width = 6,
            radioButtons("curren", "Choose a currency", choices = c("Euro", "Dollar"), inline = TRUE),
            textInput("value", "How much money do you want to put in?", value = "0"),
            actionButton("insert", "Insert")
          ),
          mainPanel(width = 6,
            verbatimTextOutput("money")
          )
        ))
      ),
  
 tabPanel("Play it yourself",
          conditionalPanel(condition = "input.apply == '' ", 
                           fluidRow(column(width=12, align = 'center', inline=TRUE, 
                                           div(style = "height:20px;font-size: 35px;font-weight:bold;",
                                              "Please select starting parameters!")))),
          conditionalPanel(condition = "input.apply != '' ", 
                           verticalLayout(
                            sidebarLayout( sidebarPanel(
                              textOutput("On what do you want to bet?", inline = TRUE),
                              uiOutput("betOn"),
                              actionButton("set", "Set")
                            ),
                            mainPanel(
                              imageOutput("image")
                           )),
                           conditionalPanel(condition = "input.knownProb == Yes",
                                            column(12, tableOutput("probabilities")))
                           ),
                           conditionalPanel(condition = "input.set != '' ",
                                           sidebarLayout(
                                             sidebarPanel(
                                               textOutput("status", inline = TRUE),
                                               selectInput("segment", "On what will you bet?", choices = names(multiplier_ame)),
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
                          ))
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
