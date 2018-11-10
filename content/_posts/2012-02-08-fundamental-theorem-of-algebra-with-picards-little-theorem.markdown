---
author: jeremykun
date: 2012-02-08 03:30:12+00:00
draft: false
title: Fundamental Theorem of Algebra (With Picard's Little Theorem)
type: post
url: /2012/02/07/fundamental-theorem-of-algebra-with-picards-little-theorem/
categories:
- Analysis
- Proof Gallery
- Topology
tags:
- complex analysis
- fundamental theorem of algebra
- mathematics
---

_This post assumes familiarity with some basic concepts in complex analysis, including continuity and entire (everywhere complex-differentiable) functions. This is likely the simplest proof of the theorem (at least, among those that this author has seen), although it stands on the shoulders of a highly nontrivial theorem._

[![](http://jeremykun.files.wordpress.com/2012/01/fta-cover.jpg)
](http://jeremykun.files.wordpress.com/2012/01/fta-cover.jpg)

The fundamental theorem of algebra has quite a few number of proofs (enough to fill a book!). In fact, it seems a new tool in mathematics can prove its worth by being able to prove the fundamental theorem in a different way. This series of proofs of the fundamental theorem also highlights how in mathematics there are many many ways to prove a single theorem, and in re-proving an established theorem we introduce new concepts and strategies. And perhaps most of all, we accentuate the unifying beauty of mathematics.

**Problem:** Let $p(z): \mathbb{C} \to \mathbb{C}$ be a non-constant polynomial. Prove $p(z)$ has a root in $\mathbb{C}$.

**Solution:** [Picard's Little Theorem](http://en.wikipedia.org/wiki/Picard_theorem) states that any entire function $\mathbb{C} \to \mathbb{C}$ whose range omits two distinct points must be constant. ([See here](http://www.proofwiki.org/wiki/Picard%27s_Theorem#Proof_of_the_little_Picard_theorem_using_the_universal_cover_of_the_twice-punctured_plane) for a proof sketch, and other notes)

Suppose to the contrary that $p$ has no zero. We claim $p$ also does not achieve some number in the set $\left \{ \frac{1}{k} : k \in \mathbb{N} \right \}$. Indeed, if it achieved all such values, we claim continuity would provide a zero. First, observe that as $p(z)$ is unbounded for large enough $|z|$, we may pick a $c \in \mathbb{R}$ such that $|p(z)| > 1$ whenever $|z| > c$. Then the points $z_k$ such that $p(z) = 1/k$ all lie within the closed disk of radius $c$. Because the set is closed and the complex plane is a complete metric space, we see that the sequence of $z_k$ converges to some $z$, and by continuity $p(z) = 0$.

In other words, no such sequence of $z_k$ can exist, and hence there is some $1/k$ omitted in the range of $p(z)$. As polynomials are entire, Picard's Little theorem applies, and we conclude that $p(z)$ is constant, a contradiction. $\square$
