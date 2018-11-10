---
author: jeremykun
date: 2012-04-09 14:00:26+00:00
draft: false
title: Optimally Stacking the Deck - Texas Hold 'Em
type: post
url: /2012/04/09/optimal-stacking-hold-em/
categories:
- Algorithms
- Combinatorics
- Discrete
- Group Theory
- Optimization
tags:
- poker
- steepest ascent
- texas hold 'em
---

[![](http://jeremykun.files.wordpress.com/2012/04/poker-img.jpg)
](http://jeremykun.files.wordpress.com/2012/04/poker-img.jpg)

**Main Theorem**: There exist optimal stackings for standard two-player Texas Hold 'Em.

## A Puzzle is Solved (and then some!)

It's been quite a while since [we first formulated the idea of an optimal stacking](http://jeremykun.wordpress.com/2011/07/11/stacking-the-deck/). In the mean time, we've gotten distracted with graduate school, preliminary exams, and the host of other interesting projects that have been going on here at Math ∩ Programming. And so months later, after traversing the homotopic hills of topology and projective plains of algebra, we've finally found time to solve the problem. And we found quite a bit more than we expected! But first, let's recap the ideas from our original post.

For a reminder of the rules of Texas Hold 'Em, here's a [silly tutorial video](http://www.youtube.com/watch?v=aJkT_NXEUTg) from PokerStars.com. For the sake of this post, the betting rules will not matter.

## Optimal Stackings

In card games, especially gambling games, trust is rarely given freely. Instead, we incorporate rituals into standard play that assure fairness. One of the most common such rituals is "cutting the deck." The player who shuffles the deck passes the deck to a second player, who cuts the deck in half, placing the bottom half above the top half. Assuming the two players are not colluding and there is no sleight of hand, this ritual absolves the dealer of any guilt. Even if the dealer had stacked the deck to deal himself favorable cards, the randomness of the cut will necessarily ruin his efforts. Moreover, the cutter is often chosen to be the player to the dealer's right (the last one dealt, in most games) to make it all the more difficult for two players to collude.

An optimal stacking circumvents the tacit fairness assumed after a deck is cut. In particular, we search for an ordering of the cards in the deck which is so mischievous that no matter where it is cut, a specific player always wins.

This author doesn't condone cheating in card games, nor does he plan to use the discoveries in this article for anything more than a parlor trick. Instead, the existence or nonexistence of an optimal stacking is an interesting combinatorial property of card games, and it appears to be a measure of complexity. As we saw [last time](http://jeremykun.wordpress.com/2011/07/11/stacking-the-deck/), simple games like [Blind Man's Bluff](http://en.wikipedia.org/wiki/Blind_man's_bluff_(poker)) (sometimes called Indian Poker) and [Kuhn Poker](http://en.wikipedia.org/wiki/Kuhn_poker) do _not_ have optimal stackings. Adding complexity to these games, we invented Kicsi Poker and discovered it has 11 total distinct optimal stackings (up to cyclic permutations of the deck). Moreover, depending on whether a card was "burned" during the deal, one player had significantly more optimal stackings than the other player (nine for player 1, and two for player 2).

But nobody plays Kicsi Poker, so the true goal is to determine whether Texas Hold 'Em has optimal stackings. Because we found optimal stackings for Kicsi Poker after __adding complexity, we reckoned that adding more complexity would not rule out the possibility of optimal stackings. Hence we supplied the following conjecture, which is now a theorem:

**Theorem**: There exist optimal stackings for standard two-player Texas Hold 'Em.

In fact, we find much more than this, but we should formalize the notion a bit further and describe our method before constructing such a stacking. The remainder of this section will be abstract and seemingly unnecessary for the casual reader. We hold the contention that a proper mathematical analysis should be independent of the real world, and with the right definitions we can logically extend optimal stackings to other situations.

**Definition**: A _cutting permutation_ $\sigma$ of a list $(1, 2, \dots, n)$ is a permutation in $S_n$ with the [cycle form](http://en.wikipedia.org/wiki/Cycle_notation#Example):

$(1\ 2\ \dots\ n)^k$

and for a fixed $0 \leq k < n$, we call $\sigma$ the cut at the $k$-th position.

If the reader is not familiar with the [symmetric groups](http://en.wikipedia.org/wiki/Symmetric_group), this is simply a formalization of the intuitive idea of a cut. For example, to "cut" the list $(1, 2, 3, 4, 5)$ at the third position is simply the permutation with cycle form $(1\ 3\ 5\ 2\ 4)$. Applying this results in the list $(4,5,1,2,3)$, as expected. Moreover, every cut can be achieved by iterating the process of putting the top card on the bottom of the deck. Hence, the set of all cutting permutations is the cyclic group $\mathbb{Z}/52\mathbb{Z}$.

Since any list imposes an ordering on its contents, we can apply cutting permutations to any list.

**Definition**: A _cut_ of a list $(c_1, \dots , c_n)$ is the list $(c_{\sigma(1)}, \dots, c_{\sigma(n)})$ for some cutting permutation $\sigma$. If the list is denoted $l$, we denote the cut $\sigma(l)$.

Specifically to card games, we speak of _cutting_ a deck as the process of replacing a list of cards with its cut. We can now define an optimal stacking.

**Definition**: Fix a game $G$ played with a set of $k$ cards and $n$ players. We say that $G$ has an _optimal stacking for player _$i$ if there exists an ordering of the cards $D = (c_1, \dots, c_k)$ such that for every cutting permutation $\sigma$, player $i$ can force a win when $\sigma(D)$ is dealt.

Moreover, a game is said to simply _have an optimal __stacking_ if it has one for any player. We do not yet know of games which have optimal stackings for some players but not others, and we conjecture that no natural games do (that would make the game unfair for some players, although this author has always found asymmetric games interesting). It may also benefit one to assume in general that all players are infinitely rational, a standard assumption in Game Theory.

Note that we do not want to assume the cheating player knows the order of the deck ahead of time. Instead, an optimal stacking should allow the player to force a win simply by logical play and the knowledge that the stacking is optimal. Specifically, for a game where players have individual hands, the cheating player should not need to know the contents of the other players' hands in order to win. In Texas Hold 'Em this becomes a null issue, since if a player knows he is being dealt an optimal stacking, his hand will always end up winning; there is no reason for him to fold, even if his chances seem slim to none by usual probabilistic analysis.

Before we get back to Texas Hold 'Em, we take a moment to prove a nice fact.

**Proposition**: The (slightly simplified) game of Hearts does not have an optimal stacking.

_Proof._ First, we must clarify that a "win" in Hearts is to either collect 0 points in a round or shoot the moon, and such a score must be_ forced_ in order to have an optimal stacking. We allow no passing of cards. Moreover, we restrict our game of Hearts to a single round, so that the winner of the game is the one who takes the smallest number of points. Hence, if one cannot shoot the moon, one must try to minimize the number of points taken. In particular, there is no reason for one player to "take one for the team" by trying to stop another player from shooting the moon unless the first player can guarantee having the smallest number of points at the end.

The crux of the proof is that all cards in the deck are dealt before play begins. Suppose first that the goal is simply to collect 0 points. Indeed, suppose that some stacking $D$ wins for player 1. Then a cut at position 1 shifts all of the hands right by one player, so then player 4 can guarantee collecting 0 points. If still player 1 can guarantee collecting zero points, then instead a cut at position 2 gives such guarantees to players 3 and 4. At this point, player 1 can still guarantee taking 0 points, then player 2 can shoot the moon, hence giving all other players 26 points.

If, on the other hand, player 1 can guarantee shooting the moon, the same argument shows that a cut at position 1 gives that guarantee to player 4. This is a contradiction since two players cannot shoot the moon simultaneously, nor can one shoot the moon while the other takes zero points. $\square$

Even extending the definition of a win to "collecting the minimum number of points" does not change the existence of an optimal stacking. The same proof applies, along with the knowledge that 26 (the total number of points) is not divisible by 4 (the number of players), or more coarsely that the Queen of Spades already represents 13 points, and can only be taken by one player.

One aspect of this proof contradicts the claim that the existence of an optimal stacking is a measure of complexity. In particular, Hearts is considered a rather complex game (certainly more complex than Kicsi Poker), and yet it does not have an optimal stacking. Moreover, with a suitable definition of a "win," we can likely extend this proof to _any _game which deals out the entire deck to all players before starting (and where all players can see all their cards at all times).

While we do not have a formal rebuttal, it may instead be the case that the existence of an optimal stacking measures the ability for a game to ___diverge_. In other words, in a game like Texas Hold 'Em, one can start with a poor hand and later improve it. On the other hand, it could simply be that Texas Hold 'Em has a complex _deal_: the five community cards, along with the dead cards burned in between each round, give the game enough "space" to allow for an optimal stacking.

But enough big-picture speculation. It's time for the real prize.

## Optimal Stackings in Texas Hold 'Em

Before we get into the program, we should give an example of an optimal stacking, and hence a proof of the main theorem. Here it is:

    
    Th5d7cAd3cQsJc4h6c8c9dTc6hQc8d9sJh5c7dAhAc9h2cKh5sJs8s7h2d
    7s9c4dKd8hQd6d3sKs5h2hAs4s2sTs6sQhJd3h4cTd3dKc
    
     p1     p2      community       p1 hand     p2 hand    winner
    Th7c | 5dAd | Qs Jc 4h 8c Tc | One Pair  | High Card | 1
    5dAd | 7c3c | Jc 4h 6c 9d 6h | One Pair  | One Pair  | 1
    7c3c | AdQs | 4h 6c 8c Tc Qc | Flush     | One Pair  | 1
    AdQs | 3cJc | 6c 8c 9d 6h 8d | Two Pair  | Two Pair  | 1
    3cJc | Qs4h | 8c 9d Tc Qc 9s | Flush     | Two Pair  | 1
    Qs4h | Jc6c | 9d Tc 6h 8d Jh | Straight  | Two Pair  | 1
    Jc6c | 4h8c | Tc 6h Qc 9s 5c | Flush     | High Card | 1
    4h8c | 6c9d | 6h Qc 8d Jh 7d | One Pair  | One Pair  | 1
    6c9d | 8cTc | Qc 8d 9s 5c Ah | One Pair  | One Pair  | 1
    8cTc | 9d6h | 8d 9s Jh 7d Ac | Straight  | One Pair  | 1
    9d6h | TcQc | 9s Jh 5c Ah 9h | Trips     | One Pair  | 1
    TcQc | 6h8d | Jh 5c 7d Ac 2c | Flush     | High Card | 1
    6h8d | Qc9s | 5c 7d Ah 9h Kh | Straight  | One Pair  | 1
    Qc9s | 8dJh | 7d Ah Ac 2c 5s | One Pair  | One Pair  | 1
    8dJh | 9s5c | Ah Ac 9h Kh Js | Two Pair  | Two Pair  | 1
    9s5c | Jh7d | Ac 9h 2c 5s 8s | Two Pair  | High Card | 1
    Jh7d | 5cAh | 9h 2c Kh Js 7h | Two Pair  | High Card | 1
    5cAh | 7dAc | 2c Kh 5s 8s 2d | Two Pair  | One Pair  | 1
    7dAc | Ah9h | Kh 5s Js 7h 7s | Trips     | One Pair  | 1
    Ah9h | Ac2c | 5s Js 8s 2d 9c | One Pair  | One Pair  | 1
    Ac2c | 9hKh | Js 8s 7h 7s 4d | One Pair  | One Pair  | 1
    9hKh | 2c5s | 8s 7h 2d 9c Kd | Two Pair  | One Pair  | 1
    2c5s | KhJs | 7h 2d 7s 4d 8h | Two Pair  | One Pair  | 1
    KhJs | 5s8s | 2d 7s 9c Kd Qd | One Pair  | High Card | 1
    5s8s | Js7h | 7s 9c 4d 8h 6d | Straight  | One Pair  | 1
    Js7h | 8s2d | 9c 4d Kd Qd 3s | High Card | High Card | 1
    8s2d | 7h7s | 4d Kd 8h 6d Ks | Two Pair  | Two Pair  | 1
    7h7s | 2d9c | Kd 8h Qd 3s 5h | One Pair  | High Card | 1
    2d9c | 7s4d | 8h Qd 6d Ks 2h | One Pair  | High Card | 1
    7s4d | 9cKd | Qd 6d 3s 5h As | Straight  | High Card | 1
    9cKd | 4d8h | 6d 3s Ks 2h 4s | One Pair  | One Pair  | 1
    4d8h | KdQd | 3s Ks 5h As 2s | Straight  | One Pair  | 1
    KdQd | 8h6d | Ks 5h 2h 4s Ts | One Pair  | High Card | 1
    8h6d | Qd3s | 5h 2h As 2s 6s | Two Pair  | One Pair  | 1
    Qd3s | 6dKs | 2h As 4s Ts Qh | One Pair  | High Card | 1
    6dKs | 3s5h | As 4s 2s 6s Jd | Flush     | Flush     | 1
    3s5h | Ks2h | 4s 2s Ts Qh 3h | One Pair  | One Pair  | 1
    Ks2h | 5hAs | 2s Ts 6s Jd 4c | One Pair  | High Card | 1
    5hAs | 2h4s | Ts 6s Qh 3h Td | One Pair  | One Pair  | 1
    2h4s | As2s | 6s Qh Jd 4c 3d | One Pair  | High Card | 1
    As2s | 4sTs | Qh Jd 3h Td Kc | Straight  | One Pair  | 1
    4sTs | 2s6s | Jd 3h 4c 3d Th | Two Pair  | One Pair  | 1
    2s6s | TsQh | 3h 4c Td Kc 5d | Straight  | One Pair  | 1
    TsQh | 6sJd | 4c Td 3d Th 7c | Trips     | One Pair  | 1
    6sJd | Qh3h | Td 3d Kc 5d Ad | Flush     | One Pair  | 1
    Qh3h | Jd4c | 3d Kc Th 7c 3c | Trips     | One Pair  | 1
    Jd4c | 3hTd | Kc Th 5d Ad Qs | Straight  | One Pair  | 1
    3hTd | 4c3d | Th 5d 7c 3c Jc | Two Pair  | One Pair  | 1
    4c3d | TdKc | 5d 7c Ad Qs 4h | One Pair  | High Card | 1
    TdKc | 3dTh | 7c Ad 3c Jc 6c | Flush     | One Pair  | 1
    3dTh | Kc5d | Ad 3c Qs 4h 8c | One Pair  | High Card | 1
    Kc5d | Th7c | 3c Qs Jc 6c 9d | High Card | High Card | 1

The first two columns show the pocket cards dealt to player 1 and player 2, respectively, and the fourth and fifth columns give their final hands, again respectively.

Immediately, the reader will recognize that there are 52! possible stackings of the deck, a number with more than 60 digits. Searching them all, even at supercomputer speed, would easily take longer than the life of the universe (at a trillion stackings per second, the estimate is on the order of $10^{50}$ years). So we cannot possibly look through them all.

The idea behind the local search is simple, and we've seen it before on this blog when we looked at [decrypting substitution ciphers](http://jeremykun.wordpress.com/2012/02/03/cryptanalysis-with-n-grams/). We use [steepest ascent](http://en.wikipedia.org/wiki/Gradient_descent) in the discrete space of all orderings of the deck where the function to optimize is the number of cuts that win for the first player dealt. Neighbors consist of the set of stackings obtainable by swapping pairs of cards, and we use random restarts to avoid local maxima. Moreover, we parallelized the algorithm to run on a [desktop supercomputer](http://en.wikipedia.org/wiki/Nvidia_Tesla_Personal_Supercomputer), access to which is graciously provided by the UIC mathematical computer science department. The result is lightning-fast results. :)

In other words, our algorithm starts with a random shuffle of the deck. We compute the _value_ of a deck by dealing out a game for each of the 52 cuts of the deck, and seeing how many times player 1 wins. Call that value $v$. Then we compare $v$ with the value of all neighboring decks, where a _neighbor _is obtained by swapping any two cards in the deck. If any such stacking has a higher value, we take the stacking with the highest value, and repeat the process. Once we get to the point where no such neighboring deck has a higher value, we stop and output the final stacking. Then we start the whole process over again with a new random deck, and stop when we find an optimal stacking (or continue searching for more).

Note our choice of 2 player Texas Hold 'Em is arbitrary, as is our preference for player 1 to win. We have found a number of optimal stackings for player 2 as well, and it's not hard to imagine there are optimal stackings for Hold 'Em with any number of players. We leave that for future research.

We chose to implement this algorithm in C++. Now this is one of the few times this author would ___willingly_ program in C/C++, because frankly the language is a jungle. A professor of mine once said "You can write programs fast, or you can write fast programs." What he meant by that was you can write programs in a language that lets you express ideas concisely and clearly, or you can spend days laboriously working in C/C++ and end up with a program that will leave all other programs in the dust. Because at first we expected optimal stackings to be sparse, we imagined speed would be quite important, and that we'd have to analyze billions of different decks before we could find an optimal stacking. In hindsight this was probably unnecessary, but we do admittedly wallow in pride when quoting statistics about how fast the program runs.

All of [the code we used](https://github.com/j2kun/optimal-stackings) is available for free on [this blog's Github page](https://github.com/j2kun?tab=repositories). We also include a text file containing the list of about 100,000 optimal stackings we found, and similar tables as above detailing the hands dealt for each cut.

In any case, we separated the code into three parts. First we implemented a general steepest-ascent framework for any problem. It's general enough that the open-minded reader could easily use it to do steepest ascent for any problem, and one only needs implement the functions to generate neighbors and compute the value of a position. To give a pedantic (yet unrealistic) example, our posted code includes an instance of optimizing a polynomial function in one variable.

Second, we implemented a poker-hand evaluator and neighbor generator. In this part, we borrowed the lookup-table/perfect hashing methods first discovered by [Kevin Suffecool](http://www.suffecool.net/poker/evaluator.html) and augmented by [Paul Senzee](http://www.paulsenzee.com/2006/06/some-perfect-hash.html). We do note that we take the "slow" method of evaluating a seven card hand, checking all 21 five-card poker hands and choosing the best. Otherwise, enlarging the lookup-table to cover seven-card hands would incur more than a 2,000 times increase in memory use, with only a speedup factor of 10 to 15 times. Considering that we're running this on someone else's personal supercomputer, we found it prudent to accept a smaller memory footprint. And even so, on the supercomputer we can evaluate about 7 million seven-card hands per second, down from about 87 million five-card hands per second. We gain the potential to go up to 87 million seven-card hands per second with the added memory footprint, but as it turns out we can find plenty of optimal stackings with the slower version.

Third, we parallelized the program using [OpenMP](http://openmp.org/wp/) to run on 12 threads, increasing the runtime by a factor of 12 for sufficiently large problem sizes. For smaller problem sizes, we see a speedup factor of roughly 10x, giving a reasonable 80% efficiency.

In the next section we detail the important aspects of the code.

## Enter the Jungle

Unfortunately, a primer on C++ is far beyond the scope of this blog. The best introductory text we know of is Prata's [C++ Primer Plus](http://www.amazon.com/C-Primer-Plus-5th-Edition/dp/0672326973), but short of reading this behemoth and becoming a guru, the reader may safely skip ahead to the next section. An equally strong understanding of the algorithm itself can also be gained from our Python post on [cryptanalysis with ngrams](http://jeremykun.wordpress.com/2012/02/03/cryptanalysis-with-n-grams/), though the program is admittedly much slower.

The general steepest ascent algorithm features a virtual C++ class called Position. A position has three functions: value(), neighbors(), and show(), the last of which returns a string containing a textual representation of a Position. Here are snippets of the code, taken from my hillclimb.h and hillclimb.cpp files:

{{< highlight python >}}class Position {
public:
   Position();
   virtual ~Position();
   virtual double value() = 0;
   virtual std::vector<Position *> *neighbors() = 0;
   virtual std::string show() = 0;
};{{< /highlight >}}

We also define the "hillclimb" function which operates on positions:

{{< highlight python >}}Position* hillclimb(Position* posn, const int numSteps);{{< /highlight >}}

One important note is that we require the caller of the neighbors function to assume ownership of all the pointers in the returned vector, along with the returned vector itself. This author has a minor suspicion that this isn't the proper way to do things in C++, but nobody has remarked otherwise.

Then the hillclimb function need know nothing about poker to work:

{{< highlight python >}}Position* hillclimb(Position* posn, const int numSteps) {
   double value = posn->value(), nextValue;
   int i;
   bool foundBigger;

   vector<Position *> *nbrs;
   vector<Position *>::iterator itr;

   for (i = 0; i < numSteps; i++) {
      nbrs = posn->neighbors(); // allocates neighboring Positions

      foundBigger = false;
      for (itr = nbrs->begin(); itr != nbrs->end(); itr++) {
         nextValue = (*itr)->value();

         if (nextValue > value) {
            foundBigger = true;
            value = nextValue;
            posn = *itr;
         }
      }

      // free the computed neighbors
      for (itr = nbrs->begin(); itr != nbrs->end(); itr++)
         if (*itr != posn)
            delete *itr;

      delete nbrs;

      if (!foundBigger)
         break;
   }

   return posn;
}{{< /highlight >}}

Note that in the parallelization step we had to avoid the use of iterators, but that only changes the code superficially by adding additional indices.

For a short example on how to use this framework, the reader should investigate our quarticopt.h and quarticopt.cpp to maximize a quartic polynomial, included on this blog's [Github page](https://github.com/j2kun?tab=repositories) with the rest of the code for this post.

The poker part required a bit of preprocessing to understand, but it is essentially a simple idea. First, we note that even though there are a lot of poker hands, many are equivalent up to scoring. For example, there are 1,020 different hands of the form AKQJ9 which score "high card," up to a choice of suits which does not make the hand a flush. But none of these hands is any better than another. In other words, there are only 7,462 distinct five-card _poker_ hands, which is a lot smaller than the some 2.5 million possible distinct five-card general hands.

The poker scoring function hence takes as in put a five-card hand and computes a number between 1 and 7,462 representing the absolute score of the hand. It does this through a combination of accessing a pre-generated look-up table for flushes and high-card hands, and a [perfect hashing](http://en.wikipedia.org/wiki/Perfect_hash_function) technique for the remaining hands. The interested reader will see [Suffecool's website](http://www.suffecool.net/poker/evaluator.html) for more details. It is quite novel, and results in a lightning-fast scoring algorithm.

Finally, we generate neighbors and score hands in the obvious (albeit tedious) way:

{{< highlight python >}}vector<Position *> *Deck::neighbors() {
   vector<Position *> *listOfNeighbors = new vector<Position *>;
   int i, j, temp;

   for (i = 0; i < DECK_SIZE - 1; i++) {
      for (j = i + 1; j < DECK_SIZE; j++) {
         // copy to a new Deck
         Deck *neighboringDeck = new Deck(*this);

         // swap a pair of cards
         temp = neighboringDeck->cards[i];
         neighboringDeck->cards[i] = neighboringDeck->cards[j];
         neighboringDeck->cards[j] = temp;

         listOfNeighbors->push_back(neighboringDeck);
      }
   }

   return listOfNeighbors;
}

double Deck::value() {
   int cutPosn, count = 0, score1, score2;
   int p1hand[7], p2hand[7];

   for (cutPosn = 0; cutPosn < DECK_SIZE; cutPosn++) {
      p1hand[0] = cards[cutPosn];
      p1hand[1] = cards[(cutPosn + 2) % DECK_SIZE];
      p1hand[2] = cards[(cutPosn + 5) % DECK_SIZE];
      p1hand[3] = cards[(cutPosn + 6) % DECK_SIZE];
      p1hand[4] = cards[(cutPosn + 7) % DECK_SIZE];
      p1hand[5] = cards[(cutPosn + 9) % DECK_SIZE];
      p1hand[6] = cards[(cutPosn + 11) % DECK_SIZE];

      p2hand[0] = cards[(cutPosn + 1) % DECK_SIZE];
      p2hand[1] = cards[(cutPosn + 3) % DECK_SIZE];
      p2hand[2] = cards[(cutPosn + 5) % DECK_SIZE];
      p2hand[3] = cards[(cutPosn + 6) % DECK_SIZE];
      p2hand[4] = cards[(cutPosn + 7) % DECK_SIZE];
      p2hand[5] = cards[(cutPosn + 9) % DECK_SIZE];
      p2hand[6] = cards[(cutPosn + 11) % DECK_SIZE];

      score1 = eval7Hand(p1hand);
      score2 = eval7Hand(p2hand);

      if (score1 < score2)
         count++;
   }

   return count;
}
{{< /highlight >}}

Where "eval7Hand" evaluates a seven-card poker hand to find the best five-card sub-hand as described above (and smaller scores are better). We note that the next time we work on this problem, we will likely extend the code to work for any number of hands and any number of players, and replace the ugly assignment operators above with a few loops. Moreover, we leave out an additional optimization from this code snippet for brevity.

Running the main application gives an output similar to the large table above for each discovered optimal stacking.

## Parallelization

A thorough introduction to parallel computation is again (sadly) beyond the scope of this post. Luckily, we chose the arguably simplest possible library for parallelization: [OpenMP](http://openmp.org/wp/). With OpenMP, the serial code looks almost identical to the parallel code, with the exception of a few sagely placed pragmas (code annotations). For instance, our main function parallelizes at the top-most level, so that each thread performs steepest ascent trials independently of the others. From this perspective, the steepest ascent algorithm is [pleasingly parallel](http://en.wikipedia.org/wiki/Embarrassingly_parallel). The code for that is:

{{< highlight python >}}) {
   [...]

   omp_set_num_threads(threadc);

   vector<Deck *> optimalStackings;
   #pragma omp parallel shared(optimalStackings)
   {
      Deck *bestSoFar = new Deck(), *result;
      int i;

      #pragma omp for schedule(static) nowait
      for (i = 0; i < numTrials; i++) {
         Deck startingDeck;
         result = (Deck *)hillclimb(&startingDeck, trialLength);

         if (result->value() == 52) {
            #pragma omp critical
            {
               cout << result->show() << "\n";
               optimalStackings.push_back(result);
            }

            if (bestSoFar->value() < 52)
               delete bestSoFar;

            bestSoFar = result;
         } else if (bestSoFar->value() < result->value()) {
            delete bestSoFar;
            bestSoFar = result;
         } else {
            delete result;
         }
      }
   }

   [...]

   return 0;
}
{{< /highlight >}}

For an explanation of the pragmas and their syntax, see this [reference/tutorial from Lawrence Livermore National Labs](https://computing.llnl.gov/tutorials/openMP/). In the code posted, we tried two different levels of parallelization. First, we parallelized at the top-most level, as above. The second way was  at the_ finest_ level, so that all threads were cooperating to evaluate the score of a single deck and compute neighbors. The former method turned out to be somewhat more efficient than the latter for large problem sizes. Specifically, in 1,000 iterations of a steepest ascent, the former was 17% faster. The speed increase is due to the significantly less system time overhead to schedule the threads, and the fact that evaluating a single deck is very fast, so at the end of every loop the thread synchronization time begins to outweigh the deck evaluation time. However, for smaller problem sizes the efficiency seems to drop off at a slower rate. We include a summary table of all of these details in a file called "interesting-properties.txt" included in the code archive.

We also include the full source code for the fine-granularity parallelization, with the mindset that it may perform better in other application domains, and it serves as an example implementation.

## Results

Running the algorithm overnight on the supercomputer gave us a list of approximately 100,000 distinct optimal stackings for two-player Hold 'Em. In particular, we discovered the following interesting properties of stackings:

	  * Optimal stackings are _plentiful._ In particular, about one in six randomly chosen decks can be improved to an optimal stacking.
	  * The number of steps in the hill-climbing process is small. Specifically, in all of our tests we never witnessed a deck which required more than 15 steps to reach a local maximum. We do not have a proof that this is upper bound is sharp. Moreover, some decks were optimized with as few as 5 steps.
	  * There are optimal stackings both for player 1 and player 2.

We include the list of about 100,000 optimal stackings for the reader's viewing pleasure, along with the game tables for their corresponding cuts, in a text file on [this blog's Github page](https://github.com/j2kun?tab=repositories). It's a relatively large file (compressed ~70MB, uncompressed ~450MB). We note the possibility that some of these decks are redundant, but the probability of that happening is decidedly small. For a smaller set of examples, one can download the source code and look for a list of a thousand optimal stackings in the "decks" directory. We encourage the reader to try one out at a friendly neighborhood poker game. And finally, here is a list of ten optimal stackings, so that casual readers can avoid downloading and navigating the directory.

    
    [AcQhJd8h9c9h6d3cTc3dQdKhJs6h3hThQc7d3sJc4h2h6c8d7c5c7s8cAd4dTd9sKs5h8s2c4c2d2s5sAhKd9dKcQs4s5dAs7hJhTs6s]
    [8h4h3cAsQd7dTh3s5h9dAhKh9sTs6s4d7s2hKdJc9h6h3h4c4sQcJsTd5d2c9c3dQhJd8c5c2dKs8s6cJh7hAcAdKc8d2sTc6dQs7c5s]
    [6d2cAc7sQc9sThJs2dQd7h6c9dAsKs2sKc3d4c9hJc2hAdKh3cQs4h5c3hTdAh4s8c8hQh7dTc8s8d5s6hJd4d3s5h6sTsKd9c7cJh5d]
    [Th2s9s6hJh3s8c5h5cAh6s3cQhJcKc4c9dAcTcJd3hQs7h8sAsTs2d8d4s3d5s7sKsAd9hKd5d2hTd4h7d7cJs9cQdQc2c8h6cKh4d6d]
    [Js7hQhTh4h8s9hAh7sQc6d3sTc9d3d5hTs8cJhAcQd5s5cTd4dKsKcJd8h2hKh4c6s7d2sQs7c6h3cKdAs2d9cJc6cAd8d3h9s4s5d2c]
    [Jd2cAc9s5c8h9cTh4c7d2dTcAdKcKsQc8c4h7s4s9d5dJs5h7hKdQh7c4d9h8d2h6dQdJc3cAs3sKh8sTd6s3hAh5sJhQsTs6h6c2s3d]
    [6dJs5c4s8d8h9s6s4dTh8s2c6h3hQd9d4hAc2d8cKcJh3d5sJdQh7dAd3cTsAs7c5h7hQs2sTcKs4cAhKdTd7s6cKhQcJc9c3s9h2h5d]
    [9dTdAd7hKd9h3cJcTsKh3h9c8s3d4hKsJs3s5c8h6c6s5d4dKcAs7dQc6d5h2c4s4c7c5s2dQh9s7s8cAc2sJhQsThQd6hJd8dAhTc2h]
    [3cJd4s2s9hAd6sKcTd3h5dTs3s9d8d4cAcQsKsKdJc3d2h5h4dJs8cAh9c7sKh6d5s4hTc7cQhQc8hJh6c9s5c2d7dQd2c8sTh6hAs7h]
    [Ac7cTd6d3c4c9hQc7h9d8hJc8c5sTc6hAdQs9s7s2cKc2s2d4s8d6sAh5d8sJs3sQhKd3hQdJh5cKh4h3d5hTsJd7dKs9c2h4dTh6cAs]

## Future Work

We are very interested in the existence or non-existence of optimal stackings for ___other_ games. We encourage the interested reader (say, as a programming exercise) to implement a steepest-ascent algorithm for optimal stackings in a different game, and post the results in a comment. Some ideas for other games include poker variants like Omaha and Lowball, along with completely unrelated games like Blackjack or Rummy. Might we even go so far as to investigate non-standard card games like [Magic: the Gathering](http://www.wizards.com/Magic/TCG/Default.aspx) (a favorite during my youth)? A critical step in the analysis of most non-poker games would be to formalize what it means to force a win, or relax the definition to make it sensible.

But there is still much we can ask about Hold 'Em. For instance, how hard is it to find optimal stackings for any given player when there are $n$ players? More specifically, how fast does the complexity grow when you add more players? Are there significantly more _semi-optimal_ stackings, in which we allow ties for player 1? What sorts of interesting patterns occur in optimal or semi-optimal stackings? Many of these sorts of questions could be answered by minor modifications to the source code provided. We leave that as an exercise for the reader, until we find enough time ourselves to go through and find optimal stackings which we believe to exist for any reasonable number of players and any position of the winning player.

Until next time!
