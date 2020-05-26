

shinyServer(function(input, output, session) {
  
  # REACTIVE VALUES
  money <- reactiveValues(amount = 0, cur = NULL) # hisa da zacetnih 10 enot denarja, vseno ali zberemo euro ali dolar
  
  report <- reactiveValues(money = "", start = "")
  
  ######## KAJ S TEM
  stave <- reactiveValues(table = data.frame(segment = character(), onWhat = character(), 
                                             amount = numeric(), return = integer(), stringsAsFactors=FALSE))
  #############
  
  miza <- reactiveValues(miza = NULL, type = NULL)
  
  # rest of the code: output, observe Event .... 
  observeEvent(input$apply, {
    if(money$amount == 0) {
      report$start <- paste("You have successfully set the settings!", 
                            paste0("Type of roullete: ", input$type),
                            paste0("Currency: ", money$cur),
                            paste0("Known probabilities:", input$knownProb),
                            paste0("House has given you starting capital of 10 ", cur_sym(input$currency), "."), sep = "\n")
    }
    else {
     report$start <- paste("You have successfully set the settings!", 
                            paste0("Type of roullete: ", input$type),
                            paste0("Currency: ", money$cur),
                            paste0("Known probabilities:", input$knownProb), sep = "\n")
    }
  })
  
  
  observeEvent(input$apply, {
    if (money$amount == 0) {
      money$amount <- 10
      money$cur <- input$currency
    }
    else {
      money$amount <- convert(money$cur, input$currency, money$amount)
      money$cur <- input$currency
    }
  })
  
  observeEvent(input$apply, {
    report$money <- paste0("You have ", sprintf("%.2f", money$amount), cur_sym(input$currency), ".")
  })
  
  
  observeEvent(input$apply, {
    miza$type <- input$type
    miza$miza <- unfair_roulete(checktype(input$type))
  })
  
  observeEvent(input$insert, {money$amount <- money$amount + convert(input$curren, money$cur, as.numeric(input$value))})
  
  observeEvent(input$insert, {
    report$money <- paste(paste0("You inserted ", input$value, cur_sym(input$curren), "."),
                       paste0("Now you have ", sprintf("%.2f", money$amount), cur_sym(money$cur), "."), sep="\n")
  })
  
  
  output$start <- renderText({report$start})
  
  output$money <- renderText({report$money})
  
  
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
  
  output$betOn <- renderUI({
    if (input$type == "American"){
      selectInput("betOn", "I'm going to bet on:", choices = names(multiplier_ame), selected = "Number")
    }
    else {
      selectInput("betOn", "I'm going to bet on:", choices = names(multiplier_eu), selected = "Number") 
    }
  })
  
  # ta se odziva glede na to kaj je izbrano v delu kjer se izbira segmente
  observeEvent(input$segment, {
    1
  })
  
  label <- reactive({
    switch(input$betOn,
           "Number" = "Choose numbers", 
           "Color" = "Choose color",
           "Odd or even" = "Choose odd/even",
           "Low or high" = "Choose low/high",
           "Dozen" = "Choose combinations of 12 numbers",
           "Row" = "Choose rows",
           "6 number combination" = "Choose combinations of 6 numbers",
           "5 number combination" = "Choose combinations of 5 numbers",
           "4 number combination" = "Choose combinations of 4 numbers",
           "3 number combination" = "Choose combinations of 3 numbers",
           "2 number combination" = "Choose combinations of 2 numbers"
           )
  })
 
  choices <- reactive({
    switch(input$betOn,
           "Number" = if (miza$type == "American") {numbers_ame} else {numbers_eu},
           "Color" = names(barve),
           "Odd or even" = names(even_odd),
           "Low or high" = names(low_high),
           "Dozen" = names(dozen),
           "Row" = names(row),
           "6 number combination" = names(six_num),
           "5 number combination" = names(five_num),
           "4 number combination" = if (miza$type == "American") {names(four_num[-1])} else {names(four_num)},
           "3 number combination" = if (miza$type == "American") {names(three_num_ame)} else {names(three_num_eu)},
           "2 number combination" = if (miza$type == "American") {names(two_num_ame)} else {names(two_num_eu)})
  })
  
  output$subBetOn <- renderUI({
    checkboxGroupInput("subBetOn", label = label(), choices = choices(), inline = TRUE)
  })
  
  output$probabilities <- renderTable({miza$miza})
  
  
  #####################################################################
  ##### strategijo treba spreminjat glede na kaj si izbereš
  ##################################################
  ##### oz., da kar sam pove kere segmente naj si izberem
  #########################################################
  miza1 <- observeEvent(input$set, {
    miza$miza <- reindex(miza$miza$num, miza$miza$prob, ret())
    gama_r <- gama_0(miza$miza)
    miza$miza$strategy <- gamas(miza$miza, gama_r[1], gama_r[2])
    miza$miza$ord <- NULL
    output$strategy <- renderTable(miza$miza)
  })
  
  output$image <- renderImage({
    if (input$type == "American") {
      list(
        src = "../images/american-roulette.png",
        width = 500,
        height = 256,
        contentType = "image/png",
        alt = "Miza"
      )
    }
    
    else {
      list(
        src = "../images/european-roulette.png",
        width = 500,
        height = 256,
        contentType = "image/png",
        alt = "Miza"
      )
    }
  }, deleteFile = FALSE)
  
  output$bets <- renderTable(stave$table)
  
  
  output$status <- renderText({sprintf("You have %.0f dollars", money$value)})
  
  output$noSetup <- renderText("Please set the parameters!")
  
  output$slider <- renderUI({
    sliderInput("amount", "Amount", value = 0, min = 0, max = money$value, step = 1)
  })
  
  
  
  
  choices1 <- reactive({
    switch(input$segment,
           "Number" = numbers_ame,
           "Color" = barve,
           "Odd or even" = even_odd)
  })
  
  label1 <- reactive({
    switch(input$segment,
           "Number" = "Choose a number", 
           "Color" = "Choose color",
           "Odd or even" = "Odd or even")
  })
  
  output$buttons <- renderUI({
    radioButtons(inputId = "betOnWhat", label = label1(), choices = choices1(), inline = TRUE)
  })

  
  
  
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
    rand <- sample(1:nrow(miza$miza), 1, prob = miza$miza$prob)
    st <- miza$miza[rand,]
    miza$number <- st$num
    miza$color <- st$color
    miza$oddEven <- odd_even(paste(st$num))
  })
  
  output$roll <- eventReactive(input$spin, paste(miza$color, miza$number))
  
  output$num <- eventReactive(input$spin, 
                              paste(dobitek(stave(), miza$color, miza$number, miza$oddEven)))
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
