# stattleship-r

Stattleship R Wrapper brought to you by [@stattleship](https://twitter.com/stattleship).

Check out the [Stattleship API](https://www.stattleship.com) - The Sports Data API you've always wanted.

Affordable. Meaningful. Developer-Friendly.

:football:, :basketball:, :black_circle: and :baseball: available now. College :football: and Major League :soccer: to come. 

We're gonna need a bigger :boat:!

## Install
`devtools::install_github("stattleship/stattleship-r")`

## Getting Started
Obtain an access TOKEN from [stattleship.com](https://www.stattleship.com/). Load R and initialize your TOKEN for your session and load the library:

```
library(stattleshipR)
set_token('insert-your-token-here')
```

Get all NBA players:

```
league <- "nba"
sport <- "basketball"
ep <- "players"
q_body <- list()
players <- ss_get_result(sport = sport, league = league, ep = ep,
                         query = q_body, version = 1, walk = TRUE)
players_df <- do.call("rbind", lapply(players, function(x) x$players))
```

Get all triple doubles this NBA season:

```
league <- "nba"
sport <- "basketball"
ep <- "stats"
q_body <- list(stat = "triple_double", type = "basketball_doubles_stat")
tripdubs <- ss_get_result(sport = sport, league = league, ep = ep,
                          query = q_body, version = 1, walk = FALSE)
```

## Next Steps
Want more? Check out our available stats across an expanding number of sports at the [Stattleship Playbook](http://playbook.stattleship.com/) or [Stattleship blog](http://blog.stattleship.com/tag/api/).

## Style Guide
We plan to follow [Hadley Wickham's R Style Guide](http://adv-r.had.co.nz/Style.html). Please follow these guidelines if you'd like to contribute!
