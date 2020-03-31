#--------------------------------------------
# This script sets out to produce a first
# high level visual of the data to check
# for potential considerations for modelling
#--------------------------------------------

#---------------------------------------
# Author: Trent Henderson, 31 March 2020
#---------------------------------------

# Load data

load("data/full_data.Rda")

# Get structure of data as opening it is computationally intensive due to size

glimpse(full_data)

#------------------------DATA SUMMARISATION-----------------------

# Summarise just down to ticket type, data and quantity

clean_data <- full_data %>%
  filter(!is.na(month)) %>%
  filter(!is.na(ticket_type)) %>%
  group_by(ticket_type, month) %>%
  summarise(quantity = round((sum(quantity))/1000000, digits = 2)) %>%
  ungroup() %>%
  mutate(year = as.numeric(gsub("-.*", "", month))) %>%
  mutate(month = as.Date(paste(month, "-01", sep = "")))

#------------------------DATA VISUALISATION-----------------------

# Produce reusable graphing components

the_palette <- c("Paper" = "#57DBD8",
                 "go card" = "#F84791")

# Produce graph

CairoPNG("output/initial-ts-graph.png", 550, 350)
p <- clean_data %>%
  ggplot(aes(x = month, y = quantity, group = ticket_type)) +
  geom_line(aes(colour = ticket_type), stat = "identity", size = 1.25) +
  labs(title = "Time series of ticket type for TransLink services",
       x = "Date",
       y = "Number of trips (million)",
       colour = "Ticket type",
       caption = the_caption) +
  scale_x_date(labels = date_format("%b"), expand = c(0, 0)) +
  scale_y_continuous(labels = function(x) paste0(x,"m")) +
  facet_grid(. ~ year, scale = "free_x", switch = "x") +
  theme_bw() +
  the_theme
print(p)

dev.off()
