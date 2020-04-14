unfair_roulete <- function() {
  miza <- roulette()
  rand <- sample.int(100, 38)
  miza$prob <- rand / sum(rand)
  #miza <- miza %>% arrange(as.integer(paste(num)))
  return(miza)
}