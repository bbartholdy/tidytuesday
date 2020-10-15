# Tidy Tuesday 22-09-2020

# Himalayan Climbing Expeditions

library(tidyverse)
library(cowplot)
library(here)

# Uploading data ----------------------------------------------------------

members <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-09-22/members.csv')
expeditions <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-09-22/expeditions.csv')
peaks <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-09-22/peaks.csv')

# Data wrangling ----------------------------------------------------------

## most common reasons for termination by peak

top_peaks <- peaks %>%
  arrange(desc(height_metres))

top_peaks <- top_peaks$peak_id[1:12]

members %>%
  filter(success == F) %>%
  filter(peak_id %in% top_peaks) %>%
  group_by(peak_id) %>%
  summarise(length(peak_id))

top_peaks <- top_peaks[-c(6,7)] # remove duplicate and LHOM (only 6 obs)

reasons <- expeditions %>% 
  group_by(peak_name) %>%
  filter(peak_id %in% top_peaks) %>%
  filter(!str_detect(termination_reason,"Success")) %>%
  filter(termination_reason != "Other") %>%
  filter(termination_reason != "Unknown") %>%
  filter(termination_reason != "Did not attempt climb") %>%
  filter(termination_reason != "Attempt rumoured") %>%
  filter(termination_reason != "Did not reach base camp") %>%
  filter(termination_reason != "Lack of time") %>%
  count(termination_reason) %>%
  mutate(n_ratio = n / sum(n))

#reasons %>% mutate(n_ratio = n / sum(n))

# Plot --------------------------------------------------------------------

p <- ggplot(reasons, aes(x = 2, y = n_ratio, fill = termination_reason)) +
  geom_bar(width = 1, stat = "identity", colour = "white") +
  coord_polar("y") +
  facet_wrap(~ peak_name) +
  theme_void() +
  xlim(0.5, 2.5) +
  theme(
    plot.background = element_rect(fill = "#263a53", 
                                   colour = NA),
    axis.title = element_blank(),
    strip.text = element_text(
      size = 14,
      colour = "white",
      vjust = 1
    ),
    plot.title = element_text(
      size = 28,
      colour = "white",
      hjust = 0.5,
      vjust = 3
    ),
    plot.subtitle = element_text(
      size = 24,
      colour = "#53cfa6",
      hjust = 0.5,
      vjust = 4
    ),
    plot.caption = element_text(
      colour = "#53cfa6",
      size = 9,
      hjust =  1.05,
      vjust = 0.04
    ),
    plot.margin = unit(c(1,5,1,5), "cm"),
    panel.spacing = unit(2, "cm"),
    legend.position = "bottom",
    legend.title = element_blank(),
    legend.text = element_text(
      size = 8,
      colour = "white")
  ) +
  labs(title = "REASONS FOR A FAILED EXPEDITION",
       subtitle = "On nine of the tallest peaks in the Himalayas",
       caption = "@OsteoBjorn | #TidyTuesday | Data: Alex Cookson \n Colours inspired by changingstories.org")
  
ggdraw(p) +
  draw_image(here("22-09-2020", "logo2.png"), x = 0.83, vjust = 0.445, width = 0.1)

ggsave(here("22-09-2020", "himalayas.png"), width = 10, height = 9, units = "in", dpi = 400)
