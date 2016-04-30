#' Retrieve the available football games for a given league, team and season during a specific time interval.
#' 
#' A function to retrieve all of the available football games for a specified team.
#' 
#' @param league character. The football league to retrieve.  Currently MLB, NBA, NHL, and MLB are supported. nfl is default.
#' @param team_id character.  The team id, can be in the form of the slug "nfl-ne".  Default is the Boston Red Sox, nfl-ne.
#' @param interval_type character.  The season interval.  Default is regularseason.
#' @param season_id character.  The season.  Default is nfl-2015.
#' @param status character.  That status of the game.  Default is ended.
#' @param verbose logical.  TRUE will print messages to the console.  Default is TRUE.
#' 
#' @return a dataframe of the football games for the specified league.
#' 
#' @examples 
#' \dontrun{
#' set_token("insert-your-token-here")
#' results <- football_games(league="nfl", team_id="nfl-ne")
#' }
#' @export
#' football_games

football_games <- function(league = "nfl", 
                             team_id = "nfl-ne", 
                             interval_type = "regularseason", 
                             season_id = "nfl-2015",
                             status = "ended",
                             verbose = TRUE) {
  
  ## quick validation
  league <- tolower(league)
  stopifnot(is.character(league),
            league %in% c("nfl"),
            is.logical(verbose),
            is.character(team_id),
            length(team_id)==1)
  
  ## put the team into a list if there was one specified
  q_body <- list()
  if (nchar(team_id) > 0) {
    q_body <- list(league = league,
                   team_id = team_id,
                   season_id = season_id,
                   interval_type = interval_type,
                   status =  status)
    
  }
  
  ## retrieve the teams
  tmp_call <- ss_get_result(sport = "football", 
                            league = league,
                            ep = "games",
                            query = q_body,
                            walk = T, 
                            verbose = verbose)
  
  ## return the data
  games <- parse_stattle(tmp_call, "games")
  away_teams <- parse_stattle(tmp_call, "away_teams")
  home_teams <- parse_stattle(tmp_call, "home_teams")
  
  ## ensure unique
  games <- unique(games)
  away_teams <- unique(away_teams)
  home_teams <- unique(home_teams)
  
  ## cleanup the teams
  away_teams <- clean_sideload_teams(away_teams, "away_team")
  home_teams <- clean_sideload_teams(home_teams, "home_team")
  
  ## drop the division and away_teams from each
  away_teams$division_id <- NULL
  away_teams$league_id <- NULL
  home_teams$division_id <- NULL
  home_teams$league_id <- NULL
  
  ## merge the data
  games <- dplyr::left_join(games, away_teams)
  games <- dplyr::left_join(games, home_teams)
  
  ## home team win indicator and season from the call
  games$season_slug = season_id
  
  ## ensure unique
  games <- unique(games)
  
  ## return the datafarme
  return(games)
  
}
  
  
  
  
  
  
  