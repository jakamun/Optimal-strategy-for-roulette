rouletteSim <- function(miza, type) {
  # simulira rouleto in vrne vse kombinacije, ki so pokrite
  number <- sample(miza$num, 1, prob = miza$prob)
  kombinacije <- c(number)
  if (type == "American") {
    combinations <- names(ame_bets[names(ame_bets) != "Number"])
    for (i in combinations) {
      subComb <- ame_bets[[i]]
      pojavitve <- subComb[sapply(subComb, function(x) any(x %in% number)) == TRUE]
      kombinacije <- c(kombinacije, names(pojavitve))
    }
  }
  else {
    combinations <- names(eu_bets[names(eu_bets) != "Number"])
    for (i in combinations) {
      subComb <- eu_bets[[i]]
      pojavitve <- subComb[sapply(subComb, function(x) any(x %in% number)) == TRUE]
      kombinacije <- c(kombinacije, names(pojavitve))
    }
  }
  kombinacije
}

dobitek <- function(bets, kombinacije) {
  # preveri ce je igralec zadel kaj, vrne vektor z številko, ki je padla in znesek, dearja, ki ga je zadel
  zadetki <- bets[bets$num_comb %in% kombinacije, ]
  if (nrow(zadetki) == 0 || is.null(bets)) {
    return(0)
  }
  else {
    dobitek <- sum(zadetki$bet_amount * zadetki$multiplier)
    return(dobitek)
  }
}


simulacija <- function(miza, knownProb, money, iter) {
  fallen <- rep("", iter)
  money_move <- rep(0, iter+1)
  money_move[1] <- money
  if (knownProb == "Yes") {
    for (i in 2:(iter + 1)) {
      rand <- sample(1:nrow(miza), 1, prob = miza$prob)
      fallen[i] <- miza[rand,]$num_comb
      win <- miza[rand,]$bet * (miza[rand,]$multiplier + 1)
      money <- money - sum(miza$bet) + win
      money_move[i] <- money
      if (money <= 0) {
        return(list(fallen, money_move, miza))
      }
      else if (money == Inf) {
        return(list(fallen[1:(i-1)], money_move[1:(i-1)], miza))
      }
      else {
        miza$bet <- round(miza$bet_share * money, 2)
      }
    }
    return(list(fallen, money_move, miza))
  }
  else {
    for (i in 2:(iter + 1)) {
      rand <- sample(1:nrow(miza), 1, prob = miza$prob1)
      fallen[i] <- miza[rand,]$num_comb
      win <- miza[rand,]$bet * (miza[rand,]$multiplier + 1)
      money <- money - sum(miza$bet) + win
      money_move[i] <- money
      if (money <= 0) {
        return(list(fallen, money_move, miza))
      }
      else if (money == Inf) {
        return(list(fallen[1:(i-1)], money_move[1:(i-1)], miza))
      }
      else {
        miza[rand,'fallen'] <- miza[rand,'fallen'] + 1
        miza <- strategy(adaptStrategy(miza) %>% rename(prob = pred_prob)) %>% rename(pred_prob = prob)
        miza$bet <- round(miza$bet_share * money, 2)
      }
    }
    return(list(fallen, money_move, miza))
  }
}

reportSim <- function(iter, money, cur) {
  n <- length(money)
  if (n == (iter + 1)) {
    paste(paste0("Starting capital: ", money[1], cur_sym(cur), "."), 
          paste0("End capital: ", money[n], cur_sym(cur), "."), 
          paste0("Number of iterations: ", iter, "."), sep = "\n")
    } 
  else if (n != (iter + 1) && money[n] <= 0) {paste(paste0("Starting capital: ", money[1], cur_sym(cur), "."), 
                                                    paste0("Simulation ended in bankrupcy."),
                                                    paste0("Stoped at ", n, " iteration."), sep = "\n")
    } 
  else if (n != (iter + 1) && money[n] > 0) {paste(paste0("Starting capital: ", money[1], cur_sym(cur), "."),
                                                   paste0("Simulation ended because Inf value reached."),
                                                   paste0("Stoped at ", n, " iteration."), sep = "\n")
  }
  else {
    paste("Izjema")
  }
}
