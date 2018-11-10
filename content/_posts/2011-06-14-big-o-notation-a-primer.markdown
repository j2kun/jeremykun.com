---
author: jeremykun
date: 2011-06-14 23:26:27+00:00
draft: false
title: Big-O Notation - A Primer
type: post
url: /2011/06/14/big-o-notation-a-primer/
categories:
- Algorithms
- Analysis
- Primers
tags:
- big-o notation
- big-theta notation
- computational complexity
- limits
- mathematics
- primer
- real analysis
---

## The Quest to Capture Speed


Companies and researchers spend hundreds of millions of dollars for the fruits of their algorithms. Whether one is indexing websites on the internet for search, folding proteins, or figuring out which warehouse is the most cost-effective to ship a product from, improvements in algorithm speed save immense amounts of money.

It's no surprise then, that a similarly immense amount of money has gone into the mathematics behind algorithm analysis. Arguably the roughest and most succinct measurement of how fast an algorithm runs is called _order of complexity_ of an algorithm. There are two commonly used measures of order of complexity, namely Big-O notation and the more nuanced Big-Theta notation. We begin with the former.

Because an algorithm runs in a discrete number of steps, we call $f(n)$ the number of steps it takes an algorithm to complete for any input of size $n$, and then analyze it for real input $x \in \mathbb{R}$. In doing so, we may utilize the vast wealth of knowledge in real analysis, and describe runtime in terms of elementary continuous functions and their limits.

**Definition:** We say a real-valued function $f(x)$ is $O(g(x))$ if for some (potentially large) input value $x_0$, there exists a positive number $M$ with $|f(x)| \leq M |g(x)|$ for all $x > x_0$. Equivalently, $\lim \limits_{x \rightarrow \infty} \dfrac{|f(x)|}{|g(x)|} < \infty$.

Here is a simple, pedantic example:

Consider an algorithm which accepts as its input a list of numbers and adds together all of the numbers in that list. Given a list of size $n$, we might count up the number of steps taken by our algorithm to arrive at $f(n) = 5(n-1)$, because there are $n-1$ additions being performed, and for each add there is an instruction fetch, a pointer reference to follow, a value in memory to load, the addition to perform, and the resulting value to store in a register, each for simplicity taking one step. We characterize this algorithm as $O(n)$, because for any $n > 1$, we have $M = 5$ giving $|f(n)| = |5n-5| < 5|n| = M|g(n)|$.

Of course, such a detailed analysis is rarely performed. Generally, we'd say there is an addition to be performed for each element in the list, giving $n$ additions and an order of complexity of $O(n)$. Typically, the goal is to have the $g$ function be as simple as possible, giving a small number of commonly used orders which facilitate over-the-table discussions about algorithms:



	  * $O(1)$: the **constant time** algorithm which always takes a fixed number of steps for any input. For example, looking up a key in a hash table.
	  * $O(\log n)$: **logarithmic time**, where at each step of the algorithm the problem size is reduced by a fixed factor. This is common to "divide and conquer" algorithms.
	  * $O(n^c)$ for $c > 0$: **polynomial time**. If $f(n)$ is not a monomial, we conventionally drop all terms but the one of highest degree, because under the limit the highest degree term dominates the runtime.
	  * $O(a^n)$ for $a > 1$: **exponential time**, where with each increase of the input size, the runtime increases by a factor of $a$. This is extremely slow for any reasonable input size, even when $a$ is very close to 1. Many brute-force algorithms (attempting every possibility) result in exponential runtime.
	  * $O(n!)$: **factorial time**, which is often clumped with exponential time, is actually strictly slower than any exponential time algorithm. Considering $s_n = a^n / n!$, as $n$ surpasses $a$, we have each $s_n = s_{n-1} (\frac{a}{n})$, and since $a < n$, we decrease $s_n$ at each step, and the limit goes to 0 (i.e., factorials grow much faster). [Travelling Salesman](http://en.wikipedia.org/wiki/Travelling_salesman_problem) is a famous problem whose brute-force solution is factorial, but even with cutting-edge methods for optimization, the worst case runtime is still exponential.

And there are additional classes that fall in between these, such as $O(n \log n)$ and $O(\log \log n)$. And it is easy to prove that constants, and additions of smaller terms are irrelevant under the O. Specifically, $O(kg(n)) = O(g(n))$ for any constant $k$, and similarly if $f(n)$ is $O(g(n))$, then $O(f(n) + g(n)) = O(g(n))$.

In this way we encapsulate the notion of _worst-case runtime_. If $f(n)$ is $O(g(n))$, we say the algorithm which has exact runtime $f(n)$ runs no worse than $g(n)$. Unfortunately, these bounds do not need to be tight. We could say, for instance, that an algorithm runs in $O(n^{100})$ as well as $O(n^2)$, and be right on both counts. That is why we need Big-Theta notation, to give tighter bounds on runtime:

**Definition**: We say $f(x)$ is $\Theta(g(x))$ if there exist $x_0, M, N$ such that whenever $x > x_0$, we have $N |g(x)| < |f(x)| < M |g(x)|$. In other words, for an appropriate choice of constants, $g$ bounds $f$ both from above and below for all sufficiently large inputs.

Now we may only use $\Theta$ notation when the bound is reasonable (not too high, not too low). We gain more information by knowing a function is $\Theta(g(n))$ than knowing it is $O(g(n))$, because we know it cannot grow slower than $g$.

Of course, for more complex algorithms with multiple input variables, the asymptotic runtimes are necessarily phrased in terms of continuous functions of multiple variables. While it's not much harder to formally develop these characterizations, it's beyond the scope of this post.

There is a wealth of knowledge out there on the orders of complexity of various algorithms; one simply cannot write a new algorithm without asking how fast it is. For the interested reader, I highly recommend the mathematically inclined book [Introduction to Algorithms](http://www.amazon.com/Introduction-Algorithms-Thomas-H-Cormen/dp/0262033844/ref=sr_1_2?s=books&ie=UTF8&qid=1308093435&sr=1-2), by Cormen, et. al. It's been the standard text on the subject for many years, and it is a wealth of knowledge and a valuable reference on any shelf.
