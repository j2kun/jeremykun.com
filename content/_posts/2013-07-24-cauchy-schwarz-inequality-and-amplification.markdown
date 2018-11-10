---
author: jeremykun
date: 2013-07-24 01:33:41+00:00
draft: false
title: Cauchy-Schwarz Inequality (and Amplification)
type: post
url: /2013/07/23/cauchy-schwarz-inequality-and-amplification/
categories:
- Analysis
- Linear Algebra
- Optimization
- Proof Gallery
tags:
- cauchy-schwarz
---

**Problem: **Prove that for vectors $v, w$ in an [inner product space](http://jeremykun.com/2011/07/25/inner-product-spaces-a-primer/), the inequality

$\displaystyle |\left \langle v, w \right \rangle | \leq \| v \| \| w \|$

**Solution:** There is an elementary proof of the Cauchy-Schwarz inequality (see [the Wikipedia article](http://en.wikipedia.org/wiki/Cauchy%E2%80%93Schwarz_inequality#Proof)), and this proof is essentially the same. What makes this proof stand out is its insightful technique, which I first read about on [Terry Tao's blog](http://terrytao.wordpress.com/2007/09/05/amplification-arbitrage-and-the-tensor-power-trick/). He calls it "textbook," and maybe it is for an analyst, but it's still very elegant.

We start by observing another inequality we know to be true, that $\| v - w \|^2 = \left \langle v - w, v - w \right \rangle \geq 0$, since norms are by definition nonnegative. By the properties of a complex inner product we can expand to get

$\displaystyle \| v \|^2 - 2 \textup{Re}(\left \langle v,w \right \rangle) + \| w \|^2 \geq 0$

or equivalently

$\displaystyle \textup{Re}(\left \langle v,w \right \rangle) \leq \frac{1}{2} \| v \|^2 + \frac{1}{2} \| w \|^2$

This inequality is close to the one we're looking for, but 'weaker' because the inequality we seek squeezes inside the inequality we have. That is,

$\displaystyle \textup{Re}(\left \langle v,w \right \rangle) \leq |\left \langle v, w \right \rangle | \leq \| v \| \| w \| \leq \frac{1}{2} \| v \|^2 + \frac{1}{2} \| w \|^2$

The first inequality is trivial (a complex number is always greater than its real part), the second is the inequality we seek to prove, and the third is a consequence of [the arithmetic-geometric mean inequality](http://en.wikipedia.org/wiki/Inequality_of_arithmetic_and_geometric_means). And so we have an inequality we'd like to "tighten" to get the true theorem. We do this by tightening each side of the inequality separately, and we do each by exploiting symmetries in the expressions involved.

First, we observe that norms of vectors are preserved by (complex) rotations $v \mapsto e^{i \theta}v$, but the real part is not. Since this inequality is true no matter which vectors we choose, we can choose $\theta$ to our advantage. That is,

$\displaystyle \textup{Re}(\left \langle e^{i \theta}v, w \right \rangle) \leq \frac{1}{2} \| e^{i \theta}v \|^2 + \frac{1}{2} \| w \|^2$

And by properties of inner products and norms (pulling out scalars) and the fact that $|e^{i\theta}| = 1$, we can simplify to

$\displaystyle \textup{Re}(e^{i \theta}\left \langle v,w \right \rangle) \leq \frac{1}{2}\| v \|^2 + \frac{1}{2} \| w \|^2$

where $\theta$ is arbitrary. Since we want to maximize the left hand side as much as possible, we can choose $\theta$ to be whatever is required to make the number real. Then the real part is just the absolute value of the number itself, and we have

$\displaystyle \left |\langle v,w \right \rangle | \leq \frac{1}{2} \| v \|^2 + \frac{1}{2} \| w \|^2$

Now we tighten the right hand side by exploiting a symmetry in inner products: the transformation $(v,w) \mapsto (\lambda v, \frac{1}{\lambda} w)$ preserves the left hand side (since $|\lambda / \bar{\lambda}| = 1$) but not the right. And so by the same reasoning, we can transform the above inequality into

$\displaystyle \left |\langle v,w \right \rangle | \leq \frac{\lambda^2}{2} \| v \|^2 + \frac{1}{2 \lambda^2} \| w \|^2$

And by plugging in $\lambda = \sqrt{\| w \| / \| v \|}$ (indeed, this minimizes the expression for nonzero $v,w$) we get exactly the Cauchy-Schwarz inequality, as desired.

$\square$

This technique is termed "amplification" by Tao, and [in his blog post](http://terrytao.wordpress.com/2007/09/05/amplification-arbitrage-and-the-tensor-power-trick/) he gives quite a few more advanced examples in harmonic and functional analysis (which are far beyond the scope of this blog).   The asymmetrical symmetry we took advantage of is a sort of "arbitrage" (again Terry's clever choice of words) to take a weak fact and boost it to a stronger fact. And while the details of this proof are quite trivial, the technique of actively looking for one-sided symmetries is difficult to forget.
