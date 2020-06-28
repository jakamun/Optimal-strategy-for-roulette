

shinyServer(function(input, output, session) {
  
  
  # REACTIVE VALUES
  money <- reactiveValues(amount = 0, cur = NULL)
  
  report <- reactiveValues(money = "", insert = "", start = "", calc = "", calcError = "", invalidBet = "")
  
  miza <- reactiveValues(miza = NULL, type = NULL, knownProb = NULL)
  
  num_combinations <- reactiveValues(chosenCombinations = NULL,
                                     missing_num = NULL,
                                     calcStrategy = NULL,
                                     fallen = NULL)
  
  click <- reactiveValues(clicked_f = 1, comb = "", error = "")
  
  stave <- reactiveValues(table = NULL)
  
  simData <- reactiveValues(iter = NULL, endTable = NULL, moneyMove = NULL)
  
  # code for first two tabs: setings tab and number combinations tab 
  observeEvent(input$apply, {
    if(money$amount == 0) {
      report$start <- paste("You have successfully set the settings!", 
                            paste0("Type of roullete: ", input$type),
                            paste0("Currency: ", money$cur),
                            paste0("Known probabilities:", input$knownProb),
                            paste0(sprintf("House has given you starting capital of %.2f ", convert("Euro", input$currency, 10)),
                                   cur_sym(input$currency), "."), sep = "\n")
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
      money$amount <- convert("Euro", input$currency, 10)
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
    num_combinations$fallen <- NULL
    num_combinations$missing_num <- miza$miza$num
    click$clicked_f <- 1
    click$error <- ""
    click$comb <- ""
    report$calc <- ""
    report$calcError <- ""
    stave$table <- NULL
  })
  
  output$knownProbNote <- renderText({if (miza$knownProb == 'No') {
    paste("You're playing roulette with unknown probabilities.", 
          "If you want to know prabilities you should set this on settings page.", sep = "\n")}
    })
  
  observeEvent(input$apply, {
    report$money <- paste0("You have ", sprintf("%.2f", money$amount), cur_sym(input$currency), ".")
  })
  
  
  observeEvent(input$insert, {
    if (is.null(num_combinations$calcStrategy)) {
      money$amount <- money$amount + convert(input$curren, money$cur, as.numeric(input$value))
    }
    else {
      money$amount <- money$amount + convert(input$curren, money$cur, as.numeric(input$value))
      num_combinations$calcStrategy$bet <- round(num_combinations$calcStrategy$bet_share * money$amount, 2)
    }
  })
  
  observeEvent(input$insert, {
    report$insert <- paste0("You inserted ", input$value, cur_sym(input$curren), ".")
    report$money <- paste0("You have ", sprintf("%.2f", money$amount), cur_sym(money$cur), ".")
  })
  
  
  output$start <- renderText({report$start})
  
  output$money <- renderText({report$money})

  output$insert <- renderText({report$insert})
  
  output$betOn <- renderUI({
    if (miza$type == "American"){
      selectInput("betOn", "I'm going to bet on:", choices = names(multiplier_ame), selected = "Number")
    }
    else {
      selectInput("betOn", "I'm going to bet on:", choices = names(multiplier_eu), selected = "Number") 
    }
  })
  
  slika <- eventReactive(input$apply, {
    if (miza$type == "American") {
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
  })
  
  output$image <- renderImage({
    slika()
  }, deleteFile = FALSE)
  
  
  label <- reactive({
    switch(input$betOn,
           "Number" = HTML(sprintf("Payoff for betting on numbers is %.0f:1. <br/> Choose numbers:", multiplier_ame[[input$betOn]])), 
           "Color" = HTML(sprintf("Payoff for betting on color is %.0f:1. <br/> Choose color:", multiplier_ame[[input$betOn]])),
           "Odd or even" = HTML(sprintf("Payoff for betting on odd/even is %.0f:1. <br/> Choose odd/even:", multiplier_ame[[input$betOn]])),
           "Low or high" = HTML(sprintf("Payoff for betting on low/high is %.0f:1. <br/> Choose low/high:", multiplier_ame[[input$betOn]])),
           "Dozen" = HTML(sprintf("Payoff for betting on combinations of 12 numbers is %.0f:1. <br/> Choose combinations of 12 numbers:", multiplier_ame[[input$betOn]])),
           "Row" = HTML(sprintf("Payoff for betting on rows is %.0f:1. <br/> Choose rows:", multiplier_ame[[input$betOn]])),
           "6 number combination" = HTML(sprintf("Payoff for betting on combinations of 6 numbers is %.0f:1. <br/> Choose combinations of 6 numbers:", multiplier_ame[[input$betOn]])),
           "5 number combination" = HTML(sprintf("Payoff for betting on combinations of 5 numbers is %.0f:1. <br/> Choose combinations of 5 numbers:", multiplier_ame[[input$betOn]])),
           "4 number combination" = HTML(sprintf("Payoff for betting on combinations of 4 numbers is %.0f:1. <br/> Choose combinations of 4 numbers:", multiplier_ame[[input$betOn]])),
           "3 number combination" = HTML(sprintf("Payoff for betting on combinations of 3 numbers is %.0f:1. <br/> Choose combinations of 3 numbers:", multiplier_ame[[input$betOn]])),
           "2 number combination" = HTML(sprintf("Payoff for betting on combinations of 2 numbers is %.0f:1. <br/> Choose combinations of 2 numbers:", multiplier_ame[[input$betOn]]))
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
      paste("Algorithm will give you optimal strategy only if you cover all the posible numbers.")
  })
  
  output$alfaHint <- renderText({
    if (miza$knownProb == "No") {
      paste("If you set high learning rate, then convergence to right probabilities will be slow.",
            "If you set low learning rate, then convergence will be fast. But you might converge to wrong probabilities.",
            "Learning rate should be at least 100 so that algorithm converges to right probabilities.", sep = "\n")
    }
    else {
      ""
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
    #num_combinations$calcStrategy <- NULL
    report$calc <- ""
    report$calcError <- ""
    click$clicked_f <- 1
    click$error <- ""
    click$comb <- ""
  })
  
  observeEvent(input$clearComb, {
    delete <- input$subBetOn
    num_combinations$chosenCombinations <- num_combinations$chosenCombinations[!(num_combinations$chosenCombinations$num_comb %in% delete),]
    num_combinations$missing_num <- c(num_combinations$missing_num, delete)
    #num_combinations$calcStrategy <- NULL
    report$calc <- ""
    report$calcError <- ""
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
      if (is.null(num_combinations$chosenCombinations)) {
        data.frame(num_comb_type = character(), num_comb = character(), prob = numeric(), multiplier = integer())
      }
      else {
        num_combinations$chosenCombinations
      }
    }
    else {
      if (is.null(num_combinations$chosenCombinations)) {
        data.frame(num_comb_type = character(), num_comb = character(), multiplier = integer(), alfa = numeric(), pred_prob = numeric())
      }
      else {
        num_combinations$chosenCombinations %>% select(num_comb_type, num_comb, multiplier, alfa, pred_prob)
      }
    }
  })
  
  output$unchosen <- DT::renderDataTable({
    if (miza$knownProb == "Yes") {
      miza$miza[miza$miza$num %in% num_combinations$missing_num,] 
    }
    else {
      miza$miza[miza$miza$num %in% num_combinations$missing_num,] %>% select(num)
    }
  })
  
  observeEvent(input$calcStrategy, {
    if (miza$knownProb == "Yes" && length(num_combinations$missing_num) == 0) {
      num_combinations$calcStrategy <- strategy(num_combinations$chosenCombinations)
      num_combinations$calcStrategy$fallen <- rep(0,nrow(num_combinations$calcStrategy))
      num_combinations$calcStrategy <- num_combinations$calcStrategy %>% select(num_comb_type, num_comb, multiplier, fallen, prob, bet_share)
      num_combinations$calcStrategy$bet <- round(num_combinations$calcStrategy$bet_share * money$amount, 2)
    }
    else if (miza$knownProb == "No" && length(num_combinations$missing_num) == 0) {
      preCalcTable <- num_combinations$chosenCombinations %>% select(num_comb_type, num_comb, multiplier, prob = pred_prob)
      num_combinations$calcStrategy <- strategy(preCalcTable) %>% rename(pred_prob = prob)
      num_combinations$calcStrategy$fallen <- rep(0,nrow(num_combinations$calcStrategy))
      num_combinations$calcStrategy <- merge(num_combinations$calcStrategy, num_combinations$chosenCombinations %>% select(num_comb, alfa))
      num_combinations$calcStrategy <- num_combinations$calcStrategy %>% select(num_comb_type, num_comb, multiplier, fallen, alfa, pred_prob, bet_share)
      num_combinations$calcStrategy$bet <- round(num_combinations$calcStrategy$bet_share * money$amount, 2)
    }
  })
  
  output$strategy1 <- DT::renderDataTable({
    if (miza$knownProb == "No") {
      if (is.null(num_combinations$calcStrategy)) {
        data.frame(num_comb_type = character(), num_comb = character(), multiplier = integer(),
                   fallen = integer(), alfa = numeric(), pred_prob = numeric(), bet_share = numeric(), bet = numeric())
      }
      else {
        num_combinations$calcStrategy %>% arrange(desc(bet_share))
      }
    }
    else {
      if (is.null(num_combinations$calcStrategy)) {
        data.frame(num_comb_type = character(), num_comb = character(), multiplier = integer(),
                   fallen = integer(), prob = numeric(), bet_share = numeric(), bet = numeric())
      }
      else {
        num_combinations$calcStrategy %>% arrange(desc(bet_share))
      }
    }
  })
  
  observeEvent(input$calcStrategy, {
    if (length(num_combinations$missing_num) == 0 && miza$knownProb == "No") { 
      report$calc <- paste("Algorithm has calculated starting betting strategy for selected alfas.", 
                            "Becouse you don't know probabilities strategy will change in each step.",
                            "You can also test the algorithm with simulation.", sep = "\n")
    }
    else if (length(num_combinations$missing_num) == 0 && miza$knownProb == "Yes") {
      report$calc <- paste("Algorithm has calculated the optimal betting strategy for given probabilities.",
                            "Now you can test it with simulation or you can use this strategy in game.", sep = "\n")
    }
  })
  
  observeEvent(input$calcStrategy, {
    if (length(num_combinations$missing_num) != 0) {
      report$calcError <- paste("You should choose combinations that cover all the numbers.",
                                "Only then can algorithm calculate optimal strategy.", sep = "\n")
    }
  })
  
  observeEvent(input$set, {
    report$calc <- ""
    report$calcError <- ""
  })
  
  output$reportCombinations <- renderText({report$calc})
  
  output$calcError <- renderText({report$calcError})
  
  ###############################################################
  # igra roulete, drugi zavihek
  output$playNumComb <- renderUI({
    if (miza$type == "American"){
      selectInput("playNumComb", "I'm going to bet on:", choices = names(multiplier_ame), selected = "Number")
    }
    else {
      selectInput("playNumComb", "I'm going to bet on:", choices = names(multiplier_eu), selected = "Number") 
    }
  })
  
  playLabel <- reactive({
    switch(input$playNumComb,
           "Number" = HTML(sprintf("Payoff for betting on numbers is %.0f:1. <br/> Choose numbers:", multiplier_ame[[input$playNumComb]])), 
           "Color" = HTML(sprintf("Payoff for betting on color is %.0f:1. <br/> Choose color:", multiplier_ame[[input$playNumComb]])),
           "Odd or even" = HTML(sprintf("Payoff for betting on odd/even is %.0f:1. <br/> Choose odd/even:", multiplier_ame[[input$playNumComb]])),
           "Low or high" = HTML(sprintf("Payoff for betting on low/high is %.0f:1. <br/> Choose low/high:", multiplier_ame[[input$playNumComb]])),
           "Dozen" = HTML(sprintf("Payoff for betting on combinations of 12 numbers is %.0f:1. <br/> Choose combinations of 12 numbers:", multiplier_ame[[input$playNumComb]])),
           "Row" = HTML(sprintf("Payoff for betting on rows is %.0f:1. <br/> Choose rows:", multiplier_ame[[input$playNumComb]])),
           "6 number combination" = HTML(sprintf("Payoff for betting on combinations of 6 numbers is %.0f:1. <br/> Choose combinations of 6 numbers:", multiplier_ame[[input$playNumComb]])),
           "5 number combination" = HTML(sprintf("Payoff for betting on combinations of 5 numbers is %.0f:1. <br/> Choose combinations of 5 numbers:", multiplier_ame[[input$playNumComb]])),
           "4 number combination" = HTML(sprintf("Payoff for betting on combinations of 4 numbers is %.0f:1. <br/> Choose combinations of 4 numbers:", multiplier_ame[[input$playNumComb]])),
           "3 number combination" = HTML(sprintf("Payoff for betting on combinations of 3 numbers is %.0f:1. <br/> Choose combinations of 3 numbers:", multiplier_ame[[input$playNumComb]])),
           "2 number combination" = HTML(sprintf("Payoff for betting on combinations of 2 numbers is %.0f:1. <br/> Choose combinations of 2 numbers:", multiplier_ame[[input$playNumComb]]))
    )
  })
  
  choices2 <- reactive({
    switch(input$playNumComb,
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
  
  output$subplayNumComb <- renderUI({
    pickerInput("subPlayComb", label = playLabel(), 
                choices = choices2(),
                selected = choices2()[1],
                options = list(`actions-box` = TRUE),
                multiple = T)
  })
  
  output$slider <- renderUI({
    sliderInput("amount", "Amount", value = 0, min = 0, max = money$amount, step = 0.01)
  })
  
  output$image2 <- renderImage({
    slika()
  }, deleteFile = FALSE)
  
  observeEvent(input$bet, {
    if (input$amount == 0) {
      report$incorectBet <- paste("You tried to place bet with 0 value.")
    }
    else if (input$amount * length(input$subPlayComb) > money$amount) {
      report$incorectBet <- paste("You tried to bet more money than you have.")
    }
  })
  
  
  observeEvent(input$bet, {
    if (input$amount > 0 && input$amount * length(input$subPlayComb) <= money$amount) {
      report$incorectBet <- ""
      money$amount <- money$amount - (input$amount * length(input$subPlayComb))
      multiplier <- if (miza$type == "American") {multiplier_ame[[input$playNumComb]]} else {multiplier_eu[[input$playNumComb]]}
      stava <- data.frame(num_comb_type = input$playNumComb, num_comb = input$subPlayComb, bet_amount = input$amount, multiplier = multiplier)
      stave$table <- rbind(stave$table, stava)
      report$money <- paste0("You have ", sprintf("%.2f", money$amount), cur_sym(money$cur), ".")
    }
  })
  
  
  output$money2 <- renderText(report$money)
  
  output$incorectBet <- renderText(report$incorectBet)
  
  output$bets <- DT::renderDataTable({
    if (is.null(stave$table)) {
      data.frame(num_comb_type = character(), num_comb = character(), bet_amount = numeric(), multiplier = integer())
    }
    else {
      stave$table
    }
  })
  
  output$strategy <- DT::renderDataTable({
    if (miza$knownProb == "No") {
      if (is.null(num_combinations$calcStrategy)) {
        data.frame(num_comb_type = character(), num_comb = character(), multiplier = integer(),
                   fallen = integer(), alfa = numeric(), pred_prob = numeric(), bet_share = numeric(), bet = numeric())
      }
      else {
        num_combinations$calcStrategy %>% arrange(desc(bet_share))
      }
    }
    else {
      if (is.null(num_combinations$calcStrategy)) {
        data.frame(num_comb_type = character(), num_comb = character(), multiplier = integer(),
                   fallen = integer(), prob = numeric(), bet_share = numeric(), bet = numeric())
      }
      else {
        num_combinations$calcStrategy %>% arrange(desc(bet_share))
      }
    }
  })
  
  observeEvent(input$clearAll, {
    betedMoney <- sum(stave$table$bet_amount)
    money$amount <- money$amount + betedMoney
    report$money <- paste0("You have ", sprintf("%.2f", money$amount), cur_sym(money$cur), ".")
    report$incorectBet <- ""
    stave$table <- NULL
  })
  
  observeEvent(input$clearSelect, {
    delete <- stave$table$num_comb %in% input$subPlayComb
    betedMoney <- sum(stave$table$bet_amount[delete])
    money$amount <- money$amount + betedMoney
    report$money <- paste0("You have ", sprintf("%.2f", money$amount), cur_sym(money$cur), ".")
    stave$table <- stave$table[!delete,]
  })
  
  
  observeEvent(input$spin, { 
    rolled <- rouletteSim(miza$miza, miza$type)
    winning <- dobitek(stave$table, rolled)
    money$amount <- money$amount + winning
    betedMoney <- sum(stave$table$bet_amount)
    output$roll <- renderText(rolled[1])
    output$win <- renderText({
      paste(paste0("You betted ", betedMoney, cur_sym(money$cur), "."),
            paste0("You won ", winning, cur_sym(money$cur), "."), sep = "\n")
  })
    #stave$table <- NULL
    if (!is.null(num_combinations$calcStrategy)) {
      choComb <- num_combinations$calcStrategy$num_comb
      whichComb <- choComb %in% rolled
      num_combinations$calcStrategy[whichComb,'fallen'] <- num_combinations$calcStrategy[whichComb,'fallen'] + 1
      num_combinations$calcStrategy <- if (miza$knownProb == "No") {strategy(adaptStrategy(num_combinations$calcStrategy) %>% rename(prob = pred_prob)) %>% rename(pred_prob = prob)} else {num_combinations$calcStrategy}
      num_combinations$calcStrategy$bet <- round(num_combinations$calcStrategy$bet_share * money$amount, 2)
    }
    report$money <- paste0("You have ", sprintf("%.2f", money$amount), cur_sym(money$cur), ".")
  })
  
  ######################################################################
  # simulacija strategije, tretji zavihek
  observeEvent(input$test, {
    if (miza$knownProb == "Yes") {
      rez <- simulacija(num_combinations$calcStrategy, "Yes", money$amount, as.integer(input$iter))
      simData$iter <- as.integer(input$iter)
      simData$endTable <- rez[[2]]
      simData$moneyMove <- rez[[1]]
    }
    else {
      tabela <- merge(num_combinations$calcStrategy, num_combinations$chosenCombinations %>% select(num_comb, prob1 = prob))
      rez <- simulacija(tabela, "No", money$amount, as.integer(input$iter))
      simData$iter <- as.integer(input$iter)
      simData$endTable <- rez[[2]]
      simData$moneyMove <- rez[[1]]
    }
  })
  
  
  output$sim <- renderPlot({
    if (is.null(simData$moneyMove)) {
      plot(0, type="n", main = "Money change", ylab = "Money amount", xlab = "Number of bets")
    }
    else {
      plot(simData$moneyMove, main = "Money change", ylab = "Money amount", xlab = "Number of bets")
    }
  })
  
  output$histo <- renderPlot({
    if (is.null(simData$endTable)) {
      plot(0, type = "n", main = "Number combinations frequency", xlab = "Number combinations", ylab = "Frequency")
    }
    else {
      data <- simData$endTable[order(simData$endTable$fallen,decreasing = TRUE),]
      color.function <- colorRampPalette( c( "#CCCCCC" , "#104E8B" ) )
      barplot(data$fallen / sum(data$fallen), names.arg = data$num_comb, las = 2, 
              main = "Number combinations frequency", ylab = "Frequency", col = color.function(n = nrow(simData$endTable)))
    }
  })
  output$endStra <- DT::renderDataTable({
    if (miza$knownProb == "Yes") {
      if (is.null(simData$endTable)) {
        data.frame(num_comb_type = character(), num_comb = character(), multiplier = integer(), 
                   fallen = integer(), prob = numeric(), bet_share = numeric(), bet = numeric())
      }
      else {
        simData$endTable %>% arrange(desc(bet_share))
      }
    }
    else {
      if (is.null(simData$endTable)) {
        data.frame(num_comb_type = character(), num_comb = character(), multiplier = integer(), 
                   fallen = integer(), alfa = numeric(), pred_prob = numeric(), bet_share = numeric(), bet = numeric())
      }
      else {
        simData$endTable$prob1 <- NULL
        simData$endTable %>% arrange(desc(bet_share))
      }
    }
  })
  
  output$repSim <- renderText({
    if (is.null(simData$iter)) {
      ""
    }
    else {
      reportSim(simData$iter, simData$moneyMove, money$cur)
    }
  })
  
  
  
})
