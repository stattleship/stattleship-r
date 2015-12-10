# stattleship-r

Stattleship R Wrapper brought to you by [@stattleship](https://twitter.com/stattleship).

## Install
`devtools::install_github("stattleship/stattleship-r")`

## Getting Started
Obtain an access TOKEN from [stattleship.com](www.stattleship.com). Load R and initialize your TOKEN for your session:

`TOKEN <- 'insert-your-token-here'`

Get all NBA players:

```
library(stattleshipR)
league = "nba"
sport = "basketball"
ep = "players"
q_body = list()
players = stattle(TOKEN, sport=sport, league=league, ep=ep, query=q_body, version=1, verbose=T, walk=TRUE)
```

## Next Steps
Want more? Check out our available stats across an expanding number of sports at the [Stattleship Playbook](http://playbook.stattleship.com/).
