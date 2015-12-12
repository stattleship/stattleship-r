#' Interface with the Stattleship API
#' 
#' A simple, generic function to query data from the Stattleship API
#' 
#' @param sport character. The sport, such as hockey, basketball, football
#' @param league character. NHL, NBA, NFL, etc.
#' @param ep character. The endpoint
#' @param query A list that defines the query parameters
#' @param version The API version. Current version is 1.
#' @param walk logical. if TRUE, walks through and returns all results if there is more than one page of results
#' @param page numeric. The page number to request
#' @param verbose logical. For debugging, returns response and parsed response.
#' 
#' @examples 
#' \dontrun{
#' setToken("insert-your-token-here")
#' results <- stattle(sport="hockey", 
#'                    league="nhl",
#'                    ep = "stats",
#'                    query = list()
#'                    version = 1,
#'                    walk = TRUE,
#'                    page = NA,
#'                    verbose = FALSE)
#' }
#' @export
#' stattle

stattle <- function(token, 
                   sport = "hockey", 
                   league = "nhl", 
                   ep = "stats", 
                   query = list(), 
                   version = 1, 
                   walk = F,
                   page = NA,
                   verbose = F) {
  
  ## if na, set page to 1 for consistency
  if (is.na(page)) page <- 1
  
  ## if page is supplied, add it to the list
  if (!is.na(page) & is.numeric(page) & page >= 1) {
    query <- c(query, page=page)
  }
  
  print("Making initial API request")
  ## get the first request
  tmp <- .queryAPI(.StattleEnv$data$token, sport, league, ep, query, debug=T)
  
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
        print(paste0("Retrieving results from page ", p, " of ", pages))
        tmp_p <- .queryAPI(.StattleEnv$data$token, sport, league, ep, query=query, page=p, debug=F)
        
        ## add as an element into the response container
        response[[p]] <- tmp_p$api_json
      }
      
    }#endif(pages)
    
  }#endif(walk)
  
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
                    walk = F,
                    page = NA,
                    debug = F) {
  
  ## packages :  doesnt feel like this is the right way to do it
  library(httr)
  
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
  api_response <- jsonlite::fromJSON(api_response, flatten=T)
  
  ## if verbose = T, return a list that includes the parsed results
  ## and the original request
  if (debug) {
    api_response <- list(response =  resp,
                        api_json = api_response)
  }
  
  ## return the data
  return(api_response)
}
