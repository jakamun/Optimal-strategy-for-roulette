checktype <- function(roulette_type) {
  if (roulette_type == "European"){
    return(TRUE)
  }
  else {
    return(FALSE)
  }
}

unfair_roulete <- function(european_f) {
  miza <- roulette(european = european_f)
  rand <- sample.int(100, nrow(miza))
  miza$prob <- rand / sum(rand)
  miza <- miza %>% arrange(desc(prob))
  miza$number <- paste(miza$color, miza$num)
  miza <- miza %>% select(number, prob) %>% rename(num = number)
  #miza <- miza %>% arrange(as.integer(paste(num)))
  return(miza)
}

