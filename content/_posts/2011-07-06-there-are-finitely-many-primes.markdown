---
author: jeremykun
date: 2011-07-06 02:01:48+00:00
draft: false
title: False Proof - There are Finitely Many Primes
type: post
url: /2011/07/05/there-are-finitely-many-primes/
categories:
- Number Theory
- Proof Gallery
- Set Theory
tags:
- countability
- false proof
- mathematics
- power set
- primes
---

**Problem**: Show there are finitely many primes.

**"Solution"**: Suppose to the contrary there are infinitely many primes. Let $P$ be the set of primes, and $S$ the set of square-free natural numbers (numbers whose prime factorization has no repeated factors). To each square-free number $n \in S$ there corresponds a subset of primes, specifically the primes which make up $n$'s prime factorization. Similarly, any subset $Q \subset P$ of primes corresponds to a number in $S$, since we can simply multiply all numbers in $Q$ together to get a square-free number.

Thus we have shown a bijection between $S$ and the power set of $P$, but the power set of an infinite set is uncountable. Hence, there are uncountably many square-free natural numbers, a contradiction. Hence there are only finitely many primes.

**Explanation**: The problem here lies in the bijection. Take any subset of primes which is infinitely large. Assuming there are infinitely primes to begin with, this is a valid step, since we may consider the subset of all primes, $P \subset P$. However, the product of all primes in an infinite subset of positive numbers is infinitely large, and hence cannot correspond to a square-free (finite) number. In other words, the set of _finite _subsets of an infinite set is countable.

This illuminates why the power set of an infinite set is interesting. Specifically, the only things which make it "big" are the infinite subsets. So these should be our primary concern.
