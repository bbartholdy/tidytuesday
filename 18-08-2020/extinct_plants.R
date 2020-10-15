# TidyTuesday 18-08-2020


# Loading necessary packages -------------------------------

library(tidyverse)
library(maps)
library(cowplot)
library(magick)


# Data --------------------------------------------------------------------

threats <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-08-18/threats.csv')

threat.cat <- threats %>%
  select(country, red_list_category) %>%
  rename(
    category = red_list_category, 
    region = country) %>%
  mutate(
    region = ifelse(region == "United States", "USA", region), # Convert to USA for compatibility with map data
    region = factor(region), 
    category = factor(category))
threat.cat2 <- threat.cat %>%
  group_by(region) %>%
  summarise(n = n()) # calculate number of extinct plants per region

world_map <- map_data("world")
cat.map <- left_join(world_map, threat.cat2)

# The plot ----------------------------------------------------------------

ggplot(cat.map, aes(x = long, y = lat, group = group)) +
  geom_polygon(aes(fill = n), colour = "#c9c9c9") +
  scale_fill_viridis_c(option = "C") + # colour blind friendly pallette
  theme_void() +
  labs(
    title = "Extinct Plants",
    subtitle = "Total number of plants extinct in the wild per country of origin",
    caption = "@OsteoBjorn | #TidyTuesday | Source: Florent Lavergne and Cédric Scherer",
    fill = "Number of Plants"
    ) +
  theme(
    plot.margin = margin(10, 20, 10, 100),
    panel.background = element_rect(fill = "#c0dded", colour = "#c0dded"),
    text = element_text(colour = "white"),
    plot.background = element_rect(fill = "#404040"),
    plot.title = element_text(hjust = 0.5, size = 16, colour = "#67c27f"),
    plot.subtitle = element_text(hjust = 0.5, size = 10, margin = margin(0, 0, 20, 0), colour = "white"),
    plot.caption = element_text(size = 8)
    )

ggsave("plant-plot.png", width = 10, height = 6, units = "in")
