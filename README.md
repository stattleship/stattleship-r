# stattleship-r

Stattleship R Wrapper brought to you by [@stattleship](https://twitter.com/stattleship).

Check out the [Stattleship API](https://www.stattleship.com) - The Sports Data API you've always wanted

Affordable. Meaningful. Developer-Friendly.

:football: :basketball: and :black_circle: with :baseball: coming soon. 

We're gonna need a bigger :boat:!

## Install
`devtools::install_github("stattleship/stattleship-r")`

## Getting Started
Obtain an access TOKEN from [stattleship.com](www.stattleship.com). Load R and initialize your TOKEN for your session and load the library:

```
library(stattleshipR)
setToken('insert-your-token-here')
```

Get all NBA players:

```
league = "nba"
sport = "basketball"
ep = "players"
q_body = list()
players = ssGetResult(sport=sport, league=league, ep=ep, query=q_body, version=1, walk=TRUE)
players_df = do.call("rbind", lapply(players, function(x) x$players))
```

Get all triple doubles this NBA season:

```
league = "nba"
sport = "basketball"
ep = "stats"
q_body=list(stat="triple_double", type="basketball_doubles_stat")
tripdubs = ssGetResult(sport=sport, league=league, ep=ep, query=q_body, version=1, walk=FALSE)
```

## Next Steps
Want more? Check out our available stats across an expanding number of sports at the [Stattleship Playbook](http://playbook.stattleship.com/).
