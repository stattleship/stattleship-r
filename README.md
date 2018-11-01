# stattleship-r

Stattleship R Wrapper brought to you by [@stattleship](https://twitter.com/stattleship).

Check out the [Stattleship API](https://www.stattleship.com) - The Sports Data API you've always wanted.

Affordable. Meaningful. Developer-Friendly.

:football:, :basketball:, :black_circle: and :baseball: available now. College :football: and Major League :soccer: to come.

We're gonna need a bigger :boat:!

## Install
`devtools::install_github("stattleship/stattleship-r")`

## Getting Started

* Obtain an access TOKEN from [stattleship.com](https://www.stattleship.com/).
* Load R and initialize your TOKEN for your session and load the library:
* Consult [Stattleship Developer API Documentation](http://developers.stattleship.com)
* Familiarize yourself with the API calls and parameters
* Understn the use of slugs like `nba-2018-2019` or `nba-2018-2019-bos-det-2018-10-27-1900`
* Code! Query! Enjoy!

## Some Brief Examples

These are NBA related, but can apply to NHL, NFL and MLB. The API is the same!

```
library(stattleshipR)
set_token('insert-your-token-here')
```

Get all [NBA players](http://developers.stattleship.com/#basketball-players):

```
league <- "nba"
sport <- "basketball"
ep <- "players"
q_body <- list()
players <- ss_get_result(sport = sport, league = league, ep = ep,
                         query = q_body, version = 1, walk = TRUE)
players_df <- do.call("rbind", lapply(players, function(x) x$players))
```

Get [NBA Schedule](http://developers.stattleship.com/#basketball-games) for a regular season:

```
q_body <- list(season_id="nba-2018-2019", interval_type="regularseason")
tmp <- ss_get_result(sport="basketball",
                     league="nba",
                     ep="games",
                     query=q_body,
                     verbose=TRUE,
                     walk = TRUE)
```


Get [NBA Play by Play](http://developers.stattleship.com/#basketball-play-by-play) for a single game:

**Important:** This endpoint works slightly differently and the `game_id` must be appended to the `ep`.

```
q_body <- list()
tmp <- ss_get_result(sport="basketball",
                     league="nba",
                     ep="play_by_play/nba-2018-2019-bos-det-2018-10-27-1900",
                     query=q_body,
                     verbose=TRUE,
                     walk = TRUE)
[1] "Making initial API request"
[1] "Retrieving results from page 2 of 12"
[1] "Retrieving results from page 3 of 12"
[1] "Retrieving results from page 4 of 12"
[1] "Retrieving results from page 5 of 12"
[1] "Retrieving results from page 6 of 12"
[1] "Retrieving results from page 7 of 12"
[1] "Retrieving results from page 8 of 12"
[1] "Retrieving results from page 9 of 12"
[1] "Retrieving results from page 10 of 12"
[1] "Retrieving results from page 11 of 12"
[1] "Retrieving results from page 12 of 12"
```


## Next Steps
Want more? Check out our available stats across an expanding number of sports at the [Stattleship Developer API Documentation](http://developers.stattleship.com//) or [Stattleship blog](http://blog.stattleship.com/tag/api/).

## Style Guide
We plan to follow [Hadley Wickham's R Style Guide](http://adv-r.had.co.nz/Style.html). Please follow these guidelines if you'd like to contribute!
