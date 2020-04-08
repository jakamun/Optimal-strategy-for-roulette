library(shiny)
library(shinythemes)
library(lubridate)
library(prob)

shinyServer(function(input, output, session) {
  
  money <- reactiveValues(value=10) # hisa da zacetnih 10 kreditov
  
  observeEvent(input$insert,{money$cur <- input$currency})
  
  observeEvent(input$insert, {money$value <- money$value + as.numeric(input$value)})
 #treba naredit tako, da se bo kolicina denarja ves čas sproti posodabljala 
#  output$denar <- 
  
  # trenutno imam tako, da vstavis denar skoz isto valuto, treba nardit tako, da bo skoz ista valuta in se pretvarja skoz v to enoto
  output$money <- eventReactive(input$insert, paste("You inserted ", input$value, ". Now you have ", money$value))
  
  output$status <- renderText({sprintf("You have %.0f dollars", money$value)})
  
  output$slider <- renderUI({
    sliderInput("amount", "Amount", value = 0, min = 0, max = money$value, step = 1)
  })
  
  choices <- reactive({
    switch(input$segment,
           "Numbers" = c("Green 00", "Green 0", "Red 1", "Black 2", "Red 3", "Black 4", "Red 5", "Black 6",
                         "Red 7", "Black 8", "Red 9", "Black 10", "Black 11", "Red 12", "Black 13", "Red 14", 
                         "Black 15", "Red 16", "Black 17", "Red 18", "Red 19", "Black 20", "Red 21",
                         "Black 22", "Red 23", "Black 24", "Red 25", "Black 26", "Red 27", "Black 28", "Black29",
                         "Red 30", "Black 31", "Red 32", "Black 33", "Red 34", "Black 35", "Red 36"),
           "Color" = c("Red", "Black"),
           "Odd or even" = c("Even", "Odd"))
  })
  
  label <- reactive({
    switch(input$segment,
           "Numbers" = "Choose a number", 
           "Color" = "Choose color",
           "Odd or even" = "Odd or even")
  })
  
  output$buttons <- renderUI({
    radioButtons(inputId = "betOnWhat", label = label(), choices = choices(), inline = TRUE)
  })
  
  output$start <- eventReactive(input$apply, # treba še za load file naredit funkcijo, ki preveri, kaj je uporabnik vnesu in uvozi te podatke 
                                paste("You are going to continue with ", typeof(input$load)))
  
  rollnumber <- function() {
    # 38 stevilk ima nasa ruleta, dve nicli in od 1 do 36
    ruleta <- c("00", "0", c(1:36))
    #ruleta <- roulette()
    rand <- round(runif(1) * 38, 0)
    return(ruleta[rand])
  }
  
  output$sta <- eventReactive(input$stava, 
                              paste("You betted ", input$bet, " on ", input$number, "."))
  
  output$num <- eventReactive(input$spin, 
                              paste("Rolled number is ", rollnumber()))
                             # dobitek(input$bet, input$number, rollnumber()))
  
  timer <- reactiveVal(10)
  active <- reactiveVal(FALSE)
  
  # Output the time left.
  output$timeleft <- renderText({
    paste("Time left: ", seconds_to_period(timer()))
  })
  
  # observer that invalidates every second. If timer is active, decrease by one.
  observe({
    invalidateLater(1000, session)
    isolate({
      if(active())
      {
        timer(timer()-1)
        if(timer()<1)
        { # ko se čas izteče se požene kolo
          active(FALSE)
          showModal(modalDialog(
            title = "Important message",
            "Countdown completed!"
          ))
        }
      }
    })
  })
  
  # observers for actionbuttons
  observeEvent(input$start, {active(TRUE)})
  observeEvent(input$stop, {active(FALSE)})
  
  
  dobitek <- function(bet, sta_num, rol_num) {
    if (sta_num == rol_num) {
      winning <- bet * (35 + 1)
      return(sprintf("You win %.0f dollars.", winning))
    }
    else {
      return(sprintf("You lose %.0f dollars.", bet))
    }
  }
  
  
})
