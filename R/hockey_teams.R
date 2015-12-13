#' Retrieve the available hockey teams
#' 
#' A function to retrieve all of the available hockey teams for a specified league.
#' 
#' @param league character. The hockey league to retrieve.  Currently only the NHL is supported, and is the default.
#' @param verbose logical.  TRUE will print messages to the console.  Default is TRUE.
#' 
#' @return a dataframe of the hockey teams for the specified league.
#' 
#' @examples 
#' \dontrun{
#' setToken("insert-your-token-here")
#' results <- hockey_teams(league="nhl")
#' }
#' @export
#' hockey_teams

hockey_teams <- function(league="nhl", verbose=TRUE) {
  ## quick validation
  league <- tolower(league)
  stopifnot(is.character(league),
            league %in% c("nhl"),
            is.logical(verbose))
  
  ## retrieve the teams
  tmp_call <- ss_get_result(sport = "hockey", 
                            league = league, 
                            ep = "teams",
                            walk = T, 
                            verbose = verbose)
  
  ## come back to this later.  many similar names collide.  Let's talk about this.
  ## get the dataframe -- walk just in case
#   tmp_teams = do.call("rbind", lapply(tmp_call, function(x) x$teams))
#   tmp_divisions = do.call("rbind", lapply(tmp_call, function(x) x$divisions))
#   tmp_confs = do.call("rbind", lapply(tmp_call, function(x) x$conferences))
#   tmp_leagues = do.call("rbind", lapply(tmp_call, function(x) x$leagues))
  
  ## give each "id" a different name
#   names(tmp_teams)[which(names(tmp_teams)=="id")] = "team_id"
#   names(tmp_divisions)[which(names(tmp_divisions)=="id")] = "division_id"
#   names(tmp_confs)[which(names(tmp_confs)=="id")] = "conference_id"
#   names(tmp_leagues)[which(names(tmp_leagues)=="id")] = "league_id"
  
  ## merge the data together
  
  ## return the data
  teams <- do.call("rbind", lapply(tmp_call, function(x) x$teams))
  
  ## ensure a dataframe
  stopifnot(is.data.frame(teams))
  
  ## return the datafarme
  return(teams)
  
}
  
  
  
  
  
  
  