# Functions to retrieve NFL information from the Stattleship API

get_nfl_team_info <- function(team_name = "New England") {
  # Gets NFL team information including nickname, Twitter hashtag and color
  #
  # team_name: String of team name or team location. Do not include team nickname.
  #
  # e.g. get_nfl_team_info("Denver")
  
  # Validation check
  stopifnot(is.character(team_name))
  
  # Get results from Stattleship API
  results <- ss_get_result(sport = "football", 
                           league = "nfl",
                           ep = "teams",
                           query = list(),
                           version = 1,
                           walk = FALSE,
                           page = NA,
                           verbose = TRUE)
  all_team_info <- results[[1]][4][[1]]
  team_name <- tolower(team_name)
  team_info <- all_team_info %>%
    filter(tolower(name) == team_name) %>%
    # TODO: Add a non-id version of Conference e.g. AFC
    # TODO: Add a non-id version of Division e.g. AFC East
    select(name, nickname, location, hashtag, hashtags,
           color, colors, latitude, longitude, slug)
  return(team_info)
}
