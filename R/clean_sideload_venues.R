#' Clean up the sideloaded venue data for easy merging with other sources of data.
#' 
#' Clean the venue sideloaded data for merging and reporting purposes
#' 
#' 
#' @return a dataframe with the modified data cleaned up for merging
#' 
#' @export
#' clean_sideload_venues

clean_sideload_venues <- function(venues, prefix="game_venue") {
  
  ## ensure a dataframe
  stopifnot(is.data.frame(venues))
  
  ## keep the columns of interest
  x <- dplyr::select(venues, -created_at, -updated_at)
  
  ## rename the variables
  colnames(x) <- paste(prefix, colnames(x), sep="_")
  
  ## ensure unique
  x <- unique(x)
  
  ## return the datafarme
  return(x)
  
}
  
  
  
  
  
  
  