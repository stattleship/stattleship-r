#' Clean up the sideloaded league data for easy merging with other sources of data.
#' 
#' Clean the league sideloaded data for merging and reporting purposes
#' 
#' 
#' @return a dataframe with the modified data cleaned up for merging
#' 
#' @examples 
#' \dontrun{
#' set_token("insert-your-token-here")
#' teams <- ss_get_result(sport = "hockey", league = "nhl", ep = "teams")
#' lgs <- parse_stattle(teams, "leagues")
#' teams <- clean_sideload_leagues(lgs)
#' }
#' @export
#' clean_sideload_leagues

clean_sideload_leagues <- function(lgs) {
  
  ## ensure a dataframe
  stopifnot(is.data.frame(lgs))
  
  ## keep the columns of interest
  lgs <- dplyr::select(lgs, id, name, slug, sport)
  
  ## rename the variables
  colnames(lgs) <- paste0("league_", colnames(lgs))
  
  ## return the datafarme
  return(lgs)
  
}
  
  
  
  
  
  
  