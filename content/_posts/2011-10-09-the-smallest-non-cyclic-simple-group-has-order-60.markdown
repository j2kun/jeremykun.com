---
author: jeremykun
date: 2011-10-09 01:53:48+00:00
draft: false
title: The Smallest Non-Cyclic Simple Group has Order 60
type: post
url: /2011/10/08/the-smallest-non-cyclic-simple-group-has-order-60/
categories:
- Group Theory
- Proof Gallery
tags:
- mathematics
- simple groups
---

**Preamble:** This proof is not particularly elegant or insightful. However, it belongs in this gallery for two reasons. First, it is an example of the goal of most mathematics: to classify things. In the same way that all natural numbers can be built up from primes, every group can be built up from simple groups. So if we want to understand all groups, it suffices to understand the simple ones. Indeed, this project has been the collective goal of hundreds of mathematicians for the past hundred years, culminating in one awesomely gargantuan theorem: [The Classification of Finite Simple Groups](http://en.wikipedia.org/wiki/Classification_of_finite_simple_groups). This post is a very small part of that theorem. Indeed, mathematicians have discovered simple groups with 42305421312000 elements, and this is considered moderately sized compared to [some simple groups](http://en.wikipedia.org/wiki/Monster_group) discovered as recently as 1982. And the full theorem itself, in it's _reduced, simplified _form, fills more than 5,000 pages of text! In it's original form, there was even a single theorem whose proof took up more than 1,200 pages.

The second reason we've included this proof is because much of important mathematics stands on the so-called "lemma-encrusted shoulders" of other mathematicians. An unbelievably large amount of knowledge came together to classify groups, and here we show a time when many separate ideas come together to prove something significant. While the details are quite gritty, in the end we have a Mona Lisa of a theorem. Perhaps, then, the full classification theorem would be the Sistine Chapel, or the more permanent grandeur of the cosmos.

Finally, note that in the details we assume a high level of familiarity with group theory, and in particular the terminology of [group actions](http://en.wikipedia.org/wiki/Group_action). In any case, the reader may glaze over the details of the proofs and notice how we methodically rule out numbers with special factorizations to achieve the final result.

**Problem:** Classify all simple groups of order less than 60.

**Solution:** Recall that a group $G$ is _simple_ if its only normal subgroups are the trivial group and the group itself. Wielding the Sylow theorems like a machete, we will hack our way through the following list of numbers to find all of the possible orders of a simple group $G$:

    
    1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25
    26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47
    48 49 50 51 52 53 54 55 56 57 58 59

Our first swing (not quite a Sylow theorem) will be to realize that every group of prime order is necessarily cyclic (as is the only group of order 1), and all prime order cyclic groups are simple, since they have no non-trivial subgroups _at all_, not to mention normality. We recognize that cyclic groups are uninteresting simple groups, and rule them out for the rest of this proof. This leaves us with all of the composite numbers up to 58

    
          4   6   8 9 10    12    14 15 16    18    20 21 22    24 25
    26 27 28    30    32 33 34 35 36    38 39 40    42    44 45 46
    48 49 50 51 52    54 55 56 57 58

Note that if a group has a nontrivial center (here denoted $Z(G)$), it cannot be simple. In particular, the center is a normal subgroup itself. On the other hand, if the center is all of $G$ (i.e. $G$ is abelian) then any subgroup of $G$ is automatically a normal subgroup, and since all groups of non-prime order have nontrivial subgroups, they also cannot be simple. To exploit this, we will prove the following theorem, that every group of prime power order is not simple:

**Theorem**: Every group $G$ of order $p^n$ has a non-trivial center.

_Proof: _$G$ acts on itself by conjugation. In particular, the set of fixed points of this action are the elements in the center of $G$, and the orbits of elements not in the center partition $G$ into conjugacy classes. So we have the so-called [class formula](http://en.wikipedia.org/wiki/Conjugacy_class#Conjugacy_class_equation):

$|G| = |Z(G)| + \sum \limits_{a \in A}|[G : G_a]|$

Where $A$ is a set of representatives of non-trivial conjugacy classes and $G_a$ is the stabilizer subgroup of $G$ for the conjugacy class of $a$. Since each of these indices $[G:G_a]$ divides the order of $G$, each index must be a power of $p$, and so we have $0 \equiv |G| \equiv |Z(G)| \mod p$. In particular, conjugation fixes the identity element, so $|Z(G)| \geq 1$, but since it must be 0 mod $p$, we have $|Z(G)| \geq p$, implying the group has nontrivial center. $\square$

In particular, this rules out groups of order 4, 8, 9, 16, ..., leaving us with the following list:

    
              6       10    12    14 15       18    20 21 22    24
    26    28    30       33 34 35 36    38 39 40    42    44 45 46
    48    50 51 52    54 55 56 57 58

Now we actually have to do a little work. Specifically, we want to take each $n$ above and determine whether every group of order $n$ has a normal subgroup. Enter the Sylow theorems:

Recall that a _Sylow p-subgroup_ is a subgroup of a group $G$ of order $p^r$ where $p$ is prime, such that $p^{r+1}$ does not divide the order of $G$. We will call this maximal prime power order. The first Sylow theorem states that this subgroup exists for all groups $G$ and all $p$ (in fact, it _really_ states that if $p^k$ divides the order of $G$ then $G$ has a subgroup of that order). The second Sylow theorem states that any two Sylow p-subgroups are conjugate, which implies that if there is a unique Sylow p-subgroup, it must be normal. Finally, the third Sylow theorem helps us count the number of Sylow p-subgroups of any group. Specifically, it states that if the order of $G$ is $p^rm$ where $p$ does not divide $m$, then the number of Sylow p-subgroups divides $m$ and is congruent to 1 modulo $p$.

Our first application will be the following theorem:

**Theorem:** If $G$ has order $mp^r$ where $p$ is prime and $1 < m < p$, then $G$ is not simple.

_Proof_. There is at least one Sylow p-subgroup of $G$, and the total number of such groups is 1 mod $p$ and divides $m$. Since $m < p$, there can only be one such subgroup. Hence, the unique Sylow p-subgroup is normal, and $G$ is not simple. $\square$

This rules out the numbers 6, 10, 14, 15, 18, ..., to leave us with the now sparse list:

    
                            12                                  24
                30                36          40             45
    48                      56

There are just a few details left.

For $|G| = 40$, there is a unique Sylow 5-subgroup (the only divisor of 8 which is 1 mod 5 is 1), and the same argument holds for $|G| = 45$, with 9 in the place of 8.

For $|G| = 30$, we may count both the number of Sylow 3-subgroups and the Sylow 5-subgroups. For the former, there are either 1 or 10 (the only divisors of 10 which are 1 mod 3), and for the latter there are either 1 or 6 (only divisors of 6 which are 1 mod 5). But certainly there can't be 6 subgroups of order 5 and 10 of order 3, since these subgroups cannot intersect, and this would account for far too many elements. Hence, there is either a unique Sylow 5-subgroup or a unique Sylow 2-subgroup. Either way, $G$ is normal.

Similarly, for $|G| = 56$, we have the number of Sylow 7-subgroups is either 1 or 8, and the number of Sylow 2-subgroups is either 1 or 7. If neither are 1, we have 6 distinct generators of each Sylow 7-subgroup, giving 48 distinct elements. We further have at least one Sylow 2-subgroup $H$ of order 8, giving a total of 56 elements, but since there are more Sylow 2-subgroups we can pick an element in one which is not $H$, and find ourselves with more than $|G|$ elements.

This leaves us with the following multiples of twelve (which have aggravatingly many divisors):

    
                            12                                  24
                                  36
    48

If $|G| = 36$ then we have either 1, 3, or 9 Sylow 2-subgroups, and 1 or 4 Sylow 3- subgroups, but it is again clear by counting elements that there cannot be both 9 of the former and 4 of the latter, so either $G$ is already simple, or there are at most 3 Sylow 2-subgroups, and we may use the following result to prove all groups with these orders are simple.

Suppose $G$ is a group with any of these remaining orders, and let $N_2$ be the number of Sylow 2-subgroups. The Sylow theorems (and our above investigation of $|G| = 30$) show that $N_2 = 3$ or else $G$ is already simple. Now let $G$ act on the set of Sylow 2-subgroups by conjugation. This is a homomorphism $G \to S_3$, but since $|G| \geq 12 > 6 = |S_3|$, this map cannot be injective. In other words, its kernel is a normal subgroup of $G$. So $G$ is not simple.

As we have just proved, there are no non-cyclic simple groups of order less than 60. On the other hand, there is such a group of order 60: the [alternating group on 5 letters](http://en.wikipedia.org/wiki/Alternating_group) (famously discovered by [Évariste Galois](http://en.wikipedia.org/wiki/%C3%89variste_Galois)). It is another theorem altogether that this is the only simple group of order 60.
