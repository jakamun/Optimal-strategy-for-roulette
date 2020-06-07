rouletteSim <- function(miza, type) {
  # simulira rouleto in vrne vse kombinacije, ki so pokrite
  rand <- sample(1:nrow(miza), 1, prob = miza$prob)
  number <- miza[rand,]$num
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


# koda za simulacijo na izbranih kombinacijah stevilk



