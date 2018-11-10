---
author: jeremykun
date: 2011-06-27 03:24:09+00:00
draft: false
title: Tiling a Chessboard
type: post
url: /2011/06/26/tiling-a-chessboard/
categories:
- Proof Gallery
tags:
- chessboard
- dominoes
- mathematics
- tiling
---

**Problem**: Take a chessboard and cut off two opposite corners. Is it possible to completely tile the remaining board with 2-by-1 dominoes?

[caption id="attachment_430" align="aligncenter" width="250" caption="Is it possible to tile this board with 2-by-1 dominoes?"][![](http://jeremykun.files.wordpress.com/2011/06/chessboard-cut-off.jpg)
](http://jeremykun.files.wordpress.com/2011/06/chessboard-cut-off.jpg)[/caption]

**Solution**: Notice that every domino covers exactly one white tile and one black tile. Counting up the colors, we have 32 white and 30 black. Hence, any tiling by 2-by-1 dominoes will leave two extra white squares unaccounted for. So no such tiling is possible.

**Problem**: Cut one corner off a chessboard. Is it possible to tile the remaining board with 3-by-1 dominoes?

**Solution**: Analyzing this problem with the normal chessboard admits no nice proof like before. Specifically, any tile covers either two white and one black tile, or two black tiles and one white tile, so a counting argument is much more difficult.

In a moment of divine inspiration, we realize that the standard coloring of the chessboard is arbitrary. We decide to repaint our board as follows:

[caption id="attachment_429" align="aligncenter" width="250" caption="Our new coloring makes the proof trivial."][![](http://jeremykun.files.wordpress.com/2011/06/chessboard-1-by-3.jpg)
](http://jeremykun.files.wordpress.com/2011/06/chessboard-1-by-3.jpg)[/caption]

Clearly, any 3-by-1 domino covers exactly one black square. Counting up the colors once more, we see that there are 22 black squares. Since there are 63 squares in all, we must have 21 3-by-1 dominoes, each covering one black square. This leaves one black square unaccounted for, and so no such tiling is possible.

Notice that if we omit the word "chessboard" and just give a colorless grid, this "divine inspiration" would certainly be much more miraculous.

Furthermore, this gives a nice method of proof for any $n$-by-1 dominoes on an $m \times m$ board, where $n < m$, and we cut off a certain number of squares. Just look for a useful coloring, such that each domino covers a helpful number of squares of a certain color.
