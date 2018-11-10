---
author: jeremykun
date: 2012-03-22 23:34:56+00:00
draft: false
title: Classic Nintendo Games are NP-Hard
type: post
url: /2012/03/22/nintendo-np-hard/
categories:
- Algorithms
- Proof Gallery
tags:
- computational complexity
- donkey kong
- games
- mario
- mathematics
- metroid
- np-completeness
- pokemon
- video games
- zelda
---

[caption id="attachment_1817" align="aligncenter" width="584" caption="The heroes and heroines of classic Nintendo games."][![](http://jeremykun.files.wordpress.com/2012/03/supersmashbroswallpaper800.jpg)
](http://jeremykun.files.wordpress.com/2012/03/supersmashbroswallpaper800.jpg)[/caption]

**Problem**: Prove that generalized versions of Mario Brothers, Metroid, Donkey Kong, Pokemon, and Legend of Zelda are NP-hard.

**Solution**: [http://arxiv.org/pdf/1203.1895v1.pdf](http://arxiv.org/pdf/1203.1895v1.pdf)

**Discussion**: Three researchers (including [Erik Demaine](http://erikdemaine.org/), a computer science professor at MIT famous for his work with the mathematics of [origami](http://erikdemaine.org/curved/)) recently finished a paper giving the complexity of a number of classic Nintendo games (the ones I loved to play). All are proven NP-hard, some are shown to be NP-complete, and some are PSPACE-complete. Recall, a problem is NP-hard if an NP-complete problem reduces to it, and a problem is NP-complete if it's NP-hard and also in NP. As we have just posted a primer on NP-completeness and reduction proofs, this paper is a fun next step for anyone looking for a more detailed reduction proof. [A pre-print is available for free on arXiv](http://arxiv.org/pdf/1203.1895v1.pdf), and it's relatively short and easy to read. I'll summarize his result here, and leave most of the details to the reader. Each game is "generalized" to the task of determining whether one can get from a "start" location to a "finish" location. So the decision problem becomes: given a finite level of a game, can the player move from the starting location to the finishing location? All of the reduction proofs are from 3-Sat, and they all rely on a common framework which can be applied to any platform game. Pictorially, the framework looks like this:

[caption id="attachment_1818" align="aligncenter" width="584" caption="The framework for reducing 3-Sat to platform games."][![](http://jeremykun.files.wordpress.com/2012/03/platform-np-hard-framework.jpg)
](http://jeremykun.files.wordpress.com/2012/03/platform-np-hard-framework.jpg)[/caption]


The player starts in the "start" gadget, which allows one to set up initial state requirements. For instance, in Super Mario Brothers, the start provides you with a mushroom, and you cannot get to the finish without being able to break blocks by jumping under them, which requires the mushroom power-up. Each "variable" gadget requires the player to make a variable assignment in such a way that the player can never return to that gadget to make a different decision. Then each "clause" gadget can be "unlocked" in some way, and each clause gadget can only be visited by the player once the player has chosen a satisfying variable assignment for that clause. Once the player has visited all variable gadgets, he goes to the "check in" area, and can travel back through all of the clauses to the finish if and only if he unlocked every clause. The crossover of the paths in the picture above requires another gadget to ensure that the player cannot switch paths (the details of this are in the paper).




For example, here is the variable gadget described in the paper for The Legend of Zelda, a Link to the Past:




[caption id="attachment_1820" align="aligncenter" width="216" caption="The variable gadget for A Link to the Past."][![](http://jeremykun.files.wordpress.com/2012/03/lttp-variable-gadget.jpg)
](http://jeremykun.files.wordpress.com/2012/03/lttp-variable-gadget.jpg)[/caption]


Note that here we require Link has the [hookshot](http://www.youtube.com/watch?v=ZznLKBYcvc0#t=09m50s), which can grapple onto chests, but has limited reach. The configuration of the chests requires him to choose a path down one of the two columns at the bottom, and from there he may never return.




Here's another example. In the classic Super Mario Brothers game, a possible clause gadget is as follows.




[caption id="attachment_1819" align="aligncenter" width="372" caption="The clause gadget for the original Super Mario Brothers."][![](http://jeremykun.files.wordpress.com/2012/03/mario-clause-gadget.jpg)
](http://jeremykun.files.wordpress.com/2012/03/mario-clause-gadget.jpg)[/caption]

Note that if the player can only enter through one of the three columns at the top, then the only thing he can do is kick a red koopa shell down so that it breaks the blocks, unlocking the way for Mario to pass underneath at the end. Note that Mario cannot win if he falls from the top ledge (since must always remain large, he can't fit through a one-tile-high entryway). Further details include the hole at the bottom, in which any stray koopa shell will necessarily fall, but which Mario can easily jump over. We recommend reading the entire paper, because it goes into all of the necessary details of the construction of the gadgets for all of the games.


## Future Work


We note that there are some parts of the paper that only got partial results, mostly due to the variation in the game play between the different titles. For instance, the original Super Mario Brothers is known to be NP-complete, but the added ability to _pick up_ koopa shells in later Super Mario Brothers games potentially makes the decision problem more complex, and so it is unknown whether, say, Super Mario World is in NP. We will summarize exactly what is known in the table below. If readers have additions for newer games (for instance, it's plausible that Super Mario Galaxy could be adapted to fit the same construction as the original Super Mario Bros.), please leave a comment with justification and we can update the table appropriately. I admit my own unfamiliarity with some of the more recent games.

**Super Mario Brothers:**



<table >
<tbody >
<tr >
Game Title
NP-hard
in NP
PSPACE-complete
</tr>
<tr >

<td >Super Mario Bros.
</td>

<td >✓
</td>

<td >✓
</td>

<td >
</td>
</tr>
<tr >

<td >Lost Levels
</td>

<td >✓
</td>

<td >✓
</td>

<td >
</td>
</tr>
<tr >

<td >Super Mario Bros. 2
</td>

<td >
</td>

<td >
</td>

<td >
</td>
</tr>
<tr >

<td >Super Mario Bros. 3
</td>

<td >✓
</td>

<td >
</td>

<td >
</td>
</tr>
<tr >

<td >Super Mario Land
</td>

<td >
</td>

<td >
</td>

<td >
</td>
</tr>
<tr >

<td >Super Mario World
</td>

<td >✓
</td>

<td >
</td>

<td >
</td>
</tr>
<tr >

<td >Land 2: 6 Golden Coins
</td>

<td >
</td>

<td >
</td>

<td >
</td>
</tr>
<tr >

<td >Super Mario Land 3
</td>

<td >
</td>

<td >
</td>

<td >
</td>
</tr>
<tr >

<td >Yoshi's Island
</td>

<td >
</td>

<td >
</td>

<td >
</td>
</tr>
<tr >

<td >Super Mario 64
</td>

<td >
</td>

<td >
</td>

<td >
</td>
</tr>
<tr >

<td >Sunshine
</td>

<td >
</td>

<td >
</td>

<td >
</td>
</tr>
<tr >

<td >New Super Mario Bros.
</td>

<td >
</td>

<td >
</td>

<td >
</td>
</tr>
<tr >

<td >Galaxy
</td>

<td >
</td>

<td >
</td>

<td >
</td>
</tr>
<tr >

<td >New Super Mario Bros. Wii
</td>

<td >
</td>

<td >
</td>

<td >
</td>
</tr>
<tr >

<td >Galaxy 2
</td>

<td >
</td>

<td >
</td>

<td >
</td>
</tr>
<tr >

<td >Super Mario 3D Land
</td>

<td >
</td>

<td >
</td>

<td >
</td>
</tr>
</tbody>
</table>







**Legend of Zelda:**







<table >
<tbody >
<tr >
Game Title
NP-hard
in NP
PSPACE-complete
</tr>
<tr >

<td >The Legend of Zelda
</td>

<td >✓
</td>

<td >
</td>

<td >
</td>
</tr>
<tr >

<td >The Adventure of Link
</td>

<td >
</td>

<td >
</td>

<td >
</td>
</tr>
<tr >

<td >A Link to the Past
</td>

<td >✓
</td>

<td >
</td>

<td >
</td>
</tr>
<tr >

<td >Link's Awakening
</td>

<td >✓
</td>

<td >
</td>

<td >
</td>
</tr>
<tr >

<td >Ocarina of Time
</td>

<td >✓
</td>

<td >
</td>

<td >✓
</td>
</tr>
<tr >

<td >Majora's Mask
</td>

<td >✓
</td>

<td >
</td>

<td >✓
</td>
</tr>
<tr >

<td >Oracle of Seasons
</td>

<td >✓
</td>

<td >
</td>

<td >✓
</td>
</tr>
<tr >

<td >Oracle of Ages
</td>

<td >
</td>

<td >
</td>

<td >
</td>
</tr>
<tr >

<td >The Wind Waker
</td>

<td >✓
</td>

<td >
</td>

<td >
</td>
</tr>
<tr >

<td >Four Swords Adventures
</td>

<td >
</td>

<td >
</td>

<td >
</td>
</tr>
<tr >

<td >The Minish Cap
</td>

<td >✓
</td>

<td >
</td>

<td >✓
</td>
</tr>
<tr >

<td >Twilight Princess
</td>

<td >✓
</td>

<td >
</td>

<td >
</td>
</tr>
<tr >

<td >Phantom Hourglass
</td>

<td >
</td>

<td >
</td>

<td >
</td>
</tr>
<tr >

<td >Spirit Tracks
</td>

<td >
</td>

<td >
</td>

<td >
</td>
</tr>
<tr >

<td >Skyward Sword
</td>

<td >✓
</td>

<td >
</td>

<td >
</td>
</tr>
</tbody>
</table>







**Donkey Kong:**
<table >
<tbody >
<tr >
Game Title
NP-hard
in NP
PSPACE-complete
</tr>
<tr >

<td >Donkey Kong
</td>

<td >
</td>

<td >
</td>

<td >
</td>
</tr>
<tr >

<td >Donkey Kong Country
</td>

<td >✓
</td>

<td >✓
</td>

<td >
</td>
</tr>
<tr >

<td >Donkey Kong Land
</td>

<td >✓
</td>

<td >✓
</td>

<td >
</td>
</tr>
<tr >

<td >Country 2: Diddy's Kong Quest
</td>

<td >✓
</td>

<td >✓
</td>

<td >
</td>
</tr>
<tr >

<td >Land 2
</td>

<td >✓
</td>

<td >✓
</td>

<td >
</td>
</tr>
<tr >

<td >Country 3: Dixie Kong's Double trouble!
</td>

<td >✓
</td>

<td >✓
</td>

<td >
</td>
</tr>
<tr >

<td >Land 3
</td>

<td >✓
</td>

<td >✓
</td>

<td >
</td>
</tr>
<tr >

<td >Donkey Kong 64
</td>

<td >
</td>

<td >
</td>

<td >
</td>
</tr>
<tr >

<td >Donkey Kong Country Returns
</td>

<td >
</td>

<td >
</td>

<td >
</td>
</tr>
</tbody>
</table>
**Metroid:**
<table >
<tbody >
<tr >
Game Title
NP-hard
in NP
PSPACE-complete
</tr>
<tr >

<td >Metroid
</td>

<td >✓
</td>

<td >✓
</td>

<td >
</td>
</tr>
<tr >

<td >Metroid II: Return of Samus
</td>

<td >
</td>

<td >
</td>

<td >
</td>
</tr>
<tr >

<td >Super Metroid
</td>

<td >✓
</td>

<td >✓
</td>

<td >
</td>
</tr>
<tr >

<td >Fusion
</td>

<td >
</td>

<td >
</td>

<td >
</td>
</tr>
<tr >

<td >Prime
</td>

<td >✓
</td>

<td >✓
</td>

<td >
</td>
</tr>
<tr >

<td >Prime 2: Echoes
</td>

<td >
</td>

<td >
</td>

<td >
</td>
</tr>
<tr >

<td >Prime Hunters
</td>

<td >✓
</td>

<td >✓
</td>

<td >
</td>
</tr>
<tr >

<td >Prime 3: Corruption
</td>

<td >✓
</td>

<td >✓
</td>

<td >
</td>
</tr>
<tr >

<td >Other M
</td>

<td >✓
</td>

<td >✓
</td>

<td >
</td>
</tr>
</tbody>
</table>







**Pokemon:**







<table >
<tbody >
<tr >
Game Title
NP-hard
in NP
PSPACE-complete
</tr>
<tr >

<td >All Games
</td>

<td >✓
</td>

<td >
</td>

<td >
</td>
</tr>
<tr >

<td >Only trainers
</td>

<td >✓
</td>

<td >✓
</td>

<td >
</td>
</tr>
</tbody>
</table>

