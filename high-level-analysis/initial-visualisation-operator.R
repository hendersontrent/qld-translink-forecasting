#--------------------------------------------
# This script sets out to produce an operator
# level line chart of go card usage
#--------------------------------------------

#---------------------------------------
# Author: Trent Henderson, 2 April 2020
#---------------------------------------

# Load data

load("data/full_data.Rda")

# Glimpse a look at the data

glimpse(full_data)

#------------------------PRE PROCESSING-----------------------

# Filter to just go card travel as paper is stagnant

filtered_operator <- full_data %>%
  filter(ticket_type == "go card") %>%
  filter(!is.na(month)) %>%
  mutate(operator = case_when(
         grepl("Bus|Coach|bus", operator)          ~ "Bus",
         grepl("Ferry|Ferries", operator)          ~ "Ferry",
         grepl("Rail", operator)                   ~ "Train",
         grepl("Transdev", operator)               ~ "Bus",
         operator == "Transport for Brisbane"      ~ "Bus",
         operator == "SeaLink"                     ~ "Ferry",
         operator == "Bay Islands Transit Systems" ~ "Bus",
         operator == "Park Ridge Transit"          ~ "Bus",
         operator == "Brisbane Transport"          ~ "Bus",
         TRUE                                      ~ operator)) %>%
  group_by(month, operator) %>%
  summarise(quantity = sum(quantity)) %>%
  ungroup() %>%
  mutate(year = as.numeric(gsub("-.*", "", month))) %>%
  mutate(month = as.Date(paste(month, "-01", sep = "")))

# Clean up # of trips outside top call to avoid big dataset operational time

clean_data <- filtered_operator %>%
  mutate(quantity = quantity/1000000)

#------------------------VISUALISATION------------------------

# Define colour palette

the_palette <- c("Bus" = "#F84791",
                 "Train" = "#57DBD8",
                 "Ferry" = "#F9B8B1")

CairoPNG("output/operator-initial-ts-plot.png", 550, 350)
p <- clean_data %>%
  ggplot(aes(x = month, y = quantity)) +
  geom_line(aes(colour = operator), stat = "identity", size = 1.25) +
  labs(title = "Time series of go card trips across TransLink by operator type",
       x = "Date",
       y = "Number of trips (million)",
       colour = "Operator type",
       caption = the_caption) +
  scale_x_date(labels = date_format("%b"), expand = c(0, 0)) +
  scale_y_continuous(limits = c(0,10),
                     breaks = c(0,2.5,5,7.5,10),
                     labels = function(x) paste0(x,"m")) +
  facet_grid(. ~ year, scale = "free_x", switch = "x") +
  theme_bw() +
  scale_colour_manual(values = the_palette) +
  the_theme
print(p)

dev.off()
