#' Clean up the sideloaded division data for easy merging with other sources of data.
#' 
#' Clean the divisions sideloaded data for merging and reporting purposes
#' 
#' 
#' @return a dataframe with the modified data cleaned up for merging
#' 
#' @examples 
#' \dontrun{
#' set_token("insert-your-token-here")
#' teams <- ss_get_result(sport = "hockey", league = "nhl", ep = "teams")
#' divs <- parse_stattle(teams, "divisions")
#' divs <- clean_sideload_divisions(divs)
#' }
#' @export
#' clean_sideload_divisions

clean_sideload_divisions <- function(x) {
  
  ## ensure a dataframe
  stopifnot(is.data.frame(x))
  
  ## keep the columns of interest
  x <- dplyr::select(x, id, name, conference_id)
  
  ## rename the variables
  x <- dplyr::rename(x, division_id = id)
  x <- dplyr::rename(x, division_name = name)
  
  ## return the datafarme
  return(x)
  
}
  
  
  
  
  
  
  