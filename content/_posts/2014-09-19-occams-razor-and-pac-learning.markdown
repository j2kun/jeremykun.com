---
author: jeremykun
date: 2014-09-19 15:00:47+00:00
draft: false
title: Occam's Razor and PAC-learning
type: post
url: /2014/09/19/occams-razor-and-pac-learning/
categories:
- Computing Theory
- Learning Theory
- Probability Theory
tags:
- chernoff
- computational learning theory
- occam's razor
- pac-learning
- vc-dimension
---

So far our discussion of learning theory has been seeing the [definition of PAC-learning](http://jeremykun.com/2014/01/02/probably-approximately-correct-a-formal-theory-of-learning/), [tinkering](http://jeremykun.com/2014/04/21/an-un-pac-learnable-problem/) with it, and seeing simple examples of learnable concept classes. We've said that our real interest is in proving big theorems about what big classes of problems can and can't be learned. One major tool for doing this with PAC is the concept of VC-dimension, but to set the stage we're going to prove a simpler theorem that gives a nice picture of PAC-learning when your hypothesis class is small. In short, the theorem we'll prove says that if you have a finite set of hypotheses to work with, and you can always find a hypothesis that's consistent with the data you've seen, then you can learn efficiently. It's obvious, but we want to quantify exactly how much data you need to ensure low error. This will also give us some concrete mathematical justification for philosophical claims about simplicity, and the theorems won't change much when we generalize to VC-dimension in a future post.


## The Chernoff bound


One tool we will need in this post, which shows up all across learning theory, is the Chernoff-Hoeffding bound. We covered this famous inequality in detail [previously on this blog](http://jeremykun.com/2013/04/15/probabilistic-bounds-a-primer/), but the part of that post we need is the following theorem that says, informally, that if you average a bunch of bounded random variables, then the probability this average random variable deviates from its expectation is exponentially small in the amount of deviation. Here's the slightly simplified version we'll use:

**Theorem:** Let $X_1, \dots, X_m$ be independent random variables whose values are in the range $[0,1]$. Call $\mu_i = \mathbf{E}[X_i]$, $X = \sum_i X_i$, and $\mu = \mathbf{E}[X] = \sum_i \mu_i$. Then for all $t > 0$,


$\displaystyle \Pr(|X-\mu| > t) \leq 2e^{-2t^2 / m}$




One nice thing about the Chernoff bound is that it doesn't matter how the variables are distributed. This is important because in PAC we need guarantees that hold for any distribution generating data. Indeed, in our case the random variables above will be individual examples drawn from the distribution generating the data. We'll be estimating the probability that our hypothesis has error deviating more than $\varepsilon$, and we'll want to bound this by $\delta$, as in the definition of PAC-learning. Since the amount of deviation (error) and the number of samples ($m$) both occur in the exponent, the trick is in balancing the two values to get what we want.





## Realizability and finite hypothesis classes


Let's recall the PAC model once more. We have a distribution $D$ generating labeled examples $(x, c(x))$, where $c$ is an unknown function coming from some concept class $C$. Our algorithm can draw a polynomial number of these examples, and it must produce a hypothesis $h$ from some hypothesis class $H$ (which may or may not contain $c$). The guarantee we need is that, for any $\delta, \varepsilon > 0$, the algorithm produces a hypothesis whose error on $D$ is at most $\varepsilon$, and this event happens with probability at least $1-\delta$. All of these probabilities are taken over the randomness in the algorithm's choices and the distribution $D$, and it has to work no matter what the distribution $D$ is.

Let's introduce some simplifications. First, we'll assume that the hypothesis and concept classes $H$ and $C$ are _finite_. Second, we'll assume that $C \subset H$, so that you can actually hope to find a hypothesis of zero error. This is called _realizability. _Later we'll relax these first two assumptions, but they make the analysis a bit cleaner. Finally, we'll assume that we have an algorithm which, when given labeled examples, can find in polynomial time a hypothesis $h \in H$ that is consistent with every example.

These assumptions give a trivial learning algorithm: draw a bunch of examples and output any consistent hypothesis. The question is, how many examples do we need to guarantee that the hypothesis we find has the prescribed generalization error? It will certainly grow with $1 / \varepsilon$, but we need to ensure it will only grow polynomially fast in this parameter. Indeed, realizability is such a strong assumption that we can prove a polynomial bound using even more basic probability theory than the Chernoff bound.

**Theorem: **A algorithm that efficiently finds a consistent hypothesis will PAC-learn any finite concept class provided it has at least $m$ samples, where


$\displaystyle m \geq \frac{1}{\varepsilon} \left ( \log |H| + \log \left ( \frac{1}{\delta} \right ) \right )$


_Proof._ All we need to do is bound the probability that a bad hypothesis (one with error more than $\varepsilon$) is consistent with the given data. Now fix $D, c, \delta, \varepsilon$, and draw $m$ examples and let $h$ be any hypothesis that is consistent with the drawn examples. Suppose that the bad thing happens, that $\Pr_D(h(x) \neq c(x)) > \varepsilon$.

Because the examples are all drawn independently from $D$, the chance that all $m$ examples are consistent with $h$ is


$\displaystyle (1 - \Pr_{x \sim D}(h(x) \neq c(x)))^m < (1 - \varepsilon)^m$




What we're saying here is, the probability that a _specific_ bad hypothesis is actually consistent with your drawn examples is exponentially small in the error tolerance. So if we apply the union bound, the probability that _some_ hypothesis you could produce is bad is at most $(1 - \varepsilon)^m S$, where $S$ is the number of hypotheses the algorithm might produce.




A crude upper bound on the number of hypotheses you could produce is just the total number of hypotheses, $|H|$. Even cruder, let's use the inequality $(1 - x) < e^{-x}$ to give the bound




$\displaystyle (1 - \varepsilon)^m |H| < e^{-\varepsilon m} |H|$




Now we want to make sure that this probability, the probability of choosing a high-error (yet consistent) hypothesis, is at most $\delta$. So we can set the above quantity less than $\delta$ and solve for $m$:




$\displaystyle e^{-\varepsilon m} |H| \leq \delta$


Taking logs and solving for $m$ gives the desired bound.


$\square$




An obvious objection is: what if you aren't working with a hypothesis class where you can guarantee that you'll find a consistent hypothesis? Well, in that case we'll need to inspect the definition of PAC again and reevaluate our measures of error. It turns out we'll get a similar theorem as above, but with the stipulation that we're only achieving error within epsilon of the error of the best available hypothesis.




But before we go on, this theorem has some deep philosophical interpretations. In particular, suppose that, before drawing your data, you could choose to work with one of two finite hypothesis classes $H_1, H_2$, with $|H_1| > |H_2|$. If you can find a consistent hypothesis no matter which hypothesis class you use, then this theorem says that your generalization guarantees are much stronger if you start with the _smaller_ hypothesis class.




In other words, all else being equal, the smaller set of hypotheses is better. For this reason, the theorem is sometimes called the "Occam's Razor" theorem. We'll see a generalization of this theorem in the next section.





## <del></del>Unrealizability and an extra epsilon


Now suppose that $H$ doesn't contain any hypotheses with error less than $\varepsilon$. What can we hope to do in this case? One thing is that we can hope to find a hypothesis whose error is within $\varepsilon$ of the minimal error of any hypothesis in $H$. Moreover, we might not have any consistent hypotheses for some data samples! So rather than require an algorithm to produce an $h \in H$ that is perfectly consistent with the data, we just need it to produce a hypothesis that has minimal _empirical error_, in the sense that it is as close to consistent as the best hypothesis of $h$ on the data you happened to draw. It seems like such a strategy would find you a hypothesis that's close to the best one in $H$, but we need to prove it and determine how many samples we need to draw to succeed.

So let's make some definitions to codify this. For a given hypothesis, call $\textup{err}(h)$ the _true error_ of $h$ on the distribution $D$. Our assumption is that there may be no hypotheses in $H$ with $\textup{err}(h) = 0$. Next we'll call the _empirical error _$\hat{\textup{err}}(h)$.

**Definition: **We say a concept class $C$ is _agnostically_ learnable using the hypothesis class $H$ if for all $c \in C$ and all distributions $D$ (and all $\varepsilon, \delta > 0$), there is a learning algorithm $A$ which produces a hypothesis $h$ that with probability at least $1 - \delta$ satisfies


$\displaystyle \text{err}(h) \leq \min_{h' \in H} \text{err}(h') + \varepsilon$


and everything runs in the same sort of polynomial time as for vanilla PAC-learning. This is called the _agnostic _setting or the _unrealizable_ setting, in the sense that we may not be able to find a hypothesis with perfect empirical error.

We seek to prove that all concept classes are agnostically learnable with a finite hypothesis class, provided you have an algorithm that can minimize empirical error. But actually we'll prove something stronger.

**Theorem: **Let $H$ be a finite hypothesis class and $m$ the number of samples drawn. Then for any $\delta > 0$, with probability $1-\delta$ the following holds:


$\displaystyle \forall h \in H, \hat{\text{err}}(h) \leq \text{err}(h) + \sqrt{\frac{\log |H| + \log(2 / \delta)}{2m}}$


In other words, we can precisely quantify how the empirical error converges to the true error as the number of samples grows. But this holds _for all_ hypotheses in $H$, so this provides a uniform bound of the difference between true and empirical error for the entire hypothesis class.

Proving this requires the Chernoff bound. Fix a single hypothesis $h \in H$. If you draw an example $x$, call $Z$ the random variable which is 1 when $h(x) \neq c(x)$, and 0 otherwise. So if you draw $m$ samples and call the $i$-th variable $Z_i$, the empirical error of the hypothesis is $\frac{1}{m}\sum_i Z_i$. Moreover, the actual error is the expectation of this random variable since $\mathbf{E}[1/m \sum_i Z_i] = Z$.

So what we're asking is the probability that the empirical error deviates from the true error by a lot. Let's call "a lot" some parameter $\varepsilon/2 > 0$ (the reason for dividing by two will become clear in the corollary to the theorem). Then plugging things into the Chernoff-Hoeffding bound gives a bound on the probability of the "bad event," that the empirical error deviates too much.


$\displaystyle \Pr[|\hat{\text{err}}(h) - \text{err}(h)| > \varepsilon / 2] < 2e^{-\frac{\varepsilon^2m}{2}}$




Now to get a bound on the probability that _some_ hypothesis is bad, we apply the union bound and use the fact that $|H|$ is finite to get




$\displaystyle \Pr[|\hat{\text{err}}(h) - \text{err}(h)| > \varepsilon / 2] < 2|H|e^{-\frac{\varepsilon^2m}{2}}$




Now say we want to bound this probability by $\delta$. We set $2|H|e^{-\varepsilon^2m/2} \leq \delta$, solve for $m$, and get




$\displaystyle m \geq \frac{2}{\varepsilon^2}\left ( \log |H| + \log \frac{2}{\delta} \right )$




This gives us a concrete quantification of the tradeoff between $m, \varepsilon, \delta, $ and $|H|$. Indeed, if we pick $m$ to be this large, then solving for $\varepsilon / 2$ gives the exact inequality from the theorem.




$\square$




Now we know that if we pick enough samples (polynomially many in all the parameters), and our algorithm can find a hypothesis $h$ of minimal empirical error, then we get the following corollary:




**Corollary: **For any $\varepsilon, \delta > 0$, the algorithm that draws $m \geq \frac{2}{\varepsilon^2}(\log |H| + \log(2/ \delta))$ examples and finds any hypothesis of minimal empirical error will, with probability at least $1-\delta$, produce a hypothesis that is within $\varepsilon$ of the best hypothesis in $H$.




_Proof. _By the previous theorem, with the desired probability, for all $h \in H$ we have $|\hat{\text{err}}(h) - \text{err}(h)| < \varepsilon/2$. Call $g = \min_{h' \in H} \text{err}(h')$. Then because the empirical error of $h$ is also minimal, we have $|\hat{\text{err}}(g) - \text{err}(h)| < \varepsilon / 2$. And using the previous theorem again and the triangle inequality, we get $|\text{err}(g) - \text{err}(h)| < 2 \varepsilon / 2 = \varepsilon$. In words, the true error of the algorithm's hypothesis is close to the error of the best hypothesis, as desired.




$\square$





## Next time




Both of these theorems tell us something about the generalization guarantees for learning with hypothesis classes of a certain size. But this isn't exactly the most reasonable measure of the "complexity" of a family of hypotheses. For example, one could have a hypothesis class with a billion intervals on $\mathbb{R}$ (say you're trying to learn intervals, or thresholds, or something easy), and the guarantees we proved in this post are nowhere near optimal.




So the question is: say you have a potentially infinite class of hypotheses, but the hypotheses are all "simple" in some way. First, what is the right notion of simplicity? And second, how can you get guarantees based on that analogous to these? We'll discuss this next time when we define the VC-dimension.




Until then!
