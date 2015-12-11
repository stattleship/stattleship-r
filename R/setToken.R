#' Set the Stattleship API token
#'
#' A simple function to set the Stattleship API token in an R environment variable
#'
#' @param token character. A valid Stattleship API token
#' @examples
#' \dontrun{
#' setToken("insert-your-token-here")}
#' @export
#' setToken

setToken <- function(token){
    if(!is.null(token)){
        .StattleEnv$data$token <- token
    }
    else{
        warning("Stattleship API token must be provided in order to access the Stattleship API.")
    }
}
