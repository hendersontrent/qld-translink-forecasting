#--------------------------------------------
# This script sets out necessary packages and 
# generalisations for the project
#--------------------------------------------

#---------------------------------------
# Author: Trent Henderson, 31 March 2020
#---------------------------------------

library(tidyverse)
library(data.table)
library(readxl)
library(janitor)
library(forecast)
library(scales)
library(Cairo)

# Load in useful functions

funcs <- list.files("R", pattern = "\\.[Rr]$", full.names = TRUE)

for(f in funcs){
  source(f)
}

# Turn of scientific notation

options(scipen = 999)
