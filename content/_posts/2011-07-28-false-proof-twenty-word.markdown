---
author: jeremykun
date: 2011-07-28 23:03:27+00:00
draft: false
title: False Proof - All Numbers are Describable in at Most Twenty Words
type: post
url: /2011/07/28/false-proof-twenty-word/
categories:
- Logic
- Proof Gallery
- Set Theory
tags:
- false proof
- kolmogorov complexity
- mathematics
- well-ordering
---

**Problem**: Show that every natural number can be unambiguously described in fewer than twenty words.

**"Solution"**: Suppose to the contrary that not every natural number can be so described. Let $S$ be the set of all natural numbers which are describable in fewer than twenty words. Consider $R = \mathbb{N}-S$, the set of all words which cannot be described in fewer than twenty words.

Since $R$ is a subset of the natural numbers, which is well-ordered, it has a unique smallest element which we call $r$. Now, we may describe $r$ unambiguously with the sentence: "the smallest natural number which cannot be unambiguously described in fewer than twenty words." Since this description uses only fourteen words, we see that $r \in S$, a contradiction. Hence, $R$ must be the empty set. $\square$

**Explanation**: Let's analyze this a bit further. Suppose that every number were indeed unambiguously describable in fewer than twenty words. It should be obvious that this admits only finitely many descriptions of infinitely many numbers!

In particular, let there be $n$ words in the English language, which we for the sake of argument say is the number of words in the Oxford English Dictionary. Then there are $\displaystyle \sum \limits_{k=1}^{20} n^k$ different phrases. This is a large number, but it is indeed finite. Even if every phrase describes a natural number, there's no way that we could get them all! This proof is clearly nonsense.

This apparent paradox is in the same vein as Russell's paradox, which we cover at the end of our [set theory primer](http://jeremykun.wordpress.com/2011/07/09/set-theory-a-primer/). Indeed, in its paradox form, this problem is sometimes called [the Richard-Berry paradox](http://en.wikipedia.org/wiki/Berry_paradox). The problem is with what kinds of sets we construct. While with Russell's paradox, the problem was with elements of our set, here it is with the propositions used to determine membership. This proof gives evidence that the English language (and any human language, really), is not rigorous enough for the purposes of mathematics. It also convinces us that naive set theory is problematic.

We find the meat of the problem when we finally get down to the definition of a description. In short (and I don’t want to spoil upcoming content on this blog), a description of a number is a program which computes the number (on some fixed universal Turing machine $U$). Note that this assumes that whatever a human can compute a computer can too, which is a controversial statement better known as the [Church-Turing Thesis](http://en.wikipedia.org/wiki/Church%E2%80%93Turing_thesis). If we further define a number’s “definition” as the shortest program which computes it, then this statement transforms into “x is the smallest integer whose definition has fewer than 100 characters.” As it turns out, when this English description is appropriately reformulated on a Turing machine, it is not an effective description: the statement is undeciable. In fact, once we get into the theory of [Kolmogorov complexity](http://jeremykun.com/2012/04/21/kolmogorov-complexity-a-primer/), we will find that Berry’s paradox can be used to prove [Gödel’s incompleteness theorem](http://en.wikipedia.org/wiki/G%C3%B6del's_incompleteness_theorems)!

The problem of description is a very deep and historically debated one. The various approaches and sub-fields are encapsulated in the study of [information theory](http://en.wikipedia.org/wiki/Information_theory). One such framework for descriptions is provided by Kolmogorov complexity, which we are diligently working toward understanding. Keep an eye out for our future primer on the subject, which we will write as extra background for the already-written post on [low-complexity art](http://jeremykun.wordpress.com/2011/07/06/low-complexity-art/) and unknown future topics.
