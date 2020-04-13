reindex <- function(numbers, probability, payoff) {
  table <- data.frame(num = numbers, prob = probability, payoff = payoff)
  table$ord <- table$prob * (table$payoff+ 1)
  table <- table %>% arrange(desc(ord))
  return(table)
}

gama_0 <- function(table){
  # ta funkcija bo vedno dobila tabelo iz funkcije reindex
  # ce ze v prvem koraku ne izpolnemo pogojev pol nč ne stavmo
  gama_0 <- 1
  n <- nrow(table)
  for (i in 1:n) {
    stevec <- 1 - sum(table$prob[1:i])
    imenovalec <- 1 - sum(1/(table$payoff[1:i]+1))
    gama_0k <- stevec / imenovalec
    if (imenovalec <= 0 | table$ord[i] <= gama_0k) {
      return(c(gama_0, i-1))
    }
    else {
      gama_0 <- gama_0k
    }
  }
  return(c(gama_0, n))
}

strategy <- function(table, gama_r, r) {
  prob <- table$prob[1:r]
  payoff <- table$payoff[1:r]
  gama_k <- prob - gama_r/(payoff + 1)
  nuls <- rep(0, nrow(table) - r)
  gama_k <- c(gama_k, nuls)
  return(gama_k)
}

# dobro da se naredi vse skupaj ne da je treba klicat 4 funkcije naenkrat
# vendar tko je bolj pregledno


# testni primer
#e <- reindex(c(1, 2, 3, 4), c(3/38, 14/38, 12/38, 9/38), c(17, 2, 2, 2))
#gama_0(e)
