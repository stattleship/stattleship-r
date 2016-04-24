#' Utility function to quickly rbind all dataframes of an entry within the list returned by ss_get_result
#' 
#' A helper to quickly bind dataframes
#' 
#' @param stattle_list list A list of data, usually the object that is returned from ?ss_get_result
#' @param entry character. The entry from the API request which houses dataframes of data
#' 
#' @return dataframe.  
#' 
#' @examples 
#' \dontrun{
#' set_token("insert-your-token-here")
#' results <- ss_get_result(sport="hockey", 
#'                          league="nhl",
#'                          ep = "feats",
#'                          query = list(game_id="nhl-2015-2016-nyr-bos-2015-11-27-1800"),
#'                          version = 1,
#'                          walk = FALSE,
#'                          page = NA,
#'                          verbose = TRUE)
#' results_df <- parse_stattle(results, "feats")
#' }
#' @export
#' parse_stattle

parse_stattle <- function(stattle_list, entry) {
  ## check that is a length > 0
  if (length(stattle_list) < 1) {
    message("There is a good chance that no results were returned from your query.  Check valid criteria for ss_get_result call")
  }
  ## ensure that the stattle_list is indeed a list
  stopifnot(class(stattle_list) == "list")
  ## ensure that the entry exists as a key in the list
  stopifnot(entry %in% names(stattle_list[[1]]))
  ## parse the data
  x <- do.call("rbind", lapply(stattle_list, function(x) x[[entry]]))
  stopifnot(is.data.frame(x))
  return(x)
}