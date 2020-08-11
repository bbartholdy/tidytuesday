# TidyTuesday 11-08-2020


# Installing and loading necessary packages -------------------------------

  # If you haven't already downloaded these
install.packages("tidyverse")
  # Loading the packages to your environment
library(tidyverse)

# Upload avatar data ------------------------------------------------------

avatar <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-08-11/avatar.csv')

# Data prep ---------------------------------------------------------------

director_rating <- avatar

  # convert director variable from character to factor
director_rating$director <- director_rating$director %>% as.factor()

  # find the mean imdb rating and overall number of episodes for each director
rating_summ <- director_rating %>% 
  na.omit() %>%
  group_by(director) %>%
  summarise(mean_rating = mean(imdb_rating), n = length(imdb_rating))

  # view the summary table
view(rating_summ)


# Plots -------------------------------------------------------------------

director_rating %>%
  na.omit() %>% # remove missing values
  ggplot(aes(x = director, y = imdb_rating, fill = director)) + # set axes
  geom_boxplot() + # plot type
  labs(y = "IMDB Rating", fill = "Director Name", title = "Best Director") + # Name the axes and plot
  theme_bw() + # Plot theme
  theme(axis.title.x = element_blank(), # remove x-axis label
        axis.text.x = element_blank()) # remove director names from x-axis (already in legend)

# or

director_rating %>%
  na.omit() %>% # remove missing values
  ggplot(aes(x = director, y = imdb_rating, fill = director)) + # set axes
  geom_boxplot() + # plot type
  labs(x = "Director Name", y = "IMDB Rating", title = "Best Director") + # Name the axes
  theme_minimal() + # plot theme
  theme(legend.position = "none",  # remove legend (director names already on x-axis)
        axis.text.x = element_text(angle = 50, vjust = 1, hjust=1)) # rotate x-axis text so the names don't overlap
