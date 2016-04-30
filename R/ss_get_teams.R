#' Retrieve the available teams 
#' 
#' A function to retrieve all of the teams for a specified league and sport
#' 
#' @param sport character. The sport to retrieve.  Currently baseball, basketball, hockey, and football are supported.  hockey is default.
#' @param league character. The league to retrieve.  Currently MLB, NBA, NHL, and MLB are supported. NHL is default.
#' @param verbose logical.  TRUE will print messages to the console.  Default is TRUE.
#' 
#' @return a dataframe of the teams for a given league and sport.
#' 
#' @examples 
#' \dontrun{
#' set_token("insert-your-token-here")
#' results <- ss_get_teams(sport="hockey", league="nhl")
#' }
#' @export
#' ss_get_teams

ss_get_teams <- function(sport="hockey", league="nhl", verbose=TRUE) {
  ## quick validation
  sport <- tolower(sport)
  league <- tolower(league)
  stopifnot(is.character(league),
            league %in% c("nhl", "nfl", "nba", "mlb"),
            is.logical(verbose),
            is.character(sport),
            sport %in% c("hockey", "basketball", "baseball", "football"))
  
  ## retrieve the teams
  tmp_call <- ss_get_result(sport = sport, 
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
  divs <- dplyr::inner_join(divs, confs)
  teams <- dplyr::inner_join(teams, divs)
  
  ## ensure a dataframe
  stopifnot(is.data.frame(teams))
  
  ## return the datafarme
  return(teams)
  
}
  
  
  
  
  
  
  