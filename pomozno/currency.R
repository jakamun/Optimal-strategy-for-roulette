cur_sym <- function(currency) {
  if(currency == "Euro") {
    # potrebno tako zapisati simbol za euro, drugače shiny čudno prevede
    return("\u20ac")
  }
  else{
    return("$")
  }
}

convert <- function(from, to, amount){
  ame_to_eu_conv_rate <- 0.91687
  if (from == to) {
    return(amount)
  }
  else if (to == "Euro") {
    return(amount * ame_to_eu_conv_rate)
  }
  else if (to == "Dollar") {
    return(amount / ame_to_eu_conv_rate)
  }
}
