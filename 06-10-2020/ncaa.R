## Tidy Tuesday ##

#install.packages("tidyverse")
#install.packages("here")
#install.packages("cowplot")
#install.packages("magick")

# Load packages -----------------------------------------------------------

library(tidyverse)
library(cowplot)
library(magick)
library(here)

# Upload data -------------------------------------------------------------

tournament <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-10-06/tournament.csv')


# Data wrangling ----------------------------------------------------------

baylor <- tournament %>%
  filter(school == "Baylor") %>% # select only data for Baylor
  select(school, year, full_percent, tourney_finish) # taking only the variables I will need.


# Plotting the data -------------------------------------------------------

p <- ggplot(baylor, aes(x = year, y = full_percent)) +
  geom_path(col = "white") + 
  geom_point(col = "white") +  
  geom_text(aes(label = paste0(tourney_finish)),
            col = "white",
            nudge_y = c(-2, 2, -2, 2, -2, -2, -2, 2, -2, 0, 2, 0, -2, -2, 2, -2, 2),
            nudge_x = c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0.75, 0, 0.75, 0, 0 ,0 , 0, 0)) +
  labs(title = "Baylor NCAA Tournament History",
       subtitle = "Total win/loss percentage and end result by year",
       x = "Year",
       caption = "@osteobjorn | #TidyTuesday 06-10-2020 | source: FiveThirtyEight") +
  theme(plot.background = element_rect(fill = "#003015"), # background colour
        plot.title = element_text(colour = "#FFBC19", # text colour
                                  size = 20, # font size
                                  face = "bold"), # bold text
        plot.subtitle = element_text(colour = "#FFBC19",
                                     size = 14),
        plot.caption = element_text(colour = "#FFBC19"),
        axis.text = element_text(colour = "#FFBC19"),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.y = element_blank(),
        plot.margin = unit(c(1,1,1,1), "cm"),
        panel.background = element_rect(fill = "#003015"),
        panel.grid = element_blank())

p # plot without logo


# Add logo ----------------------------------------------------------------

img <- here::here("img", "logo1.png") %>% # upload the Baylor logo
  image_read()

ggdraw() +
  draw_plot(p) + # draw plot
  draw_image(img, scale = 0.2, hjust = -0.4, vjust = 0.3) # draw logo on top of plot

ggsave("baylor.png", width = 9, height = 7, units = "in")
