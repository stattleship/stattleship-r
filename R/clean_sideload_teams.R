#' Clean up the sideloaded team data for easy merging with other sources of data.
#' 
#' Clean the teams sideloaded data for merging and reporting purposes
#' 
#' 
#' @return a dataframe with the modified data cleaned up for merging
#' 
#' @examples 
#' \dontrun{
#' set_token("insert-your-token-here")
#' result <- ss_get_result(sport = "hockey", league = "nhl", ep = "teams")
#' teams <- parse_stattle(result, "teams")
#' teams <- clean_sideload_teams(teams)
#' }
#' @export
#' clean_sideload_teams

clean_sideload_teams <- function(x, prefix="team") {
  
  ## ensure a dataframe
  stopifnot(is.data.frame(x))
  
  ## keep the columns of interest
  #y <- dplyr::select(x, -created_at, -updated_at, -division_id, -league_id)
  y <- dplyr::select(x, -created_at, -updated_at)
  
  ## rename all of the variables
  colnames(y) <- paste(prefix, colnames(y), sep="_")
  
  ## put back on the division and league ids
  #y$division_id <-  x$division_id
  #y$league_id  <-  x$league_id
  
  ## ensure unique
  y = unique(y)
  
  ## return the datafarme
  return(y)
  
}


  
  
  
  
  
  
  