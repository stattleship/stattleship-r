#' Helper to get team game logs for a specified team in a sport and league
#' 
#' A function to interface and make it easier to get team game logs for a team in a sport/league.
#' 
#' @param sport character. The sport of the team
#' @param league character. The hockey league to retrieve.  Currently MLB, NBA, NHL, and NFL are supported. 
#' NHL is default.
#' @param team_id character.  Optional. The team id, can be in the form of the slug "nhl-bos".  
#' Default is all teams (empty character).
#' @param interval_type character.  The season interval.  Default is regularseason.
#' @param season_id character.  The season.  Default is nhl-2015-2016.
#' @param status character.  The status of the game.  Ended is default.
#' @param game_id character.  Optional. A specific game of interest.
#' @param verbose logical.  TRUE will print messages to the console.  Default is TRUE.
#' @param walk logical.  TRUE will retrieve all of the pages. Default is TRUE.
#' 
#' @return a dataframe of the teams game logs
#' 
#' @examples 
#' \dontrun{
#' set_token("insert-your-token-here")
#' bos_logs <- ss_team_logs(league="nhl", team_id="nhl-bos") 
#' }
#' @export
#' ss_team_logs

ss_team_logs <- function(sport = "hockey",
                         league = "nhl", 
                         team_id = "nhl-bos", 
                         interval_type = "regularseason", 
                         season_id = "nhl-2015-2016",
                         status = "ended",
                         game_id = "",
			 since = "",
                         verbose = TRUE,
                         walk = TRUE) {
  
  ## quick validation
  league <- tolower(league)
  sport <- tolower(sport)
  stopifnot(is.character(league),
            league %in% c("nhl", "mlb", "nba", "nfl"),
            sport %in% c("baseball", "basketball", "football", "hockey"),
            is.logical(verbose),
            is.character(team_id),
            length(team_id)==1,
            length(status)==1)
  
  ## the core body
  q_body <- list(season_id = season_id,
                 interval_type = interval_type,
                 status = status)
  ## conditioned on team
  if (nchar(team_id) > 0) {
    q_body = c(q_body, team_id = team_id)
  }
  ## conditioned on game
  if (nchar(game_id) > 0) {
    q_body = c(q_body, game_id = game_id)
  }
  ## conditioned on since
  if (nchar(since) > 0 ) {
    q_body = c(q_body, since=since)
  }
  
  ## retrieve the players for a team in a league
  tmp_call <- ss_get_result(sport = sport, 
                            league = league,
                            ep = "team_game_logs",
                            query = q_body,
                            walk = walk, 
                            verbose = verbose)
  
  ## get the teams from the API because the division data is lacking
  tmp_team <- ss_get_result(sport = sport,
                            league = league,
                            ep = "teams")
  
  ## pull out the data
  gls <- parse_stattle(tmp_call, "team_game_logs")
  teams <- parse_stattle(tmp_call, "teams")
  games <- parse_stattle(tmp_call, "games")
  venues <- parse_stattle(tmp_call, "venues")
  away_teams <- parse_stattle(tmp_call, "away_teams")
  home_teams <- parse_stattle(tmp_call, "home_teams")
  divs <- parse_stattle(tmp_team, "divisions")
  
  ## combine the teams for the opponent data
  teams_opp <- rbind(away_teams, home_teams)
  teams_opp <- unique(teams_opp)
  
  ## cleanup the data
  teams <- clean_sideload_teams(teams, prefix="team")
  teams_opp <- clean_sideload_teams(teams_opp, prefix="opponent")
  games <- clean_sideload_games(games, prefix="game")
  venues <- clean_sideload_venues(venues, prefix="game_venue")
  
  ## add on the division data
  divs_team <- clean_sideload_divisions(divs, prefix="team_division", drop_conf = TRUE)
  divs_opp <- clean_sideload_divisions(divs, prefix="opponent_division", drop_conf = TRUE)
  teams <- dplyr::left_join(teams, divs_team)
  teams_opp <- dplyr::left_join(teams_opp, divs_opp)
  
  ## merge together for a big dataset
  gls <- dplyr::left_join(gls, teams)  ## append the gamelog's team info
  gls <- dplyr::left_join(gls, teams_opp)  ## opponent info
  gls <- dplyr::left_join(gls, games)
  gls <- dplyr::left_join(gls, venues)
  
  ## ensure unique
  gls <- unique(gls)
  
  ## return the datafarme
  return(gls)
  
}
  
  
  
  
  
  
  
