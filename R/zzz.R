.StattleEnv <- new.env()
.StattleEnv$data <- list()

.onLoad <- function(libname, pkgname){
    if(is.null(.StattleEnv$data) == FALSE){
    	.StattleEnv$data <- list(
        	token <- NULL
          )
    }
}
