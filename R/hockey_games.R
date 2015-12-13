#' Retrieve the available hockey games for a given team
#' 
#' A function to retrieve all of the available hockey games for a specified team.
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
#' results <- hockey_games(league="nhl", team_id="nhl-bos")
#' }
#' @export
#' hockey_games

hockey_games <- function(league="nhl", team_id="nhl-bos", verbose=TRUE) {
  
  ## quick validation
  league <- tolower(league)
  stopifnot(is.character(league),
            league %in% c("nhl"),
            is.logical(verbose),
            is.character(team_id),
            length(team_id)==1)
  
  ## put the team into a list
  q_body = list(team_id=team_id)
  
  ## retrieve the teams
  tmp_call <- ss_get_result(sport = "hockey", 
                            league = league,
                            ep = "games",
                            query = q_body,
                            walk = T, 
                            verbose = verbose)
  
  ## return the data
  games <- do.call("rbind", lapply(tmp_call, function(x) x$games))
  
  ## ensure a dataframe
  stopifnot(is.data.frame(games))
  
  ## return the datafarme
  return(games)
  
}
  
  
  
  
  
  
  