---
author: jeremykun
date: 2013-07-05 15:00:49+00:00
draft: false
title: Reservoir Sampling
type: post
url: /2013/07/05/reservoir-sampling/
categories:
- Algorithms
- Probability Theory
- Program Gallery
tags:
- induction
- programming
- python
- randomized algorithm
- reservoir sampling
- streaming algorithms
- streaming data
---

**Problem: **Given a data stream of unknown size $n$, pick an entry uniformly at random. That is, each entry has a $1/n$ chance of being chosen.

**Solution: **(in Python)

    
    import random
    
    def reservoirSample(stream):
       for k,x in enumerate(stream, start=1):
          if random.random() < 1.0 / k:
             chosen = x
    
       return chosen


**Discussion: **This is one of many techniques used to solve a problem called _reservoir sampling_. We often encounter data sets that we'd like to sample elements from at random. But with the advent of big data, the lists involved are so large that we either can't fit it all at once into memory or we don't even know how big it is because the data is in the form of a stream (e.g., the number of atomic price movements in the stock market in a year). Reservoir sampling is the problem of sampling from such streams, and the technique above is one way to achieve it.

In words, the above algorithm holds one element from the stream at a time, and when it inspects the $k$-th element (indexing $k$ from 1), it flips a coin of bias $1/k$ to decide whether to keep its currently held element or to drop it in favor of the new one.

We can prove quite easily by induction that this works. Indeed, let $n$ be the (unknown) size of the list, and suppose $n=1$. In this case there is only one element to choose from, and so the probability of picking it is 1. The case of $n=2$ is similar, and more illustrative. Now suppose the algorithm works for $n$ and suppose we increase the size of the list by 1 adding some new element $y$ to the end of the list. For any given $x$ among the first $n$ elements, the probability we're holding $x$ when we  inspect $y$ is $1/n$ by induction. Now we flip a coin which lands heads with probability $1/(n+1)$, and if it lands heads we take $y$ and otherwise we keep $x$. The probability we get $y$ is exactly $1/(n+1)$, as desired, and the probability we get $x$ is $\frac{1}{n}\frac{n}{n+1} = \frac{1}{n+1}$. Since $x$ was arbitrary, this means that after the last step of the algorithm each entry is held with probability $1/(n+1)$.


$\square$


It's easy to see how one could increase the number of coins being flipped to provide a sampling algorithm to pick any finite number of elements (with replacement, although a variant without replacement is not so hard to construct using this method). Other variants, exist, such as [distributed and weighted sampling](http://gregable.com/2007/10/reservoir-sampling.html).

Python's generators make this algorithm for reservoir sampling particularly nice. One can define a generator which abstractly represents a data stream (perhaps querying the entries from files distributed across many different disks), and this logic is hidden from the reservoir sampling algorithm. Indeed, this algorithm works for any iterable, although if we knew the size of the list we could sample much faster (by uniformly generating a random number and indexing the list appropriately). The start parameter given to the enumerate function makes the $k$ variable start at 1.
