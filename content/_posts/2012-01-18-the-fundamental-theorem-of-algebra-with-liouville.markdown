---
author: jeremykun
date: 2012-01-18 04:37:45+00:00
draft: false
title: The Fundamental Theorem of Algebra (with Liouville)
type: post
url: /2012/01/17/the-fundamental-theorem-of-algebra-with-liouville/
categories:
- Analysis
- Proof Gallery
tags:
- complex analysis
- fundamental theorem of algebra
---

_This proof assumes knowledge of complex analysis, specifically the notions of analytic functions and Liouville's Theorem (which we will state below)._

[![](http://jeremykun.files.wordpress.com/2012/01/fta-cover.jpg)
](http://jeremykun.files.wordpress.com/2012/01/fta-cover.jpg)

The fundamental theorem of algebra has quite a few number of proofs (enough to fill a book!). In fact, it seems a new tool in mathematics can prove its worth by being able to prove the fundamental theorem in a different way. This series of proofs of the fundamental theorem also highlights how in mathematics there are many many ways to prove a single theorem, and in re-proving an established theorem we introduce new concepts and strategies. And perhaps most of all, we accentuate the unifying beauty of mathematics.

**Problem:** Let $p(x)$ be a non-constant polynomial with coefficients in $\mathbb{C}$. Prove $p(x)$ has a root in $\mathbb{C}$.

**Solution:** First, we note that Liouville's theorem states that any bounded entire function (has infinitely many derivatives, is analytic/holomorphic) $\mathbb{C} \to \mathbb{C}$ is constant. In other words, if we can find a number $M$ such that $|f(z)| < M$ for all $z \in \mathbb{C}$, then $f(z) = c$ for some constant $c$. The proof of this follows from [Cauchy's integral formula](http://en.wikipedia.org/wiki/Cauchy%27s_integral_formula), and we take it for granted here.

Suppose to the contrary that $p(x)$ is non-constant and has no roots. Then the function $f(z) = \frac{1}{p(z)}$ is defined everywhere on $\mathbb{C}$ and is analytic (the denominator is never zero by assumption). Now if

$\displaystyle p(z) = a_nz^n + a_{n-1}z^{n-1} + \dots + a_0$

Then we have

$\displaystyle |f(z)| = \left | \frac{1}{p(z)} \right | = \frac{1}{|z|^n} \frac{1}{\left | a_n + \frac{a_{n-1}}{z} + \dots + \frac{a_0}{z^n} \right |}$

Now each term in the denominator of the rightmost term, we have $\frac{a_i}{z^{n-i}} \to 0$ as $z \to \infty$. Therefore, $|f(z)| \to \frac{1}{|a_n||z|^n} \to 0$ as $z \to \infty$.

In particular, we may pick $R$ sufficiently large so that $|f(x)| < 1$ whenever $|z| > R$. On the other hand, since $f(z)$ is continuous on the closed, bounded disk centered at $0$ of radius $R$, $f(z)$ is also bounded whenever $|z| \leq R$. Together these two imply that $f(z)$ is bounded everywhere on $\mathbb{C}$, and so $f = 1/p = c$, so $p = 1/c$ is constant as well. This contradicts the assumption that $p$ is non-constant, and hence $p$ has a zero. $\square$
