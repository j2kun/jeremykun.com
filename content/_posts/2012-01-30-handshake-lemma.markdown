---
author: jeremykun
date: 2012-01-30 04:24:31+00:00
draft: false
title: Handshake Lemma
type: post
url: /2012/01/29/handshake-lemma/
categories:
- Combinatorics
- Graph Theory
- Proof Gallery
tags:
- mathematics
---

**Problem**: Prove or disprove: at a party of $n$ people, there must be an even number of people who have an odd number of friends at the party.

**Solution**: Let $P$ be the set of all people, and for any person $p \in P$, let $d(p)$ be the number of friends that person has. Let $f$ be the total number of friendships between pairs of people at the party. Since each friendship among two friends at the party concerns exactly two people, we see that the following is true:

$\displaystyle \sum_{p \in P} d(p) = 2f$

In other words, counting up all of the number of friends that each person has will always be twice the number of total friendships. In particular, this number is always even. If there were an odd number of people with an odd number of friends at the party, and everyone else had an even number of friends, then the total number $\sum_{p \in P} d(p)$ would necessarily be odd.

Hence, there can only be an even number of people with an odd number of friends at the party. $\square$

**Discussion**: This is a proof by "double-counting," so to speak. Double counting proves an identity by showing that each side of the equality can be thought of as a different way of counting elements in the same set. In the above proof, we are counting the set of one-sided friendships in two different ways.

This technique comes up all over mathematics (particularly in combinatorics, the field of maths concerned with counting things). We can relate this to graph theory (see our [very basic introduction to the topic](http://jeremykun.wordpress.com/2011/06/26/teaching-mathematics-graph-theory/)), by seeing that a party is just a graph where the vertices are people and the edges are friendships. This theorem then says that for any graph, the sum of the degrees of each vertex is twice the number of edges, and hence always even.

Double counting has been used to prove a number of identities, and it can even be used to prove something as interesting as [Fermat's Little Theorem](http://en.wikipedia.org/wiki/Proofs_of_Fermat%27s_little_theorem#Proof_by_counting_necklaces) (which has quite a few proofs, and quite a few uses!) and [counting the number of trees made from a set of n distinct vertices](http://en.wikipedia.org/wiki/Double_counting_(proof_technique)#Counting_trees) (it's quite large: $O(n^n)$ in fact!).
