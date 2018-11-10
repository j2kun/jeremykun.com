---
author: jeremykun
date: 2011-06-23 23:04:47+00:00
draft: false
title: Number of Games in a Tournament
type: post
url: /2011/06/23/number-of-games-in-a-tournament/
categories:
- Proof Gallery
- Set Theory
tags:
- mathematics
---

**Problem**: 1000 players compete in a tournament. In each round, players are matched with opponents, and the winner proceeds to the next round. If there are an odd number of players in a round, one player chosen at random sits out of that round. What is the total number of games are played in the tournament?

**Solution**: 999. Each player loses exactly one game, except for the winner of the tournament. Hence, in a tournament of $n$ players, there will be $n-1$ games played. More formally, we have a bijection between the losers of the tournament and the games played, where each loser is paired with the game he lost. Since there are $n-1$ losers and one winner, there are $n-1$ games played.

This is a wonderful argument, particularly because it is entirely based on logic. Another attempt might be combinatorical or number-theoretical, counting the number of games in each round. While this would work nice for tournaments where there are $2^n$ players, here it flounders. This method works much more generally, and stands as a testament to the power of logic.
