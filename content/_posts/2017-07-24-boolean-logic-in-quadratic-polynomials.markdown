---
author: jeremykun
date: 2017-07-24 16:00:38+00:00
draft: false
title: Boolean Logic in Polynomials
type: post
url: /2017/07/24/boolean-logic-in-quadratic-polynomials/
categories:
- Computing Theory
- Logic
- Optimization
tags:
- boolean satisfiability
- optimization
- polynomials
---

**Problem: **Express a boolean logic formula using polynomials. I.e., if an input variable $x$ is set to $0$, that is interpreted as false, while $x=1$ is interpreted as true. The output of the polynomial should be 0 or 1 according to whether the formula is true or false as a whole.

**Solution:** You can do this using a single polynomial.

Illustrating with an example: the formula is $\neg[(a \vee b) \wedge (\neg c \vee d)]$ also known as

{{< highlight python >}}
not((a or b) and (not c or d))
{{< /highlight >}}

The trick is to use multiplication for "and" and $1-x$ for "not." So $a \wedge b$ would be $x_1 x_2$, and $\neg z$ would be $1-z$. Indeed, if you have two binary variables $x$ and $y$ then $xy$ is 1 precisely when both are 1, and zero when either variable is zero. Likewise, $1-x = 1$ if $x$ is zero and zero if $x$ is one.

Combine this with [deMorgan's rule](https://en.wikipedia.org/wiki/De_Morgan%27s_laws) to get any formula. $a \vee b = \neg(\neg a \wedge \neg b)$ translates to $1 - (1-a)(1-b)$. For our example above,


$\displaystyle f(x_1, x_2, x_3, x_4) = 1 - (1 - (1-a)(1-b))(1 - c(1-d))$




Which expands to




$\displaystyle 1 - a - b + ab + (1-d)(ac + bc - abc)$




If you plug in $a = 1, b = 0, c = 1, d = 0$ you get True in the original formula (because "not c or d" is False), and likewise the polynomial is




$\displaystyle 1 - 1 - 0 + 0 + (1-0)(1 + 0 - 0) = 1$




You can verify the rest work yourself, using the following table as a guide:


{{< highlight python >}}
0, 0, 0, 0 -> 1
0, 0, 0, 1 -> 1
0, 0, 1, 0 -> 1
0, 0, 1, 1 -> 1
0, 1, 0, 0 -> 0
0, 1, 0, 1 -> 0
0, 1, 1, 0 -> 1
0, 1, 1, 1 -> 0
1, 0, 0, 0 -> 0
1, 0, 0, 1 -> 0
1, 0, 1, 0 -> 1
1, 0, 1, 1 -> 0
1, 1, 0, 0 -> 0
1, 1, 0, 1 -> 0
1, 1, 1, 0 -> 1
1, 1, 1, 1 -> 0
{{< /highlight >}}

**Discussion: **This trick is used all over CS theory to embed boolean logic within polynomials, and it makes the name "boolean algebra" obvious, because it's just a subset of normal algebra.

Moreover, since boolean satisfiability—the problem of algorithmically determining if a boolean formula has a satisfying assignment (a choice of variables evaluating to true)—is NP-hard, this can be used to show certain problems relating to multivariable polynomials is also hard. For example, finding roots of multivariable polynomials (even if you knew nothing about algebraic geometry) is hard because you'd run into NP-hardness by simply considering the subset of polynomials coming from boolean formulas.

Here's a more interesting example, related to the kinds of optimization problems that show up in modern machine learning. Say you want to optimize a polynomial $f(x)$ subject to a set of quadratic equality constraints. This is NP-hard. Here's why.

Let $\varphi$ be a boolean formula, and $f_\varphi$ its corresponding polynomial. First, each variable $x_i$ used in the polynomial can be restricted to binary values via the constraint $x_i(x_i - 1) = 0$.

You can even show NP-hardness if the target function to optimize is only quadratic. As an exercise, one can express the subset sum problem as a quadratic programming problem using similar choices for the constraints. According to [this writeup](http://www-personal.umich.edu/~murty/np.pdf) you even express subset sum as a quadratic program with linear constraints.

The moral of the story is simply that multivariable polynomials can encode arbitrary boolean logic.
