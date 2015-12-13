#' Interface with the Stattleship API
#' 
#' A simple, generic function to query data from the Stattleship API
#' 
#' @param sport character. The sport, such as hockey, basketball, football. Default is hockey.
#' @param league character. NHL, NBA, NFL, etc. Default is nhl.
#' @param ep character. The endpoint.  Default is teams.
#' @param query list. A list that defines the query parameters. Default is empty list.
#' @param version numeric. The API version. Current version is 1 and is the default value.
#' @param walk logical. If TRUE, walks through and returns all results if there is more than one page of results.  Default is FALSE.
#' @param page numeric. The page number to request.  Default is NA.
#' @param verbose logical. For debugging, prints status messages to the console, which can be helpful for walking through results. Default is TRUE.
#' 
#' @return a list of lists.  If `walk=FALSE`, it will be a list of length 1.  If `walk=TRUE`, a list of lists may be returned depending on how many pages are returned.
#' 
#' @examples 
#' \dontrun{
#' set_token("insert-your-token-here")
#' results <- ss_get_result(sport="hockey", 
#'                          league="nhl",
#'                          ep = "teams",
#'                          query = list()
#'                          version = 1,
#'                          walk = FALSE,
#'                          page = NA,
#'                          verbose = TRUE)
#' }
#' @export
#' ss_get_result

ss_get_result <- function(token,
                          sport = "hockey", 
                          league = "nhl", 
                          ep = "teams", 
                          query = list(), 
                          version = 1, 
                          walk = FALSE,
                          page = NA,
                          verbose = TRUE) {
  
  ## if na, set page to 1 for consistency
  if (is.na(page)) page <- 1
  
  ## if page is supplied, add it to the list
  if (!is.na(page) & is.numeric(page) & page >= 1) {
    query <- c(query, page=page)
  }
  
  ## if verbose = TRUE, print status messages
  if (verbose) {
    print("Making initial API request")    
  }

  ## get the first request
  tmp <- .queryAPI(.StattleEnv$data$token, sport, league, ep, query, debug=TRUE)
  
  ## create the response list
  response <- list()
  
  ## set the original parsed response to the first element
  response[[1]] <- tmp$api_json
  
  ## if walk, parse here and send into respose[[i]]
  ## NOT FINISHED -- below is under dev
  if (walk) {
    ## check to see if paging is necessary
    total_results <- as.numeric(tmp$response$headers$total)
    rpp <- as.numeric(tmp$response$headers$`per-page`)
    pages <- ceiling(total_results / rpp)
    
    ## the first page was already retrievedd, only care 2+
    if (pages >= 2) {
      for (p in 2:pages) {
        
        ## if verbose, print the status message
        if (verbose) {
          print(paste0("Retrieving results from page ", p, " of ", pages))
        }
        
        ## get the data
        tmp_p <- .queryAPI(.StattleEnv$data$token, sport, league, ep, query=query, page=p, debug=TRUE)
        
        ## add as an element into the response container
        response[[p]] <- tmp_p$api_json
        
        ## sleep the response: 
        ## limited to 300calls/5 minutes, so stay safe at 1.1
        Sys.sleep(1.1)
      }
      
    }#endif(pages)
    
  }#endif(walk)
  stopifnot(length(response)==pages)
  
  ## return the list of data results
  ## list of lists
  return(response)
  
}


.queryAPI <- function(token, 
                    sport = "hockey", 
                    league = "nhl", 
                    ep = "teams", 
                    query = list(), 
                    version= 1, 
                    walk = FALSE,
                    page = NA,
                    debug = FALSE) {
  
  ## packages :  doesnt feel like this is the right way to do it
  library(httr)
  
  ## testing???
  stopifnot(is.character(token), 
            is.character(sport),
            is.character(ep),
            is.list(query),
            is.logical(walk),
            is.logical(page) | is.numeric(page),
            is.logical(debug),
            length(sport) == 1,
            length(league) == 1,
            length(ep) == 1)
  
  ## ensure that are lower case
  sport = tolower(sport)
  league = tolower(league)
  ep = tolower(ep)
  
  ## enforce some basics
  stopifnot(sport %in% c("hockey", "basketball", "football"),
            league %in% c("nhl", "nba", "nfl"))
  
  ## build the URL and the endpoint
  URL <- sprintf("https://www.stattleship.com/%s/%s/%s", sport, league, ep)
  
  ## the accept parameters.  Is there a better way to do this?
  ACCEPT <- sprintf("application/vnd.stattleship.com; version=%d", version)
  
  ## if page is supplied, add it to the list
  if (!is.na(page) & is.numeric(page) & page >= 1) {
    query <- c(query, page=page)
  }
  
  ## info for the User-Agent header
  platform <- sessionInfo()$platform
  package_v <- packageVersion("stattleshipR")
  UA <- sprintf("Stattleship R/%s (%s)", package_v, platform)
  
  ## get the request from the API
  resp <- GET(URL,
             add_headers(Authorization =.StattleEnv$data$token, 
                         Accept = ACCEPT, 
                         `Content-Type` = "application/json",
                         `User-Agent` = UA), 
             query = query)
  
  ## convert response to text first, do not use baseline httr::content default
  api_response <- content(resp, as="text")
  
  ## use jsonlite::fromJSON
  api_response <- jsonlite::fromJSON(api_response, flatten=TRUE)
  
  ## if verbose = T, return a list that includes the parsed results
  ## and the original request
  if (debug) {
    api_response <- list(response =  resp,
                        api_json = api_response)
  }
  
  ## return the data
  return(api_response)
}
