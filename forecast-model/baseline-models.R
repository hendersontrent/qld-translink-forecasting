#--------------------------------------------
# This script sets out to produce baseline
# models to benchmark more sophisticated
# methods against
#--------------------------------------------

#---------------------------------------
# Author: Trent Henderson, 31 March 2020
#---------------------------------------

# Load data

load("data/for-modelling.Rda")

# Convert to time series object

filt_ts <- ts(filtered$quantity, start = c(2016,4), end = c(2019,12), frequency = 12)

#------------------------MODEL BUILDS-------------------------

#----------------
# AVERAGE, NAIVE
# AND SEASONAL
# NAIVE
#----------------

p <- autoplot(filt_ts) +
  autolayer(meanf(filt_ts, h = 12),
            series = "Mean", PI = FALSE) +
  autolayer(naive(filt_ts, h = 12),
            series = "Naïve", PI = FALSE) +
  autolayer(snaive(filt_ts, h = 12),
            series = "Seasonal naïve", PI = FALSE) +
  labs(title = "Baseline forecasts of go card trips",
       x = "Date",
       y = "Number of go card trips",
       caption = the_caption,
       colour = "Forecast type") +
  the_theme +
  theme(legend.position = "bottom")
print(p)
