#--------------------------------------------
# This script sets out to load and clean raw
# data files and save as a quick-access .Rda
#--------------------------------------------

#---------------------------------------
# Author: Trent Henderson, 31 March 2020
#---------------------------------------

# Load data

load("data/full_data.Rda")

# Get structure of data as opening it is computationally intensive due to size

structure(full_data)

#------------------------DATA SUMMARISATION-----------------------

# Summarise just down to ticket type, data and quantity

clean_data <- full_data %>%
  filter(!is.na(month)) %>%
  filter(!is.na(ticket_type)) %>%
  group_by(ticket_type, month) %>%
  summarise(quantity = round((sum(quantity))/1000000, digits = 2)) %>%
  ungroup()

#------------------------DATA VISUALISATION-----------------------

# Produce reusable graphing components

the_caption <- "Source: TransLink, Orbisant Analysis"

the_palette <- c("Paper" = "#57DBD8",
                 "go card" = "#F84791")

the_theme <-   theme(legend.position = "bottom",
                     axis.text = element_text(colour = "#25388E"),
                     axis.title = element_text(colour = "#25388E", face = "bold"),
                     panel.border = element_blank(),
                     panel.grid.minor = element_blank(),
                     panel.grid.major = element_line(colour = "white"),
                     axis.line = element_line(colour = "#25388E"),
                     panel.background = element_rect(fill = "#edf0f3", colour = "#edf0f3"),
                     plot.background = element_rect(fill = "#edf0f3", colour = "#edf0f3"),
                     legend.background = element_rect(fill = "#edf0f3", colour = "#edf0f3"),
                     legend.box.background = element_rect(fill = "#edf0f3", colour = "#edf0f3"),
                     legend.key = element_rect(fill = "#edf0f3", colour = "#edf0f3"),
                     legend.text = element_text(colour = "#25388E"),
                     legend.title = element_text(colour = "#25388E"),
                     plot.title = element_text(colour = "#25388E"),
                     plot.subtitle = element_text(colour = "#25388E"),
                     plot.caption = element_text(colour = "#25388E"))

# Produce graph

clean_data %>%
  ggplot(aes(x = month, y = quantity, group = ticket_type)) +
  geom_line(aes(colour = ticket_type), stat = "identity", size = 1.25) +
  labs(title = "Time series of ticket type for TransLink services",
       x = "Date",
       y = "Number of trips (millions)",
       colour = "Ticket type",
       caption = the_caption) +
  theme_bw() +
  the_theme
