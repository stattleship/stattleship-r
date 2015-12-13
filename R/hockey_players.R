#' Retrieve players for a given team
#' 
#' A function to retrieve all of the players for a given team, in a given league
#' 
#' @param league character. The hockey league to retrieve.  Currently only the NHL is supported, and is the default.
#' @param team_id character.  The team id, can be in the form of the slug "nhl-bos".  Default is the Boston Bruins, nhl-bos.
#' @param verbose logical.  TRUE will print messages to the console.  Default is TRUE.
#' 
#' @return a dataframe of the hockey teams for the specified league.
#' 
#' @examples 
#' \dontrun{
#' setToken("insert-your-token-here")
#' results <- hockey_players(league="nhl", team_id="nhl-bos")
#' }
#' @export
#' hockey_players

hockey_players <- function(league="nhl", team_id="nhl-bos", verbose=TRUE) {
  
  ## quick validation
  league <- tolower(league)
  stopifnot(is.character(league),
            league %in% c("nhl"),
            is.logical(verbose),
            is.character(team_id),
            length(team_id)==1)
  
  ## put the team into a list if there was one specified
  ## team_id = "" is for all teams
  q_body = list()
  if (nchar(team_id) > 0) {
    q_body = list(team_id=team_id)
  }

  
  ## retrieve the players for a team in a league
  tmp_call <- ss_get_result(sport = "hockey", 
                            league = league,
                            ep = "players",
                            query = q_body,
                            walk = T, 
                            verbose = verbose)
  
  ## return the data
  players <- do.call("rbind", lapply(tmp_call, function(x) x$players))
  
  ## ensure a dataframe
  stopifnot(is.data.frame(players))
  
  ## return the datafarme
  return(players)
  
}
  
  
  
  
  
  
  