#--------------------------------------------
# This script sets out to produce an X
# forecast model
#--------------------------------------------

#---------------------------------------
# Author: Trent Henderson, 3 April 2020
#---------------------------------------

# Load data

load("data/for-modelling.Rda")

# Convert to time series object

filt_ts <- ts(filtered$quantity, start = c(2016,4), end = c(2019,12), frequency = 12)

#------------------------MODEL BUILDS-------------------------

the_forecast <- forecast(auto.arima(filt_ts, lambda = 0), h = 12, level = c(80))

outputs <- data.frame(the_coeff = the_forecast$mean, 
                     the_lower = the_forecast$lower, 
                     the_upper = the_forecast$upper)

#------------------------JOINS--------------------------------

# Clean up column names

clean_forecast <- outputs %>%
  rename(quantity = 1) %>%
  rename(the_lower = 2) %>%
  rename(the_upper = 3) %>%
  mutate(category = "Forecast") %>%
  mutate(year = 2020)

clean_forecast <- mutate(clean_forecast, id = rownames(clean_forecast))

cleaner_forecast <- as.data.frame(clean_forecast) %>%
  mutate(year = as.numeric(as.character(year))) %>% # These type recoding lines fix ts binding error
  mutate(quantity = as.numeric(as.character(quantity))) %>%
  mutate(the_lower = as.numeric(as.character(the_lower))) %>%
  mutate(the_upper = as.numeric(as.character(the_upper))) %>%
  mutate(month = case_when(
         id == 1  ~ "2020-01-01",
         id == 2  ~ "2020-02-01",
         id == 3  ~ "2020-03-01",
         id == 4  ~ "2020-04-01",
         id == 5  ~ "2020-05-01",
         id == 6  ~ "2020-06-01",
         id == 7  ~ "2020-07-01",
         id == 8  ~ "2020-08-01",
         id == 9  ~ "2020-09-01",
         id == 10 ~ "2020-10-01",
         id == 11 ~ "2020-11-01",
         id == 12 ~ "2020-12-01")) %>%
  mutate(month = as.character(month)) %>%
  dplyr::select(-c(id))

# Join forecast to historical data

historical <- filtered %>%
  mutate(category = "Historical") %>%
  mutate(the_lower = NA) %>%
  mutate(the_upper = NA) %>%
  mutate(month = as.character(month))

full_data <- bind_rows(historical, cleaner_forecast) %>%
  mutate(month = as.Date(month, "%Y-%m-%d")) %>%
  mutate(category = factor(category, levels = c("Historical", "Forecast"))) # For plot legend ordering

#------------------------VISUALISATION------------------------

# Define colour palette

the_palette <- c("Historical" = "#25388E",
                 "Forecast" = "#57DBD8")

p <- full_data %>%
  ggplot(aes(x = month, y = quantity)) +
  geom_line(aes(colour = category), stat = "identity", size = 1.5) +
  geom_ribbon(aes(ymin = the_lower, ymax = the_upper, x = month, fill = category), alpha = 0.3) +
  scale_x_date(labels = date_format("%b"), expand = c(0, 0)) +
  labs(title = "ARIMA forecast of go card trips",
       caption = the_caption,
       x = "Date",
       y = "Go card tips",
       colour = NULL,
       fill = NULL) +
  facet_grid(. ~ year, scale = "free_x", switch = "x") +
  scale_colour_manual(values = the_palette) +
  scale_fill_manual(values = the_palette) +
  the_theme
print(p)
