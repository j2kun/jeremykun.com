---
author: jeremykun
date: 2017-04-24 16:00:14+00:00
draft: false
title: Testing Polynomial Equality
type: post
url: /2017/04/24/testing-polynomial-equality/
categories:
- General
---

**Problem: **Determine if two polynomial expressions represent the same function. Specifically, if $p(x_1, x_2, \dots, x_n)$ and $q(x_1, x_2, \dots, x_n)$ are a polynomial with inputs, outputs and coefficients in a field $F$, where $|F|$ is sufficiently large, then the problem is to determine if $p(\mathbf{x}) = q(\mathbf{x})$ for every $x \in F$, in time polynomial in the number of bits required to write down $p$ and $q$.

**Solution:** Let $d$ be the maximum degree of all terms in $p, q$. Choose a finite set $S \subset F$ with $|S| > 2d$. Repeat the following process 100 times:

	  1. Choose inputs $z_1, z_2, \dots, z_n \in S$ uniformly at random.
	  2. Check if $p(z_1, \dots, z_n) = q(z_1, \dots, z_n)$.

If every single time the two polynomials agree, accept the claim that they are equal. If they disagree on any input, reject. You will be wrong with probability at most $2^{-100}$.

**Discussion: **At first glance it's unclear why this problem is hard.

If you have two representations of polynomials $p, q$, say expressed in algebraic notation, why can't you just do the algebra to convert them both into the same format, and see if they're equal?

Unfortunately, that conversion can take exponential time. For example, suppose you have a polynomial $p(x) = (x+1)^{1000}$. Though it only takes a few bits to write down, expressing it in a "canonical form," often in the monomial form $a_0 + a_1x + \dots + a_d x^d$, would require exponentially many bits in the original representation. In general, it's unknown how to algorithmically transform polynomials into a "canonical form" (so that they can be compared) in subexponential time.

Instead, the best we know how to do is treat the polynomials as black boxes and plug values into them.

Indeed, for single variable polynomials it's well known that a nonzero degree $d$ polynomial has at most $d$ roots. A similar result is true for polynomials with many variables, and so we can apply that result to the polynomial $p - q$ to determine if $p = q$. This theorem is so important (and easy to prove) that it deserves the name of _lemma._

**The Schwartz-Zippel lemma. **Let $p$ be a nonzero polynomial of total degree $d \geq 0$ over a field $F$. Let $S$ be a finite subset of $F$ and let $z_1, \dots, z_n$ be chosen uniformly at random from $S$. The probability that $p(z_1, \dots, z_n) = 0$ is at most $d / |S|$.

_Proof. _By induction on the number of variables $n$. For the case of $n=1$, it's the usual fact that a single-variable polynomial can have at most $d$ roots. Now for the inductive step, assume this is true for all polynomials with $n-1$ variables, and we will prove it for $n$ variables. Write $p$ as a polynomial in the variable $x_1$, whose coefficients are other polynomials:

$\displaystyle p(x_1, \dots, x_n) = \sum_{k=1}^d Q_k(x_2, \dots, x_n) x_1^k$

Here we've grouped $p$ by the powers of $x_1$, so that $Q_i$ are the coefficients of each $x_1^k$. This is useful because we'll be able to apply the inductive hypothesis to one of the $Q_i$'s, which have fewer variables.

Indeed, we claim there must be some $Q_k$ which is nonzero for $k > 0$. Clearly, since $p$ is not the zero polynomial, some $Q_k$ must be nonzero. If the only nonzero $Q_k$ is $Q_0$, then we're done because $p$ doesn't depend on $x_1$ at all. Otherwise, take the largest nonzero $Q_k$. It's true that the degree of $Q_k$ is at most $d-k$. This is true because the term $x_1^k Q_k$ has degree at most $d$.

By the inductive hypothesis, if we choose $z_2, \dots, z_n$ and plug them into $Q_k$, we get zero with probability at most $\frac{d-k}{|S|}$. The crucial part is that if this _polynomial_ coefficient is nonzero, then the entire polynomial $p$ is nonzero. This is true even if an unlucky choice of $x_1 = z_1$ causes the resulting evaluation $p(z_1, \dots, z_n) \neq 0$.

To think about it a different way, imagine we're evaluating the polynomial in phases. In the first phase, we pick the $z_2, \dots, z_n$. We could also pick $z_1$ independently but not reveal what it is, for the sake of this story. Then we plug in the $z_2, \dots, z_n$, and the result is a one-variable polynomial whose largest coefficient is $Q_k(z_1, \dots, z_n)$. The inductive hypothesis tells us that this one-variable polynomial is the zero polynomial with probability at most $\frac{d-k}{|S|}$. (It's probably a smaller probability, since _all_ the coefficients have to be zero, but we're just considering the largest one for the sake of generality and simplicity)

Indeed, the resulting polynomial after we plug in $z_2, \dots, z_n$ has degree $k$, so we can apply the inductive hypothesis to it as well, and the probability that it's zero for a random choice of $z_1$ is at most $k / |S|$.

Finally, the probability that both occur can be computed using basic probability algebra. Let $A$ be the event that, for these $z_i$ inputs, $Q_k$ is zero, and $B$ the event that $p$ is zero for the $z_i$ and the additional $z_1$.

Then $\textup{Pr}[B] = \textup{Pr}[B \textup{ and } A] + \textup{Pr}[B \textup{ and } !A] = \textup{Pr}[B \mid A] \textup{Pr}[A] + \textup{Pr}[B \mid !A] \textup{Pr}[!A]$.

Note the two quantities above that we don't know are $\textup{Pr}[B \mid A]$ and $\textup{Pr}[!A]$, so we'll bound them from above by 1. The rest of the quantities add up to exactly what we want, and so

$\displaystyle  \textup{Pr}[B] \leq \frac{d-k}{|S|} + \frac{k}{|S|} = \frac{d}{|S|},$

which proves the theorem.

$\square$

While this theorem is almost trivial to prove (it's elementary induction, and the obvious kind), it can be used to solve polynomial identity testing, as well as finding perfect matchings in graphs and test numbers for primality.

But while the practical questions are largely solved–it's hard to imagine a setting where you'd need faster primality testing than the existing randomized algorithms–the theory and philosophy of the result is much more interesting.

Indeed, checking two polynomials for equality has no known deterministic polynomial time algorithm. It's one of a small class of problems, like integer factoring and the discrete logarithm, which are not known to be efficiently solvable in theory, but are also not known to be NP-hard, so there is still hope. The existence of this randomized algorithm increases hope (integer factorization sure doesn't have one!). And more generally, the fact that there are so few natural problems in this class makes one wonder whether randomness is actually beneficial at all. From a polynomial-time-defined-as-efficient perspective, can every problem efficiently solvable with access to random bits also be solved without such access? In the computational complexity lingo, does P = BPP? Many experts think the answer is yes.
