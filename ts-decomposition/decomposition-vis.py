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
import matplotlib.dates as mdates

from matplotlib.dates import DateFormatter
from statsmodels.graphics.tsaplots import plot_acf
from statsmodels.graphics.tsaplots import plot_pacf
from statsmodels.tsa.arima_model import ARIMA
from statsmodels.tsa.seasonal import seasonal_decompose
from statsmodels.tsa.stattools import adfuller
from tspype import stationary_calculator

#%%
#--------------------LOAD DATA-----------------------

data = pd.read_csv("/Users/trenthenderson/Documents/R/qld-translink-forecasting/data/modelling_data.csv")

# Convert month column to datetime

data['month'] = pd.to_datetime(data['month'])

#%%
#--------------------DEFINE FUNCTIONS----------------

# Main time-series plotting function

def tsplot(x, y, figsize = (12,8)):

    if np.issubdtype(y.dtype, np.number) == False:
        raise TypeError("tsplotter expects the y (response) variable to be a float or integer.")
    else:
        
        # Set up subplots as a matrix
        
        sns.set(style = "darkgrid")
        fig = plt.figure(figsize = figsize)
        layout = (2,2)
        data_ax = plt.subplot2grid(layout, (0,0))
        dens_ax = plt.subplot2grid(layout, (0,1))
        acf_ax = plt.subplot2grid(layout, (1,0))
        pacf_ax = plt.subplot2grid(layout, (1,1))
        
        # Date formatting for main summary plot
        
        date_form = DateFormatter("%m-%y")
        data_ax.xaxis.set_minor_formatter(date_form)
        
        # Add titles
        
        data_ax.title.set_text('Raw time series')
        dens_ax.title.set_text('Density of response variable')
        
        # Produce actual graphs
        
        sns.lineplot(x = x, y = y, 
                     ax = data_ax)
        sns.distplot(y, ax = dens_ax)
        plot_acf(y, ax = acf_ax)
        plot_pacf(y, ax = pacf_ax)
        sns.despine()
        plt.tight_layout()
        return data_ax, dens_ax, acf_ax, pacf_ax

# Time-series property decomposition function
    
def decompose(x, y, periods, figsize = (12,8)):
    
    if np.issubdtype(y.dtype, np.number) == False:
        raise TypeError("decomposer expects response variable vector data as a float or integer.")
    elif isinstance(periods, int) == False:
        raise TypeError("Periods should be specified as an integer")
    else:
        decomposition = seasonal_decompose(y, period = periods)

        trend = decomposition.trend
        seasonal = decomposition.seasonal
        residual = decomposition.resid
    
        sns.set(style = "darkgrid")
        fig = plt.figure(figsize = figsize)
        layout = (2,2)
        orig_ax = plt.subplot2grid(layout, (0,0))
        trend_ax = plt.subplot2grid(layout, (0,1))
        seas_ax = plt.subplot2grid(layout, (1,0))
        resid_ax = plt.subplot2grid(layout, (1,1))
        
        # Date formatting for main summary plot
        
        date_form = DateFormatter("%m-%y")
        orig_ax.xaxis.set_minor_formatter(date_form)
        
        # Add titles
        
        orig_ax.title.set_text('Raw time series')
    
        sns.lineplot(x = x, y = y, 
                     ax = orig_ax)
        trend.plot(ax = trend_ax, title = 'Trend')
        seasonal.plot(ax = seas_ax, title = 'Seasonal')
        residual.plot(ax = resid_ax, title = 'Residual')
        plt.tight_layout()
        return orig_ax, trend_ax, seas_ax, resid_ax

#%%
#---------------------PRODUCE VISUALISATIONS---------

# Overall

tsplot(data['month'], data['quantity'])
plt.savefig('/Users/trenthenderson/Documents/R/qld-translink-forecasting/output/ts_plot.png', dpi = 1000)


#%%
# Stationarity

stationary_calculator(data['quantity'], 0.05)

#%%

# Decomposition

decompose(data['month'], data['quantity'], periods = 12)
plt.savefig('/Users/trenthenderson/Documents/R/qld-translink-forecasting/output/decomp_plot.png', dpi = 1000)
