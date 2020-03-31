#--------------------------------------------
# This script sets out to prepare the data
# for time series forecasting
#--------------------------------------------

#---------------------------------------
# Author: Trent Henderson, 31 March 2020
#---------------------------------------

# Load data

load("data/full_data.Rda")

# Glimpse a look at the data

glimpse(full_data)

#------------------------PRE PROCESSING-----------------------

# Filter to just go card travel as paper is stagnant

filtered <- full_data %>%
  filter(ticket_type == "go card") %>%
  filter(!is.na(month)) %>%
  group_by(month) %>%
  summarise(quantity = sum(quantity)) %>%
  ungroup() %>%
  mutate(year = as.numeric(gsub("-.*", "", month))) %>%
  mutate(month = as.Date(paste(month, "-01", sep = "")))

# Produce time series object

filt_ts <- ts(filtered$quantity, start = c(2016,4), end = c(2019,12), frequency = 12)

#------------------------TIME SERIES DIAGNOSTICS--------------

#----------------
# Time
#----------------

p <- filtered %>%
  ggplot(aes(x = month, y = quantity)) +
  geom_line(colour = "#F84791", stat = "identity", size = 1.25) +
  labs(title = "Time series of go card trips across TransLink",
       x = "Date",
       y = "Number of trips",
       colour = "Ticket type",
       caption = the_caption) +
  scale_x_date(labels = date_format("%b"), expand = c(0, 0)) +
  facet_grid(. ~ year, scale = "free_x", switch = "x") +
  theme_bw() +
  the_theme
print(p)

#----------------
# Seasonality
#----------------

p2 <- ggseasonplot(filt_ts, year.labels = TRUE, year.labels.left = TRUE) +
  labs(title = "Seasonal plot",
       x = "Month",
       y = "Number of go card trips") +
  the_theme
print(p2)

#----------------
# Autocorrelation
#----------------

p3 <- ggAcf(filt_ts) +
  labs(title = "Autocorrelation plot",
       x = "Lag",
       y = "ACF") +
  the_theme
print(p3)
