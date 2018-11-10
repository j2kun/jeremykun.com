---
author: jeremykun
date: 2012-12-02 21:17:26+00:00
draft: false
title: Ramsey Number Lower Bound
type: post
url: /2012/12/02/ramsey-number-lower-bound/
categories:
- Graph Theory
- Probability Theory
- Proof Gallery
tags:
- computational complexity
- graph coloring
- probabilistic method
- ramsey numbers
---

Define the Ramsey number $R(k,m)$ to be the minimum number $n$ of vertices required of the complete graph $K_n$ so that for any two-coloring (red, blue) of the edges of $K_n$ one of two things will happen:

	  * There is a red $k$-clique; that is, a complete subgraph of $k$ vertices for which all edges are red.
	  * There is a blue $m$-clique.

It is known that these numbers are always finite, but it is very difficult to compute them exactly.

**Problem: **Prove that the Ramsey number $R(m,m) > n$ whenever $n,m$ satisfy

$\displaystyle \binom{n}{m}2^{1-\binom{m}{2}} < 1$

**Solution: **Color the edges of $K_n$ uniformly at random (that is, each edge has probability 1/2 of being colored red). For any complete subgraph $G = K_m$, define by event $A_G$ the event that $G$ is monochromatic (its edges are either all red or all blue).

Now the probability that $A_G$ occurs (where $G$ is fixed ahead of time) is easy to compute:

$\displaystyle \textup{Pr}(A_G) = \left (\frac{1}{2} \right)^{\binom{m}{2} - 1} = 2^{1-\binom{m}{2}}$

Since there are $\binom{n}{m}$ possible subgraphs with $m$ vertices, The probability that for some $G$ the event $A_G$ occurs is at most

$\displaystyle \binom{n}{m}2^{1-\binom{m}{2}}$

Whenever this quantity is strictly less than 1 (by assumption) then there is a positive probability that no event $A_G$ will occur. That is, there is a positive probability that a random coloring will have no monochromatic subgraph $K_m$. So there must exist such a coloring, and the Ramsey number $R(m,m)$ must be larger than $n$. $\square$

**Discussion:** This proof (originally due to Erdős) is a classic example of the so-called probabilistic method. In particular, we create a probability space from the object we wish to study, and then we make claims about the probability of joint events.

While it seems quite simple in nature, the probabilistic method has been successfully applied to a wide variety of problems in mathematics. For instance, there is [an elegant proof](http://en.wikipedia.org/wiki/P/poly#Adleman.27s_theorem) in complexity theory that $\textup{BPP} \subset \textup{P/poly}$ which uses this same method. The probabilistic method has been applied to [loads of problems](http://en.wikipedia.org/wiki/Probabilistic_proofs_of_non-probabilistic_theorems) in combinatorics, number theory, and graph theory, and it forms the foundation of the area of random graph theory (which is the setting in which one studies social networks). Perhaps unsurprisingly, there is also a proof of the fundamental theorem of algebra that uses the probabilistic method.
