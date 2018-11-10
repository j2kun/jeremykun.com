---
author: jeremykun
date: 2013-04-15 16:14:32+00:00
draft: false
title: Probabilistic Bounds — A Primer
type: post
url: /2013/04/15/probabilistic-bounds-a-primer/
categories:
- Primers
- Probability Theory
tags:
- chebyshev
- chernoff
- markov
- mathematics
- probabilistic method
- random variables
- variance
---

Probabilistic arguments are a key tool for the analysis of algorithms in machine learning theory and probability theory. They also assume a prominent role in the analysis of randomized and streaming algorithms, where one imposes a restriction on the amount of storage space an algorithm is allowed to use for its computations (usually sublinear in the size of the input).

While a whole host of probabilistic arguments are used, one theorem in particular (or family of theorems) is ubiquitous: the Chernoff bound. In its simplest form, the Chernoff bound gives an _exponential_ bound on the deviation of sums of random variables from their expected value.

This is perhaps most important to algorithm analysis in the following mindset. Say we have a program whose output is a random variable $X$. Moreover suppose that the expected value of $X$ is the correct output of the algorithm. Then we can run the algorithm multiple times and take a median (or some sort of average) across all runs. The probability that the algorithm gives a _wildly_ incorrect answer is the probability that more than half of the runs give values which are wildly far from their expected value. Chernoff's bound ensures this will happen with small probability.

So this post is dedicated to presenting the main versions of the Chernoff bound that are used in learning theory and randomized algorithms. Unfortunately the _proof_ of the Chernoff bound in its full glory is beyond the scope of this blog. However, we will give short proofs of weaker, simpler bounds as a straightforward application of this blog's previous work laying down the theory.

If the reader has not yet intuited it, this post will rely heavily on the mathematical formalisms of probability theory. We will assume our reader is familiar with the material from our [first probability theory primer](http://jeremykun.com/2013/01/04/probability-theory-a-primer/), and it certainly wouldn't hurt to have read our [conditional probability theory primer](http://jeremykun.com/2013/03/28/conditional-partitioned-probability-a-primer/), though we won't use conditional probability directly. We will refrain from using measure-theoretic probability theory entirely (some day my colleagues in analysis will like me, but not today).


## Two Easy Bounds of Markov and Chebyshev


The first bound we'll investigate is almost trivial in nature, but comes in handy. Suppose we have a random variable $X$ which is non-negative (as a function). Markov's inequality is the statement that, for any constant $a > 0$,


$\displaystyle \textup{P}(X \geq a) \leq \frac{\textup{E}(X)}{a}$




In words, the probability that $X$ grows larger than some fixed constant is bounded by a quantity that is inversely proportional to the constant.




The proof is quite simple. Let $\chi_a$ be the indicator random variable for the event that $X \geq a$ ($\chi_a = 1$ when $X \geq a$ and zero otherwise). As with all indicator random variables, the expected value of $\chi_a$ is the probability that the event happens (if this is mysterious, use the definition of expected value). So $\textup{E}(\chi_a) = \textup{P}(X \geq a)$, and linearity of expectation allows us to include a factor of $a$:




$\textup{E}(a \chi_a) = a \textup{P}(X \geq a)$




The rest of the proof is simply the observation that $\textup{E}(a \chi_a) \leq \textup{E}(X)$. Indeed, as random variables we have the inequality $a \chi_a \leq X$. Whenever $X < a$, the value of $a \chi_a = 0$ while $X$ is nonnegative by definition. And whenever $a \leq X$,the value of $a \chi_a = a$ while $X$ is by assumption at least $a$. It follows that $\textup{E}(a \chi_a) \leq \textup{E}(X)$.




This last point is a simple property of expectation we omitted from our first primer. It usually goes by _monotonicity of expectation,_ and we prove it here. First, if $X \geq 0$ then $\textup{E}(X) \geq 0$ (this is trivial). Second, if $0 \leq X \leq Y$, then define a new random variable $Z = Y-X$. Since $Z \geq 0$ and using linearity of expectation, it must be that $\textup{E}(Z) = \textup{E}(Y) - \textup{E}(X) \geq 0$. Hence $\textup{E}(X) \leq \textup{E}(Y)$. Note that we do require that $X$ has a finite expected value for this argument to work, but if this is not the case then Markov's inequality is nonsensical anyway.




Markov's inequality by itself is not particularly impressive or useful. For example, if $X$ is the number of heads in a hundred coin flips, Markov's inequality ensures us that the probability of getting at least 99 heads is at most 50/99, which is about 1/2. Shocking. We know that the true probability is much closer to $2^{-100}$, so Markov's inequality is a bust.




However, it does give us a more useful bound as a corollary. This bound is known as Chebyshev's inequality, and its use is sometimes referred to as the [_second moment method_](http://en.wikipedia.org/wiki/Second_moment_method) because it gives a bound based on the variance of a random variable (instead of the expected value, the "first moment").




The statement is as follows.




**Chebyshev's Inequality: **Let $X$ be a random variable with finite expected value and positive variance. Then we can bound the probability that $X$ deviates from its expected value by a quantity that is proportional to the variance of $X$. In particular, for any $\lambda > 0$,




$\displaystyle \textup{P}(|X - \textup{E}(X)| \geq \lambda) \leq \frac{\textup{Var}(X)}{\lambda^2}$




And without any additional assumptions on $X$, [this bound is sharp](http://en.wikipedia.org/wiki/Chebyshev's_inequality#Sharpness_of_bounds).




_Proof._ The proof is a simple application of Markov's inequality. Let $Y = (X - \textup{E}(X))^2$, so that $\textup{E}(Y) = \textup{Var}(X)$. Then by Markov's inequality




$\textup{P}(Y \geq \lambda^2) \leq \frac{\textup{E}(Y)}{\lambda^2}$




Since $Y$ is nonnegative $|X - \textup{E}(X)| = \sqrt(Y)$, and $\textup{P}(Y \geq \lambda^2) = \textup{P}(|X - \textup{E}(X)| \geq \lambda)$. The theorem is proved. $\square$




Chebyshev's inequality shows up in so many different places (and usually in rather dry, technical bits), that it's difficult to give a good example application.  Here is one that shows up somewhat often.




Say $X$ is a nonnegative integer-valued random variable, and we want to argue about when $X = 0$ versus when $X > 0$, given that we know $\textup{E}(X)$. No matter how large $\textup{E}(X)$ is, it can still be possible that $\textup{P}(X = 0)$ is arbitrarily close to 1. As a colorful example, let $X$ is the number of alien lifeforms discovered in the next ten years. We might debate that $\textup{E}(X)$ can arbitrarily large: if some unexpected scientific and technological breakthroughs occur tomorrow, we could discover an unbounded number of lifeforms. On the other hand, we are very likely not to discover any, and probability theory allows for such a random variable to exist.




If we know everything about $\textup{Var}(X)$, however, we can get more informed bounds.




**Theorem:** If $\textup{E}(X) \neq 0$, then $\displaystyle \textup{P}(X = 0) \leq \frac{\textup{Var}(X)}{\textup{E}(X)^2}$.




_Proof._ Simply choose $\lambda = \textup{E}(X)$ and apply Chebyshev's inequality._
_




$\displaystyle \textup{P}(X = 0) \leq \textup{P}(|X - \textup{E}(X)| \geq \textup{E}(X)) \leq \frac{\textup{Var}(X)}{\textup{E}(X)^2}$




The first inequality follows from the fact that the only time $X$ can ever be zero is when $|X - \textup{E}(X)| = \textup{E}(X)$, and $X=0$ only accounts for one such possibility. $\square$




This theorem says more. If we know that $\textup{Var}(X)$ is significantly smaller than $\textup{E}(X)^2$, then $X > 0$ is more certain to occur. More precisely, and more computationally minded, suppose we have a sequence of random variables $X_n$ so that $\textup{E}(X_n) \to \infty$ as $n \to \infty$. Then the theorem says that if $\textup{Var}(X_n) = o(\textup{E}(X_n)^2)$, then $\textup{P}(X_n > 0) \to 1$. Remembering one of our [very early primers on asymptotic notation](http://jeremykun.com/2011/06/14/big-o-notation-a-primer/), $f = o(g)$ means that $f$ grows asymptotically slower than $g$, and in terms of this fraction $\textup{Var}(X) / \textup{E}(X)^2$, this means that the denominator dominates the fraction so that the whole thing tends to zero.





## The Chernoff Bound


The Chernoff bound takes advantage of an additional hypothesis: our random variable is a sum of independent coin flips. We can use this to get exponential bounds on the deviation of the sum. More rigorously,

**Theorem: **Let $X_1 , \dots, X_n$ be independent random $\left \{ 0,1 \right \}$-valued variables, and let $X = \sum X_i$. Suppose that $\mu = \textup{E}(X)$. Then the probability that $X$ deviates from $\mu$ by more than a factor of $\lambda > 0$ is bounded from above:


$\displaystyle \textup{P}(X > (1+\lambda)\mu) \leq \frac{e^{\lambda \mu}}{(1+\lambda)^{(1+\lambda)\mu}}$


The proof is beyond the scope of this post, but we point the interested reader to [these lecture notes](http://www.cs.berkeley.edu/~jfc/cs174/lecs/lec10/lec10.pdf).

We can apply the Chernoff bound in an easy example. Say all $X_i$ are fair coin flips, and we're interested in the probability of getting more than 3/4 of the coins heads. Here $\mu = n/2$ and $\lambda = 1/2$, so the probability is bounded from above by


$\displaystyle \left ( \frac{e}{(3/2)^3} \right )^{n/4} \approx \frac{1}{5^n}$




So as the number of coin flips grows, the probability of seeing such an occurrence diminishes extremely quickly to zero. This is important because if we want to _test_ to see if, say, the coins are biased toward flipping heads, we can simply run an experiment with $n$ sufficiently large. If we observe that more than 3/4 of the flips give heads, then we proclaim the coins are biased and we can be assured we are correct with high probability. Of course, after seeing 3/4 of more heads we'd be _really_ confident that the coin is biased. A more realistic approach is to define some $\varepsilon$ that is small enough so as to say, "if some event occurs whose probability is smaller than $\varepsilon$, then I call shenanigans." Then decide how many coins and what bound one would need to make the bad event have probability approximately $\varepsilon$. Finding this balance is one of the more difficult aspects of probabilistic algorithms, and as we'll see later all of these quantities are left as variables and the correct values are discovered in the course of the proof.





## Chernoff-Hoeffding Inequality


The Hoeffding inequality (named after the Finnish statistician, [Wassily Høffding](http://en.wikipedia.org/wiki/Wassily_Hoeffding)) is a variant of the Chernoff bound, but often the bounds are collectively known as Chernoff-Hoeffding inequalities. The form that Hoeffding is known for can be thought of as a simplification and a slight generalization of Chernoff's bound above.

**Theorem: **Let $X_1, \dots, X_n$ be independent random variables whose values are within some range $[a,b]$. Call $\mu_i = \textup{E}(X_i)$, $X = \sum_i X_i$, and $\mu = \textup{E}(X) = \sum_i \mu_i$. Then for all $t > 0$,


$\displaystyle \textup{P}(|X - \mu| > t) \leq 2e^{-2t^2 / n(b-a)^2}$




For example, if we are interested in the sum of $n$ rolls of a fair six-sided die, then the probability that we deviate from $(7/2)n$ by more than $5 \sqrt{n \log n}$ is bounded by $2e^{(-2 \log n)} = 2/n^2$. Supposing we want to know how many rolls we need to guarantee with probability 0.01 that we don't deviate too much, we just do the algebra:




$2n^{-2} < 0.01$
$n^2 > 200$
$n > \sqrt{200} \approx 14$




So with 15 rolls we can be confident that the sum of the rolls will lie between 20 and 85. It's not the best possible bound we could come up with, because we're completely ignoring the known structure on dice rolls (that they follow a uniform distribution!). The benefit is that it's a quick and easy bound that works for _any_ kind of random variable with that expected value.




Another version of this theorem concerns the _average_ of the $X_i$, and is only a minor modification of the above.




**Theorem:** If $X_1, \dots, X_n$ are as above, and $X = \frac{1}{n} \sum_i X_i$, with $\mu = \frac{1}{n}(\sum_i \mu_i)$, then for all $t > 0$, we get the following bound




$\displaystyle \textup{P}(|X - \mu| > t) \leq 2e^{-2nt^2/(b-a)^2}$




The only difference here is the extra factor of $n$ in the exponent. So the deviation is exponential both in the amount of deviation ($t^2$), and in the number of trials.




This theorem comes up very often in learning theory, in particular to prove [Boosting](http://en.wikipedia.org/wiki/Boosting_(machine_learning)) works. Mathematicians will joke about how all theorems in learning theory are just applications of Chernoff-Hoeffding-type bounds. We'll of course be seeing it again as we investigate boosting and the PAC-learning model in future posts, so we'll see the theorems applied to their fullest extent then.




Until next time!
