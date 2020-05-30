

# Define UI for application that draws a histogram
shinyUI(navbarPage(theme = shinytheme("united"),
  
  # Application title
  title = "Optimal roulette strategy",
    tabPanel("Setings",
       tags$head(tags$style(HTML("h3 { font-style: italic;font-weight:bold;}"))),
      h3("Before you start playing please set some settings."),
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
            textInput("value", "How much money do you want to put in?", value = "0.00"),
            actionButton("insert", "Insert")
          ),
          mainPanel(width = 6,
            verbatimTextOutput("money")
          )
        ))
      ),
  
 tabPanel("Number combinations",
          tags$head(tags$style(HTML("h3 { font-style: italic;font-weight:bold;}"))),
          conditionalPanel(condition = "input.apply == '' ", 
                           fluidRow(column(width=12, align = 'center', inline=TRUE, 
                                           div(style = "height:20px;font-size: 35px;font-weight:bold;",
                                               "Please select starting parameters!")))),
          conditionalPanel(condition = "input.apply != '' ",
                           fluidRow(h3("Select on what kind of a number combinations do you wish to bet."),
                                    column(width = 12, align = "center", imageOutput("image"))),
                           fluidRow(column(width = 5,
                                      textOutput("On what do you want to bet?", inline = TRUE),
                                      uiOutput("betOn"),
                                      uiOutput("subBetOn"),
                                      actionButton("clearComb", "Clear selected combinations"),
                                      actionButton("clearAllComb", "Clear all combinations"),
                                      actionButton("set", "Set")
                                      ),
                                    column(width=7,
                                           verbatimTextOutput("combWarning")
                                    ),
                                    column(width=7,
                                           verbatimTextOutput("combError")
                                    ),
                                    column(width = 8,
                                           conditionalPanel(condition = "input.knownProb == Yes",
                                                            textInput("alfa", "Select learning rate", value = "0.00")),
                                           actionButton("calcStrategy", "Calculate optimal strategy")),
                                    column(width = 4,
                                           verbatimTextOutput("reportCombinations"))
                                    ),
                           tabsetPanel(
                             #     conditionalPanel(condition = "")
                             tabPanel("Probabilities", DT::dataTableOutput("probabilities")),
                             tabPanel("Choosen number combinations", DT::dataTableOutput("chooseCombinations")),
                             tabPanel("Unchosen numbers", DT::dataTableOutput("unchosen"))
                           )
                                           
          )),
  
 tabPanel("Play it yourself",
          conditionalPanel(condition = "input.apply == '' ", 
                           fluidRow(column(width=12, align = 'center', inline=TRUE, 
                                           div(style = "height:20px;font-size: 35px;font-weight:bold;",
                                              "Please select starting parameters!")))),
          conditionalPanel(condition = "input.apply != '' ", 
                           conditionalPanel(condition = "input.set == '' ",
                                            fluidRow(column(width=12, align = 'center', inline=TRUE, 
                                                            div(style = "height:20px;font-size: 35px;font-weight:bold;",
                                                                "Before you start playing please select number combinations on which you wish to bet.")))),
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
 
 tabPanel(title = "Simulate",
          conditionalPanel(condition = "input.apply == '' ", 
                           fluidRow(column(width=12, align = 'center', inline=TRUE, 
                                           div(style = "height:20px;font-size: 35px;font-weight:bold;",
                                               "Please select starting parameters!")))))

#  fluidRow(
#    column(12,
 #          actionButton('start','Start'),
  #         actionButton('stop','Stop'),
   #        textOutput('timeleft')),
    
#  )
  
  )
)
