library(tidyverse)

# Uploading data
beyonce_lyrics <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-09-29/beyonce_lyrics.csv')
taylor_swift_lyrics <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-09-29/taylor_swift_lyrics.csv')

# Separate lines
taylor_swift <- taylor_swift_lyrics %>%
  tidytext::unnest_sentences(line, Lyrics) %>%
  select(Artist, line)

beyonce <- beyonce_lyrics %>%
  select(artist_name, line)

col_names <- c("artist", "line")
colnames(beyonce) <- col_names
colnames(taylor_swift) <- col_names

lyrics <- rbind(beyonce, taylor_swift)