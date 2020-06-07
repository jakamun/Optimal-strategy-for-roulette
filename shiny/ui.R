

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
            verbatimTextOutput("money"),
            verbatimTextOutput("insert")
          )
        ))
      ),
  
 tabPanel("Number combinations",
          tags$head(tags$style(HTML("h3 { font-style: italic;font-weight:bold;text-align: center};
                                     h4 { font-style: italic;font-weight:bold;}"))),
          conditionalPanel(condition = "input.apply == '' ", 
                           fluidRow(column(width=12, align = 'center', inline=TRUE, 
                                           div(style = "height:20px;font-size: 35px;font-weight:bold;",
                                               "Please select what kind of roulete do you want to play.")))),
          conditionalPanel(condition = "input.apply != '' ",
                           wellPanel(fluidRow(
                                    h3("Select on what kind of a number combinations do you wish to bet."),
                                    column(width = 12, align = "center", imageOutput("image")))),
                           wellPanel(fluidRow(
                             column(width=12,
                                    tags$h4("Note:"),
                                    verbatimTextOutput("note")),
                             column(width=12,
                                    conditionalPanel(condition = "output.alfaHint != '' ",
                                                     tags$h4("Learning rate hint:")),
                                    verbatimTextOutput("alfaHint"))
                           )),
                                    wellPanel(sidebarLayout(sidebarPanel(width=5,
                                                              textOutput("On what do you want to bet?", inline = TRUE),
                                                              uiOutput("betOn"),
                                                              uiOutput("subBetOn"),
                                                              uiOutput("alfa"),
                                                              actionButton("clearComb", "Clear selected combinations"),
                                                              actionButton("clearAllComb", "Clear all combinations"),
                                                              actionButton("set", "Set combination"),
                                                              actionButton("calcStrategy", "Calculate optimal strategy")
                                      ),
                                      mainPanel(width = 7,
                                                column(width=7,
                                                       conditionalPanel(condition = "output.combWarning != '' ",
                                                                        tags$h4("Warning:")),
                                                       tags$head(tags$style("#combWarning{color: red;}")),
                                                       verbatimTextOutput("combWarning")
                                                ),
                                                column(width=7,
                                                       conditionalPanel(condition = "output.combError != '' ",
                                                                        tags$h4("Error:")),
                                                       tags$head(tags$style("#combError{color: red;}")),
                                                       verbatimTextOutput("combError")
                                                ),
                                                column(width=7,
                                                       conditionalPanel(condition = "output.sucess != '' ",
                                                                        tags$h4("Sucess:")),
                                                       tags$head(tags$style("#sucess{color: green;}")),
                                                       verbatimTextOutput("sucess")),
                                                column(width = 7,
                                                       conditionalPanel(condition = "output.reportCombinations != '' ",
                                                                        tags$h4("Calculation note:")),
                                                       tags$head(tags$style("#reportCombinations{color: green;}")),
                                                       verbatimTextOutput("reportCombinations")),
                                                column(width = 7,
                                                       conditionalPanel(condition = "output.calcError != '' ",
                                                                        tags$h4("Calculation error:")),
                                                       tags$head(tags$style("#calcError{color: red;}")),
                                                       verbatimTextOutput("calcError")
                                                       )
                                    ))),
                           wellPanel(tabsetPanel(
                                     tabPanel("Probabilities", 
                                              DT::dataTableOutput("probabilities"),
                                              tags$head(tags$style("#knownProbNote{font-size: 15px;}")),
                                              verbatimTextOutput("knownProbNote")
                                              
                                     ),
                                     tabPanel("Choosen number combinations", DT::dataTableOutput("chooseCombinations")),
                                     tabPanel("Unchosen numbers", DT::dataTableOutput("unchosen")),
                                     tabPanel("Strategy", DT::dataTableOutput("strategy1"))
                           ))
                                           
          )),
  
 tabPanel("Play it yourself",
          conditionalPanel(condition = "input.apply == '' ", 
                           fluidRow(column(width=12, align = 'center', inline=TRUE, 
                                           div(style = "height:20px;font-size: 35px;font-weight:bold;",
                                              "Please select what kind of roulete do you want to play.")))),
          conditionalPanel(condition = "input.apply != '' ", 
                           wellPanel(fluidRow(
                             h3("You can play roulette here."),
                             column(width = 12, align = "center", imageOutput("image2")))),
                           wellPanel(sidebarLayout(
                             sidebarPanel(
                               uiOutput("playNumComb"),
                               uiOutput("subplayNumComb"),
                               uiOutput("slider"),
                               actionButton("clearSelect", "Clear selected bets"),
                               actionButton("clearAll", "Clear all bets"),
                               actionButton("bet", "Place bet"),
                               actionButton("spin", "Spin the wheel")
                             ),
                             mainPanel(
                               column(width = 7,
                                      h4("Money amount:"),
                                      verbatimTextOutput("money2")),
                               column(width = 7,
                                      conditionalPanel(condition = "output.incorectBet != '' ",
                                                       tags$h4("Warning:")),
                                      tags$head(tags$style("#incorectBet{color: red;}")),
                                      verbatimTextOutput("incorectBet")
                               ),
                               column(width = 7,
                                      conditionalPanel(condition = "input.spin != '' ",
                                                       tags$h4("Rolled number:")),
                                      verbatimTextOutput("roll")),
                               column(width = 7,
                                      conditionalPanel(condition = "input.spin != '' ",
                                                       tags$h4("Winnings:")),
                                      verbatimTextOutput("win"))
                           ))),
                           wellPanel(tabsetPanel(
                             tabPanel("Placed bets", DT::dataTableOutput("bets")),
                             tabPanel("Strategy", DT::dataTableOutput("strategy"))
                           ))
          )),
 
 tabPanel(title = "Simulate",
          conditionalPanel(condition = "input.apply == '' ", 
                           fluidRow(column(width=12, align = 'center', inline=TRUE, 
                                           div(style = "height:20px;font-size: 35px;font-weight:bold;",
                                               "Please select what kind of roulete do you want to play.")))),
          conditionalPanel(condition = "input.apply != '' && input.calcStrategy == '' ",
                           fluidRow(column(width=12, align = 'center', inline=TRUE, 
                                           div(style = "height:20px;font-size: 35px;font-weight:bold;",
                                               "First you have to set a strategy and then you can simulate it.")))
                           ),
          # PAZI TA POGOJ TREBA ŠE POPRAVIT
          conditionalPanel(condition = "input.apply != '' && input.calcStrategy != '' ",
                           wellPanel(fluidRow(
                             h3("You can test suggested strategy here."))),
                           wellPanel(
                             sidebarLayout(
                               sidebarPanel(
                                 actionButton("test", "Simulate")
                               ),
                               mainPanel(
                                 plotOutput("sim")
                               )
                             )
                           )
                           )
          )

)
)

