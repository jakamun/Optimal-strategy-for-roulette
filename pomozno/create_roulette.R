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
  return(miza)
}

segments_distribution <- function(miza, seg_list) {
  names <- names(seg_list)
  prob <- c()
  for (i in names) {
    val <- seg_list[[i]]
    seg_miza <- merge(miza, data.frame(num = val))
    prob <- c(prob, sum(seg_miza$prob))
  }
  seg_miza <- data.frame(combinations = names, prob = prob)
  seg_miza %>% arrange(desc(prob))
}

start_prob_predict <- function(old_table, new_table, knowPr, alfa) {
  if (knowPr == "Yes") {
    rbind(old_table, new_table)
  }
  else {
    new_table$alfa <- alfa
    n <- nrow(new_table)
    new_table$pred_prob <- as.numeric(alfa) / (n*as.numeric(alfa))
    binded <- rbind(old_table, new_table)
    alfa1 <- as.numeric(binded$alfa)
    binded$pred_prob <- alfa1 / (sum(alfa1))
    binded
  }
}
