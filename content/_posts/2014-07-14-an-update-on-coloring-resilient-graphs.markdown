---
author: jeremykun
date: 2014-07-14 15:00:51+00:00
draft: false
title: An Update on "Coloring Resilient Graphs"
type: post
url: /2014/07/14/an-update-on-coloring-resilient-graphs/
categories:
- Computing Theory
- Graph Theory
tags:
- boolean satisfiability
- np-hard
- research
- resilience
---

[A while back](http://jeremykun.com/2014/02/21/on-coloring-resilient-graphs/) I announced a [preprint](http://arxiv.org/abs/1402.4376) of a paper on coloring graphs with certain resilience properties. I'm pleased to announce that it's been accepted to the [Mathematical Foundations of Computer Science 2014](http://www.inf.u-szeged.hu/mfcs2014/), which is being held in Budapest this year. Since we first published the preprint we've actually proved some additional results about resilience, and so I'll expand some of the details here. I think it makes for a nicer overall picture, and in my opinion it gives a little more justification that resilient coloring is interesting, at least in contrast to other resilience problems.

## Resilient SAT

Recall that a "resilient" yes-instance of a combinatorial problem is one which remains a yes-instance when you add or remove some constraints. The way we formalized this for SAT was by fixing variables to arbitrary values. Then the question is how resilient does an instance need to be in order to actually find a certificate for it? In more detail,

**Definition:** $r$-resilient $k$-SAT formulas are satisfiable formulas in $k$-CNF form (conjunctions of clauses, where each clause is a disjunction of three literals) such that for all choices of $r$ variables, every way to fix those variables yields a satisfiable formula.

For example, the following 3-CNF formula is 1-resilient:

$\displaystyle (a \vee b \vee c) \wedge (a \vee \overline{b} \vee \overline{c}) \wedge (\overline{a} \vee \overline{b} \vee c)$

The idea is that resilience may impose enough structure on a SAT formula that it becomes easy to tell if it's satisfiable at all. Unfortunately for SAT (though this is definitely not the case for coloring), there are only two possibilities. Either the instances are _so _resilient that they never existed in the first place (they're vacuously trivial), or the instances are NP-hard. The first case is easy: there are no $k$-resilient $k$-SAT formulas. Indeed, if you're allowed to fix $k$ variables to arbitrary values, then you can just pick a clause and set all its variables to false. So no formula can ever remain satisfiable under that condition.

The second case is when the resilience is strictly less than the clause size, i.e. $r$-resilient $k$-SAT for $0 \leq r < k$. In this case the problem of finding a satisfying assignment is NP-hard. We'll show this via a sequence of reductions which start at 3-SAT, and they'll involve two steps: increasing the clause size and resilience, and decreasing the clause size and resilience. The trick is in balancing which parts are increased and decreased. I call the first step the "blowing up" lemma, and the second part the "shrinking down" lemma.

## Blowing Up and Shrinking Down

Here's the intuition behind the blowing up lemma. If you give me a regular (unresilient) 3-SAT formula $\varphi$, what I can do is make a copy of $\varphi$ with a new set of variables and OR the two things together. Call this $\varphi^1 \vee \varphi^2$. This is clearly logically equivalent to the original formula; if you give me a satisfying assignment for the ORed thing, I can just see which of the two clauses are satisfied and use that sub-assignment for $\varphi$, and conversely if you can satisfy $\varphi$ it doesn't matter what truth values you choose for the new set of variables. And further you can transform the ORed formula into a 6-SAT formula in polynomial time. Just apply deMorgan's rules for distributing OR across AND.

Now the choice of a new set of variables allows us to give some resilient. If you fix one variable to the value of your choice, I can always just work with the other set of variables. Your manipulation doesn't change the satisfiability of the ORed formula, because I've added all of this redundancy. So we took a 3-SAT formula and turned it into a 1-resilient 6-SAT formula.

The idea generalizes to the blowing up lemma, which says that you can measure the effects of a blowup no matter what you start with. More formally, if $s$ is the number of copies of variables you make, $k$ is the clause size of the starting formula $\varphi$, and $r$ is the resilience of $\varphi$, then blowing up gives you an $[(r+1)s - 1]$-resilient $(sk)$-SAT formula. The argument is almost identical to the example above the resilience is more general. Specifically, if you fix fewer than $(r+1)s$ variables, then the pigeonhole principle guarantees that one of the $s$ copies of variables has at most $r$ fixed values, and we can just work with that set of variables (i.e., this small part of the big ORed formula is satisfiable if $\varphi$ was $r$-resilient).

The shrinking down lemma is another trick that is similar to the reduction from $k$-SAT to 3-SAT. There you take a clause like $v \vee w \vee x \vee y \vee z$ and add new variables $z_i$ to break up the clause in to clauses of size 3 as follows:

$\displaystyle (v \vee w \vee z_1) \wedge (\neg z_1 \vee x \vee z_2) \wedge (\neg z_2 \vee y \vee z)$

These are equivalent because your choice of truth values for the $z_i$ tell me which of these sub-clauses to look for a true literal of the old variables. I.e. if you choose $z_1 = T, z_2 = F$ then you have to pick either $y$ or $z$ to be true. And it's clear that if you're willing to double the number of variables (a linear blowup) you can always get a $k$-clause down to an AND of 3-clauses.

So the shrinking down reduction does the same thing, except we only split clauses in half. For a clause $C$, call $C[:k/2]$ the first half of a clause and $C[k/2:]$ the second half (you can see how my Python training corrupts my notation preference). Then to shrink a clause $C_i$ down from size $k$ to size $\lceil k/2 \rceil + 1$ (1 for the new variable), add a variable $z_i$ and break $C_i$ into

$\displaystyle (C_i[:k/2] \vee z_i) \wedge (\neg z_i \vee C[k/2:])$

and just AND these together for all clauses. Call the original formula $\varphi$ and the transformed one $\psi$. The formulas are logically equivalent for the same reason that the $k$-to-3-SAT reduction works, and it's already in the right CNF form. So resilience is all we have to measure. The claim is that the resilience is $q = \min(r, \lfloor k/2 \rfloor)$, where $r$ is the resilience of $\varphi$.

The reason for this is that if all the fixed variables are old variables (not $z_i$), then nothing changes and the resilience of the original $\phi$ keeps us safe. And each $z_i$ we fix has no effect except to force us to satisfy a variable in one of the two halves. So there is this implication that if you fix a $z_i$ you have to also fix a regular variable. Because we can't guarantee anything if we fix more than $r$ regular variables, we'd have to stop before fixing $r$ of the $z_i$. And because these new clauses have size $k/2 + 1$, we can't do this more than $k/2$ times or else we risk ruining an entire clause. So this give the definition of $q$. So this proves the shrinking down lemma.

## Resilient SAT is always hard

The blowing up and shrinking down lemmas can be used to show that $r$-resilient $k$-SAT is NP-hard for all $r < k$. What we do is reduce from 3-SAT to an $r$-resilient $k$-SAT instance in such a way that the 3-SAT formula is satisfiable if and only if the transformed formula is resiliently satisfiable.

What makes these two lemmas work together is that shrinking down shrinks the clause size just barely less than the resilience, and blowing up increases resilience just barely more than it increases clause size. So we can combine these together to climb from 3-SAT up to some high resilience and satisfiability, and then iteratively shrink down until we hit our target.

One might worry that it will take an exponential number of reductions (or a few reductions of exponential size) to get from 3-SAT to the $(r,k)$ of our choice, but we have a construction that does it in at most four steps, with only a linear initial blowup from 3-SAT to $r$-resilient $3(r+1)$-SAT. Then, to deal with the odd ceilings and floors in the shrinking down lemma, you have to find a suitable larger $k$ to reduce to (by padding with useless variables, which cannot make the problem _easier_). And you choose this $k$ so that you only need at most two applications of shrinking down to get to $(k-1)$-resilient $k$-SAT. Our preprint has the gory details (which has an inelegant part that is not worth writing here), but in the end you show that $(k-1)$-resilient $k$-SAT is hard, and since that's the maximal amount of resilience before the problem becomes vacuously trivial, all smaller resilience values are also hard.

## So how does this relate to coloring?

I'm happy about this result not just because it answers an open question I'm honestly curious about, but also because it shows that resilient coloring is more interesting. Basically this proves that satisfiability is so hard that no amount of resilience can make it easier in the worst case. But coloring has a gradient of difficulty. Once you get to order $k^2$ resilience for $k$-colorable graphs, the coloring problem can be solved efficiently by a greedy algorithm (and it's not a vacuously empty class of graphs). Another thing on the side is that we use the hardness of resilient SAT to get the hardness results we have for coloring.

If you really want to stretch the implications, you might argue that this says something like "coloring is somewhat easier than SAT," because we found a quantifiable axis along which SAT remains difficult while coloring crumbles. The caveat is that fixing colors of vertices is not _exactly_ comparable to fixing values of truth assignments (since we are fixing lots of instances by fixing a variable), but at least it's something concrete.

Coloring is still mostly open, and recently I've been going to talks where people are discussing startlingly similar ideas for things like Hamiltonian cycles. So that makes me happy.

Until next time!
