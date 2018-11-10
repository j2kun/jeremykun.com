---
author: jeremykun
date: 2015-03-09 14:00:11+00:00
draft: false
title: Finding the majority element of a stream
type: post
url: /2015/03/09/finding-the-majority-element-of-a-stream/
categories:
- Algorithms
- Combinatorics
- Set Theory
tags:
- data mining
- frequency moments
- mathematics
- programming
- python
- streaming algorithms
- streaming data
- sublinear space
---

**Problem: **Given a massive data stream of $n$ values in $\{ 1, 2, \dots, m \}$ and the guarantee that one value occurs more than $n/2$ times in the stream, determine exactly which value does so.

**Solution: **(in Python)

{{< highlight python >}}
def majority(stream):
   held = next(stream)
   counter = 1

   for item in stream:
      if item == held:
         counter += 1
      elif counter == 0:
         held = item
         counter = 1
      else:
         counter -= 1

   return held
{{< /highlight >}}

_Discussion: _Let's prove correctness. Say that $s$ is the unknown value that occurs more than $n/2$ times. The idea of the algorithm is that if you could pair up elements of your stream so that _distinct _values are paired up, and then you "kill" these pairs, then $s$ will always survive. The way this algorithm pairs up the values is by holding onto the most recent value that has no pair (implicitly, by keeping a count how many copies of that value you saw). Then when you come across a new element, you decrement the counter and implicitly account for one new pair.

Let's analyze the complexity of the algorithm. Clearly the algorithm only uses a single pass through the data. Next, if the stream has size $n$, then this algorithm uses $O(\log(n) + \log(m))$ space. Indeed, if the stream entirely consists of a single value (say, a stream of all 1's) then the counter will be $n$ at the end, which takes $\log(n)$ bits to store. On the other hand, if there are $m$ possible values then storing the largest requires $\log(m)$ bits.

Finally, the guarantee that one value occurs more than $n/2$ times is necessary. If it is not the case the algorithm could output anything (including the most _infrequent_ element!). And moreover, if we don't have this guarantee then _every algorithm _that solves the problem must use at least $\Omega(n)$ space in the worst case. In particular, say that $m=n$, and the first $n/2$ items are all distinct and the last $n/2$ items are all the same one, the majority value $s$. If you do not know $s$ in advance, then you must keep at least one bit of information to know which symbols occurred in the first half of the stream because any of them could be $s$. So the guarantee allows us to bypass that barrier.

This algorithm can be generalized to detect $k$ items with frequency above some threshold $n/(k+1)$ using space $O(k \log n)$. The idea is to keep $k$ counters instead of one, adding new elements when any counter is zero. When you see an element not being tracked by your $k$ counters (which are all positive), you decrement _all_ the counters by 1. This is like a $k$-to-one matching rather than a pairing.
