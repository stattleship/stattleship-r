#' Utility function to list the side-loaded data that accompanies a successful call with ss_get_result
#' 
#' A helper to list the dataframes available to you as a result of a call with ss_gest_result
#' 
#' @param stattle_list list A list of data the results from a valid call using ss_get_result
#' 
#' @return vector  The elements that can be called during parse_stattle.
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
#' show_datasets(results_df)
#' 
#' }
#' @export
#' show_datasets

show_datasets <- function(stattle_list) {
  ## ensure that the stattle_list is indeed a list
  stopifnot(class(stattle_list) == "list")
  ## ensure that the stattle_list is at least length 1
  stopifnot(length(stattle_list) >= 1)
  ## ensure that the entry exists as a key in the list
  x <- names(stattle_list[[1]])
  return(x)
}