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

structure(full_data)

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

the_caption <- "Source: TransLink, Orbisant Analysis"

the_palette <- c("Paper" = "#57DBD8",
                 "go card" = "#F84791")

the_theme <-   theme(legend.position = "bottom",
                     axis.text = element_text(colour = "#25388E"),
                     axis.title = element_text(colour = "#25388E", face = "bold"),
                     panel.grid.minor = element_blank(),
                     panel.grid.major = element_line(colour = "white"),
                     panel.border = element_blank(),
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
                     plot.caption = element_text(colour = "#25388E"),
                     strip.placement = "outside",
                     strip.background = element_rect(fill = "#edf0f3", colour = "#25388E"),
                     strip.text = element_text(colour = "#25388E"),
                     panel.spacing.x = unit(0, "lines"))

# Produce graph

clean_data %>%
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
