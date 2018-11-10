---
author: jeremykun
date: 2011-07-12 03:30:05+00:00
draft: false
title: Optimally Stacking the Deck - Kicsi Poker
type: post
url: /2011/07/11/stacking-the-deck/
categories:
- Algorithms
- Discrete
- Probability Theory
tags:
- cut data
- games
- mathematica
- mathematics
- programming
---

## A Puzzle is Born

Sitting around a poolside table, in the cool air and soft light of a June evening, a few of my old friends and I played a game of Texas Hold 'Em. While we played we chatted about our times in high school, of our old teachers, friends, and, of course, our times playing poker. We even reminisced lightly about some of the more dishonest people we played with (whom we invited for want of a larger payout), but especially we recalled the times we caught them cheating. We witnessed dealing from the bottom of the deck, two people teaming up with each other to fix hands, and some very blatant deck stacking.

Often having a player different from the dealer cut the deck (usually the player to the dealer's right, as the cards are dealt starting to the left) absolves the dealer of any foul play. This is tacit at the poker table, and thinking of this on that midsummer evening, a puzzle popped into my head:

For a fixed set of rules in a game using a standard deck of 52 cards, is it possible to optimally stack a deck, such that no matter where the deck is cut, a specific player always wins?

Of course, my mind was initially set on answering this for Texas Hold 'Em (with a fixed number of players). A public suggestion that such a stacking might be possible halted activity at the table as each person thought about it, attempting to find some quick flaw. Of course, it occurred to everyone at the table that if a stacking existed, it very well could have happened in one of the many hands we collectively played over our (albeit short) lifetimes. Finally, Forrest, one of the men at the table, simply said, "This is blowing my mind."

At this point I thought it might actually be a puzzle worth working on.

## Preliminary Thoughts

This question can be asked of any card game, so we'll start with as simple a game as we can: Kuhn Poker. There are two players and three cards: a King, a Queen, and a Jack. Each player is dealt one card, and with after a single round of betting, the player with the highest card wins the pot. From a game-theoretic perspective, there are some [interesting results on this game](http://en.wikipedia.org/wiki/Kuhn_poker); specifically, the first player has multiple optimal betting strategies, while the second player has only one. Despite this, if the second player plays optimally, he should expect to win at a rate of 1/18th of a betting unit per hand. That is, of course, assuming the first player does not stack the deck.

For this combinatorially tractable game we may analyze each of the six cases quickly. We will describe a stacking of the deck by the first letters of its cards in order, with the left end of the string being first card dealt. For example, "KQJ" represents the unique stacking for which the first dealt card is a King, the second a Queen, and the third a Jack. Then, a cut is specified by positions between cards, indexed from zero as follows: "0K1Q2J." Here cutting at 0 means the deck is left as is, which is usually an option given to the cutter. Cutting at 1 turns the deck into QJK, and at 2 we get JKQ. Here is our analysis of the game:

KQJ: cut at 2, receiving a King against a Queen
KJQ: cut at 1, receiving a Queen against a Jack
QKJ: cut at 1, receiving a King against a Jack
QJK: cut at 2, receiving a King against a Queen
JKQ: cut at 0, receiving a King against a Jack
JQK: cut at 0, receiving a Queen against a Jack

So no such stacking is possible for Kuhn Poker. While this is disheartening to the cheater, the honest card player may now rest assured that with a random cut, no cheater is secure.

Note that this same argument extends to any game in which each player is dealt only one card, and we do not allow a tie to result from a good stacking (i.e. the second player cuts aiming for a tie if he cannot cut to win). The only such one-card poker game I know that is actually played is [Indian Poker](http://en.wikipedia.org/wiki/Blind_man%27s_bluff_(poker)) (also known as Blind Man's Bluff), and two-player Indian Poker admits an identical analysis. Suppose we have a stacking of a deck of $n$ cards which is optimal for the first player dealt at any cut. Then card $k$ strictly beats card $k+1$ for all positions $k$ of cards in the deck. By transitivity of "beats," we have that the first card in the deck beats the last card (in fact, every card beats the last card), and hence the second player may cut at position $n-1$. Since this forces the first player to receive the last card (the worst card in the deck), the second player will not lose, contradicting our original assumption that the deck was optimally stacked.

So no such optimal stacking exists for Indian Poker either. Despite the easy answer to this problem, we cannot assume the same result holds for Texas Hold 'Em. Even if a cut results in the first player being dealt low cards, there are sufficiently many rules so as to allow the first player to win (for example, he could have a low flush or straight). So let us try to invent a poker with sufficiently many rules to allow optimal deck stacking, if it is at all possible.

## K Poker

We define a new game called K Poker. The K stands for "kicsi," (pronounced _kee_-chi) the Hungarian word for "small," and also for "Kun," the family name of its creator ([also Hungarian](http://en.wikipedia.org/wiki/Cuman_people)).

K Poker is a two player game. A K Poker deck contains nine consecutively ranked cards of the same suit; we use deuce through ten. Each player is dealt two cards face down from the top of the deck. Dealing is done by the poker standard, to the dealer's left, one card at a time. After a round of betting, three community cards are placed face up in the center for all players to use. After another round of betting, one further community card is dealt, and after a final round of betting, the players reveal their cards and the best five-card poker hand wins. Dealing then switches, and the next hand is dealt.

Actually, the betting scheme here is irrelevant, since we simply care about which player wins in the end. For our purposes, we might as well just say each player is dealt two cards and there are four community cards which both players may use to make a hand. But we might as well define a complete playable set of rules, so there it is. The first player dealt will hereby be referred to as player one, while the second player dealt will be player two.

Note that there are only two hands in K Poker: high card and straight (or, since all cards are the same suit, a straight flush, but this name is inappropriately extravagant). A player receives a straight about one fifth of the time, while high card comparison is the default.

This simple game, while not realistically enjoyable, has theoretical interest to us: optimal stackings exist for both players.

One optimal stacking is very nice: a sorted, ascending K Poker deck is optimal for player two. On one level this is obvious, because the second player will always receive the last card dealt. Since there are no [burn cards](http://en.wikipedia.org/wiki/Burn_card), the next four community cards, being in ascending order form player two's straight. Things just happen to work out in the cases where player two has no straight. As an exercise to the reader, prove (or verify) that with an ascending K Poker deck, player one can never receive a straight, no matter the cut. Then, notice that for both cuts which give player one the ten, player two receives a straight. Otherwise, player two obviously receives the highest card.

It is intractable by brute force human effort to find the other optimal stackings, and it is not obvious whether others exist. Trying some 'orderly' stackings (descending, alternating, etc.) do not work. So while we could build up an army of lemmas and work toward some theorem, we find it more cost-efficient for this particular game to conduct a computer search, which may later guide our efforts in proving lemmas and theorems.

We chose a nine-card game specifically with this in mind. In particular, there are merely $9! = 362,880$ different permutations of the deck. Since each deck has nine cuts, we may further reduce our search to those stackings which begin with a deuce. This reduces the number of decks to $8! = 40,320$. Since we may easily determine who wins on each cut of a stacking (bringing us back up to $9!$ computations), a brute-force search is reasonable.

## We Came, We Sought, We Cheated

This time, our excuse for coding in Mathematica is its lightning fast look-up table for permutations. The [Mathematica notebook is posted online](https://github.com/j2kun/optimal-stackings) (along with the code for our followup post on [optimally stacking Texas Hold 'Em](http://jeremykun.com/2012/04/09/optimal-stacking-hold-em/)) at [this blog's Github page](https://github.com/j2kun?tab=repositories). Since the code is not exactly scintillating material, we leave the reader to download it at his own discretion.

We found nine distinct (up to cuts) optimal stacking for player one, and merely two for player two. We list them here, where the leftmost digit is on the top of the deck:

    
    Player one:
    (2, 5, 10, 7, 3, 8, 4, 9, 6),
    (2, 5, 10, 7, 3, 9, 4, 8, 6),
    (2, 5, 10, 7, 4, 9, 3, 8, 6),
    (2, 6, 8, 3, 9, 4, 7, 10, 5),
    (2, 6, 9, 3, 8, 4, 7, 10, 5),
    (2, 6, 9, 4, 8, 3, 7, 10, 5),
    (2, 6, 10, 7, 3, 8, 4, 9, 5),
    (2, 6, 10, 7, 3, 9, 4, 8, 5),
    (2, 6, 10, 7, 4, 9, 3, 8, 5)
    
    Player two:
    (2, 3, 4, 5, 6, 7, 8, 9, 10),
    (2, 5, 6, 7, 8, 9, 10, 4, 3)

Wonderful! These are the only optimal stackings, though we admit if a stacker is willing to accept draws, there are many more admissible stackings.

First, notice that there are many more optimal stackings for player one than player two! In fact, counting cuts, player one has 81 optimal stackings, while player two has a mere 18. Though player one still only has one fifth of a percent chance to get such a stacking at random, that is still better than player two's mere 0.04%. This does not necessarily say that the game is unfairly balanced for player one, though. There may exist more stackings which admit a larger proportion of wins to player two than player one. And, of course, by the symmetry of switching dealers every hand, the game must be balanced across multiple hands.

Second, notice that when we make a slight modification of the rules, when we burn a single card before dealing the community cards, the count of optimal stackings is reversed: player two has nine while player one has just two. In addition, stacking the deck in descending order is optimal for player one.

Forgetting the sinister tricks we might play on friends, this has exciting implications. Adding complexity gave us more optimal stackings! Further, there is a glimmer of symmetry to the optimal stackings. It remains to be seen whether there is a limit to how much complexity we may have while still maintaining the existence of optimal stackings. We conjecture there is such a limit.

We could try adding more cards or allowing for more poker hands, and seeing if we can maintain optimal stackings. However, the factorial growth rate of the number of deck stackings would limit us almost immediately. Clearly, and sadly enough, a brute force search for optimal stackings in two-player Texas Hold 'Em would take far longer than the life of the universe. So that is out. In addition, the sparsity of optimal stackings in the case of nine cards implies that a Monte Carlo (random sampling) search is unlikely to produce results. While Monte Carlo is still a viable option, perhaps augmented with some local search methods, we find it more likely that the patterns in K Poker generalize to patterns in Texas Hold 'Em. We leave both tantalizing problems open for future posts.

Until then!
