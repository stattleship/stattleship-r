setToken <- function(token){
    if(!is.null(token)){
        .StattleEnv$data$token <- token
    }
    else{
        warning("Stattleship API token must be provided in order to access the Stattleship API.")
    }
}
