#' Clean up the sideloaded player data for easy merging with other sources of data.
#' 
#' Clean the teams sideloaded data for merging and reporting purposes
#' 
#' 
#' @return a dataframe with the modified data cleaned up for merging
#' 
#' @examples 
#' \dontrun{
#' set_token("insert-your-token-here")
#' result <- ss_get_result(sport = "hockey", league = "nhl", ep = "injuries")
#' players <- parse_stattle(result, "players")
#' players <- clean_sideload_players(players)
#' }
#' @export
#' clean_sideload_players

clean_sideload_players <- function(x, prefix="player") {
  
  ## ensure a dataframe
  stopifnot(is.data.frame(x))
  
  ## keep the columns of interest
  y <- dplyr::select(x, -created_at, -updated_at, -league_id)
  
  ## rename all of the variables
  colnames(y) <- paste(prefix, colnames(y), sep="_")
  
  ## return the datafarme
  return(y)
  
}


  
  
  
  
  
  
  