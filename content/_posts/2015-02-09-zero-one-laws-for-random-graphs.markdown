---
author: jeremykun
date: 2015-02-09 15:00:00+00:00
draft: false
title: Zero-One Laws for Random Graphs
type: post
url: /2015/02/09/zero-one-laws-for-random-graphs/
categories:
- Analysis
- Combinatorics
- Graph Theory
- Logic
- Probability Theory
tags:
- big-o notation
- countability
- erdos-renyi
- logic
- mathematics
- model theory
- network science
- random graph
---

[Last time](http://jeremykun.com/2015/02/02/the-giant-component-and-explosive-percolation/)** **we saw a number of properties of graphs, such as connectivity, where the probability that an Erdős–Rényi random graph $G(n,p)$ satisfies the property is asymptotically either zero or one. And this zero or one depends on whether the parameter $p$ is above or below a universal threshold (that depends only on $n$ and the property in question).




To remind the reader, the Erdős–Rényi random "graph" $G(n,p)$ is a distribution over graphs that you draw from by including each edge independently with probability $p$. Last time we saw that the existence of an isolated vertex has a sharp threshold at $(\log n) / n$, meaning if $p$ is asymptotically smaller than the threshold there will certainly be isolated vertices, and if $p$ is larger there will certainly be _no_ isolated vertices. We also gave a laundry list of other properties with such thresholds.




One might want to study this phenomenon in general. Even if we might not be able to find all the thresholds we want for a given property, can we classify which properties have thresholds and which do not?




The answer turns out to be mostly yes! For large classes of properties, there are proofs that say things like, "either this property holds with probability tending to one, or it holds with probability tending to zero." These are called "zero-one laws," and they're sort of meta theorems. We'll see one such theorem in this post relating to constant edge-probabilities in random graphs, and we'll remark on another at the end.





## Sentences about graphs in first order logic




A zero-one law generally works by defining a class of properties, and then applying a generic first/second moment-type argument to every property in the class.




So first we define what kinds of properties we'll discuss. We'll pick a large class: **anything that can be expressed in first-order logic** in the language of graphs. That is, any finite logical statement that uses existential and universal quantifiers over variables, and whose only relation (test) is whether an edge exists between two vertices. We'll call this test $e(x,y)$. So you write some sentence $P$ in this language, and you take a graph $G$, and you can ask $P(G) = 1$, whether the graph satisfies the sentence.




This seems like a _really_ large class of properties, and it is, but let's think carefully about what kinds of properties can be expressed this way. Clearly the existence of a triangle can be written this way, it's just the sentence




$\exists x,y,z : e(x,y) \wedge e(y,z) \wedge e(x,z)$




I'm using $\wedge$ for AND, and $\vee$ for OR, and $\neg$ for NOT. Similarly, one can express the existence of a clique of size $k$, or the existence of an independent set of size $k$, or a path of a fixed length, or whether there is a vertex of maximal degree $n-1$.




Here's a question: can we write a formula which will be true for a graph if and only if it's connected? Well such a formula seems like it would have to know about how many vertices there are in the graph, so it could say something like "for all $x,y$ there is a path from $x$ to $y$." It seems like you'd need a family of such formulas that grows with $n$ to make anything work. But this isn't a proof; the question remains whether there is some other tricky way to encode connectivity.




But as it turns out, connectivity is _not_ a formula you can express in propositional logic. We won't prove it here, but we will note at the end of the article that connectivity is in a different class of properties that you can prove has a similar zero-one law.





## The zero-one law for first order logic




So the theorem about first-order expressible sentences is as follows.




**Theorem:** Let $P$ be a property of graphs that can be expressed in the first order language of graphs (with the $e(x,y)$ relation). Then for any constant $p$, the probability that $P$ holds in $G(n,p)$ has a limit of zero or one as $n \to \infty$.




_Proof. _We'll prove the simpler case of $p=1/2$, but the general case is analogous. Given such a graph $G$ drawn from $G(n,p)$, what we'll do is define a countably infinite family of propositional formulas $\varphi_{k,l}$, and argue that they form a sort of "basis" for all first-order sentences about graphs.




First let's describe the $\varphi_{k,l}$. For any $k,l \in \mathbb{N}$, the sentence will assert that for every set of $k$ vertices and every set of $l$ vertices, there is some other vertex connected to the first $k$ but not the last $l$.




$\displaystyle \varphi_{k,l} : \forall x_1, \dots, x_k, y_1, \dots, y_l \exists z : \\ e(z,x_1) \wedge \dots \wedge e(z,x_k) \wedge \neg e(z,y_1) \wedge \dots \wedge \neg e(z,y_l)$.




In other words, these formulas encapsulate every possible incidence pattern for a single vertex. It is a strange set of formulas, but they have a very nice property we're about to get to. So for a fixed $\varphi_{k,l}$, what is the probability that it's false on $n$ vertices? We want to give an upper bound and hence show that the formula is true with probability approaching 1. That is, we want to show that _all_ the $\varphi_{k,l}$ are true with probability tending to 1.




Computing the probability: we have $\binom{n}{k} \binom{n-k}{l}$ possibilities to choose these sets, and the probability that some other fixed vertex $z$ has the good connections is $2^{-(k+l)}$ so the probability $z$ is not good is $1 - 2^{-(k+l)}$, and taking a product over all choices of $z$ gives the probability that _there is some bad vertex _$z$ with an exponent of $(n - (k + l))$. Combining all this together gives an upper bound of $\varphi_{k,l}$ being false of:




$\displaystyle \binom{n}{k}\binom{n-k}{l} (1-2^{-k-1})^{n-k-l}$




And $k, l$ are constant, so the left two terms are polynomials while the rightmost term is an exponentially small function, and this implies that the whole expression tends to zero, as desired.




_Break from proof._





## A bit of model theory




So what we've proved so far is that the probability of every formula of the form $\varphi_{k,l}$ being satisfied in $G(n,1/2)$ tends to 1.




Now look at the set of all such formulas




$\displaystyle \Phi = \{ \varphi_{k,l} : k,l \in \mathbb{N} \}$




We ask: is there any graph which satisfies all of these formulas? Certainly it cannot be finite, because a finite graph would not be able to satisfy formulas with sufficiently large values of $l, k > n$. But indeed, there is a _countably infinite_ graph that works. It's called the [_Rado graph_](http://en.wikipedia.org/wiki/Rado_graph), pictured below.




[![rado](https://jeremykun.files.wordpress.com/2015/01/rado.png?w=660)
](https://jeremykun.files.wordpress.com/2015/01/rado.png)




The Rado graph has some really interesting properties, such as that it contains _every finite and countably infinite graph_ as induced subgraphs. Basically this means, as far as countably infinite graphs go, it's the big momma of all graphs. It's _the_ graph in a very concrete sense of the word. It satisfies all of the formulas in $\Phi$, and in fact it's uniquely determined by this, meaning that if any other countably infinite graph satisfies all the formulas in $\Phi$, then that graph is isomorphic to the Rado graph.




But for our purposes (proving a zero-one law), there's a better perspective than graph theory on this object. In the logic perspective, the set $\Phi$ is called a_ theory_, meaning a set of statements that you consider "axioms" in some logical system. And we're asking whether there any model realizing the theory. That is, is there some logical system with a semantic interpretation (some mathematical object based on numbers, or sets, or whatever) that satisfies all the axioms?




A good analogy comes from the rational numbers, because they satisfy a similar property among all ordered sets. In fact, the rational numbers are the unique countable, ordered set with the property that it has no biggest/smallest element and is dense. That is, in the ordering there is always another element between any two elements you want. So the theorem says if you have two countable sets with these properties, then they are actually isomorphic as ordered sets, and they are isomorphic to the rational numbers.




So, while we won't prove that the Rado graph is a model for our theory $\Phi$, we will use that fact to great benefit. One consequence of having a theory with a model is that the theory is _consistent, _meaning it can't imply any contradictions. Another fact is that this theory $\Phi$ is _complete._ Completeness means that any formula or it's negation is logically implied by the theory. Note these are syntactical implications (using standard rules of propositional logic), and have nothing to do with the model interpreting the theory.




The proof that $\Phi$ is complete actually follows from the uniqueness of the Rado graph as the only countable model of $\Phi$. Suppose the contrary, that $\Phi$ is not consistent, then there has to be some formula $\psi$ that is not provable, and it's negation is also not provable, by starting from $\Phi$. Now extend $\Phi$ in two ways: by adding $\psi$ and by adding $\neg \psi$. Both of the new theories are still countable, and by [a theorem from logic](http://en.wikipedia.org/wiki/L%C3%B6wenheim%E2%80%93Skolem_theorem) this means they both still have countable models. But both of these new models are also countable models of $\Phi$, so they have to both be the Rado graph. But this is very embarrassing for them, because we assumed they disagree on the truth of $\psi$.




So now we can go ahead and prove the zero-one law theorem.




_Return to proof._




Given an arbitrary property $\varphi \not \in \Psi$. Now either $\varphi$ or it's negation can be derived from $\Phi$. Without loss of generality suppose it's $\varphi$. Take all the formulas from the theory you need to derive $\varphi$, and note that since it is a proof in propositional logic you will only finitely many such $\varphi_{k,l}$. Now look at the probabilities of the $\varphi_{k,l}$: they are _all true _with probability tending to 1, so the implied statement of the proof of $\varphi$ (i.e., $\varphi$ itself) must also hold with probability tending to 1. And we're done!




$\square$




If you don't like model theory, there is another "purely combinatorial" proof of the zero-one law using something called [Ehrenfeucht–Fraïssé games](http://en.wikipedia.org/wiki/Ehrenfeucht%E2%80%93Fra%C3%AFss%C3%A9_game). It is a bit longer, though.





## Other zero-one laws




One might naturally ask two questions: what if your probability is not constant, and what other kinds of properties have zero-one laws? Both great questions.




For the first, there are some extra theorems. I'll just describe one that has always seemed very strange to me. If your probability is of the form $p = n^{-\alpha}$ but $\alpha$ is _irrational_, then the zero-one law still holds! This is a theorem of [Baldwin-Shelah-Spencer](http://www.math.umd.edu/~laskow/Pubs/rational.pdf), and it really makes you wonder why irrational numbers would be so well behaved while rational numbers are not :)




For the second question, there is another theorem about _monotone _properties of graphs. Monotone properties come in two flavors, so called "increasing" and "decreasing." I'll describe increasing monotone properties and the decreasing counterpart should be obvious. A property is called _monotone increasing_ if adding edges can never destroy the property. That is, with an empty graph you don't have the property (or maybe you do), and as you start adding edges eventually you suddenly get the property, but then adding _more_ edges can't cause you to lose the property again. Good examples of this include connectivity, or the existence of a triangle.




So the theorem is that there is an identical zero-one law for monotone properties. Great!




It's not so often that you get to see these neat applications of logic and model theory to graph theory and (by extension) computer science. But when you do get to apply them they seem very powerful and mysterious. I think it's a good thing.




Until next time!
