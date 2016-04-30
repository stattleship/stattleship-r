#' Clean up the sideloaded position data for easy merging with other sources of data.
#' 
#' Clean the position data sideloaded data for merging and reporting purposes
#' 
#' 
#' @return a dataframe with the modified data cleaned up for merging
#' 
#' @export
#' clean_sideload_positions

clean_sideload_positions <- function(x, prefix="position") {
  
  ## ensure a dataframe
  stopifnot(is.data.frame(x))
  
  ## keep the columns of interest
  y <- dplyr::select(x, -created_at, -updated_at, -league_id)
  
  ## rename all of the variables
  colnames(y) <- paste(prefix, colnames(y), sep="_")
  
  ## return the datafarme
  return(y)
  
}


  
  
  
  
  
  
  