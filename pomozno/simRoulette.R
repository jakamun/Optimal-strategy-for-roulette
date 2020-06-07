#checkIfAppear <- function(num, )

rouletteSim <- function(miza, type) {
  # simulira rouleto in vrne vse kombinacije, ki so pokrite
  rand <- sample(1:nrow(miza), 1, prob = miza$prob)
  number <- miza[rand,]$num
  if (type == "American") {
    combinations <- names(ame_bets)
    for (i in combinations) {
      subComb <- ame_bets[[i]]
      subCombNames <- names(subComb)
      return(sapply(subComb, `%in%`, x = number))
    }
  }
  else {
    combinations <- names(eu_bets)
    for (i in combinations) {
      subComb <- ame_bets[[i]]
      subCombNames <- names(subComb)
      return(sapply(subComb, `%in%`, x = number))
    }
  }
}