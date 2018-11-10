---
author: jeremykun
date: 2011-07-16 14:49:32+00:00
draft: false
title: False Proof - All Horses are the Same Color
type: post
url: /2011/07/16/false-proof-all-horses-are-the-same-color/
categories:
- Proof Gallery
tags:
- false proof
- induction
---

**Problem**: Show that all horses are of the same color.

**"Solution"**: We will show, by induction, that for any set of $n$ horses, every horse in that set has the same color. Suppose $n=1$, this is obviously true. Now suppose for all sets of $n$ horses, every horse in the set has the same color. Consider any set $H$ of $n+1$ horses. We may pick a horse at random, $h_1 \in H$, and remove it from the set, getting a set of $n$ horses. By the inductive hypothesis, all of the $n$ remaining horses are the same color.

On the other hand, if we remove a different horse $h_2 \in H$, we again get a set of $n$ horses which are all the same color. Let us call this color "brown," just to give it a name. In particular, $h_1$ is brown. But when we removed $h_1$, we got that all the remaining horses had the same color as $h_2$. So $h_2$ must also be brown. Hence, all horses in $H$ are brown.

**![](http://ourclassme.files.wordpress.com/2011/03/hr.jpg)
Explanation**: The argument here is valid for almost all $n$. For large $n$, it is a very natural argument that follows from the inductive hypothesis. However, it fails for $n=2$ (and this is the only time it fails). By having only two horses, we cannot conclude that the removed horses have the same color, because there aren't any horses remaining in $H$ to apply the transitivity of "having the same color as."

This false proof highlights the danger of neglecting the base case of an inductive argument. Here the true base case was not $n=1$, but rather $n=2$. Since the base case is false, we should have prudently stopped our argument there before embarrassing ourselves.
