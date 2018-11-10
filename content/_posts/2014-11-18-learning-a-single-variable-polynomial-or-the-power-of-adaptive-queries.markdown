---
author: jeremykun
date: 2014-11-18 15:00:18+00:00
draft: false
title: Learning a single-variable polynomial, or the power of adaptive queries
type: post
url: /2014/11/18/learning-a-single-variable-polynomial-or-the-power-of-adaptive-queries/
categories:
- Algorithms
- Learning Theory
- Linear Algebra
- Program Gallery
- Proof Gallery
tags:
- adaptive queries
- learning theory
- polynomial identity testing
- polynomial interpolation
---

**Problem:** Alice chooses a secret polynomial $p(x)$ with nonnegative integer coefficients. Bob wants to discover this polynomial by querying Alice for the value of $p(x)$ for some integer $x$ of Bob's choice. What is the minimal number of queries Bob needs to determine $p(x)$ exactly?

**Solution: **Two queries. The first is $p(1)$, and if we call $N = p(1) + 1$, then the second query is $p(N)$.

To someone who is familiar with polynomials, this may seem shocking, and I'll explain why it works in a second. After all, it's very easy to prove that if Bob gives Alice all of his queries at the same time (if the queries are not _adaptive_), then it's impossible to discover what $p(x)$ is using fewer than $\textup{deg}(p) + 1$ queries. This is due to a fact called _polynomial interpolation_, which we've seen on this blog before in the context of [secret sharing](http://jeremykun.com/2014/06/23/the-mathematics-of-secret-sharing/). Specifically, there is a unique single-variable degree $d$ polynomial passing through $d+1$ points (with distinct $x$-values). So if you knew the degree of $p$, you could determine it easily. But Bob doesn't know the degree of the polynomial, and there's no way he can figure it out without adaptive queries! Indeed, if Bob tries and gives a set of $d$ queries, Alice could have easily picked a polynomial of degree $d+1$. So it's literally impossible to solve this problem without adaptive queries.

The lovely fact is that once you allow adaptiveness, the number of queries you need doesn't even depend on the degree of the secret polynomial!

Okay let's get to the solution. It was crucial that our polynomial had nonnegative integer coefficients, because we're going to do a tiny bit of number theory. Let $p(x) = a_0 + a_1 x + \dots + a_d x^d$. First, note that $p(1)$ is exactly the sum of the coefficients $\sum_i a_i$, and in particular $p(1) + 1$ is larger than any single coefficient. So call this $N$, and query $p(N)$. This gives us a number $y_0$ of the form


$\displaystyle y_0 = a_0 + a_1N + a_2N^2 + \dots + a_dN^d$




And because $N$ is so big, we can compute $a_0$ easily by computing $y_0 \mod N$. Now set $y_1 = (y_0 - a_0) / N$, and this has the form $a_1 + a_2N + \dots + a_dN^{d-1}$. We can compute modulus again to get $a_1$, and repeat until we have all the coefficients. We'll stop once we get a $y_i$ that is zero.


[Addendum 2018-02-14: [implementation on github](https://github.com/j2kun/guess-the-polynomial/)]


As a small technical note, this is a polynomial-time algorithm in the number of bits needed to write down $p(x)$. So this demonstrates the power of adaptive queries: we get from something which is uncomputable with any number of queries to something which is efficiently computable with a constant number of queries.




The obvious follow-up question is: can you come up with an efficient algorithm if we allow the coefficients to be negative integers?
