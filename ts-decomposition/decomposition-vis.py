#--------------------------------------------
# This script sets out to produce a time
# series decomposition visual for the
# aggregate TransLink univariate data.
#
# NOTE: This script requires analyses in R
# to have been run first.
#--------------------------------------------

#---------------------------------------
# Author: Trent Henderson, 11 July 2020
#---------------------------------------

#%%
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import statsmodels as sm

from statsmodels.graphics.tsaplots import plot_acf
from statsmodels.graphics.tsaplots import plot_pacf
from statsmodels.tsa.arima_model import ARIMA
from statsmodels.tsa.seasonal import seasonal_decompose
from statsmodels.tsa.stattools import adfuller
from tspype import tsplotter
from tspype import stationary_calculator
from tspype import decomposer

#%%
#--------------------LOAD DATA-----------------------

data = pd.read_csv("/Users/trenthenderson/Documents/R/qld-translink-forecasting/data/modelling_data.csv")

#%%
#---------------------PRODUCE VISUALISATION----------

# Overall

tsplotter(data['month'], data['quantity'], data)

# Stationarity

stationary_calculator(data['quantity'], 0.05)

# Decomposition

decomposer(data, data['month'], data['quantity'], periods = 12)