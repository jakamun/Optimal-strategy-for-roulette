reindex <- function(table) {
  table$ord <- table$prob * (table$multiplier + 1)
  table <- table %>% arrange(desc(ord))
  return(table)
}

gama_0 <- function(table){
  # sprejme tabelo iz reindex
  # ce ze v prvem koraku ne izpolnemo pogojev pol nč ne stavmo
  gama_0 <- 1
  n <- nrow(table)
  for (i in 1:n) {
    stevec <- 1 - sum(table$prob[1:i])
    imenovalec <- 1 - sum(1/(table$multiplier[1:i]+1))
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

gamas <- function(table, gama_r, r) {
  if (r > 0) {
    prob <- table$prob[1:r]
    payoff <- table$multiplier[1:r]
    gama_k <- prob - gama_r/(payoff + 1)
    nuls <- rep(0, nrow(table) - r)
    gama_k <- c(gama_k, nuls)
    return(gama_k)
  }
  else {
    return(rep(0, nrow(table)))
  }
}

strategy <- function(miza) {
  table <- reindex(miza)
  gama_r <- gama_0(table)
  gamas <- gamas(table, gama_r[1], gama_r[2])
  table$ord <- NULL
  table$bet_share <- gamas
  return(table)
}

##########################
# za nepoznane verjetnosti je potrebno na vsakem koraku še izračunati verjetnosti, ostalo je nespremenjeno

adaptStrategy <- function(strategy) {
  sum_alfa <- sum(as.numeric(strategy$alfa))
  n <- sum(strategy$fallen)
  strategy$pred_prob <- (as.numeric(strategy$alfa) + strategy$fallen) / (sum_alfa + n - 1)
  strategy
}

