---
author: jeremykun
date: 2011-07-10 01:14:59+00:00
draft: false
title: Set Theory - A Primer
type: post
url: /2011/07/09/set-theory-a-primer/
categories:
- Logic
- Primers
- Set Theory
tags:
- axiom of choice
- bijections
- countability
- functions
- mathematics
- power set
- primer
---

It's often that a student's first exposure to rigorous mathematics is through set theory, as originally studied by [Georg Cantor](http://en.wikipedia.org/wiki/Georg_Cantor). This means we will not treat set theory axiomatically (as in [ZF set theory](http://en.wikipedia.org/wiki/Zermelo-Fraenkel_set_theory)), but rather we will take the definition of a set for granted, and allow any operation to be performed on a set. This will be clear when we present examples, and it will be clear why this is a bad idea when we present paradoxes.

## The Basics of Sets

**Definition**: A _set _$S$ is a collection of distinct objects, each of which is called an _element_ of S. For a potential element $x$, we denote its membership in $S$ and lack thereof by the infix symbols $\in, \notin$, respectively. The proposition $x \in S$ is true if and only if $x$ is an element of $S$.

**Definition**: The _cardinality_ of $S$, denoted $|S|$, is the number of elements in S.

The elements of a set can in principal be anything: numbers, equations, cats, morals, and even (especially) other sets. There is no restriction on their size, and the order in which we list the objects is irrelevant. For now, we will stick to sets of numbers and later we will move on to sets of other sets.

There are many ways to construct sets, and for finite sets it suffices to list the objects:

$S = \left \{ 0, 2,4,6,8,10 \right \}$

Clearly this set has cardinality six. The left and right curly braces are standard notation for the stuff inside a set. Another shorter construction is to simply state the contents of a set (let $S$ be the set of even numbers between 0 and 10, inclusive). Sometimes, it will be very important that we construct the sets in a more detailed way than this, because, as we will see, sets can become rather convoluted.

We may construct sets using an implied pattern, i.e. for the positive evens:

$E = \left \{ 2, 4, 6, 8, \dots \right \}$

For now, we simply allow that this set has infinite cardinality, though we will revisit this notion in more detail later. In this way we define two basic sets of numbers:

$\mathbb{N} = \left \{ 1, 2, 3, \dots \right \} \\ \mathbb{Z} = \left \{ 0, -1, 1, -2, 2, \dots \right \}$

We name $\mathbb{N}$ the _natural numbers_, and $\mathbb{Z}$ the _integers_. Yet another construction allows us to populate a set with all values that satisfy a particular equation or proposition. We denote this $\left \{ \textup{variable} | \textup{condition} \right \}$. For example, we may define $\mathbb{Q}$, the _rational numbers_ (fractional numbers) as follows:

$\displaystyle \mathbb{Q} = \left \{ \frac{p}{q} | p \in \mathbb{Z} \textup{ and } q \in \mathbb{Z} q \neq 0 \right \}$

This is not quite a complete description of how rational numbers work: some fractions are "equivalent" to other fractions, like 2/4 and 1/2. There is an additional piece of data called a "relation" that's imposed on this set, and any two things which are related are considered equivalent. We're not going to go into the details of this, but the interested reader should look up an [equivalence relation](http://en.wikipedia.org/wiki/Equivalence_relation).

Next, we want to describe certain pieces of sets:

**Definition**: A set $R$ is a _subset _of a set $S$, denoted $R \subset S$, if all elements of $R$ are in $S$. i.e., for all $x, x \in R$ implies $x \in S$.

And we recognize that under our standard equality of numbers (i.e. $\frac{4}{1} = 4$), we have $\mathbb{N} \subset \mathbb{Z} \subset \mathbb{Q}$.

We may now define equality on sets, extending the natural idea that two sets are equal if they contain precisely the same elements:

**Definition**: Two sets $R,S$ are equal if $R \subset S$ and $S \subset R$.

A natural set to construct now is the _power set _of a given set:

**Definition**: the _power set_ of $S$, denoted $P(S)$, is the set of all subsets of $S$. i.e. $P(S) = \left \{ R | R \subset S \right \}$.

Elements of this set are sets themselves, and there are two trivial, yet important sets to recognize are in $P(S)$, namely $S \subset S$ itself and $\left \{ \right \} \subset S$, the _empty set_ which contains no elements, is vacuously a subset of every set.

For a finite set $S$, power sets are strictly larger in size, since there exists a _singleton_ set $\left \{ x \right \} \in P(S)$ for each $x \in S$. As an exercise for the reader, determine the size of $P(S)$ for any finite set $S$, expressed in terms of $|S|$. For infinite sets, we simply admit that their power sets are also infinite, since we don't yet have a way to describe "larger" infinities.

## Building Sets From Other Sets

We have a couple of nice operations we may define on sets, which are rather trivial to define.

**Definition**: The _union_ of two sets $R,S$, denoted $R \cup S$, is $\left \{ x | x \in S \textup{ or } x \in R \right \}$.

**Definition**: The _intersection_ of two sets $R,S$, denoted $R \cap S$, is $\left \{ x | x \in S \textup{ and } x \in R \right \}$.

As an exercise, try to prove that $|S \cup R| = |S| + |R| - |S \cap R|$.

The next definition requires one to remember what an _ordered tuple_ $(a_1,a_2, \dots , a_n)$ is. Specifically, an ordered pair is just like a set which allows for repetition and respects the presented order of elements. So $(a,b) \neq (b,a) \neq (a,a,b)$.

**Definition**: The _direct product _(or simply _product_) of two sets $R,S$, denoted $R \times S$, is $\left \{ (x,y) | x \in R \textup{ and } y \in S \right \}$.

This is just like in defining the Cartesian Plane $\mathbb{R}^2 = \mathbb{R} \times \mathbb{R}$ as ordered pairs of real numbers. We can extend this even further by defining $\mathbb{S}^n$ to be the set of all $n$-tuples of elements in $S$.

## Functions, and Their -Jections

Now that we have sets and ways to build interesting sets, we may define mathematical objects which do stuff with them.

**Definition**: A _relation_ $\sim$ on $R$ and $S$, is a subset of $R \times S$. Denotationally, we write $a \sim b$ as shorthand for $(a,b) \in \sim $.

Relations are natural generalizations of $=$ on numbers. In general relations need no additional properties, but they are not very interesting unless they do. For more discussion on relations, we point the reader to [the Wikipedia page on _equivalence relations_](http://en.wikipedia.org/wiki/Equivalence_relation). As an exercise to the reader, prove that set equality (defined above) is an equivalence relation, as expected.

Now, we get to the meat of our discussion on sets: functions.

**Definition**: A _function _$f : S \to R$ is a relation on $S$ and $R$, a subset of $S \times R$, with the additional properties that for each $x \in S$, there is exactly one element of the form $(x, \cdot ) \in f$.

Colloquially, functions 'accept' a value from $S$ and output something in $R$. This is why we may only have one ordered pair for each $x \in S$, because functions are deterministic. Furthermore, we must be able to put every value from $S$ into our function, so no values $x \in S$ may be without a corresponding element of $f$.

We have special notation for functions, which was established long before set theory was invented. If $x \in S$, we write $f(x)$ to denote the corresponding element $y$ in $(x,y) \in f$. In addition, we say that a value $x$ _maps to_ $y$ to mean $f(x)=y$. If the function is implicitly understood, we sometimes just write $x \mapsto y$. Then we have the following definitions:

**Definition**: The _domain_ of a function $f: S \to R$, sometimes denoted $\textup{dom}(f)$, is the set of input values $S$. The _codomain_, denoted $\textup{codom}(f)$, is the set $R$. Since not every value in $R$ must be in a pair in $f$, we call the subset of values of $R$ which are produced by some input in $S$ the _range_ of $f$. Rigorously, the range of $f$ is $\left \{ f(x) | x \in S \right \}$.

Now we may speak of some "interesting" functions:

**Definition**: A function $f : S \to R$ is a _surjection_ if its range is equal to its codomain. In other words, for every $y \in R$, there is some $x \in S$ with $f(x) = y$, or, equivalently, $f(S) = R$.

Note that $f$ being a surjection on finite sets implies that the domain is at least as big as the codomain. Though it seems trivial, we can use functions in this way to reason about the cardinalities of their domains and codomains.

**Definition**: A function $f : S \to R$ is an _injection _if no two different values $x \in S$ map to the same $y \in R$. In other words, if $f(a) = f(b)$, then $a=b$.

Similarly, for finite domains/codomains an injection forces the codomain to be at least as big as the domain in cardinality.

Now, we may combine the two properties to get a very special kind of function.

**Definition**: A function $f: S \to R$ is a _bijection _if it is both a surjection and an injection.

A bijection specifically represents a "relabeling" of a given set, in that each element in the domain has exactly one corresponding element in the codomain, and each element in the codomain has exactly one corresponding element in the domain. Thus, the bijection represents changing the label $x$ into the label $f(x)$.

Note that for finite sets, since a bijection is both a surjection and an injection, the domain and codomain of a bijection must have the same cardinality! What's better, is we can extend this to infinite sets.

## To Infinity, and Beyond! (Literally)

**Definition**: Two infinite sets have equal cardinality if there exists a bijection between them.

Now we will prove that two different infinite sets, the natural numbers and the integers, have equal cardinality. This is surprising, because despite the fact that the sets are not equal, one is a subset of the other and they have equal cardinality! So here we go.

Define $f : \mathbb{N} \to \mathbb{Z}$ as follows. Let $f(1) = 0, f(2) = 1, f(3) = -1 \dots$. Continuing in this way, we see that $f(2k+1) = -k$, and $f(2k) = k$ for all $k \in \mathbb{N}$. This is clearly a bijection, and hence $|\mathbb{N}| = |\mathbb{Z}|$.

We can extend this to any bijection between an infinite set $S$ of positive numbers and the set $\left \{ \pm x | x \in S \right \}$.

Let's try to push bijections a bit further. Let's see if we can construct a bijection between the natural numbers and the positive rationals (and hence the set of all rationals). If integers seemed bigger than the naturals, then the rational numbers must be truly huge. As it turns out, the rationals also have cardinality equal to the natural numbers!

It suffices to show that the natural numbers are equal in cardinality to the nonnegative rationals. Here is a picture describing the bijection:

![](http://upload.wikimedia.org/wikipedia/commons/thumb/6/6f/Pairing_natural.svg/429px-Pairing_natural.svg.png)

We arrange the rationals into a grid, such that each blue dot above corresponds to some $\frac{p}{q}$, where $p$ is the x-coordinate of the grid, and $q$ is the y-coordinate. Then, we assign to each blue dot a nonnegative integer in the diagonal fashion described by the sequence of arrows. Note these fractions are not necessarily in lowest terms, so some rational numbers correspond to more than one blue dot. To fix this, we simply eliminate the points $(p,q)$ for which their greatest common divisor is not 1. Then, in assigning the blue dots numbers, we just do so in the same fashion, skipping the places where we deleted bad points.

This bijection establishes that the natural numbers and rationals have identical cardinality. Despite how big the rationals seem, they are just a relabeling of the natural numbers! Astounding.

With this result it seems like _every _infinite set has cardinality equal to the natural numbers. It should be totally easy to find a bijection between the naturals and the real numbers $\mathbb{R}$.

Unfortunately, try as we might, no such bijection exists. This was a huge result proven by Georg Cantor in his study of infinite sets, and its proof has become a staple of every mathematics education, called Cantor's Diagonalization Proof.

First, we recognize that every real number has a representation in base 2 as an infinite sequence of 0's and 1's. Thus, if there were such a bijection between the natural numbers and reals, we could list the reals in order of their corresponding naturals, as:

$1 \mapsto d_{1,1}d_{1,2}d_{1,3} \dots \\ 2 \mapsto d_{2,1}d_{2,2}d_{2,3} \dots \\ 3 \mapsto d_{3,1}d_{3,2}d_{3,3} \dots$
$\vdots$

Here each $d_{i,j} \in \left \{ 0,1 \right \}$ corresponds to the $j$th digit of the $i$th number in the list. Now we may build a real number $r = d_{1,1}d_{2,2}d_{3,3} \dots$, the diagonal elements of this matrix. If we take $r$ and flip each digit from a 0 to a 1 and vice versa, we get the complement of $r$, call it $r'$. Notice that $r'$ differs from every real number at some digit, because the $i$th real number shares digit $i$ with $r$, and hence differs from $r'$ at the same place. But $r'$ is a real number, so it must occur somewhere in this list! Call that place $k \mapsto r'$. Then, $r'$ differs from $r'$ at digit $k$, a contradiction.

Hence, no such bijection can exist. This is amazing! We have just found two infinite sets which _differ_ in size! Even though the natural numbers are infinitely large, there are so many mind-bogglingly more real numbers that it is a larger infinity! We need new definitions to make sense of this:

**Definition**: An infinite set $S$ is _countably infinite_ if there exists a bijection $\mathbb{N} \to S$. If no such bijection exists, we call it _uncountably infinite_, or just _uncountable_.

Georg Cantor went on to [prove this in general](http://en.wikipedia.org/wiki/Cantor%27s_theorem), that there cannot exist a bijection from a set onto its power set (we may realize the reals as the power set of the naturals by a similar decimal expansion). He did so simply by extending the diagonalization argument. But since we are dealing with infinite sets, we need even more definitions of "how hugely infinite" these infinite sets can be. These new measures of set cardinality were also invented by Cantor, and they are called [transfinite numbers](http://en.wikipedia.org/wiki/Transfinite_number). Their investigation is beyond the scope of this post, but we encourage the reader to follow up on this fascinating subject.

We have still only scratched the surface of set theory, and we have even left out a lot of basic material to expedite our discussion of uncountability. There is a huge amount of debate that resulted from Cantor's work, and it inspired many to further pick apart the foundations of mathematics, leading to more rigorous formulations of set theory, and extensions or generalizations such as category theory.

## Sets of Sets of Sets, and so on Ad Insanitum

We wrap up this post with a famous paradox, which makes one question whether all of the operations performed in set theory are justified. It is called Russell's Paradox, after Bertrand Russell.

Suppose we define a set $S$, which contains itself as an element. This does not break any rules of Cantor's set theory, because we said a set could be any collection of objects. We may even speak of the set of all sets which contain themselves as elements.

Now let us define the set of all sets which _do not_ contain themselves. Call this set $X$. It must be true that either $X \in X$ or $X \notin X$. If $X \in X$, then $X$ is contained in itself, obviously, but then by the definition of $X$, it does not contain itself as an element. This is a contradiction, so $X \notin X$. However, if $X \notin X$, then $X$ satisfies the definition of a set which does not contain itself, so $X \in X$. Again, a contradiction.

This problem has no resolution within Cantor's world of sets. For this reason (and other paradoxes based on wild constructions of sets), many have come to believe that Cantor's set theory is not well-founded. That is not to say his arguments and famous results are wrong, but rather that they need to be reproved within a more constrained version of set theory, in which such paradoxes cannot happen.

Such a set theory was eventually found that bypassed Russell's paradox, and it is called [Zermelo-Fraenkel set theory](http://en.wikipedia.org/wiki/Zermelo%E2%80%93Fraenkel_set_theory). But even that was not enough! Additional statements, like the [Axiom of Choice](http://en.wikipedia.org/wiki/Axiom_of_choice) (which nevertheless does lead to [some counter-intuitive theorems](http://en.wikipedia.org/wiki/Banach%E2%80%93Tarski_paradox)), were found which cannot be proved or disproved by the other axioms of ZF set theory.

Rather than give up all that work on axiomatizing set theory, most mathematicians today accept the Axiom of Choice and work around any oddities that arise, resulting in ZFC (ZF +  Choice), doing their mathematical work there.

So along with paradoxical curiosities, we have laid all the foundation necessary for reasoning about countability and uncountability, which has already shown up numerous times on this blog.

Until next time!
