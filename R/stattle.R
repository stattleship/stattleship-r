#' Interface with the Stattleship API
#' 
#' A simple, generic function to query data from the Stattleship API
#' 
#' @param token character. A valid token for the API
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
#' TOKEN <- "insert-your-token-here"
#' results <- stattle(TOKEN, 
#'                    sport="hockey", 
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

stattle = function(token, 
                   sport="hockey", 
                   league = "nhl", 
                   ep="stats", 
                   query=list(), 
                   version=1, 
                   walk=F,
                   page=NA,
                   verbose=F) {
  ## if na, set page to 1 for consistency
  if (is.na(page)) page = 1
  
  ## if page is supplied, add it to the list
  if (!is.na(page) & is.numeric(page) & page >= 1) {
    query = c(query, page=page)
  }
  
  print("Making initial API request")
  ## get the first request
  tmp = .queryAPI(TOKEN, sport, league, ep, query, verbose=T)
  
  ## simple alert
  if (tmp$response$status_code != 200) {
    message("API response was something other than 200")
  }
  
  ## create the response list
  response = list()
  
  ## set the original parsed response to the first element
  response[[1]] = tmp$api_json
  
  ## if walk, parse here and send into respose[[i]]
  ## NOT FINISHED -- below is under dev
  if (walk) {
    ## check to see if paging is necessary
    total_results = as.numeric(tmp$response$headers$total)
    rpp = as.numeric(tmp$response$headers$`per-page`)
    pages = ceiling(total_results / rpp)
    
    ## the first page was already retrievedd, only care 2+
    if (pages >= 2) {
      for (p in 2:pages) {
        print(paste0("Retrieving results from page ", p, " of ", pages))
        tmp_p = .queryAPI(TOKEN, sport, league, ep, query=query, page=p, verbose=T)
        
        ## check to make sure 200
        if (tmp$response$status_code != 200) {
          message("the pages>2 loop requested a page that was not 200")
        }
        
        ## add as an element into the response container
        response[[p]] = tmp_p$api_json
      }
      
    }#endif(pages)
    
  }#endif(walk)
  
  ## return the list of data results
  ## list of lists
  return(response)
  
}


.queryAPI <- function(token, 
                    sport="hockey", 
                    league = "nhl", 
                    ep="stats", 
                    query=list(), 
                    version=1, 
                    walk=F,
                    page=NA,
                    verbose=F) {
  
  ## build the URL and the endpoint
  URL = sprintf("https://www.stattleship.com/%s/%s/%s", sport, league, ep)
  
  ## the accept parameters.  Is there a better way to do this?
  ACCEPT = sprintf("application/vnd.stattleship.com; version=%d", version)
  
  ## if page is supplied, add it to the list
  if (!is.na(page) & is.numeric(page) & page >= 1) {
    query = c(query, page=page)
  }
  
  ## test the body to see if it is a list and has values
  ## if not, just return an empty list
  ## todo: test to ensure that query is a list if !is.na
  ## get the request from the API
  resp = GET(URL,
             add_headers(Authorization =TOKEN, 
                         Accept = ACCEPT, 
                         `Content-Type`="application/json"), 
             query=query)
  
  ## walk the content if true
  
  ## convert response to text first, do not use baseline httr::content default
  api_response = content(resp, as="text")
  
  ## use jsonlite::fromJSON
  api_response = jsonlite::fromJSON(api_response)
  
  
  ## if verbose = T, return a list that includes the parsed results
  ## and the original request
  if (verbose) {
    api_response = list(response =  resp,
                        api_json = api_response)
  }
  
  ## return the data
  return(api_response)
}

