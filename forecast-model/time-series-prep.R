#--------------------------------------------
# This script sets out to prepare the data
# for time series forecasting
#--------------------------------------------

#---------------------------------------
# Author: Trent Henderson, 31 March 2020
#---------------------------------------

# Load data

load("data/full_data.Rda")

# Get structure of data as opening it is computationally intensive due to size

structure(full_data)

#------------------------PRE PROCESSING-----------------------

# Convert to weekly times
