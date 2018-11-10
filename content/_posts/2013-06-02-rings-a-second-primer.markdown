---
author: jeremykun
date: 2013-06-02 04:49:01+00:00
draft: false
title: Rings — A Second Primer
type: post
url: /2013/06/01/rings-a-second-primer/
categories:
- Group Theory
- Ring Theory
tags:
- commutative algebra
- hilbert basis theorem
- ideals
- mathematics
- polynomial ring
---

[Last time](http://jeremykun.com/2013/04/30/rings-a-primer/) we defined and gave some examples of rings. Recapping, a ring is a special kind of group with an additional multiplication operation that "plays nicely" with addition. The important thing to remember is that a ring is intended to remind us arithmetic with integers (though not too much: multiplication in a ring need not be commutative). We proved some basic properties, like zero being unique and negation being well-behaved. We gave a quick definition of an integral domain as a place where the only way to multiply two things to get zero is when one of the multiplicands was already zero, and of a Euclidean domain where we can perform nice algorithms like the one for computing the greatest common divisor. Finally, we saw a very important example of the ring of polynomials.

In this post we'll take a small step upward from looking at low-level features of rings, and start considering how general rings relate to each other. The reader familiar with this blog will notice many similarities between this post and our post on [group theory](http://jeremykun.com/2012/12/22/groups-a-second-primer/). Indeed, the definitions here will be "motivated" by an attempt to replicate the same kinds of structures we found helpful in group theory (subgroups, homomorphisms, quotients, and kernels). And because rings are also abelian groups, we will play fast and loose with a number of the proofs here by relying on facts we proved in [our two-post series on group theory](http://jeremykun.com/2012/12/08/groups-a-primer/). The ideas assume a decidedly distinct flavor here (mostly in ideals), and in future posts we will see how this affects the computational aspects in more detail.

## Homomorphisms and Sub-structures

The first question we should ask about rings is: what should mappings between rings look like? For groups they were set-functions which preserved the group operation ($f(xy) = f(x)f(y)$ for all $x,y$). The idea of preserving algebraic structure translates to rings, but as rings have two operations we must preserve both.

**Definition:** Let $(R, +_R, \cdot_R), (S, +_S, \cdot_S)$ be rings, and let $f: R \to S$ be a function on the underlying sets. We call $f$ a _ring homomorphism_ if $f$ is a group homomorphism of the underlying abelian groups, and for all $x,y \in R$ we have $f(x \cdot_R y) = f(x) \cdot_S f(y)$. A bijective ring homomorphism is called an _isomorphism_.

Indeed, we have the usual properties of ring homomorphisms that we would expect. All ring homomorphisms preserve the additive and multiplicative identities, multiplicative inverses (when they exist), and things like zero-divisors. We leave these verifications to the reader.

Ring homomorphisms have the same kinds of constructions as group homomorphisms did. One of particular importance is the kernel $\textup{ker} f$, which is the preimage of zero under $f$, or equivalently the set $\left \{ x : f(x) = 0 \right \}$. This is the same definition as for group homomorphisms, linear maps, etc.

The second question we want to ask about rings is: what is the appropriate notion of a sub-structure for rings? One possibility is obvious.

**Definition:** A _subring_ $S$ of a ring $R$ is a subset $S \subset R$ which is also a ring under the same operations as those of $R$ (and with the same identities).

Unfortunately subrings do not have the properties we want them to have, and this is mostly because of the requirement that our rings have a multiplicative identity. For instance, we want to say that the kernel of a ring homomorphism $f: R \to S$ is a subring of $R$. This will obviously not be the case, because the multiplicative identity never maps to zero under a ring homomorphism! We also want an appropriate notion of a quotient ring, but if we quotient out ("declare to be zero") a sub_ring_, then the identity will become zero, which yields all sorts of contradictions in all but the most trivial of rings. One nice thing, however, is that the _image_ of a ring homomorphism $R \to S$ is a subring of $S$. It is a trivial exercise to prove.

Rather than modify our definition of a kernel or a quotient to make it work with the existing definition of a subring, we pick a different choice of an appropriate sub-structure: the ideal.

## The Study of Ideals

From an elementary perspective, an ideal is easiest understood as a generalization of even numbers. Even integers have this nice property that multiplying any integer by an even integer gives you an even integer. This is a kind of _closure property_ that mathematicians really love to think about, because they tend to lead to further interesting properties and constructions. Indeed, we can generalize it as follows:

**Definition: **Let $R$ be a commutative ring, and $I \subset R$. We call $I$ an _ideal_ if two conditions are satisfied:

	  1. $I$ is a sub_group_ of $R$ under addition.
	  2. For all $r \in R$ and for all $x \in I$, we have $rx \in I$.

That is, an ideal is a subgroup closed under multiplication. The even integers as a subset of $\mathbb{Z}$ give a nice example, as does the set $\left \{ 0 \right \}$. In fact, _every_ ideal contains zero by being a subgroup. A slightly more complicated example is the set of polynomials divisible by $(x-1)$ as a subset of the polynomial ring $\mathbb{R}[x]$.

We have to be a little careful here if our ring is not commutative. Technically this definition above is for a _left_-ideal, which is closed under left-multiplication. You can also define _right-_ideals closed under right-multiplication, and the official name for a plain old "ideal" is a _two-sided_ ideal. The only time we will ever work with noncommutative rings (that we can envision) is with matrix rings, so excluding that case our ideals will forevermore be two-sided. Often times we will use the notation $rI$ to denote the set of all possible left multiplications $\left \{ rx : x \in I \right \}$, and so the ideal condition is just $rI = I$. This is a multiplicative kind of coset, although as we are about to see we will use both additive and multiplicative cosets in talking about rings.

Let's look at some properties of ideals that show how neatly this definition encapsulates what we want. First,

**Proposition: **The kernel of a ring homomorphism is an ideal.

_Proof_. Let $f: R \to S$ be a ring homomorphism, and let $I = \textup{ker}(f)$. We already know that $I$ is a subgroup of $R$ under addition because kernels of group homomorphisms are subgroups. To show the ideal condition, simply take $r \in R, x \in I$ and note that $f(rx) = f(r)f(x) = f(r)0 = 0$, and so $rx \in \textup{ker}(f)$. $\square$

In fact the correspondence is one-to-one: _every_ ideal is the kernel of a ring homomorphism and every ring homomorphism's kernel is an ideal. This is not surprising as it was the case for groups, and the story starts here with quotients, too.

**Definition:** Let $R$ be a ring and $I$ an ideal of $R$. The quotient group $R/I$ forms a ring called the _quotient_ ring, and is still denoted by $R / I$.

To show this definition makes any sense requires some thought: what are the operations of this new ring? Are they well-defined on coset representatives?

For the first, we already know the addition operation because it is the same operation when we view $R / I$ as a quotient group; that is, $(x + I) + (y + I) = (x+y) + I$. The additive identity is just $0 + I = I$. The multiplication operation is similar: $(x + I)(y + I) = xy + I$. And the multiplicative identity is clearly $1 + I$.

The fact that multiplication works as we said it does above gives more motivation for the definition of an ideal. To prove it, pick any representatives $x + z_1 \in x + I$ and $y + z_2 \in y + I$. Their product is

$(xy + xz_2 + yz_1 + z_1z_2) \in xy + xI + yI + I^2$

Where we denote by $I^2 = \left \{ xy : x \in I, y \in I \right \}$. The condition for an ideal to be an ideal is precisely that the weird parts, the $xI + yI + I^2$, become just $I$. And indeed, $I$ is an additive group, so sums of things in $I$ are in $I$, and moreover $I$ is closed under multiplication by arbitrary elements of $R$. More rigorously, $xy + xz_2 + yz_1 + z_1z_2$ is equivalent to $xy$ under the coset equivalence relation because their difference $xz_2 + yz_1 + z_1z_2$ is a member of $I$.

Now we can realize that every ideal is the kernel of some homomorphism. Indeed, if $I$ is an ideal of $R$, then there is a natural map $\pi : R \to R/I$ (called the _canonical projection, _see our post on [universal properties](http://jeremykun.com/2013/05/24/universal-properties/) for more) defined by sending an element to its coset: $\pi(x) = x+ I$. It should be obvious to the reader that the kernel of $\pi$ is exactly $I$ (because $x + i = 0 + I$ if and only if $x \in I$; this is a fact we borrow from groups). And so there is a correspondence between kernels and ideals. They are really the same concept manifested in two different ways.

Because we have quotient rings and ring homomorphisms, we actually get a number of "theorems" for free. These are the isomorphism theorems for rings, the most important one being the analogue of the First Isomorphism Theorem for groups. That is, if $f: R \to S$ is a ring homomorphism, $\textup{im}(f)$ is a subring of $S$, and moreover $R/ \textup{ker}(f) \cong \textup{im}(f)$. We invite the reader to prove it by hand (start by defining a map $\varphi(x + I) = f(x)$ and prove it's a ring isomorphism). There are [some other isomorphism theorems](http://en.wikipedia.org/wiki/Isomorphism_theorem#First_isomorphism_theorem_2), but they're not particularly deep; rather, they're just commonly-applied corollaries of the first isomorphism theorem. In light of this blog's discussions on category theory, the isomorphism theorems are a trivial consequence of the fact that rings have quotients, and that $\textup{im}(f)$ happens to be well-behaved.

## Noetherian Rings and Principal Ideal Domains

One cannot overestimate the importance of ideals as a fundamental concept in ring theory. They are literally the cornerstone of everything interesting in the subject, and especially the computational aspects of the field (more on that in future posts). So to study ideals, we make some basic definitions.

**Definition: **Let $A \subset R$ be any subset of the ring $R$. The ideal _generated_ by $A$ is the smallest ideal of $R$ containing $A$, denoted $I(A)$. It is "smallest" in the sense that all ideals containing $A$ must also contain $I(A)$.

Indeed, we can realize $I(A)$ directly as the set of all possible finite linear combinations $r_1 a_1 + \dots r_k a_k$ where the $r_i \in R$ and $a_i \in A$. Such a linear combination is called an $R$-linear combination because the "coefficients" come from $R$. It is not hard to see that this is an ideal. It is obviously a subgroup since sums of linear combinations are also linear combinations, and negation distributes across the sum. It satisfies multiplicative closure because

$r(r_1a_1 + \dots + r_k a_k) = (rr_1)a_1 + \dots + (rr_k)a_k$

is another $R$-linear combination.

One convenient way to think of this ideal is as the intersection of all ideals $I$ which contain $A$. Since the intersection of any family of ideals is an ideal (check this!) this will always give us the smallest possible ideal containing $A$.

One important bit of notation is that if $I = I(A)$ is the ideal generated by a _finite_ set $A$, then we write $I = \left \langle a_1, \dots, a_n \right \rangle$ where $A = \left \{ a_1, \dots, a_n \right \}$. We say that $I$ is _finitely generated__._ If $A$ happens to be a singleton, we say that $I$ is a _principal ideal_. Following the notation of linear algebra, a minimal (by cardinality) generating set for an ideal is called a _basis_ for the ideal. _
_

Thinking about how ideals are generated is extremely important both in the pure theory of rings and in the computational algorithms that deal with them. It's so important, in fact, that there are entire classes of rings defined by how their ideals behave. We give the two most important ones here.

**Definition: **A commutative ring is called _Noetherian_ if all of its ideals are finitely generated. An integral domain is called a _principal ideal domain_ if all of its ideals are principal.

The concept of a Noetherian ring is a particularly juicy one, and it was made famous by the founding mother of commutative ring theory, [Emmy Noether](https://en.wikipedia.org/wiki/Emmy_Noether). Without going into too much detail, just as an integral domain is the most faithful abstraction of the ring of integers, a Noetherian ring is the best way to think about polynomial rings (and quotients of polynomial rings). This is highlighted by a few basic facts and some deep theorems:

**Fact: **If $R$ is a Noetherian ring and $I$ an ideal, then $R/I$ is Noetherian.

This follows from the correspondence of ideals between $R$ and $R/I$. Indeed, for every ideal $J \subset R/I$ there is an ideal $\pi^{-1}(J)$ of $R$ which contains $I$. Moreover, this correspondence is a bijection. So if we want a generating set for $J$, we can lift it up to $R$ via $\pi$, get a finite generating set for $\pi^{-1}(J)$, and project the generators back down to $R/I$. Some of the generators will be killed off (sent to $I$ by $\pi$), but what remains will be a valid generating set for $J$, and still finite.

**Theorem (Hilbert Basis Theorem):** If $R$ is a Noetherian ring, then the polynomial ring in one variable $R[x]$ is Noetherian. Inductively, $R[x_1, \dots, x_n]$ is also Noetherian.

These theorems start to lay the foundation for algebraic geometry, which connects ideals generated by a family of polynomials to the _geometric_ solution set of those polynomials. Since a vast array of industrial problems can be reduced to solving systems of polynomial equations (take robot motion planning, for example), it would be quite convenient if we could write programs to reason about those systems of equations. Indeed, such algorithms do exist, and we make heavy use of theorems like the Hilbert Basis Theorem to ensure their correctness.

In the next post in this series, we'll start this journey through elementary algebraic geometry by defining a _variety_, and establishing its relationship to ideals of polynomial rings. We'll then work towards theorems like Hilbert's Nullstellensatz, the computational operations we wish to perform on ideals, and the algorithms that carry out those operations. As usual, we'll eventually see some applications and write some code.

Until then!
