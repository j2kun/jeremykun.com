---
author: jeremykun
date: 2011-07-20 00:10:00+00:00
draft: false
title: False Proof - The Reals are Countable
type: post
url: /2011/07/19/false-proof-the-reals-are-countable/
categories:
- Proof Gallery
- Set Theory
tags:
- axiom of choice
- countability
- false proof
- mathematics
- well-ordering
---

_It seems that false proofs are quickly becoming some of the most popular posts on M__ath ∩ Programming. I have been preparing exciting posts on applications of graph coloring, deck stacking, and serial killers. Unfortunately, each requires resources which exist solely on my home desktop, which is currently dismantled in California while I am on vacation in Costa Rica. Until I return from the tropics, I will continue with more of the ever -popular false proofs._

**Problem**: Show the real numbers $\mathbb{R}$ are countable. [For a primer on set theory and countability, see [our post on the subject](http://jeremykun.wordpress.com/2011/07/09/set-theory-a-primer/)].

**"Solution"**: Recall from our [post on well-orderings](http://jeremykun.wordpress.com/2011/06/14/well-orderings-and-search/) that every set has a well-order (assuming the axiom of choice). So $\mathbb{R}$ has a well-ordering. Call it $<$. Recall additionally that by the definition of a well-order, every nonempty subset of $\mathbb{R}$ has a least element with respect to $<$. We construct a sequence $x_i \in \mathbb{R}$ that uses this well-order in the following way:

Let $x_1$ be the smallest element of $\mathbb{R}$ with respect to $<$. Let $x_2$ be the smallest element of $\mathbb{R} - \left \{ x_1 \right \}$. Let $x_i$ be the smallest element of $\mathbb{R} - \left \{ x_1, x_2, \dots, x_{i-1} \right \}$.

Define $f: \mathbb{N} \to \mathbb{R}$ by $f(i)=x_i$. Clearly this map is injective, and we argue that it is surjective because any element $y \in \mathbb{R}$ is the smallest element of the subset of $\mathbb{R}$ that contains strictly greater elements with respect to $<$. So this map is a bijection, and the reals are countable.

**Explanation**: The reader should be extremely wary of this argument, because it does not only claim that the reals are countable. If the argument above held, then we could apply it to _any_ set (since every set has a well-order!). So something is definitely fishy here.

The problem with analyzing this argument is that the well-order of the reals is not known explicitly. However, our noses point us to recognize that the only place a flaw could exist is in the claim of surjectivity.  We prove the falsity of the above argument now, by proving that the same argument fails to show the integers $\mathbb{Z}$ are countable with respect to a well-order of our choosing.

Define a well-order $<_{\xi}$ on $\mathbb{Z}$ by letting non-positive numbers be larger than all positive numbers, and ordering negative numbers by increasing absolute value. In other words, we order the integers like $1,2, \dots, n, \dots, 0, -1, -2, \dots, -n, \dots$. We leave it as an exercise to the reader to prove $<_{\xi}$ is a well-order.

Notice that with the argument above, we never choose -1, or any negative number, as an $x_i$. Specifically, the sequence of $x_i$ is precisely the natural numbers. Hence, we cannot enumerate all of $\mathbb{Z}$ in this fashion. Clearly the argument fails for $\mathbb{R}$ as well.

This false proof is significant in that we get some intuition about well-orders. In particular, a function from the natural numbers to a set $S$ is also a way to "order" $S$. However, a well-order is more general and more expressive than a bijection from $\mathbb{N} \to S$, in that we can construct such an order on any set. As we have seen, with a well-order we don't have to worry about a contiguous sequence of elements from smallest to greatest. We are allowed the power to say "all of these guys are bigger than all of these guys," regardless of how many are in each group.

And, as always, with more power comes the responsibility to manage counter-intuitive results, either by accepting them through rigorous proof or rejecting false constructions like the one above.
