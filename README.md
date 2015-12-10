# stattleship-r

Stattleship R Wrapper brought to you by [@stattleship](https://twitter.com/stattleship).

## Install
`devtools::install_github("stattleship/stattleship-r")`

## Getting Started
Obtain an access TOKEN from [stattleship.com](www.stattleship.com). Load R and initialize your TOKEN for your session:

`TOKEN <- 'insert-your-token-here'`

Get all NBA triple doubles this season:

```
library(stattleshipR)
league = "nba"
sport = "basketball"
ep = "stats"
q_body=list(stat="triple_double")
tripdubs = stattle(TOKEN, sport=sport, league=league, ep=ep, query=q_body, version=1, walk=T)
```

## Next Steps
