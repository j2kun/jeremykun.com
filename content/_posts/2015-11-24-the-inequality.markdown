---
author: jeremykun
date: 2015-11-24 04:06:27+00:00
draft: false
title: The Inequality
type: post
url: /2015/11/23/the-inequality/
categories:
- Analysis
- Learning Theory
- Probability
tags:
- calculus
- cauchy-schwarz
- euler's number
- mathematics
- taylor series
---

Math and computer science are full of inequalities, but there is one that shows up more often in my work than any other. Of course, I'm talking about

$\displaystyle 1+x \leq e^{x}$

This is The Inequality. I've been told on many occasions that the entire field of machine learning reduces to The Inequality combined with the Chernoff bound (which is [proved](https://en.wikipedia.org/wiki/Chernoff_bound#Theorem_for_multiplicative_form_of_Chernoff_bound_.28relative_error.29) using The Inequality).

Why does it show up so often in machine learning? Mostly because in analyzing an algorithm you want to bound the probability that some bad event happens. Bad events are usually phrased similarly to

$\displaystyle \prod_{i=1}^m (1-p_i)$

And applying The Inequality we can bound this from above by

$\displaystyle\prod_{i=1}^m (1-p_i) \leq \prod_{i=1}^m e^{-p_i} = e^{-\sum_{i=1}^m p_i}$

The point is that usually $m$ is the size of your dataset, which you get to choose, and by picking larger $m$ you make the probability of the bad event vanish exponentially quickly in $m$. (Here $p_i$ is unrelated to how I am about to use $p_i$ as weights).

Of course, The Inequality has much deeper implications than bounds for the efficiency and correctness of machine learning algorithms. To convince you of the depth of this simple statement, let's see its use in an elegant proof of the arithmetic geometric inequality.

**Theorem: **(The arithmetic-mean geometric-mean inequality, general version): For all non-negative real numbers $a_1, \dots, a_n$ and all positive $p_1, \dots, p_n$ such that $p_1 + \dots + p_n = 1$, the following inequality holds:

$\displaystyle a_1^{p_1} \cdots a_n^{p_n} \leq p_1 a_1 + \dots + p_n a_n$

Note that when all the $p_i = 1/n$ this is the standard [AM-GM inequality.](https://en.wikipedia.org/wiki/Inequality_of_arithmetic_and_geometric_means)

_Proof._ This proof is due to George Polya (in Hungarian, Pólya György).

We start by modifying The Inequality $1+x \leq e^x$ by a shift of variables $x \mapsto x-1$, so that the inequality now reads $x \leq e^{x-1}$. We can apply this to each $a_i$ giving $a_i \leq e^{a_i - 1}$, and in fact,

$\displaystyle a_1^{p_1} \cdots a_n^{p_n} \leq e^{\sum_{i=1}^n p_ia_i - p_i} = e^{\left ( \sum_{i=1}^n p_ia_i \right ) - 1}$

Now we have something quite curious: if we call $A$ the sum $p_1a_1 + \dots + p_na_n$, the above shows that $a_1^{p_1} \cdots a_n^{p_n} \leq e^{A-1}$. Moreover, again because $A \leq e^{A-1}$ that shows that the right hand side of the inequality we're trying to prove is also bounded by $e^{A-1}$. So we know that _both_ sides of our desired inequality (and in particular, the max) is bounded from above by $e^{A-1}$. This seems like a conundrum until we introduce the following beautiful idea: normalize by the thing you think should be the larger of the two sides of the inequality.

Define new variables $b_i = a_i / A$ and notice that $\sum_i p_i b_i = 1$ just by unraveling the definition. Call this sum $B = \sum_i p_i b_i$. Now we know that

$b_1^{p_1} \cdots b_n^{p_n} = \left ( \frac{a_1}{A} \right )^{p_1} \cdots \left ( \frac{a_n}{A} \right )^{p_n} \leq e^{B - 1} = e^0 = 1$

Now we unpack the pieces, and multiply through by $A^{p_1}A^{p_2} \cdots A^{p_n} = A$, the result is exactly the AM-GM inequality.

$\square$

Even deeper, there is only one case when The Inequality is tight, i.e. when $1+x = e^x$, and that is $x=0$. This allows us to use the proof above to come to a full characterization of the case of equality in the proof above. Indeed, the crucial step was that $(a_i / A) = e^{A-1}$, which is only true when $(a_i / A) = 1$, i.e. when $a_i = A$. Spending a few seconds thinking about this gives the characterization of equality if and only if $a_1 = a_2 = \dots = a_n = A$.

So this is excellent: the arithmetic-geometric inequality is a deep theorem with applications all over mathematics and statistics. Adding another layer of indirection for impressiveness, one can use the AM-GM inequality to [prove](http://rgmia.org/papers/v12e/Cauchy-Schwarzinequality.pdf) the Cauchy-Schwarz inequality rather directly. Sadly, [the Wikipedia page for the Cauchy-Schwarz inequality](https://en.wikipedia.org/wiki/Cauchy%E2%80%93Schwarz_inequality#Applications) hardly does it justice as far as the massive number of applications. For example, many novel techniques in [geometry](http://www.maths.bris.ac.uk/~maxmr/opt/cauchy-shcwarz.pdf) and [number theory](https://en.wikipedia.org/wiki/Large_sieve) are proved directly from C-S. More, in fact, than I can hope to learn.

Of course, no article about The Inequality could be complete without a proof of The Inequality.

**Theorem: **For all $x \in \mathbb{R}$, $1+x \leq e^x$.

_Proof. _The proof starts by proving a simpler theorem, named after Bernoulli, that $1+nx \leq (1+x)^n$ for every $x [-1, \infty)$ and every $n \in \mathbb{N}$. This is relatively straightforward by induction. The base case is trivial, and

$\displaystyle (1+x)^{n+1} = (1+x)(1+x)^n \geq (1+x)(1+nx) = 1 + (n+1)x + nx^2$

And because $nx^2 \geq 0$, we get Bernoulli's inequality.

Now for any $z \geq 0$ we can set $x = z/n$, and get $(1+z) = (1+nx) \leq (1+\frac{z}{n})^n$ for every $n$. Note that Bernoulli's inequality is preserved for larger and larger $n$ because $x \geq 0$. So taking limits of both sides as $n \to \infty$ we get the definition of $e^z$ on the right hand side of the inequality. We can prove a symmetrical inequality for $-x$ when $x < 0$, and this proves the theorem.

$\square$

What other insights can we glean about The Inequality? For one, it's a truncated version of the Taylor series approximation

$\displaystyle e^x = 1 + x + \frac{x^2}{2!} + \frac{x^3}{3!} + \dots$

Indeed, the Taylor remainder theorem tells us that the first two terms approximate $e^x$ around zero with error depending on some constant times $e^x x^2 \geq 0$. In other words, $1+x$ is a lower bound on $e^x$ around zero. It is perhaps miraculous that this extends to a lower bound everywhere, until you realize that exponentials grow extremely quickly and lines do not.

One might wonder whether we can improve our approximation with higher order approximations. Indeed we can, but we have to be a bit careful. In particular, $1+x+x^2/2 \leq e^x$ is only true for nonnegative $x$ (because the remainder theorem now applies to $x^3$, but if we restrict to odd terms we win: $1+x+x^2/2 + x^3/6 \leq e^x$ is true for all $x$.

What is really surprising about The Inequality is that, at least in the applications I work with, we rarely see higher order approximations used. For most applications, The difference between an error term which is quadratic and one which is cubic or quartic is often not worth the extra work in analyzing the result. You get the same theorem: that something vanishes exponentially quickly.

If you're interested in learning more about the theory of inequalities, I wholeheartedly recommend [The Cauchy-Schwarz Master Class](http://www.amazon.com/gp/product/052154677X/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=052154677X&linkCode=as2&tag=mathinterpr00-20&linkId=UNQQ7FKX5OR327DH). This book is wonderfully written, and chock full of fun exercises. I know because I do exercises from books like this one on planes and trains. It's my kind of sudoku :)
