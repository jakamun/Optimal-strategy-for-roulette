

shinyServer(function(input, output, session) {
  
  
  # REACTIVE VALUES
  money <- reactiveValues(amount = 0, cur = NULL) # hisa da zacetnih 10 enot denarja, vseno ali zberemo euro ali dolar
  
  report <- reactiveValues(money = "", start = "")
  
  ######## KAJ S TEM
  stave <- reactiveValues(table = data.frame(segment = character(), onWhat = character(), 
                                             amount = numeric(), return = integer(), stringsAsFactors=FALSE))
  #############
  
  miza <- reactiveValues(miza = NULL, type = NULL, knownProb = NULL)
  
  num_combinations <- reactiveValues(chosenCombinations = NULL,
                                     missing_num = NULL,
                                     calcStrategy = NULL,
                                     fallen = NULL)
  
  click <- reactiveValues(clicked_f = 1, comb = "", error = "")
  
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
    miza$type <- input$type
    miza$miza <- unfair_roulete(checktype(input$type))
    miza$knownProb <- input$knownProb
    num_combinations$chosenCombinations <- NULL
    num_combinations$calcStrategy <- NULL
    num_combinations$missing_num <- miza$miza$num
    click$clicked_f <- 1
    click$error <- ""
    click$comb <- ""
  })
  
  output$knownProbNote <- renderText({if (miza$knownProb == 'No') {
    paste("You're playing roulette with unknown probabilities.", 
          "If you want to know prabilities you should set this on settings page.", sep = "\n")}
    })
  
  observeEvent(input$apply, {
    report$money <- paste0("You have ", sprintf("%.2f", money$amount), cur_sym(input$currency), ".")
  })
  
  
  observeEvent(input$insert, {money$amount <- money$amount + convert(input$curren, money$cur, as.numeric(input$value))})
  
  observeEvent(input$insert, {
    report$money <- paste(paste0("You inserted ", input$value, cur_sym(input$curren), "."),
                       paste0("Now you have ", sprintf("%.2f", money$amount), cur_sym(money$cur), "."), sep="\n")
  })
  
  
  output$start <- renderText({report$start})
  
  output$money <- renderText({report$money})

  
  output$betOn <- renderUI({
    if (input$type == "American"){
      selectInput("betOn", "I'm going to bet on:", choices = names(multiplier_ame), selected = "Number")
    }
    else {
      selectInput("betOn", "I'm going to bet on:", choices = names(multiplier_eu), selected = "Number") 
    }
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
    pickerInput("subBetOn", label = label(), 
                       choices = choices(),
                       selected = choices()[1],
                       options = list(`actions-box` = TRUE),
                       multiple = T)
  })
  
  output$alfa <- renderUI({
    if (miza$knownProb == "No") {
      textInput("alfa", "Select learning rate", value = "200")
    }
  })
  
  tables <- reactive({
    switch(input$betOn,
           "Number" = miza$miza,
           "Color" = segments_distribution(miza$miza, barve),
           "Odd or even" = segments_distribution(miza$miza, even_odd),
           "Low or high" = segments_distribution(miza$miza, low_high),
           "Dozen" = segments_distribution(miza$miza, dozen),
           "Row" = segments_distribution(miza$miza, row),
           "6 number combination" = segments_distribution(miza$miza, six_num),
           "5 number combination" = segments_distribution(miza$miza, five_num),
           "4 number combination" = if (miza$type == "American") {segments_distribution(miza$miza, four_num[-1])} else {segments_distribution(miza$miza, four_num)},
           "3 number combination" = if (miza$type == "American") {segments_distribution(miza$miza, three_num_ame)} else {segments_distribution(miza$miza, three_num_eu)},
           "2 number combination" = if (miza$type == "American") {segments_distribution(miza$miza, two_num_ame)} else {segments_distribution(miza$miza, two_num_eu)})
  })
  
  output$probabilities <- DT::renderDataTable({
    if (miza$knownProb == "Yes") {
      tables()
    }
  })
  
  chosenNumbers <- eventReactive(input$subBetOn, {
    if (input$betOn == "Number") {
      input$subBetOn
    }
    else if (miza$type == "American") {
      unlist(ame_bets[[input$betOn]][input$subBetOn], use.names = FALSE)
    } 
    else {
      unlist(eu_bets[[input$betOn]][input$subBetOn], use.names = FALSE)
    }
  })
  
  reportOverlap <- eventReactive(input$subBetOn, {
    if ((input$betOn == "Number") && (sum(num_combinations$chosenCombinations$num_comb %in% input$subBetOn) > 0)) {
      overlap <- input$subBetOn[input$subBetOn %in% num_combinations$chosenCombinations$num_comb]
      paste("You have already selected the following numbers:", paste(overlap, collapse = ", "))
    }
    else if (sum(num_combinations$chosenCombinations$num_comb %in% input$subBetOn) > 0) {
      overlap <- input$subBetOn[input$subBetOn %in% num_combinations$chosenCombinations$num_comb]
      paste("You have already selected the following combinations:", paste(overlap, collapse = ", "))
    }
    else if (sum(chosenNumbers() %in% num_combinations$missing_num) != length(chosenNumbers())) {
      chosen <- chosenNumbers()
      overlap <- chosen[!(chosen %in% num_combinations$missing_num)]
      paste("In other combinations you have already selected the following numbers:", paste(overlap, collapse = ", "))
    }
  })
  
  output$combWarning <- renderText({reportOverlap()})
  
  
  # javi uporabniku da poskuša izvesti prepovedane stvari
  observeEvent(input$set, {
    if (is.null(reportOverlap()) && click$comb != input$subBetOn) {
      click$error <- ""
      click$comb <- input$subBetOn
      click$clicked_f <- 1
    }
    else {
      click$clicked_f <- 0
      click$error <- "You have tried to set certain combinations that involve numbers that you already selected."
    }
  })
  
  output$combError <- renderText({click$error})
  
  output$note <- renderText({
    if (input$knownProb == "Yes") {
      paste("Algorithm will give you optimal strategy only if you cover all the posible numbers.",
            "It's not a bad idea to select numbers with high probabilities in a way that they will have high payoff.", sep = "\n")
    }
    else {
      paste("Algorithm will give you optimal strategy only if you cover all the posible numbers.",
            "If you want a high payoff you should select combinations that have high payoff.", sep = "\n")
    }
  })
  
  observeEvent(input$set, {
    if ((miza$type == "American") && (input$betOn != "Number") && (click$clicked_f == 1)) {
      mul <- multiplier_ame[[input$betOn]]
      numbers <- unlist(ame_bets[[input$betOn]][input$subBetOn], use.names = FALSE)
      num_combinations$missing_num <- num_combinations$missing_num[!(num_combinations$missing_num %in% numbers)]
      verjetnosti <- merge(tables(), data.frame(combinations = input$subBetOn))$prob
      combinations <- data.frame(num_comb_type = input$betOn, num_comb = input$subBetOn, prob = verjetnosti, multiplier = mul)
      num_combinations$chosenCombinations <- start_prob_predict(num_combinations$chosenCombinations, combinations, miza$knownProb, input$alfa)
    }
    else if ((miza$type == "American") && (input$betOn == "Number") && (click$clicked_f == 1)) {
      mul <- multiplier_ame[[input$betOn]]
      numbers <- input$subBetOn
      num_combinations$missing_num <- num_combinations$missing_num[!(num_combinations$missing_num %in% numbers)]
      verjetnosti <- merge(tables(), data.frame(num = input$subBetOn))$prob
      combinations <- data.frame(num_comb_type = input$betOn, num_comb = input$subBetOn, prob = verjetnosti, multiplier = mul)
      num_combinations$chosenCombinations <- start_prob_predict(num_combinations$chosenCombinations, combinations, miza$knownProb, input$alfa)
    }
    else if ((miza$type == "European") && (input$betOn == "Number") && (click$clicked_f == 1)) {
      mul <- multiplier_eu[[input$betOn]]
      numbers <- input$subBetOn
      num_combinations$missing_num <- num_combinations$missing_num[!(num_combinations$missing_num %in% numbers)]
      verjetnosti <- merge(tables(), data.frame(num = input$subBetOn))$prob
      combinations <- data.frame(num_comb_type = input$betOn, num_comb = input$subBetOn, prob = verjetnosti, multiplier = mul)
      num_combinations$chosenCombinations <- start_prob_predict(num_combinations$chosenCombinations, combinations, miza$knownProb, input$alfa)
    }
    else if ((miza$type == "European") && (input$betOn != "Number") && (click$clicked_f == 1)) {
      mul <- multiplier_eu[[input$betOn]]
      numbers <- unlist(eu_bets[[input$betOn]][input$subBetOn], use.names = FALSE)
      num_combinations$missing_num <- num_combinations$missing_num[!(num_combinations$missing_num %in% numbers)]
      verjetnosti <- merge(tables(), data.frame(combinations = input$subBetOn))$prob
      combinations <- data.frame(num_comb_type = input$betOn, num_comb = input$subBetOn, prob = verjetnosti, multiplier = mul)
      num_combinations$chosenCombinations <- start_prob_predict(num_combinations$chosenCombinations, combinations, miza$knownProb, input$alfa)
    }
  })
  
  
  observeEvent(input$clearAllComb, {
    num_combinations$chosenCombinations <- NULL
    num_combinations$missing_num <- miza$miza$num
    click$clicked_f <- 1
    click$error <- ""
    click$comb <- ""
  })
  
  observeEvent(input$clearComb, {
    delete <- input$subBetOn
    num_combinations$chosenCombinations <- num_combinations$chosenCombinations[!(num_combinations$chosenCombinations$num_comb %in% delete),]
    num_combinations$missing_num <- c(num_combinations$missing_num, delete)
    click$clicked_f <- 1
    click$error <- ""
    click$comb <- ""
  })
  
  output$sucess <- renderText({
    if (length(num_combinations$missing_num) == 0) {
      paste("Great you have selected all the numbers.", "Algorithm can now calculate optimal strategy.", sep="\n")
    }
    else {
      ""
    }
  })
  
  output$chooseCombinations <- DT::renderDataTable({
    if (miza$knownProb == "Yes") {
      num_combinations$chosenCombinations
    }
    else {
      if (is.null(num_combinations$chosenCombinations)) {
        NULL
      }
      else {
        num_combinations$chosenCombinations %>% select(num_comb_type, num_comb, multiplier, alfa, pred_prob)
      }
    }
  })
  
  output$unchosen <- DT::renderDataTable({
    miza$miza[miza$miza$num %in% num_combinations$missing_num,]
  })
  
  reportStrategyCalc <- eventReactive(input$calcStrategy, {
    if (length(num_combinations$missing_num) == 0 && miza$knownProb == "No") {
      "Algorithm has calculated starting strategy becouse you don't know probabilities strategy will change in each step. You can also test the algorithm with simulation."
    }
    else if (length(num_combinations$missing_num) == 0 && miza$knownProb == "Yes") {
      "Algorithm has calculated the optimal strategy. Now you can test it with simulation or you can play roulette."
    }
    else {
      "You should choose combinations that cover all the numbers. Only then can algorithm calculate optimal strategy."
    }
  })
  
  output$reportCombinations <- renderText({reportStrategyCalc()})
  
  observeEvent(input$calcStrategy, {
    if (miza$knownProb == "Yes") {
      num_combinations$calcStrategy <- strategy(num_combinations$chosenCombinations)
      output$strategy1 <- DT::renderDataTable({num_combinations$calcStrategy})
      output$strategy1 <- DT::renderDataTable({num_combinations$calcStrategy})
    }
    else {
      preCalcTable <- num_combinations$chosenCombinations %>% select(num_comb_type, num_comb, multiplier, prob = pred_prob)
      num_combinations$calcStrategy <- strategy(preCalcTable)
      output$strategy1 <- DT::renderDataTable({num_combinations$calcStrategy})
    }
  })
  
  
  
  #####################################################################
  ##### strategijo treba spreminjat glede na kaj si izbereš
  ##################################################
  ##### oz., da kar sam pove kere segmente naj si izberem
  #########################################################
  miza1 <- observeEvent(input$set1, {
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
  
  
  
  
  
  
  
})
