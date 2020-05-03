library(shiny)
library(shinythemes)
library(lubridate)
library(prob)
library(dplyr)
library(png)
library(jpeg)

source("pomozno/strategy.R")

source("pomozno/create_roulette.R")

source("pomozno/vseStave.R")

runApp(appDir = "shiny/")