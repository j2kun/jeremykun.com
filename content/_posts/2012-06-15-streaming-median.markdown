---
author: jeremykun
date: 2012-06-15 03:03:55+00:00
draft: false
title: Streaming Median
type: post
url: /2012/06/14/streaming-median/
categories:
- Algorithms
- Discrete
- Program Gallery
- Statistics
tags:
- big data
- data analysis
- mathematics
- median
- programming
- python
- streaming data
---

**Problem:** Compute a reasonable approximation to a "streaming median" of a potentially infinite sequence of integers.

**Solution:** (in Python)

{{< highlight python >}}
def streamingMedian(seq):
   seq = iter(seq)
   m = 0

   for nextElt in seq:
      if m > nextElt:
         m -= 1
      elif m < nextElt:
         m += 1

      yield m
{{< /highlight >}}

**Discussion: **Before we discuss the details of the Python implementation above, we should note a few things.

First, because the input sequence is potentially infinite, we can't store any amount of information that is increasing in the length of the sequence. Even though storing something like $O(\log(n))$ integers would be reasonable for the real world (note that the log of a petabyte is about 60 bytes), we should not let that stop us from shooting for the ideal $O(1)$ space bound, and exploring what sorts of solutions arise under that constraint. For the record, I don't know of any algorithms to compute the true streaming median which require $O(\log(n))$ space, and I would be very interested to see one.

Second, we should note the motivation for this problem. If the process generating the stream of numbers doesn't change over time, then one can find a reasonably good approximation to the median of the entire sequence using only a sufficiently large, but finite prefix of the sequence. But if the process _does_ change, then all bets are off. We need an algorithm which can compensate for potentially wild changes in the statistical properties of the sequence. It's unsurprising that such a naive algorithm would do the trick, because it can't make any assumptions.

In words, the algorithm works as follows: start with some initial guess for the median $m$. For each element $x$ in the sequence, add one to $m$ if $m$ is less than $x$; subtract one if $m$ is greater than $x$, and do nothing otherwise.

In the Python above, we make use of _generators_ to represent infinite sequences of data. A generator is an object with some iterable state, which yields some value at each step. The simplest possible non-trivial generator generates the natural numbers $\mathbb{N}$:

    
    def naturalNumbers():
       n = 1
       while True:
          yield n
          n += 1

What Python does with this function is translate it into a generator object "g" which works as follows: when something calls next(g), the function computes as usual until it reaches a yield statement; then it returns the yielded value, saves all of its internal state, and then returns control to the caller. The next time next(g) is called, this process repeats. A generator can be infinite or finite, and it terminates the iteration process when the function "falls off the end," returning None as a function which has no return statement would.

We should note as well that Python knows how to handle generators with the usual "for ... in ..." language form. This makes it extremely handy, because programmers don't have to care whether they're using a list or an iterator; the syntax to work with them is identical.

Now the "streamingMedian" function we began with accepts as input a generator (or any iterable object, which it converts to a generator with the "iter" function). It then computes the streaming median of that generator as part of another generator, so that one can call it, e.g., with the code:

    
    for medianSoFar in streamingMedian(naturalNumbers()):
       print medianSoFar
