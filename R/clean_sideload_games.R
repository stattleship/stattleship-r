#' Clean up the sideloaded game data for easy merging with other sources of data.
#' 
#' Clean the game sideloaded data for merging and reporting purposes
#' 
#' 
#' @return a dataframe with the modified data cleaned up for merging
#' 
#' @export
#' clean_sideload_games

clean_sideload_games <- function(games, prefix="game") {
  
  ## ensure a dataframe
  stopifnot(is.data.frame(games))
  
  ## keep the columns of interest
  x <- dplyr::select(games, -created_at, -updated_at)
  
  ## rename the variables
  colnames(x) <- paste(prefix, colnames(x), sep="_")
  
  ## ensure unique
  x <- unique(x)
  
  ## return the datafarme
  return(x)
  
}
  
  
  
  
  
  
  