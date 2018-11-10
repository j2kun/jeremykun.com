---
author: jeremykun
date: 2014-08-31 22:51:37+00:00
draft: false
title: A Rook Game
type: post
url: /2014/08/31/a-rook-game/
categories:
- Game Theory
- Proof Gallery
tags:
- board games
- chessboard
- games
- symmetry
---

**Problem: **Two players take turns moving a rook on an 8x8 chessboard. The rook is only allowed to move south or west (but not both in a single turn), and may move any number of squares in the chosen direction on a turn. The loser is the player who first cannot move the rook. What is the optimal play for any starting position?

[![rook-board](http://jeremykun.files.wordpress.com/2014/08/rook-board.png)
](http://jeremykun.files.wordpress.com/2014/08/rook-board.png)

**Solution: **Take advantage of the symmetry of the board. If the rook is not on the diagonal, the optimal strategy is to move it to the diagonal. Then when the other player moves it off, your next move is to move it back to the diagonal. If your opponent starts their turn with the rook always on the diagonal, then you will never lose, and by the symmetry of the board you can always move the rook back to the diagonal. This provides an optimal algorithm for either player. In particular, if the rook starts on a square that is not on the diagonal, then player 1 can guarantee a win, and otherwise player 2 can.

Symmetry is one of the most powerful tools in all of mathematics, and this is a simple albeit illustrative example of its usage.
