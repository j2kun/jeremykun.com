---
author: jeremykun
date: 2012-03-22 16:09:57+00:00
draft: false
title: Caching (and Memoization)
type: post
url: /2012/03/22/caching-and-memoization/
---

**Problem**: Remember results of a function call which requires a lot of computation.

**Solution**: (in Python)

{{< highlight python >}}def memoize(f):
   cache = {}

   def memoizedFunction(*args):
      if args not in cache:
         cache[args] = f(*args)
      return cache[args]

   memoizedFunction.cache = cache
   return memoizedFunction

@memoize
def f():
   ...{{< /highlight >}}

**Discussion**: You might not use [monoids ](http://jeremykun.wordpress.com/2011/12/19/metrics-on-words/)or [eigenvectors ](http://jeremykun.wordpress.com/2011/07/25/inner-product-spaces-a-primer/)on a daily basis, but you use caching far more often than you may know. Caching the results of some operation is so prevalent in computer science that the world would slow down considerably without it. Every computer has a number of caches built into the hardware and operating system to optimize memory access, speedup graphical computations, and manage your applications. Moreover, every single website which has an underlying database (every website you use to actually _do_ something) uses multiple levels of caching to make their database queries, and hence your page requests, that much faster. Even your browser caches web pages and media files and common javascript files used by websites (for better or [worse](http://www.youtube.com/watch?v=bt0Qh9c59_c)).

And caching comes in handy for a lot of numerically-intensive problems. In fact, I used caching to speed up affine image rotations in [my very first game](http://jeremykun.wordpress.com/2012/03/15/learning-programming-zombies/).

In the solution above, we use a Python _decorator _to implement a generic cache for a function call. We explain decorators in more detail in our primer on dynamic programming, [A Spoonful of Python](http://jeremykun.wordpress.com/2012/01/12/a-spoonful-of-python/). Here we note its downsides. First, since we use a hash table (a Python dictionary) to store our results, we cannot apply this to any function whose arguments are not hashable by default. In Python, no built-in mutable types are hashable (including lists and dictionaries). This makes the implementation less transparent than we might like, but is more or less a minor detail.

Second, and more importantly, we note that this cache stores _all_ results. In more general applications of caching, the program runs indefinitely. To avoid accumulating too much waste, we would only want to store, say, the most recent $n$ results, or the $n$ most commonly asked-for results. This would require a more complicated data structure (a queue or a heap, respectively), so that we could eject old values from the cache when we no longer want them. In fact, these sorts of considerations lie at the heart of every discussion on caching, and the resulting solutions can be quite sophisticated.
