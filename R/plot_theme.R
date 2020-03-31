#--------------------------------------------
# This script defines key thematic changes
# to plots to style them according to the
# Orbisant Analytics aesthetic
#--------------------------------------------

#---------------------------------------
# Author: Trent Henderson, 31 March 2020
#---------------------------------------

the_caption <- "Source: TransLink, Orbisant Analysis"

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
