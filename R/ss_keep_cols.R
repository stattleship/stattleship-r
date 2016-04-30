#' Helper to only keep specified columns
#' 
#' A helper function that takes a data frame and returns the same dataframe, but 
#' just with the specified columns.  This is helpfult to keep just the columns of interest 
#' and remove those applicable to other sports.
#' 
#' @param dat data.frame The original data frame
#' @param cols vector  A character vector of columns to keep.
#' 
#' @return a dataframe with only the valid specified columns retained.  
#' 
#' @examples 
#' \dontrun{
#' set_token("insert-your-token-here")
#' teams = hockey_teams()
#' mycols = c("team_id", "team_hashtag", "team_name")
#' teams2 = ss_keep_cols(teams, mycols)
#' }
#' @export
#' ss_keep_cols

ss_keep_cols <- function(dat, cols=c()) {
  
  ## quick validation
  stopifnot(is.data.frame(dat))
  stopifnot(length(cols)>0)
  stopifnot(is.vector(cols))
  
  ## keep just the columns that match from the user
  MATCHES <- which(cols %in% colnames(dat))
  match_cols <- cols[MATCHES]
  
  ## drop all but matched columns
  dat <- dat[, match_cols]
  
  ## return the datafarme
  return(dat)
  
}
  
  
  
  
  
  
  