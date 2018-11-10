---
author: jeremykun
date: 2011-11-18 16:32:54+00:00
draft: false
title: Tiling a Chessboard with Dominoes (Opposite Colors Removed)
type: post
url: /2011/11/18/tiling-a-chessboard-2/
categories:
- Algorithms
- Combinatorics
- Proof Gallery
tags:
- chessboard
- dominoes
- proofs without words
- tiling
---

This is a natural follow-up to our first gallery entry on [the impossibility of tiling certain chessboards with dominoes](http://jeremykun.wordpress.com/2011/06/26/tiling-a-chessboard/).

**Problem:** Suppose we remove two squares from a chessboard which have opposite color. Is it possible to tile the remaining squares with 2-by-1 dominoes?

**Solution**:

[caption id="attachment_1243" align="aligncenter" width="351" caption="From Honsberger's Mathematical Gems I."][![](http://jeremykun.files.wordpress.com/2011/11/tiling-gomory.png)
](http://jeremykun.files.wordpress.com/2011/11/tiling-gomory.png)[/caption]

Notice that if we remove two squares of opposite color, then there is only one way to place dominoes on the remaining squares according to this scheme (one cannot tile a domino across the "walls"). Removing two squares of opposite color ensures there is an even number of squares between the removed squares, and so the dominoes will fit as desired. In other words, the two "paths" from A to B, starting on any side of A, contain an even number of squares, and so placing a domino every two squares will fill the path with a good tiling.

Not only does this method provide a positive answer to the solution, it gives a _constructive _answer. If we had some odd desire to do so, we could write an algorithm which tiles any chessboard where two squares are removed, (moreover, it would run in linear time). It's not obvious at first whether such an algorithm exists, as the average human attempt to tile a board with two random squares removed would likely require some backtracking. In other words, human solutions would generally be _heuristic_ in nature, but this analysis gives a solution that any person could utilize.
