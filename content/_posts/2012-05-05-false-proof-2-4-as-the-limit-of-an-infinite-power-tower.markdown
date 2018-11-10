---
author: jeremykun
date: 2012-05-05 19:06:34+00:00
draft: false
title: False Proof – 2 = 4, As the Limit of an Infinite Power Tower
type: post
url: /2012/05/05/false-proof-2-4-as-the-limit-of-an-infinite-power-tower/
categories:
- Analysis
- Proof Gallery
tags:
- false proof
- mathematics
---

**Problem:** Prove that $2 = 4$.

**Solution:** Consider the value of the following infinitely iterated exponent:


$\displaystyle \sqrt{2}^{\sqrt{2}^{\sqrt{2}^{\cdot^{\cdot^{\cdot}}}}}$




Let $a_n = \sqrt{2} \uparrow \uparrow n$, that is, the above power tower where we stop at the $n$-th term. Then $a_n$ is clearly an increasing sequence, and moreover $a_n \leq 4$ by a trivial induction argument: $\sqrt{2} \leq 4$ and if $a_n \leq 4$ then $a_{n+1} = (\sqrt{2})^{a_n} \leq (\sqrt{2})^{4} = 4$.




So by basic results in analysis, the sequence of $a_n$ converges to a limit. Let's call this limit $x$, and try to solve for it.




It is not hard to see that $x$ is defined by the equation:




$\displaystyle (\sqrt{2})^x = x,$




simply because the infinite power tower starting at the second level is the same as the infinite power tower starting at the first level. However, we notice that $x=2$ and $x=4$ both satisfy this relationship. Hence,




$\displaystyle 2 = \sqrt{2}^{\sqrt{2}^{\sqrt{2}^{\cdot^{\cdot^{\cdot}}}}} = 4$




And hence $2=4$, as desired. $\square$




**Explanation****:** The issue here is relatively subtle, but one trained in real analysis should have no trouble spotting the problem.




The first alarm is that we are claiming that the limit of a sequence is not unique, which is always false. Inspecting this argument more closely, we corner the flaw to our claim that $x$ is _defined_ by the equation $(\sqrt{2})^x = x$. It does, in fact, satisfy this equation, but there is a world of difference between satisfying an equation and being defined by satisfying an equation. One might say that this only makes sense when there is a unique solution to the equation. But as we just saw, there are multiple valid solutions here: 2 and 4 (I don't immediately see any others; it's clear no other powers of two will work).




Analogously, one might erroneously say that $i$ is _defined_ by satisfying the equation $x^2 = -1$, but this does not imply $i = -i$, since the equation has two differing complex roots. This is a slightly murky analogy, as complex conjugation gives an automorphism of $\mathbb{C}$. One would reasonably argue that $i$ and $-i$ "play the same role" in this field, while 2 and 4 play wildly different roles as real numbers. But nevertheless, they are not _equal_ simply by virtue of satisfying the same equation.




Moreover, while we said the sequence was bounded from above by 4, an identical argument shows it's bounded from above by 2. And so one can immediately conclude that the limit of the sequence cannot be 4.




In fact, this infinite tower power $x^{x^{\cdot^{\cdot^{\cdot}}}}$_ is continuous as a function_, whose domain is the interval $[e^{-e}, \sqrt[e]{e}]$ and whose range is $[e^{-1},e]$. For more information about interesting number-theoretic properties of infinite power towers, see [this paper](http://www.nntdm.net/papers/nntdm-16/NNTDM-16-3-18-24.pdf).
