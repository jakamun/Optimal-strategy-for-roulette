library(shiny)
library(shinythemes)
library(lubridate)
library(prob)
library(dplyr)
library(png)
library(shinyWidgets)
library(DT)

# set working directory
current_working_dir = dirname(rstudioapi::getActiveDocumentContext()$path)
setwd(current_working_dir)

# source 
source("pomozno/strategy.R")

source("pomozno/create_roulette.R")

source("pomozno/vseStave.R")

source("pomozno/currency.R")

source("pomozno/simRoulette.R")

# shiny app
runApp(appDir = "shiny/")