#' Retrieve players for a given league, team and season during a specific time interval.
#' 
#' A function to retrieve all of the players in baseball, for a given team during a current season and interval type.
#' 
#' @param league character. The hockey league to retrieve.  Currently MLB, NBA, NHL, and MLB are supported. NBA the default.
#' @param team_id character.  The team id, can be in the form of the slug "nba-bos".  Default is the Boston Red Sox, nba-bos.
#' @param interval_type character.  The season interval.  Default is regularseason.
#' @param season_id character.  The season.  Default is nba-2015-2016.
#' @param verbose logical.  TRUE will print messages to the console.  Default is TRUE.
#' 
#' @return a dataframe of the baseball players for the specified league and team.
#' 
#' @examples 
#' \dontrun{
#' set_token("insert-your-token-here")
#' results <- basketball_players(league="nba", team_id="nba-bos")
#' }
#' @export
#' basketball_players

basketball_players <- function(league = "nba", 
                           team_id = "nba-bos", 
                           interval_type = "regularseason", 
                           season_id = "nba-2015-2016",
                           verbose = TRUE) {
  
  ## quick validation
  league <- tolower(league)
  stopifnot(is.character(league),
            league %in% c("nba"),
            is.logical(verbose),
            is.character(team_id),
            length(team_id)==1)
  
  ## put the team into a list if there was one specified
  ## team_id = "" is for all teams
  q_body <- list()
  if (nchar(team_id) > 0) {
    q_body <- list(league = league,
                   team_id = team_id,
                   season_id = season_id,
                   interval_type = interval_type)
  }

  
  ## retrieve the players for a team in a league
  tmp_call <- ss_get_result(sport = "baseball", 
                            league = league,
                            ep = "players",
                            query = q_body,
                            walk = T, 
                            verbose = verbose)
  
  ## return the data
  players <- parse_stattle(tmp_call, "players")
  leagues <- parse_stattle(tmp_call, "leagues")
  teams <- parse_stattle(tmp_call, "teams")
  
  ## clean the data
  leagues <-  clean_sideload_leagues(leagues)
  teams <- clean_sideload_teams(teams)
  
  ## merge on the data
  players <- dplyr::left_join(players, teams)
  players <- dplyr::left_join(players, leagues)
  
  ## ensure a dataframe
  stopifnot(is.data.frame(players))
  
  ## ensure unique
  players <- unique(players)
  
  ## return the datafarme
  return(players)
  
}
  
  
  
  
  
  
  