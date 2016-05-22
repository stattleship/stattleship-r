#' Retrieve the available hockey teams
#' 
#' A function to retrieve all of the available hockey teams for a specified league.
#' 
#' @param league character. The hockey league to retrieve.  Currently MLB, NBA, NHL, and MLB are supported. NHL is default.
#' @param verbose logical.  TRUE will print messages to the console.  Default is TRUE.
#' 
#' @return a dataframe of the hockey teams for the specified league.
#' 
#' @examples 
#' \dontrun{
#' set_token("insert-your-token-here")
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
  
  ## return the data
  teams <- parse_stattle(tmp_call, "teams")
  divs <- parse_stattle(tmp_call, "divisions")
  confs <- parse_stattle(tmp_call, "conferences")
  lgs <- parse_stattle(tmp_call, "leagues")
  
  ## clean up data
  lgs <-  clean_sideload_leagues(lgs)
  divs <- clean_sideload_divisions(divs)
  confs <- clean_sideload_conferences(confs)
  teams <- clean_sideload_teams(teams)

  ## merge divs and confs
  confs <-  dplyr::inner_join(confs, lgs)
  divs <- dplyr::inner_join(divs, confs, by=c("division_conference_id"="conference_id"))
  teams <- dplyr::inner_join(teams, divs, by=c("team_division_id"="division_id"))
  
  ## ensure a dataframe
  stopifnot(is.data.frame(teams))
  
  ## ensure unique
  teams <- unique(teams)
  
  ## return the datafarme
  return(teams)
  
}
  
  
  
  
  
  
  