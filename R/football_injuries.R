#' Retrieve the available football injuries for a given league, team and season during a specific time interval.
#' 
#' A function to retrieve all of the available football injuries for a specified team.
#' 
#' @param league character. The football league to retrieve.  Currently MLB, NBA, NHL, and MLB are supported. nfl is default.
#' @param team_id character.  The team id, can be in the form of the slug "nfl-ne".  Default is the New England Patriots, nfl-ne.
#' @param interval_type character.  The season interval.  Default is regularseason.
#' @param season_id character.  The season.  Default is nfl-2015.
#' @param verbose logical.  TRUE will print messages to the console.  Default is TRUE.
#' 
#' @return a dataframe of the football injuries for the specified team.
#' 
#' @examples 
#' \dontrun{
#' set_token("insert-your-token-here")
#' results <- football_injuries(league="nfl", team_id="nfl-ne")
#' }
#' @export
#' football_injuries

football_injuries <- function(league = "nfl", 
                              team_id = "nfl-ne", 
                              interval_type = "regularseason", 
                              season_id = "nfl-2016",
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
                   interval_type = interval_type)
    
  }
  
  ## retrieve the teams
  tmp_call <- ss_get_result(sport = "football", 
                            league = league,
                            ep = "injuries",
                            query = q_body,
                            walk = T, 
                            verbose = verbose)
  
  ## return the data
  injuries <- parse_stattle(tmp_call, "injuries")
  players <- parse_stattle(tmp_call, "players")
  teams <- parse_stattle(tmp_call, "teams")
  
  ## cleanup sideloads
  players <- clean_sideload_players(players)
  teams <- clean_sideload_teams(teams)
  
  ## tack on some metadata
  injuries <- dplyr::left_join(injuries, players)
  injuries <- dplyr::left_join(injuries, teams)
  
  ## cleanup
  injuries <- dplyr::select(injuries, -division_id, -league_id)
  injuries$season_slug <- season_id
  
  ## ensure a dataframe
  stopifnot(is.data.frame(injuries))
  
  ## ensure unique
  injuries <- unique(injuries)
  
  ## return the datafarme
  return(injuries)
  
}
  
  
  
  
  
  
  