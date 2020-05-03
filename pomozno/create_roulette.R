

unfair_roulete <- function(european = FALSE) {
  miza <- roulette(european = european)
  rand <- sample.int(100, nrow(miza))
  miza$prob <- rand / sum(rand)
  #miza <- miza %>% arrange(as.integer(paste(num)))
  return(miza)
}

