---
author: alelkes
date: 2014-02-12 16:00:51+00:00
draft: false
title: Simulating a Biased Coin with a Fair Coin
type: post
url: /2014/02/12/simulating-a-biased-coin-with-a-fair-coin/
categories:
- Algorithms
- Analysis
- Computing Theory
- Number Theory
- Probability Theory
- Program Gallery
tags:
- calculus
- coins
- convergent series
- mathematics
- programming
- python
---

_This is a guest post by my friend and colleague [Adam Lelkes](http://homepages.math.uic.edu/~alelkes/index.html). Adam's interests are in algebra and theoretical computer science. This gem came up because Adam gave a talk on probabilistic computation in which he discussed this technique._

**Problem:** simulate a biased coin using a fair coin.

**Solution:** (in Python)

{{< highlight python >}}
def biasedCoin(binaryDigitStream, fairCoin):
   for d in binaryDigitStream:
      if fairCoin() != d:
         return d
{{< /highlight >}}

**Discussion:** This function takes two arguments, an iterator representing the binary expansion of the intended probability of getting 1 (let us denote it as $p$) and another function that returns 1 or 0 with equal probability. At first glance this might seem like an overcomplicated way of solving this problem: why can't the probability be a floating point number?

The point is that $p$ can have infinite precision! Assuming that fairCoin() gives us a perfectly random stream of 1's and 0's (independently and with probability 1/2) and we can read each bit of the binary expansion of $p$, this function returns 1 with probability _exactly_ $p$ even if $p$ is irrational or a fraction with infinite decimal expansion. If we used floating point arithmetic there would be a small chance we get unlucky and exhaust the precision available. We would only get an approximation of the true bias at best.

Now let us explain why this algorithm works. We keep tossing our fair coins to get a sequence of random bits, until one of our random bits is different from the corresponding bit in the binary expansion of $p$. If we stop after $i$ steps, that means that the first $i-1$ bits in the two binary sequences were the same, which happens with probability $\frac{1}{2^{i-1}}$. Given that this happens, in the $i$th step we will return the $i$th bit of $p$; let us denote this bit by $p_i$. Then the probability of returning 1 is $\sum_{i=1}^\infty \frac{p_i}{2^{i-1}}$, which is the binary expansion of $p$.

This algorithm is also efficient. By efficient here we mean that the expected running time is constant. Of course, to show this we need to make some assumption about the computational complexity of calculating the bits of $p$. If we assume that the bits of $p$ are efficiently computable in the sense that the time required to compute $p_i$ is bounded by a polynomial in $i$, then this algorithm does run in constant expected time.

Indeed, the expected running time is $\sum_{i=0}^\infty \frac{i^n}{2^i}$. Showing that this sum is a constant is an easy calculus exercise: using the ratio test we get that


$\displaystyle \textup{limsup}_{i \to \infty} \left | \frac{\frac{(i+1)^n}{2^{i+1}}}{\frac{i^n}{2^i}} \right | = \limsup_{i\to\infty} \frac{\left(\frac{i+1}{i}\right)^n}{2} = \frac{1}{2} < 1$,


thus the series is convergent.

Now that we proved that our algorithm works, it's time to try it! Let's say that we want to simulate a coin which gives "heads" with probability 1/3.
We need to construct our binary digit stream. Since 1/3 is 0.010101... in binary, we could use the following simple generator:

{{< highlight python >}}
def oneThird():
   while True:
      yield 0
      yield 1
{{< /highlight >}}

However, we might want to have a more general generator that gives us the binary representation of any number. The following function, which takes a number between 0 and 1 as its argument, does the job:

{{< highlight python >}}
def binaryDigits(fraction):
   while True:
      fraction *= 2
      yield int(fraction)
      fraction = fraction % 1
{{< /highlight >}}

We also need a fair coin simulator. For this simulation, let's just use Python's built-in pseudo-random number generator:

{{< highlight python >}}
def fairCoin():
   return random.choice([0,1])
{{< /highlight >}}

Let us toss our biased coin 10000 times and take the sum. We expect the sum to be around 3333. Indeed, when I tried

{{< highlight python >}}
>>> sum(biasedCoin(oneThird(), fairCoin) for i in range(10000))
3330
{{< /highlight >}}

It might be worth noting oneThird() is approximately ten times faster than binaryDigits(fractions.Fraction(1,3)), so when a large number of biased coins is needed, you can hardwire the binary representation of $p$ into the program.
