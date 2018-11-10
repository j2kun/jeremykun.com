---
author: jeremykun
date: 2012-02-03 04:42:11+00:00
draft: false
title: The Fundamental Theorem of Algebra (with Galois Theory)
type: post
url: /2012/02/02/the-fundamental-theorem-of-algebra-galois-theory/
categories:
- Analysis
- Field Theory
- Group Theory
- Proof Gallery
tags:
- fundamental theorem of algebra
- galois theory
- mathematics
---

_This post assumes familiarity with some basic concepts in abstract algebra, specifically the terminology of field extensions, and the classical results in Galois theory and group theory._

[![](http://jeremykun.files.wordpress.com/2012/01/fta-cover.jpg)
](http://jeremykun.files.wordpress.com/2012/01/fta-cover.jpg)

The fundamental theorem of algebra has quite a few number of proofs (enough to fill a book!). In fact, it seems a new tool in mathematics can prove its worth by being able to prove the fundamental theorem in a different way. This series of proofs of the fundamental theorem also highlights how in mathematics there are many many ways to prove a single theorem, and in re-proving an established theorem we introduce new concepts and strategies. And perhaps most of all, we accentuate the unifying beauty of mathematics.

**Problem:** Let $p(x) \in \mathbb{C}[x]$ be a non-constant polynomial. Prove $p(x)$ has a root in $\mathbb{C}$.

**Solution:** Without loss of generality, we may assume $p(x) \in \mathbb{R}[x]$ has _real_ coefficients, since if $p(x)$ has no roots, then neither does $p(x)\overline{p(x)}$,  where the bar represents complex conjugation. In particular, $p(x)\overline{p(x)}$ is invariant under complex conjugation, and all such quantities are real.

Let $F$ be the splitting field for $p(x)$ over $\mathbb{R}$, and embed $F$ in some algebraic closure of $\mathbb{R}$. Consider the extension $F(i)$. We claim $F(i)$ is Galois over $\mathbb{R}$; indeed, it is the splitting field of the separable polynomial constructed as the square-free part of $p(x)(x^2 + 1)$, i.e., the product of all linear factors of that polynomial.

Let $G$ be the Galois group of this extension over $\mathbb{R}$, and note that since $i \in F(i)$, we have an intermediate field $\mathbb{R} \subset F \subset F(i)$, so that the degree of the extension $F \subset F(i)$ is 2; so 2 divides the degree of $\mathbb{R} \subset F(i)$, and hence the order of the Galois group $G$ (recall $|\textup{Aut}_{k}(F)| = [F : k]$ for any Galois field extension).

Since $2 \big | |G|$, there is a Sylow 2-subgroup $H \subset G$, which by Sylow's theorem has odd index in $G$. By the Galois correspondence, $H$ corresponds to an intermediate field extension $\mathbb{R} \subset E \subset F(i)$ of odd degree (the degree is equal to the index of the subgroup $H$). Since every real polynomial of odd degree has a root in $\mathbb{R}$ (recall the intermediate value theorem), we see that there are no irreducible polynomials of odd degree $d > 1$, and hence there can be no separable extensions of degree $d$ (in particular, every such extension is finite and separable, and all such extensions are simple: the minimal polynomial of the singly-adjoined element must be irreducible). Hence, the degree of $E$ over $\mathbb{R}$ must be 1, i.e. $E = \mathbb{R}$ is a trivial extension.

Taking this back to the group, since the index $[G:H] = [E:\mathbb{R}]$ by the Galois correspondence, we have $[G:H] = 1$, and hence $G=H$ has order $2^n$ for some $n$. We note that since $\mathbb{C} = \mathbb{R}(i) \subset F(i)$, $F(i)$ is a Galois extension of $\mathbb{C}$. In particular the automorphism group $G' = \textup{Aut}_{\mathbb{C}}(F(i))$ is a subgroup of $G$, and hence has order $2^k$ for some $k$ dividing $n$. We will show that $k=0$, which occurs precisely when the extension is trivial (again, by virtue of being a Galois extension).

If $k > 0$, then we recall the corollary of Cauchy's theorem for $p$-groups, that $G'$ has a subgroup of order $2^j$ for any $j < k$, and in particular a subgroup of index 2. But such a subgroup corresponds to an intermediate field extension of degree 2. As with the case for odd extensions of $\mathbb{R}$, we note that there are no irreducible polynomials of degree 2 over $\mathbb{C}$: we have the [sing-a-long quadratic formula](http://www.youtube.com/watch?v=O8ezDEk3qCg) which constructs the roots in $\mathbb{C}$. So $k=0$, and hence $F(i) = \mathbb{C}$ is the splitting field of $p(x)$, and contains all of its roots. $\square$
