library(stattleshipR)
context("Pagination")

set_token("18efec0cec8943fa9f5397516e4a6809")

sport <- "football"
league <- "nfl"
ep <- "teams"
query <- list()
test_that("number of rows returned matches total results in response header", {

  tmp <- stattleshipR:::.queryAPI(stattleshipR:::.StattleEnv$data$token, sport, league, ep, query, debug=TRUE, walk=TRUE)
  expect_equal(as.numeric(tmp$response$headers$total), nrow(tmp$api_json$teams))

  ## need a test like this but with fewer pages, just need a few pages returned, this takes too long to run
  ep <- "injuries"
  q_body <- list()
  tmp <- stattleshipR:::.queryAPI(stattleshipR:::.StattleEnv$data$token, sport=sport, league=league, ep=ep, query=q_body, version=1, debug=TRUE, walk=TRUE)
  json_result <- ss_get_result(sport=sport, league=league, ep=ep, query=q_body, version=1, verbose=TRUE, walk=TRUE)
  result <- rbindlist(lapply(json_result, function(x) x$injuries))
  expect_equal(as.numeric(tmp$response$headers$total), nrow(result))  

  ep <- "stats"
  q_body <- list(type='football_passing_stat', stat='passes_touchdowns', player_id = 'nfl-tom-brady')
  tmp <- stattleshipR:::.queryAPI(stattleshipR:::.StattleEnv$data$token, sport=sport, league=league, ep=ep, query=q_body, version=1, debug=TRUE, walk=TRUE)
  json_result <- ss_get_result(sport=sport, league=league, ep=ep, query=q_body, version=1, verbose=TRUE, walk=TRUE)
  result <- rbindlist(lapply(json_result, function(x) x$stats))
  expect_equal(as.numeric(tmp$response$headers$total), nrow(result))

  
})
