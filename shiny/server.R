

shinyServer(function(input, output, session) {
  
  money <- reactiveValues(value = 10) # hisa da zacetnih 10 kreditov
  
  stave <- reactiveValues(table = data.frame(segment = character(), onWhat = character(), 
                                             amount = numeric(), return = integer(), stringsAsFactors=FALSE))
  
  rolled <- reactiveValues(miza = NULL)
  
  multiplier <- function(react) {
    switch(react,
           "Number" = 35,
           "Color" = 1,
           "Odd or even" = 1
           )
  }
  
  ret <- reactive({
    multiplier(input$segment)
  })
  
  observeEvent(input$bet, {
    money$value <- money$value - input$amount
    stava <- list(input$segment, input$betOnWhat, input$amount, ret())
    stave$table[nrow(stave$table) + 1, ] <- stava
  })
  
  observeEvent(input$clear, {
    stave$table <- stave$table[0,]
  })
  
  observeEvent(input$apply, {
    rolled$miza <- unfair_roulete(input$type)
  })
  
  #####################################################################
  ##### strategijo treba spreminjat glede na kaj si izbereš
  ##################################################
  ##### oz., da kar sam pove kere segmente naj si izberem
  #########################################################
  miza1 <- observeEvent(input$set, {
    rolled$miza <- reindex(rolled$miza$num, rolled$miza$prob, ret())
    gama_r <- gama_0(rolled$miza)
    rolled$miza$strategy <- gamas(rolled$miza, gama_r[1], gama_r[2])
    rolled$miza$ord <- NULL
    output$strategy <- renderTable(rolled$miza)
  })
  
  output$image <- renderImage({
    if (input$type == "American") {
      list(
        src = "../images/american-roulette.png",
        width = 400,
        height = 181,
        contentType = "image/png",
        alt = "Miza"
      )
    }
    
    else {
      list(
        src = "../images/european-roulette.png",
        width = 400,
        height = 181,
        contentType = "image/png",
        alt = "Miza"
      )
    }
  }, deleteFile = FALSE)
  
  output$bets <- renderTable(stave$table)
  
  observeEvent(input$insert,{money$cur <- input$currency})
  
  observeEvent(input$insert, {money$value <- money$value + as.numeric(input$value)})
  
  # trenutno imam tako, da vstavis denar skoz isto valuto, treba nardit tako, da bo skoz ista valuta in se pretvarja skoz v to enoto
  output$money <- eventReactive(input$insert, paste("You inserted ", input$value, ". Now you have ", money$value))
  
  output$status <- renderText({sprintf("You have %.0f dollars", money$value)})
  
  output$slider <- renderUI({
    sliderInput("amount", "Amount", value = 0, min = 0, max = money$value, step = 1)
  })
  
  
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
  
  output$start <- eventReactive(input$load, # treba še za load file naredit funkcijo, ki preveri, kaj je uporabnik vnesu in uvozi te podatke 
                                paste("You are going to continue with ", typeof(input$file)))
  
  
  
  #miza$strategy <- strategy(miza$num, miza$prob, 35)
  
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
    rand <- sample(1:nrow(rolled$miza), 1, prob = rolled$miza$prob)
    st <- rolled$miza[rand,]
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
