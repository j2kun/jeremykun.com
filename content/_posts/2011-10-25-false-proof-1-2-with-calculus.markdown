---
author: jeremykun
date: 2011-10-25 19:46:12+00:00
draft: false
title: 'False Proof: 1 = 2 (with Calculus)'
type: post
url: /2011/10/25/false-proof-1-2-with-calculus/
categories:
- Proof Gallery
tags:
- calculus
- false proof
---

**Problem**: Show 1 = 2 (with calculus)

"**Solution"**: Consider the following:


$1^2 = 1$
$2^2 = 2 + 2$
$3^2 = 3 + 3 + 3$
$\vdots$
$x^2 = x + x + \dots + x$ ($x$ times)


And since this is true for all values of $x$, we may take the derivative of both sides, and the equality remains true. In other words:


$2x = 1 + 1 + \dots + 1$ ($x$ times)


Which simplifies to $x=2x$, and plugging in $x=1$ we have $1 = 2$, as desired.

**Explanation**: Though there are some considerations about the continuity of adding something to itself a variable number of times, the true error is as follows. If we are taking the derivative of a function with respect to $x$, then we need to take into account _all_ parts of that function which involve the variable. In this case, we ignored that the number of times we add $x$ to itself depends on $x$. In other words, $x + x + \dots + x$ ($x$ times) is a function of _two_ variables in disguise:


$f(u,v) = u + u + \dots + u$ ($v$ times)


And our mistake was to only take the derivative with respect to the first variable, and ignore the second variable. Unsurprisingly, we made miracles happen after that.

Addendum: Continuing with this logic, we could go on to say:


$x = 1 + 1 + \dots + 1$ ($x$ times)


But certainly the right hand side is _not_ constant with respect to $x$, even though each term is.
