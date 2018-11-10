---
author: jeremykun
date: 2014-02-10 16:00:40+00:00
draft: false
title: Elliptic Curves as Elementary Equations
type: post
url: /2014/02/10/elliptic-curves-as-elementary-equations/
categories:
- Combinatorics
- Cryptography
- Group Theory
- Number Theory
tags:
- algebra
- cryptography
- elliptic curves
- mathematica
- mathematics
---

Finding solutions to systems of polynomial equations is one of the oldest and deepest problems in all of mathematics. This is broadly the domain of algebraic geometry, and mathematicians wield some of the most sophisticated and abstract tools available to attack these problems.

The elliptic curve straddles the elementary and advanced mathematical worlds in an interesting way. On one hand, it's easy to describe in elementary terms: it's the set of solutions to a cubic function of two variables. But despite how simple they seem deep theorems govern their behavior, and many natural questions about elliptic curves are still wide open. Since elliptic curves provide us with some of the strongest and most widely used encryption protocols, understanding elliptic curves more deeply would give insight into the security (or potential insecurity) of these protocols.

Our first goal in this series is to treat elliptic curves as mathematical objects, and derive the _elliptic curve group _as the primary object of study. We'll see what "group" means next time, and afterward we'll survey some of the vast landscape of unanswered questions. But this post will be entirely elementary, and will gently lead into the natural definition of the group structure on an elliptic curve.

## Elliptic Curves as Equations

The simplest way to describe an elliptic curve is as the set of all solutions to a specific kind of polynomial equation in two real variables, $x,y$. Specifically, the equation has the form:

$\displaystyle y^2 = x^3 + ax + b$

Where $a,b$ are real numbers such that

$\displaystyle -16(4a^3 + 27b^2) \neq 0$

One would naturally ask, "Who the hell came up with _that?_" A thorough answer requires a convoluted trip through 19th and 20th-century mathematical history, but it turns out that this is a clever form of a very natural family of equations. We'll elaborate on this in another post, but for now we can give an elementary motivation.

Say you have a pyramid of spheres whose layers are squares, like the one below

[![pyramid-spheres](http://jeremykun.files.wordpress.com/2014/01/pyramid-spheres.png)
](http://jeremykun.files.wordpress.com/2014/01/pyramid-spheres.png)

We might wonder when it's the case that we can rearrange these spheres into a single square. Clearly you can do it for a pyramid of height 1 because a single ball is also a 1x1 square (and one of height zero if you allow a 0x0 square). But are there any others?

This question turns out to be a question about an elliptic curve. First, [recall](http://jeremykun.com/2011/06/24/sums-of-the-first-n-numbers-squares/) that the number of spheres in such a pyramid is given by

$\displaystyle 1 + 4 + 9 + 16 + \dots + n^2 = \frac{n(n+1)(2n+1)}{6}$

And so we're asking if there are any positive integers $y$ such that

$\displaystyle y^2 = \frac{x(x+1)(2x+1)}{6}$

Here is a graph of this equation in the plane. As you admire it, though, remember that we're chiefly interested in _integer_ solutions.

[![pyramid-ec](http://jeremykun.files.wordpress.com/2014/02/pyramid-ec1.png)
](http://jeremykun.files.wordpress.com/2014/02/pyramid-ec1.png)

The equation doesn't quite have the special form we mentioned above, but the reader can rest assured (and we'll prove it later) that one can transform our equation into that form without changing the set of solutions. In the meantime let's focus on the question: are there any integer-valued points on this curve besides $(0,0)$ and $(1,1)$? The method we use to answer this question comes from ancient Greece, and is due to [Diophantus](http://en.wikipedia.org/wiki/Diophantus). The idea is that we can use the two points we already have to construct a third point. This method is important because it forms the basis for our entire study of elliptic curves.

Take the line passing through $(0,0)$ and  $(1,1)$, given by the equation $y = x$, and compute the intersection of this line and the original elliptic curve. The "intersection" simply means to solve both equations simultaneously. In this case it's

$\begin{aligned} y^2 &= \frac{x(x+1)(2x+1)}{6} \\ y &= x \end{aligned}$

It's clear what to do: just substitute the latter in for the former. That is, solve

$\displaystyle x^2 = \frac{x(x+1)(2x+1)}{6}$

Rearranging this into a single polynomial and multiplying through by 3 gives

$\displaystyle x^3 - \frac{3x^2}{2} + \frac{x}{2} = 0$

Factoring cubics happens to be easy, but let's instead use a different trick that will come up again later. Let's use a [fact](http://en.wikipedia.org/wiki/Vieta's_formulas) that is taught in elementary algebra and precalculus courses and promptly forgotten, that the sum of the roots of any polynomial is $\frac{-a_{n-1}}{a_n}$, where $a_{n}$ is the leading coefficient and $a_{n-1}$ is the next coefficient. Here $a_n = 1$, so the sum of the roots is $3/2$. This is useful because _we already know two roots, _namely the solutions 0 and 1 we used to define the system of equations in the first place. So the third root satisfies

$\displaystyle r + 0 + 1 = \frac{3}{2}$

And it's $r = 1/2$, giving the point $(1/2, 1/2)$ since the line was $y=x$. Because of the symmetry of the curve, we also get the point $(1/2, -1/2)$.

Here's a zoomed-in picture of what we just did to our elliptic curve. We used the two pink points (which gave us the dashed line) to find the purple point.

[![line-intersection-example](http://jeremykun.files.wordpress.com/2014/02/line-intersection-example.png)
](http://jeremykun.files.wordpress.com/2014/02/line-intersection-example.png)

The bad news is that these two new points don't have integer coordinates. So it doesn't answer our question. The good news is that now we have more points! So we can try this trick again to see if it will give us still more points, and hope to find some that are integer valued. (It sounds like a hopeless goal, but just hold out a bit longer). If we try this trick again using $(1/2, -1/2)$ and $(1,1)$, we get the equation_
_

$\displaystyle (3x - 2)^2 = \frac{x(x+1)(2x+1)}{6}$

And redoing all the algebraic steps we did before gives us the solution $x=24, y=70$. In other words, we just proved that

$\displaystyle 1^2 + 2^2 + \dots + 24^2 = 70^2$

Great! Here's another picture showing what we just did.

[![line-intersection-example-2](http://jeremykun.files.wordpress.com/2014/02/line-intersection-example-2.png)
](http://jeremykun.files.wordpress.com/2014/02/line-intersection-example-2.png)

In reality we don't care about this little puzzle. Its solution might be a fun distraction (and even more distracting: try to prove there aren't any _other_ integer solutions), but it's not the real treasure. The mathematical gem is the _method_ of finding the solution. We can ask the natural question: if you have two points on an elliptic curve, and you take the line between those two points, will you _always _get a third point on the curve?

Certainly the answer is _no_. See this example of two points whose line is vertical.

[![vertical-line](http://jeremykun.files.wordpress.com/2014/02/vertical-line.png)
](http://jeremykun.files.wordpress.com/2014/02/vertical-line.png)

But with some mathematical elbow grease, we can actually _force_ it to work! That is, we can define things _just right_ so that the line between any two points on an elliptic curve will _always_ give you another point on the curve. This sounds like mysterious black magic, but it lights the way down a long mathematical corridor of new ideas, and is required to make sense of using elliptic curves for cryptography.

## Shapes of Elliptic Curves

Before we continue, let's take a little detour to get a good feel for the shapes of elliptic curves. We have defined elliptic curves by a special kind of equation (we'll give it a name in a future post). During most of our study we won't be able to make any geometric sense of these equations. But for now, we can pretend that we're working over real numbers and graph these equations in the plane.

Elliptic curves in the form $y^2 = x^3 + ax + b$ have a small handful of different shapes that we can see as $a,b$ vary:

[![ECdynamics1](http://jeremykun.files.wordpress.com/2014/02/ecdynamics1.gif)
](http://jeremykun.files.wordpress.com/2014/02/ecdynamics1.gif)[![ECdynamics2](http://jeremykun.files.wordpress.com/2014/02/ecdynamics2.gif)
](http://jeremykun.files.wordpress.com/2014/02/ecdynamics2.gif)

The problem is when we cross the point at which the rounded part pinches off in the first animation, and the circular component appears in the second. At those precise moments, the curve becomes "non-smooth" (or _singular_), and for reasons we'll see later this is bad. The condition from the beginning of the article (that $-16(4a^3 + 27b^2) \neq 0$) ensures that these two cases are excluded from consideration, and it's one crucial part of our "elbow grease" to ensure that lines behave nicely.

The "canonical" shape of the elliptic curve is given by the specific example $y^2 = x^3 - x + 1$. It's the example that should pop up whenever you imagine an elliptic curve, and it's the example we'll use for all of our pictures.

[![canonical-EC](http://jeremykun.files.wordpress.com/2014/02/canonical-ec.png)
](http://jeremykun.files.wordpress.com/2014/02/canonical-ec.png)

So in the next post we'll roll up our sleeves and see exactly how "drawing lines" can be turned into an _algebraic structure _on an elliptic curve.

Until then!
