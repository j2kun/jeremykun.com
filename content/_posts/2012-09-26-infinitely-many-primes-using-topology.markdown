---
author: jeremykun
date: 2012-09-26 16:51:28+00:00
draft: false
title: Infinitely Many Primes (Using Topology)
type: post
url: /2012/09/26/infinitely-many-primes-using-topology/
categories:
- Discrete
- Number Theory
- Topology
tags:
- primes
---

**Problem: **Prove there are infinitely many prime numbers.

**Solution: **First recall that an [arithmetic progression](http://en.wikipedia.org/wiki/Arithmetic_progression) with difference $d$ is a sequence of integers $a_n \subset \mathbb{Z}$ so that for every pair $a_k, a_{k+1}$ the difference $a_{k+1} - a_k = d$.

We proceed be defining a topology on the set of integers by defining a basis $B$ of unbounded (in both directions) arithmetic progressions. That is, an open set in this topology is an arbitrary union of arithmetic progressions from $-\infty$ to $\infty$. To verify this makes sense, we need only check that $B$ is a basis. Indeed, $B$ covers $\mathbb{Z}$ since $\mathbb{Z}$ is itself an arithmetic progression with difference 1. And any two arithmetic progressions $a_n, b_n$ have intersection which is again an arithmetic progression: if the two progressions have equal difference then the intersection is empty or $a_n = b_n$, and if their differences are $d_1 \neq d_2$, then the intersection has difference $\textup{lcm}(d_1, d_2)$. (We discussed this idea in a different context in our post on [design with prime numbers](http://jeremykun.wordpress.com/2011/06/13/prime-design/).)

Now we notice that the basis sets are both open (by definition) and closed. The latter follows from the fact that there are only finitely many shifts of an arithmetic sequence. That is, if $a_n$ is an arithmetic sequence with difference $d$, then its complement is the union of all $a_n + k$ where $k$ ranges from 1 to $d-1$ (and each of these sets are open, so the union is open as well).

Further we notice that no finite set can be open. Indeed, since the arithmetic sequences which form our basis are all infinite, and any open set is a union of sets in a basis, every open set in this topology must be infinite.

Now for a prime $p$, let $U_p$ be the arithmetic progression with difference $p$ containing zero, and let $U$ be the union of all $U_p$. Supposing there were only finitely many primes, $U$ is a finite union of closed sets and hence closed in this topology. But the only integers which are not multiples of some prime are $\pm 1$. So $\mathbb{Z} - U = \{ 1, -1 \}$. Since $U$ is closed, its complement is open, but as we mentioned above no finite sets are open. This is a contradiction, and so there must be infinitely many primes. $\square$

**Discussion:** Even though the definition of a topology is basic knowledge for a mathematician, this proof shows that a topology alone can carry a lot of interesting structure. Even more so, the ability to pick a topology on a space to suit one's needs is a powerful tool. It reminds this author of the more elementary idea of [picking colorings on a chessboard](http://jeremykun.wordpress.com/2011/06/26/tiling-a-chessboard/). Indeed, the entire field of algebraic geometry lives in the setting of [one particular kind of topology](http://en.wikipedia.org/wiki/Zariski_topology) on real or projective space. As one might expect, the open sets in a custom topology must be related to the task at hand. In the case of algebraic geometry, they're the solution sets of families of polynomials in finitely many variables. Considering how important polynomials are in mathematics, one can imagine how complex and rich the resulting theories are. We plan to cover both basic topology and algebraic geometry in the future of this blog.
