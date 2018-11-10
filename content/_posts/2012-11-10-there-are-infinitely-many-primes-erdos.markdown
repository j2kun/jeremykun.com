---
author: jeremykun
date: 2012-11-10 19:48:52+00:00
draft: false
title: There are Infinitely Many Primes (Erdős)
type: post
url: /2012/11/10/there-are-infinitely-many-primes-erdos/
categories:
- Number Theory
- Proof Gallery
tags:
- primes
---

**Problem: **Prove there are infinitely many primes

**Solution: **Denote by $\pi(n)$ the number of primes less than or equal to $n$. We will give a lower bound on $\pi(n)$ which increases without bound as $n \to \infty$.

Note that every number $n$ can be factored as the product of a square free number $r$ (a number which no square divides) and a square $s^2$. In particular, to find $s^2$ recognize that 1 is a square dividing $n$, and there are finitely many squares dividing $n$. So there must be a largest one, and then $r = n/s^2$. We will give a bound on the number of such products $rs^2$ which are less than or equal to $n$.

If we want to count the number of square-free numbers less than $n$, we can observe that each square free number is a product of distinct primes, and so (as in [our false proof that there are finitely many primes](http://jeremykun.wordpress.com/2011/07/05/there-are-finitely-many-primes/)) each square-free number corresponds to a subset of primes. At worst, we can allow these primes to be as large as $n$ (for example, if $n$ itself is prime), so there are no more than $2^{\pi(n)}$ such subsets.

Similarly, there are at most $\sqrt{n}$ square numbers less than $n$, since if $x > \sqrt{n}$ then $x^2 > n$.

At worst the two numbers $r, s^2$ will be unrelated, so the total number of factorizations $rs^2$ is at most the product $2^{\pi(n)}\sqrt{n}$. In other words,


$2^{\pi(n)}\sqrt{n} \geq n$




The rest is algebra: divide by $\sqrt{n}$ and take logarithms to see that $\pi(n) \geq \frac{1}{2} \log(n)$. Since $\log(n)$ is unbounded as $n$ grows, so must $\pi(n)$. Hence, there are infinitely many primes.


**Discussion: **This is a classic analytical argument originally discovered by [P](http://en.wikipedia.org/wiki/Paul_Erd%C5%91s)**[aul Erdős](http://en.wikipedia.org/wiki/Paul_Erd%C5%91s). **One of the classical ways to investigate the properties of prime numbers is to try to estimate $\pi(n)$. In fact, much of the work of the famous number theorists of the past involved giving [good approximations](http://en.wikipedia.org/wiki/Prime_number_theorem) of $\pi(n)$ in terms of logarithms. This usually involved finding good upper bounds and lower bounds and limits. Erdős's proof is entirely in this spirit, although there are [much closer and more accurate](http://en.wikipedia.org/wiki/Prime_number_theorem#Bounds_on_the_prime-counting_function) lower and upper bounds. In this proof we include a lot of values which are not actually valid factorizations (many larger choices of $r, s^2$ will have their product larger than $n$). But for the purposes of proving there are infinitely many primes, this bound is about as elegant as one can find.
