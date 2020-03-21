library(shiny)
library(shinythemes)

shinyServer(function(input, output) {
  
  zbirka <- c(1, 2)
  
  rollnumber <- function() {
    # 38 stevilk ima nasa ruleta, dve nicli in od 1 do 36
    stevilke <- c("00", "0", c(1:36))
    rand <- round(runif(1) * 38, 0)
    return(stevilke[rand])
  }
  
  output$sta <- eventReactive(input$stava, 
                              paste("You betted ", input$bet, " on ", input$number, "."))
   
  output$num <- eventReactive(input$roll, 
                            paste(paste("Rolled number is", rollnumber(), sep=": "), paste("And you win", input$bet, sep = ": "), sep = ". "))
  
})
