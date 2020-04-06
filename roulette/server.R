library(shiny)
library(shinythemes)
library(lubridate)
library(prob)

shinyServer(function(input, output, session) {
  
  money <- reactiveValues(value=0)
  
  observeEvent(input$insert,{money$cur <- input$currency})
  
  observeEvent(input$insert, {money$value <- money$value + as.numeric(input$value)})
 #treba naredit tako, da se bo kolicina denarja ves čas sproti posodabljala 
#  output$denar <- 
  
  # trenutno imam tako, da vstavis denar skoz isto valuto, treba nardit tako, da bo skoz ista valuta in se pretvarja skoz v to enoto
  output$money <- eventReactive(input$insert, paste("You inserted ", input$value, ". Now you have ", money$value))
  
  output$start <- eventReactive(input$apply, # treba še za load file naredit funkcijo, ki preveri, kaj je uporabnik vnesu in uvozi te podatke 
                                paste("You are going to continue with ", typeof(input$load)))
  
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
  
  
  zbirka <- c(1, 2)
  
  rollnumber <- function() {
    # 38 stevilk ima nasa ruleta, dve nicli in od 1 do 36
    ruleta <- c("00", "0", c(1:36))
    #ruleta <- roulette()
    rand <- round(runif(1) * 38, 0)
    return(ruleta[rand])
  }
  
  dobitek <- function(bet, sta_num, rol_num) {
    if (sta_num == rol_num) {
      winning <- bet * (35 + 1)
      return(sprintf("You win %.0f dollars.", winning))
    }
    else {
      return(sprintf("You lose %.0f dollars.", bet))
    }
  }
  
  output$sta <- eventReactive(input$stava, 
                              paste("You betted ", input$bet, " on ", input$number, "."))
   
  output$num <- eventReactive(input$roll, 
                           # paste(paste("Rolled number is", rollnumber(), sep=": "), paste("And you win", input$bet, sep = ": "), sep = ". ")
                            dobitek(input$bet, input$number, rollnumber()))
  
})
