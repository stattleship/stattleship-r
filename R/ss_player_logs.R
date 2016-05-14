#' Helper to get player's game logs for a specified team in a sport and league
#' 
#' A function to interface and make it easier to get player game logs for a team in a sport/league and 
#' optionally, a game id.
#' 
#' @param sport character. The sport of interest
#' @param league character. The league to retrieve.  Currently MLB, NBA, NHL, and NFL are supported. 
#' NHL is default.
#' @param team_id character.  The team id, can be in the form of the slug "nhl-bos".  
#' Default is all teams (empty character).
#' @param interval_type character.  The season interval.  Default is regularseason.
#' @param season_id character.  The season.  Default is nhl-2015-2016.
#' @param status character.  The status of the game.  Ended is default.
#' @param game_id character.  A specific game of interest.
#' @param player_id character.  A specific player of interest.
#' @param walk logical  Whether or not you want to get additional pages.  Default is TRUE.
#' @param verbose logical.  TRUE will print messages to the console.  Default is TRUE.
#' 
#' @return a dataframe of the player game logs
#' 
#' @examples 
#' \dontrun{
#' set_token("insert-your-token-here")
#' bos_logs <- ss_player_logs(league="nhl", team_id="nhl-bos") 
#' }
#' @export
#' ss_player_logs

ss_player_logs <- function(sport = "hockey",
                           league = "nhl", 
                           team_id="nhl-bos", 
                           interval_type='regularseason', 
                           season_id='nhl-2015-2016',
                           status='ended',
                           game_id = "",
                           player_id = "",
                           verbose = TRUE,
                           walk = TRUE) {
  
  
  
  ## quick validation
  league <- tolower(league)
  sport <- tolower(sport)
  stopifnot(is.character(league),
            league %in% c("nhl", "mlb", "nba", "nfl"),
            sport %in% c("baseball", "basketball", "football", "hockey"),
            is.logical(verbose),
            is.character(team_id),
            length(team_id)==1,
            length(status)==1,
            length(game_id)==1,
            length(player_id)==1)
  
  ## put the team into a list if there was one specified
  q_body <- list()
  if (nchar(team_id) > 0) {
    q_body <- list(team_id = team_id,
                   season_id = season_id,
                   interval_type = interval_type,
                   status = status)
  }
  
  ## if player and/or game ids are specified, add them to the query body
  if (nchar(player_id) > 0 ) {
    q_body = c(q_body, player_id=player_id)
  }
  if (nchar(game_id) > 0 ) {
    q_body = c(q_body, game_id=game_id)
  }
  
  ## retrieve the players for a team in a league
  tmp_call <- ss_get_result(sport = sport, 
                            league = league,
                            ep = "game_logs",
                            query = q_body,
                            walk = walk, 
                            verbose = verbose)
  
  ## pull out the data
  gls <- parse_stattle(tmp_call, "game_logs")
  teams <- parse_stattle(tmp_call, "teams")
  games <- parse_stattle(tmp_call, "games")
  venues <- parse_stattle(tmp_call, "venues")
  opps <- parse_stattle(tmp_call, "opponents")
  players <- parse_stattle(tmp_call, "players")
  
  ## cleanup the data
  teams <- clean_sideload_teams(teams, prefix="team")
  opps <- clean_sideload_teams(opps, prefix="opponent")
  games <- clean_sideload_games(games, prefix="game")
  venues <- clean_sideload_venues(venues, prefix="game_venue")
  players <- clean_sideload_players(players)
  
  ## merge together for a big dataset
  gls <- dplyr::left_join(gls, players)
  gls <- dplyr::left_join(gls, teams)  ## append the gamelog's team info
  gls <- dplyr::left_join(gls, opps)  ## opponent info
  gls <- dplyr::left_join(gls, games)
  gls <- dplyr::left_join(gls, venues)
  
  ## ensure unique
  gls <- unique(gls)
  
  ## return the datafarme
  return(gls)
  
}
  
  
  
  
  
  
  