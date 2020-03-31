#--------------------------------------------
# This script sets out to load and clean raw
# data files and save as a quick-access .Rda
#--------------------------------------------

#---------------------------------------
# Author: Trent Henderson, 31 March 2020
#---------------------------------------

# Read in excel files and bind together

data_files <- list.files("data", full.names = TRUE, pattern = "\\.xlsx", all.files = TRUE)

data.list <- list()

for(d in data_files){
  df <- read_excel(d)
  data.list[[d]] <- df
}

full_data <- rbindlist(data.list, use.names = TRUE, fill = TRUE)

# Save file for future use

save(full_data, file = "data/full_data.Rda")
