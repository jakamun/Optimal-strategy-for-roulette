library(shiny)
library(shinythemes)
library(lubridate)
library(prob)

shinyServer(function(input, output, session) {
  
  money <- reactiveValues(value = 10) # hisa da zacetnih 10 kreditov
  
  stave <- reactiveValues(table = data.frame(segment = character(), onWhat = character(), 
                                             amount = numeric(), return = integer(), stringsAsFactors=FALSE))
  
  rolled <- reactiveValues(number = NULL, color = NULL, oddEven = NULL)
  
  ret <- reactive({
    switch(input$segment,
           "Number" = 35,
           "Color" = 1,
           "Odd or even" = 1)
  })
  
  observeEvent(input$bet, {
    stava <- list(input$segment, input$betOnWhat, input$amount, ret())
    stave$table[nrow(stave$table) + 1, ] <- stava
  })
  
  observeEvent(input$clear, {
    stave$table <- stave$table[0,]
  })
  
  output$bets <- renderTable(stave$table)
  
  observeEvent(input$insert,{money$cur <- input$currency})
  
  observeEvent(input$insert, {money$value <- money$value + as.numeric(input$value)})
  
  # trenutno imam tako, da vstavis denar skoz isto valuto, treba nardit tako, da bo skoz ista valuta in se pretvarja skoz v to enoto
  output$money <- eventReactive(input$insert, paste("You inserted ", input$value, ". Now you have ", money$value))
  
  output$status <- renderText({sprintf("You have %.0f dollars", money$value)})
  
  output$slider <- renderUI({
    sliderInput("amount", "Amount", value = 0, min = 0, max = money$value, step = 1)
  })
  
  numbers <- c("Green 00", "Green 0", "Red 1", "Black 2", "Red 3", "Black 4", "Red 5", "Black 6",
               "Red 7", "Black 8", "Red 9", "Black 10", "Black 11", "Red 12", "Black 13", "Red 14", 
               "Black 15", "Red 16", "Black 17", "Red 18", "Red 19", "Black 20", "Red 21",
               "Black 22", "Red 23", "Black 24", "Red 25", "Black 26", "Red 27", "Black 28", "Black29",
               "Red 30", "Black 31", "Red 32", "Black 33", "Red 34", "Black 35", "Red 36")
  
  barve <- c("Red", "Black")
  
  sodo_liho <- c("Even", "Odd")
  
  choices <- reactive({
    switch(input$segment,
           "Number" = numbers,
           "Color" = barve,
           "Odd or even" = sodo_liho)
  })
  
  label <- reactive({
    switch(input$segment,
           "Number" = "Choose a number", 
           "Color" = "Choose color",
           "Odd or even" = "Odd or even")
  })
  
  output$buttons <- renderUI({
    radioButtons(inputId = "betOnWhat", label = label(), choices = choices(), inline = TRUE)
  })
  
  output$start <- eventReactive(input$apply, # treba še za load file naredit funkcijo, ki preveri, kaj je uporabnik vnesu in uvozi te podatke 
                                paste("You are going to continue with ", typeof(input$load)))
  
  rollnumber <- function() {
    ruleta <- roulette() 
    verjetnosti <- c(1:38) / sum(1:38)
    rand <- sample(1:38, 1, prob = verjetnosti)
    return(ruleta[rand,])
  }
  
  dobitek <- function(bets, rol_col, rol_num, even) {
    skupaj <- paste(rol_num, rol_col)
    match <- stave$table[stave$table$onWhat == skupaj | stave$table$onWhat == rol_col | stave$table$onWhat == even,]
    if (length(match) != 0) {
      return(sum(match$amount * (match$return + 1)))
    }
    else {
      return(0)
    }
  }
  
  odd_even <- function(num) {
    if (num == "0" | num == "00") {
      return(FALSE)
    }
    else if ((as.integer(num) %% 2) == 0) {
      return("Even")
    }
    else {
      return("Odd")
    }
  }
  
  observeEvent(input$spin, {
    st <- rollnumber()
    rolled$number <- st$num
    rolled$color <- st$color
    rolled$oddEven <- odd_even(paste(st$num))
  })
  
  output$roll <- eventReactive(input$spin, paste(rolled$color, rolled$number))
  
  output$num <- eventReactive(input$spin, 
                              paste(dobitek(stave(), rolled$color, rolled$number, rolled$oddEven)))
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
  
  
  
  
  
})
