---
author: jeremykun
date: 2012-03-19 01:33:42+00:00
draft: false
title: In Place Uniform Shuffle
type: post
url: /2012/03/18/in-place-uniform-shuffle/
categories:
- Algorithms
- Combinatorics
- Probability Theory
- Program Gallery
tags:
- python
---

[![](http://jeremykun.files.wordpress.com/2012/03/riffle.jpg)
](http://jeremykun.files.wordpress.com/2012/03/riffle.jpg)

**Problem**: Write a program that shuffles a list. Do so without using more than a constant amount of extra space and linear time in the size of the list.

**Solution**: (in Python)

{{< highlight python >}}import random
random.seed()

def shuffle(myList):
   n = len(myList)
   for i in xrange(0, n):
      j = random.randint(i, n-1) # randint is inclusive
      myList[i], myList[j] = myList[j], myList[i]{{< /highlight >}}

**Discussion**: Using a computer to shuffle a deck of cards is nontrivial at first glance for the following reasons. First, computers are perfect. One can't "haphazardly" spread the cards on a table and mix them around for a while. Neither can it use a "riffle" technique until it's satisfied the cards are random enough. These are all human characteristics which have inherent sloppy flaws caused by our limited-precision dexterity. Another difficulty is that we have to give a mathematical _guarantee_ that the resulting distribution of shuffles is uniform. It certainly isn't when humans shuffle cards, so this adds a new level of difficulty.

We note that there are many gambling companies whose integrity is based on the validity of their shuffling algorithms (and hence, the fairness of their games). But despite the simplicity of our algorithm above, there are still [some companies](http://www.planetpoker.com/) who [got it wrong](http://www.cigital.com/papers/download/developer_gambling.php). So we need to take a close look at the right way to solve this problem.

Before we get there, we note that this problem generalizes to constructing random permutations. While it's easier to understand a problem based on a deck of cards, generating random permutations is really the useful thing we're getting out of this.

[This page](http://www.cigital.com/papers/download/developer_gambling.php) gives an example of how _not _to shuffle cards. We will derive the correct way. If we have a list of $n$ elements, and a good shuffling algorithm, then each element has a uniform probability of $1/n$ to end up in the first position in the list. Once we've chosen such an element, we can recursively operate with the remaining $n-1$ elements, and randomly choose which element goes in the second spot, where each has a chance of $1/(n-1)$ to get there. Note that this means for the first stage, we pick a random integer uniformly between 1 and $n$, and in the second stage we pick a integer between 2 and $n$. Inductively, if we have already processed the first $i$ cards, then we need to pick a random integer uniformly between $i+1$ and $n$ to decide which of the remaining cards goes in the $i+1$-th spot. Note that subtracting 1 from all of these randomly chosen numbers gives us the right indices.

We make one further note: the order of the unprocessed cards it totally irrelevant. That means that if, say, during the first stage we want the 5th element to go in the first spot, we can simply swap the fifth and first element in the list. Since we're picking uniformly distributed numbers, we still have an equal chance to pick any one of the remaining cards in later stages. And of course, sometimes we will be swapping an element with itself, which is the same as not swapping at all.

Taking all of this into consideration, we have the following pseudocode:

    
    on input list L:
       for i in range(0, n-1) inclusive:
          j = random(i, n-1) inclusive
          swap L[i], L[j]

As we showed above, this pseudocode translates quite nicely to Python, and it obviously satisfies the requirements of not using a lot of extra space and running in linear time; we only visit each position in the list once, and swaps take constant time and all the swaps combined only use constant space. On the other hand, [implementations in functional languages](http://okmij.org/ftp/Haskell/perfect-shuffle.txt) are a bit more difficult, and if the language is _purely functional_, it can't be done "in place." I'd usually be the last one to admit functional languages aren't the best tool for every job, but there you have it.
