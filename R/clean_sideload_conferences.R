#' Clean up the sideloaded conference data for easy merging with other sources of data.
#' 
#' Clean the conferences sideloaded data for merging and reporting purposes
#' 
#' 
#' @return a dataframe with the modified data cleaned up for merging
#' 
#' @examples 
#' \dontrun{
#' set_token("insert-your-token-here")
#' teams <- ss_get_result(sport = "hockey", league = "nhl", ep = "teams")
#' confs <- parse_stattle(teams, "conferences")
#' confs <- clean_sideload_conferences(confs)
#' }
#' @export
#' clean_sideload_conferences

clean_sideload_conferences <- function(x) {
  
  ## ensure a dataframe
  stopifnot(is.data.frame(x))
  
  ## keep the columns of interest
  x <- dplyr::select(x, id, name, league_id)
  
  ## rename the variables
  x <- dplyr::rename(x, conference_id = id)
  x <- dplyr::rename(x, conference_name = name)
  
  ## return the datafarme
  return(x)
  
}


  
  
  
  
  
  
  