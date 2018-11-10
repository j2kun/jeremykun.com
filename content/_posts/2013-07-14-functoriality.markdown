---
author: jeremykun
date: 2013-07-14 15:03:29+00:00
draft: false
title: Functoriality
type: post
url: /2013/07/14/functoriality/
categories:
- Category Theory
- Linear Algebra
tags:
- categories
- functor
- ML
- morphisms
---

[Last time](http://jeremykun.com/2013/05/24/universal-properties/) we worked through some basic examples of universal properties, specifically singling out quotients, products, and coproducts. There are many many more universal properties that we will mention as we encounter them, but there is one crucial topic in category theory that we have only hinted at: functoriality.

As we've repeatedly stressed, the meat of category theory is in the _morphisms. _One natural question one might ask is, what notion of morphism is there between categories themselves? Indeed, the most straightforward way to see category theoretic concepts in classical mathematics is in a clever choice of functor. For example (and this example isn't necessary for the rest of the article) one can "associate" to each topological space a group, called the [homology group](http://jeremykun.com/2013/04/03/homology-theory-a-primer/), in such a way that continuous functions on topological spaces translate to group homomorphisms. Moreover, this translation is _functorial_ in the following sense: the group homomorphism associated to a composition is the composition of the associated group homomorphisms. If we denote the association by a subscripted asterisk, then we get the following common formula.

$\displaystyle (fg)_* = f_* g_*$

This is _the_ crucial property that maintains the structure of morphisms. Again, this should reinforce the idea that the crucial ingredient of every definition in category theory is its effect on morphisms.

## Functors: a Definition

In complete generality, a functor is a mapping between two categories which preserves the structure of morphisms. Formally,

**Definition: **Let $\mathbf{C}, \mathbf{D}$ be categories. A _functor _$\mathscr{F}$ consists of two parts:

	  * For each object $C \in \mathbf{C}$ an associated object $\mathscr{F}(C) \in \mathbf{D}$.
	  * For each morphism $f \in \textup{Hom}_{\mathbf{C}}(A,B)$ a corresponding morphism $\mathscr{F}(f) \in \textup{Hom}_{\mathbf{D}}(\mathscr{F}(A), \mathscr{F}(B))$. Specifically, for each $A,B$ we have a set-function $\textup{Hom}_{\mathbf{C}}(A,B) \to \textup{Hom}_{\mathbf{C}}(\mathscr{F}(A), \mathscr{F}(B))$.

There are two properties that a functor needs to satisfy to "preserve structure." The first is that the identity morphisms are preserved for every object; that is, $\mathscr{F}(1_A) = 1_{\mathscr{F}(A)}$ for every object $A$. Second, composition must be preserved. That is, if $f \in \textup{Hom}_{\mathbf{C}}(A,B)$ and $g \in \textup{Hom}_{\mathbf{C}}(B,C)$, we have

$\displaystyle \mathscr{F}(gf) = \mathscr{F}(g) \mathscr{F}(f)$

We often denote a functor as we would a function $\mathscr{F}: \mathbf{C} \to \mathbf{D}$, and use the function application notation as if everything were with sets.

Let's look at a few simple examples.

Let $\mathbf{FiniteSet}$ be the poset category of finite sets with subsets as morphisms, and let $\mathbf{Int}$ be the category whose objects are integers where there is a unique morphism from $x \to y$ if $x \leq y$. Then the size function is a functor $\mathbf{Set} \to \mathbf{Int}$. Continuing with $\mathbf{Int}$, remember that $\mathbf{Int}$ forms a group under addition (also known as $\mathbb{Z}$). And so by its very definition any group homomorphism $\mathbb{Z} \to \mathbb{Z}$ is a functor from $\mathbf{Int} \to \mathbf{Int}$. A functor from a category to itself is often called an _endofunctor_.

There are many examples of functors from the category $\mathbf{Top}$ of topological spaces to the category $\mathbf{Grp}$ of groups. These include some examples we've seen on this blog, such as [the fundamental group](http://jeremykun.com/2013/01/12/the-fundamental-group-a-primer/) and [homology groups](http://jeremykun.com/2013/04/03/homology-theory-a-primer/).

One trivial example of a functor is called the _forgetful functor._ Let $\mathbf{C}$ be a category whose objects are sets and whose morphisms are set-maps with additional structure, for example the category of groups. Define a functor $\mathbf{C} \to \mathbf{Set}$ which acts as the identity on both sets and functions. This functor simply "forgets" the structure in $\mathbf{C}$. In the realm of programs and types (this author is thinking Java), one can imagine this as a 'type-cast' from String to Object.  In the same vein, one could define an "identity" endofunctor $\mathbf{C} \to \mathbf{C}$ which does absolutely nothing.

One interesting way to think of a functor is as a "realization" of one category inside another. In particular, because the composition structure of $\mathbf{C}$ is preserved by a functor $\mathbf{C} \to \mathbf{D}$, it must be the case that all commutative diagrams are "sent" to commutative diagrams. In addition, isomorphisms are sent to isomorphisms because if $f, g$ are inverses of each other, $1_{\mathscr{F}(A)} = \mathscr{F}(1_A) = \mathscr{F}(gf) = \mathscr{F}(g)\mathscr{F}(f)$ and likewise for the reverse composition. And so if we have a functor $\mathscr{F}$ from a poset category (say, the real numbers with the usual inequality) to some category $\mathbf{C}$, then we can realize the structure of the poset sitting inside of $\mathbf{C}$ (perhaps involving only some of the objects of $\mathbf{C}$). This view comes in handy in a few places we'll see later in our series on computational topology.

## The Hom Functor

There is a very important and nontrivial example called the "hom functor" which is motivated by the category of [vector spaces](http://jeremykun.com/2011/06/19/linear-algebra-a-primer/). We'll stick to the concrete example of vector spaces, but the generalization to arbitrary categories is straightforward. If the reader knows absolutely nothing about vector spaces, replace "vector space" with "object" and "linear map" with "morphism." It won't quite be correct, but it will get the idea across.

To each vector space $V$ one can define a _dual_ vector space of functions $V \to \mathbb{C}$ (or whatever the field of scalars for $V$ is). Following the lead of hom sets, the dual vector space is denoted $\textup{Hom}(V,\mathbb{C})$. Here the morphisms in the set are those from the category of vector spaces (that is, linear maps $V \to \mathbb{C}$). Indeed, this is a vector space: one can add two functions pointwise ($(f+g)(v) = f(v) + g(v)$) and scale them ($(\lambda f)(v) = \lambda f(v)$), and the properties for a vector spaces are trivial to check.

Now the mapping $\textup{Hom}(-, \mathbb{C})$ which takes $V$ and produces $\textup{Hom}(V, \mathbb{C})$ is a functor called the _hom functor_. But let's inspect this one more closely. The source category is obviously the category of vector spaces, but what is the target category? The objects are clear: the hom sets $\textup{Hom}(V,\mathbb{C})$ where $V$ is a vector space. The morphisms of the category are particularly awkward. Officially, they are written as

$\displaystyle \textup{Hom}(\textup{Hom}(V, \mathbb{C}), \textup{Hom}(W, \mathbb{C}))$

so a morphism in this category takes as input a linear map $V \to \mathbb{C}$ and produces as output one $W \to \mathbb{C}$. But what are the morphisms in words we can understand? And how can we compose them? Before reading on, think about what a morphism of morphisms should look like.

Okay, ready?

The morphisms in this category can be thought of as linear maps $W \to V$. More specifically, given a morphism $\varphi: V \to \mathbb{C}$ and a linear map $g: W \to V$, we can construct a linear map $W \to \mathbb{C}$ by composing $\varphi g$.

And so if we apply the $\textup{Hom}$ functor to a morphism $f: W \to V$, we get a morphism in $\textup{Hom}(\textup{Hom}(V, \mathbb{C}), \textup{Hom}(W, \mathbb{C}))$. Let's denote the application of the hom functor using an asterisk so that $f \mapsto f_*$.

But wait a minute! The mapping here is going in the wrong direction: we took a map in one category going from the $V$ side to the $W$ side, and after applying the functor we got a map going from the $W$ side ($\textup{Hom}(W, \mathbb{C})$) to the $V$ side ($\textup{Hom}(V, \mathbb{C})$). It seems there is no reasonable way to take a map $V \to \mathbb{C}$ and get a map in $W \to \mathbb{C}$ using just $f$, but the other way is obvious. The hom functor "goes backward" in a sense. In other words, the composition property for our "functor" makes the composite $(g f)_*$ to the map taking $\varphi$ to $\varphi g f$. On the other hand, there is no way to compose $g_* f_*$, as they operate on the wrong domains! It must be the other way around:

$\displaystyle (gf)_* = f_* g_*$

We advise the reader to write down the commutative diagram and trace out the compositions to make sure everything works out. But this is a problem, because it makes the hom functor fail the most important requirement. In order to fix this reversal "problem," we make the following definition:

**Definition: **A functor $\mathscr{F} : \mathbf{C} \to \mathbf{D}$ is called _covariant _if it preserves the order of morphism composition, so that $\mathscr{F}(gf) = \mathscr{F}(g) \mathscr{F}(f)$. If it reverses the order, we call it _contravariant_.

And so the hom functor on vector spaces is a contravariant functor, while all of the other functors we've defined in this post are covariant.

There is another way to describe a contravariant functor as a covariant functor which is often used. It involves the idea of an "opposite" category. For any category $\mathbf{C}$ we can define the _opposite category _$\mathbf{C}^{\textup{op}}$ to be a category with the same objects as $\mathbf{C}$, but with all morphisms reversed. That is, we define

$\displaystyle \textup{Hom}_{\mathbf{C}^{\textup{op}}}(A,B) = \textup{Hom}_{\mathbf{C}}(B,A)$

We leave it to the reader to verify that this is indeed a category. It is also not hard to see that $(\mathbf{C}^{\textup{op}})^{\textup{op}} = \mathbf{C}$. Opposite categories give us a nice recharacterization of a contrvariant functor. Indeed, because composition in opposite categories is reversed, a contravariant functor $\mathbf{C} \to \mathbf{D}$ is just a _covariant_ functor on the opposite category $\mathbf{C}^{\textup{op}} \to \mathbf{D}$. Or equivalently, one $\mathbf{C} \to \mathbf{D}^{\textup{op}}$. More than anything, opposite categories are syntactical sugar. Composition is only reversed artificially to make domains and codomains line up, but the actual composition is the same as in the original category.

## Functors as Types

Before we move on to some code, let's take a step back and look at the big picture (we've certainly plowed through enough details up to this point). The main thesis is that functoriality is a valuable property for an operation to have, but it's not entirely clear _why_. Even the brightest of readers can only assume such properties are useful for mathematical analysis. It seems that the question we [started this series out with](http://jeremykun.com/2013/04/16/categories-whats-the-point/), "what does category theory allow us to _do_ that we couldn't do before?" still has the answer, "nothing." More relevantly, the question of what functoriality allows us to do is unclear. Indeed, once again the answer is "nothing." Rather, functoriality in a computation allows one to analyze the behavior of a program. It gives the programmer a common abstraction in which to frame operations, and ease in proving the correctness of one's algorithms.

In this light, the best we can do in implementing functors in programs is to give a type definition and examples. And in this author's opinion this series is quickly becoming boring (all of the computational examples are relatively lame), so we will skip the examples in favor of the next post which will analyze more meaty programming constructs from a categorical viewpoint.

So recall the ML type definition of a category, a tuple of operations for source, target, identity, and composition:

{{< highlight python >}}datatype ('object, 'arrow)Category =
    category of ('arrow -> 'object) *
                ('arrow -> 'object) *
                ('object -> 'arrow) *
                ('arrow * 'arrow -> 'arrow){{< /highlight >}}

And so a functor consists of the two categories involved (as types), and the mapping on objects, and the mapping on morphisms.

{{< highlight python >}}datatype ('cObject, 'cArrow, 'dObject, 'dArrow)Functor =
   aFunctor of ('cObject, 'cArrow)Category *
               ('cObject -> 'dObject) *
               ('cArrow -> 'dArrow) *
               ('dObject -> 'dArrow)Category{{< /highlight >}}

We encourage the reader who is uncomfortable with these type definitions to experiment with them by implementing some of our simpler examples (say, the size functor from sets to integers). Insofar as the basic definitions go, functors are not all that interesting. They become much more interesting when additional structure is imposed on them, and in the distant future we will see a glimpse of this in the form of adjointness. We hope to get around to analyzing statements like "syntax and semantics are adjoint functors." For the next post in this series, we will take the three beloved functions of functional programming (map, foldl(r), and filter), and see what their categorical properties are.

Until then!
