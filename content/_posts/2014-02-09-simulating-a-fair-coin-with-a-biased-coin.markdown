---
author: alelkes
date: 2014-02-09 01:03:46+00:00
draft: false
title: Simulating a Fair Coin with a Biased Coin
type: post
url: /2014/02/08/simulating-a-fair-coin-with-a-biased-coin/
categories:
- Algorithms
- Probability Theory
- Program Gallery
tags:
- coins
- mathematics
- python
- random number generators
---

_This is a guest post by my friend and colleague [Adam Lelkes](http://homepages.math.uic.edu/~alelkes/index.html). Adam's interests are in algebra and theoretical computer science. This gem came up because Adam gave a talk on probabilistic computation in which he discussed this technique._

**Problem:** Simulate a fair coin given only access to a biased coin.

**Solution:** (in Python)

{{< highlight python >}}
def fairCoin(biasedCoin):
   coin1, coin2 = 0,0
   while coin1 == coin2:
      coin1, coin2 = biasedCoin(), biasedCoin()
   return coin1
{{< /highlight >}}

**Discussion:** This is originally [von Neumann's](http://en.wikipedia.org/wiki/John_von_Neumann) clever idea. If we have a biased coin (i.e. a coin that comes up heads with probability different from 1/2), we can simulate a fair coin by tossing pairs of coins until the two results are different. Given that we have different results, the probability that the first is "heads" and the second is "tails" is the same as the probability of "tails" then "heads". So if we simply return the value of the first coin, we will get "heads" or "tails" with the same probability, i.e. 1/2.

Note that we did not have to know or assume anything about our biasedCoin function other than it returns 0 or 1 every time, and the results between function calls are independent and identically distributed. In particular, we do not need to know the probability of getting 1. (However, that probability should be strictly between 0 or 1.) Also, we do not use any randomness directly, only through the biasedCoin function.

Here is a simple simulation:

{{< highlight python >}}
from random import random
def biasedCoin():
   return int(random() < 0.2)
{{< /highlight >}}

This function will return 1 with probability 0.2. If we try

{{< highlight python >}}
sum(biasedCoin() for i in range(10000))
{{< /highlight >}}

with high probability we will get a number that is close to 2000. I got 2058.

On the other hand, if we try

{{< highlight python >}}
sum(fairCoin(biasedCoin) for i in range(10000))
{{< /highlight >}}

we should see a value that is approximately 5000. Indeed, when I tried it, I got 4982, which is evidence that fairCoin(biasedCoin) returns 1 with probability 1/2 (although I already gave a proof!).

One might wonder how many calls to biasedCoin we expect to make before the function returns. One can recognize the experiment as a geometric distribution and use the known expected value, but it is short so here is a proof. Let $s$ be the probability of seeing two different outcomes in the biased coin flip, and $t$ the expected number of trials until that happens. If after two flips we see the same outcome (HH or TT), then by independence the expected number of flips we need is unchanged. Hence


$t = 2s + (1-s)(2 + t)$




Simplifying gives $t = 2/s$, and since we know $s = 2p(1-p)$ we expect to flip the coin $\frac{1}{p(1-p)}$ times.


For a deeper dive into this topic, see [these notes](http://www.eecs.harvard.edu/~michaelm/coinflipext.pdf) by Michael Mitzenmacher from Harvard University. They discuss strategies for simulating a fair coin from a biased coin that are optimal in the expected number of flips required to run the experiment once. He has also written a book on the subject of [randomness in computing](http://www.amazon.com/Probability-Computing-Randomized-Algorithms-Probabilistic/dp/0521835402).
