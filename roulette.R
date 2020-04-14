library(shiny)
library(shinythemes)
library(lubridate)
library(prob)
library(dplyr)

source("pomozno/strategy.R")

source("pomozno/create_roulette.R")

runApp(appDir = "shiny/")