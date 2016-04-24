#' Retrieve the available baseball teams in a given league
#' 
#' A function to retrieve all of the available baseball teams for a specified league.
#' 
#' @param league character. The baseball league to retrieve.  Currently MLB, NBA, NHL, and MLB are supported. MLB is default.
#' @param verbose logical.  TRUE will print messages to the console.  Default is TRUE.
#' 
#' @return a dataframe of the baseball teams for the specified league.
#' 
#' @examples 
#' \dontrun{
#' set_token("insert-your-token-here")
#' results <- baseball_teams(league="mlb")
#' }
#' @export
#' baseball_teams

baseball_teams <- function(league="mlb", verbose=TRUE) {
  ## quick validation
  league <- tolower(league)
  stopifnot(is.character(league),
            league %in% c("mlb"),
            is.logical(verbose))
  
  ## retrieve the teams
  tmp_call <- ss_get_result(sport = "baseball", 
                            league = league, 
                            ep = "teams",
                            walk = T, 
                            verbose = verbose)
  
  ## return the data
  teams <- do.call("rbind", lapply(tmp_call, function(x) x$teams))
  
  ## ensure a dataframe
  stopifnot(is.data.frame(teams))
  
  ## return the datafarme
  return(teams)
  
}
  
  
  
  
  
  
  