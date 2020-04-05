#---------------------------------------------
# This script sets out to produce forecast 
# accuracy diagnostics for a battery of
# forecast models. This will enable an initial
# high level comparison
#---------------------------------------------

#---------------------------------------
# Author: Trent Henderson, 5 April 2020
#---------------------------------------

# Load data

load("data/for-modelling.Rda")

# Convert to time series object

filt_ts <- ts(filtered$quantity, start = c(2016,4), end = c(2019,12), frequency = 12)

# Extract to 2018 as test data to measure model accuracy against

train <- window(filt_ts, start = c(2016,4), end = c(2018,12))

#------------------------MODEL BUILDS-------------------------

# Mean

mean_fit <- meanf(train, h = 12)

# Naive

naive_fit <- rwf(train, h = 12)

# Seasonal Naive

snaive_fit <- snaive(train, h = 12)

# ARIMA

arima_fit <- forecast(auto.arima(train, lambda = 0), h = 12, level = c(80))

#------------------------VISUALISATION------------------------

autoplot(window(filt_ts, c(2016,4))) +
  autolayer(mean_fit, series = "Mean", PI = FALSE) +
  autolayer(naive_fit, series = "Naïve", PI = FALSE) +
  autolayer(snaive_fit, series = "Seasonal naïve", PI = FALSE) +
  autolayer(arima_fit, series = "ARIMA", PI = FALSE) +
  labs(title = "High level forecast model comparison",
       x = "Date",
       y = "Number of go card trips",
       colour = "Model type") +
  the_theme

#------------------------ERROR COMPARISONS--------------------

# Compare model predictions of 2019 against real data

test <- window(filt_ts, start = c(2019, 1))
accuracy(mean_fit, test)
accuracy(naive_fit, test)
accuracy(snaive_fit, test)
accuracy(arima_fit, test)
