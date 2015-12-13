#' Retrieve hockey injuries for a league
#' 
#' A function to retrieve all of the injuries in hockey, for a given team.
#' 
#' @param league character. The hockey league to retrieve.  Currently only the NHL is supported, and is the default.
#' @param team_id character.  Optional. The team id, can be in the form of the slug "nhl-bos".  Default is all teams (empty character).
#' @param verbose logical.  TRUE will print messages to the console.  Default is TRUE.
#' 
#' @return a dataframe of the hockey injuries for the specified league, and optionally, for a given team.
#' 
#' @examples 
#' \dontrun{
#' setToken("insert-your-token-here")
#' results_bos <- hockey_injuries(league="nhl", team_id="nhl-bos") ## bruins injuries
#' results_all <- hockey_injuries(league="nhl") ## all injuries
#' }
#' @export
#' hockey_injuries

hockey_injuries <- function(league="nhl", team_id="", verbose=TRUE) {
  
  ## quick validation
  league <- tolower(league)
  stopifnot(is.character(league),
            league %in% c("nhl"),
            is.logical(verbose),
            is.character(team_id),
            length(team_id)==1)
  
  ## put the team into a list if there was one specified
  q_body = list()
  if (nchar(team_id) > 0) {
    q_body = list(team_id=team_id)
  }
  
  ## retrieve the players for a team in a league
  tmp_call <- ss_get_result(sport = "hockey", 
                            league = league,
                            ep = "injuries",
                            query = q_body,
                            walk = T, 
                            verbose = verbose)
  
  ## return the data
  injuries <- do.call("rbind", lapply(tmp_call, function(x) x$injuries))
  
  ## ensure a dataframe
  stopifnot(is.data.frame(injuries))
  
  ## return the datafarme
  return(injuries)
  
}
  
  
  
  
  
  
  