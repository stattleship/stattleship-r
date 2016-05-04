## ----echo=F, warning=FALSE, message=FALSE--------------------------------
options(stringsAsFactors=FALSE)
knitr::opts_chunk$set(comment = NA)
knitr::opts_chunk$set(warning = F)
knitr::opts_chunk$set(message = F)

## load the packages
library(stattleshipR)
library(dplyr)


## ----eval=FALSE----------------------------------------------------------
#  install.packages("devtools")
#  devtools::install_github("stattleship/stattleship-r")
#  
#  ## Load the stattleshipR package
#  library(stattleshipR)

## ----eval=FALSE----------------------------------------------------------
#  set_token("your-API-token-goes-here")

## ------------------------------------------------------------------------
set_token(Sys.getenv("STATTLE_TOKEN"))

## ----eval=FALSE----------------------------------------------------------
#  library(dplyr)

## ---- echo=TRUE, message=FALSE, warning=FALSE, error= FALSE, comment=NA----
teams_raw <- ss_get_result(sport="baseball", league = "mlb", ep = "teams")

## ------------------------------------------------------------------------
list_sideload(teams_raw)

## ------------------------------------------------------------------------
mlb_teams <- do.call('rbind', lapply(teams_raw, function(x) x$teams))
head(mlb_teams$hashtag)

## ------------------------------------------------------------------------
mlb_teams2 <- parse_stattle(teams_raw, "teams")
head(mlb_teams2$hashtag)

## ------------------------------------------------------------------------
mlb_teams3 <- baseball_teams()
head(mlb_teams3$team_hashtag)

## ------------------------------------------------------------------------
colnames(mlb_teams3)

## ------------------------------------------------------------------------
## get the data with the defaults set to New England
pats_games <- football_games() %>% 
  filter(weather_conditions=="cloudy")

## keep columns and print a few rows
tbl_df(pats_games) %>% 
  select(interval, on, score_differential) %>% 
  print(n=5)

## ------------------------------------------------------------------------
celts_gls <- ss_team_logs(sport="basketball", 
                          league="nba", 
                          team_id="nba-bos", 
                          season_id="nba-2015-2016")

## ------------------------------------------------------------------------
colnames(celts_gls)

## ------------------------------------------------------------------------
mycols <- c("game_label", "is_home_team", "points_scored_total", "game_venue_name")
celts_limited_cols <- ss_keep_cols(celts_gls, mycols)
head(celts_limited_cols)

## ------------------------------------------------------------------------
marchy <- ss_player_logs(player_id="nhl-brad-marchand")

## ------------------------------------------------------------------------
mycols <- c("game_on", "goals", "opponent_slug", "opponent_color", "game_attendance", "game_venue")
ss_keep_cols(marchy, mycols) %>% head

