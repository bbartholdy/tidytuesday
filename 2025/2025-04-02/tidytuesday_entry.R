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
    geom_segment(aes(y = 0, yend = max(hp)), col = "grey80", linewidth = 10, alpha = 0.8, show.legend = FALSE, lineend = "round") +
    geom_segment(aes(y = 0, yend = hp, col = type_1), linewidth = 10, alpha = 0.8, show.legend = TRUE, lineend = "round") +
    geom_image(aes(image = url_icon, y = 1, x = reorder(pokemon, hp)), size = 0.08, inherit.aes = FALSE) +
    geom_text(family = "Manjari", hjust = "left", y = 12, check_overlap = TRUE, size = 6, colour = "white") +
    coord_flip() +
    scale_colour_manual(values = type_palette) +
    theme_void() +
    guides(colour = guide_legend(override.aes = list(linewidth = 4))) +
    theme(
      axis.text.x = element_text(vjust = 2),
      legend.position = "top",
      legend.title.position = "left",
      plot.margin = margin(10, 10, 10, 10),
      plot.title = element_markdown(hjust = 0.5, margin = margin(b = 6)),
      plot.subtitle = element_text(family = "Karumbi", face = "bold", size = 24, hjust = 0.5, margin = margin(b = 10)),
      plot.caption = element_markdown(hjust = 0),
      text = element_text(family = "Manjari"),
      plot.background = element_rect(fill = "#e5eeee", colour = NA)
    ) +
    labs(
      col = "Type",
      title = "<img src='https://image.tmdb.org/t/p/original/xvERvRImZQOj83WPj1y3nxPxMDv.png' width='200'/>",
      subtitle = "with the most hit points (HP)",
      caption = "**Data:** {pokemon} R package <br> **code:** github.com/bbartholdy/tidytuesday/2025/2025-04-02"
    )

ggsave("2025/2025-04-02/pokemon-hp.png", width = 110, height = 160, units = "mm", dpi = 400)
