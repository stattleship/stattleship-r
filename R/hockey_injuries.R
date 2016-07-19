#' Retrieve hockey injuries for a given league, team and season during a specific time interval.
#' 
#' A function to retrieve all of the injuries in hockey, for a given team during a current season and interval type.
#' 
#' @param league character. The hockey league to retrieve.  Currently MLB, NBA, NHL, and MLB are supported. NHL is default.
#' @param team_id character.  Optional. The team id, can be in the form of the slug "nhl-bos".  Default is the Boston Bruins, nhl-bos.
#' @param interval_type character.  The season interval.  Default is regularseason.
#' @param season_id character.  The season.  Default is nhl-2015-2016.
#' @param verbose logical.  TRUE will print messages to the console.  Default is TRUE.
#' 
#' @return a dataframe of the hockey injuries for the specified league, and optionally, for a given team.
#' 
#' @examples 
#' \dontrun{
#' set_token("insert-your-token-here")
#' results_bos <- hockey_injuries(league="nhl", team_id="nhl-bos") ## bruins injuries
#' results_all <- hockey_injuries(league="nhl") ## all injuries
#' }
#' @export
#' hockey_injuries

hockey_injuries <- function(league = "nhl", 
                            team_id = "nhl-bos", 
                            interval_type = "regularseason", 
                            season_id = "nhl-2015-2016",
                            verbose = TRUE) {
  
  ## quick validation
  league <- tolower(league)
  stopifnot(is.character(league),
            league %in% c("nhl"),
            is.logical(verbose),
            is.character(team_id),
            length(team_id)==1)
  
  ## put the team into a list if there was one specified
  q_body <- list()
  if (nchar(team_id) > 0) {
    q_body <- list(team_id = team_id,
                   season_id = season_id,
                   interval_type = interval_type)
  }
  
  ## retrieve the players for a team in a league
  tmp_call <- ss_get_result(sport = "hockey", 
                            league = league,
                            ep = "injuries",
                            query = q_body,
                            walk = TRUE, 
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
  #injuries <- dplyr::select(injuries, -division_id, -league_id)
  injuries$season_slug <- season_id
  
  ## ensure a dataframe
  stopifnot(is.data.frame(injuries))
  
  ## ensure unique
  injuries <- unique(injuries)
  
  ## return the datafarme
  return(injuries)
  
}
  
  
  
  
  
  
  