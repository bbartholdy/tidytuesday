library(dplyr)
library(ggplot2)
library(ggimage)
library(ggtext)
library(tidytuesdayR)

tuesdata <- tidytuesdayR::tt_load('2025-04-01')
pokemon_df <- tuesdata$pokemon_df

colour_df <- pokemon_df |>
  distinct(type_1, .keep_all = TRUE) |>
  select(type_1, color_1)
type_palette <- colour_df$color_1
names(type_palette) <- colour_df$type_1
pokemon_df |>
  filter(id < 152) |>
  arrange(desc(hp)) |>
  slice_head(n = 10) |>
  mutate(url_icon = paste0("https:", url_icon)) |>
  ggplot(aes(x = reorder(pokemon, hp), y = hp, label = pokemon, colour = type_1)) +
    geom_segment(aes(y = 0, yend = max(hp)), col = "#ffffff", linewidth = 5, show.legend = FALSE, lineend = "round") +
    geom_segment(aes(y = 0, yend = hp, col = type_1), linewidth = 5, alpha = 0.9, show.legend = TRUE, lineend = "round") +
    geom_image(aes(image = url_icon, y = 1, x = reorder(pokemon, hp)), size = 0.08, inherit.aes = FALSE) +
    geom_text(family = "Manjari", hjust = "left", y = 12, check_overlap = TRUE, size = 3, colour = "white") +
    coord_flip() +
    scale_colour_manual(values = type_palette) +
    theme_void() +
    guides(colour = guide_legend(override.aes = list(linewidth = 2))) +
    theme(
      axis.text.x = element_text(vjust = 2),
      legend.position = "top",
      legend.title.position = "left",
      legend.title = element_text(face = "bold"),
      legend.text = element_text(hjust = 0.5),
      plot.margin = margin(8, 8, 8, 8),
      plot.title = element_markdown(hjust = 0.5, margin = margin(b = 4)),
      plot.subtitle = element_text(family = "Karumbi", face = "bold", size = 22, hjust = 0.5, margin = margin(b = 6)),
      plot.caption = element_markdown(hjust = 0, size = 5),
      text = element_text(family = "Manjari", size = 6, colour = "#ffffff"),
      plot.background = element_rect(fill = "#e93232", colour = NA)
    ) +
    labs(
      col = "Type",
      title = "<img src='https://image.tmdb.org/t/p/original/xvERvRImZQOj83WPj1y3nxPxMDv.png' width='180'/>",
      subtitle = "with the most hit points (HP)",
      caption = "Top 10 Pokemon from the first generation with the most hit points (HP)<br> **Data:** {pokemon} R package <br> **code:** github.com/bbartholdy/tidytuesday/tree/master/2025/2025-04-02"
    )

ggsave("2025/2025-04-02/pokemon-hp.png", width = 92, height = 116, units = "mm", dpi = 300)
