---
author: jeremykun
date: 2011-11-07 06:10:26+00:00
draft: false
title: Z[√2] has Infinitely Many Units
type: post
url: /2011/11/07/zrt2-has-infinitely-many-units/
categories:
- Number Theory
- Proof Gallery
- Ring Theory
tags:
- euclidean domains
- mathematics
- programming
---

_Note, while the problem below arose in ring theory (specifically, Euclidean domains), the proof itself is elementary, and so the title should not scare away any viewers. In fact, we boil the problem down to something which requires no knowledge of abstract algebra at all._

**Problem:** Show that the ring $\mathbb{Z}[\sqrt{2}]$ has infinitely many units.

**Solution:** An element of $\mathbb{Z}[\sqrt{2}]$ has the form $a+b\sqrt{2}$ for integers $a, b$, and there is a function $N: \mathbb{Z}[\sqrt{2}] \to \mathbb{Z}$ defined by $N(a+b\sqrt{2}) = a^2 - 2b^2$ satisfying $N(uv) = N(u)N(v)$, and from this it's easy to see $u$ is a unit if and only if $N(u) = \pm 1$.

So we have reduced this problem to proving there are infinitely many integer solutions to the equation $a^2 - 2b^2 = \pm 1$. A quick check with some small numbers provides at least one solution: $a=3, b=2$. An attempt at proof by contradiction seems to bear no fruit, and it's unclear how to continue. It would be great to have some more examples of solutions, so that one could study a pattern, so let us write a short program to search for solutions (in Mathematica):

    
    L = Flatten[Table[{i,j,i^2 - 2 j^2},{i,1,1000},{j,1,1000}], 1];
    Select[L, (Abs[#[[3]] == 1])&]


Here we construct a table of all possible differences $i^2-2j^2$ as $i,j$ range over the integers from 1 to 1000 (flattening the list appropriately), and then we select those whose values are $\pm 1$. Here is the result of evaluating the above expression:

    
    {{1, 1, -1}, {3, 2, 1}, {7, 5, -1}, {17, 12, 1},
     {41, 29, -1}, {99, 70, 1}, {239, 169, -1}, {577, 408, 1}}


i.e., the triple $\left \{ 99, 70, 1 \right \}$ represents the solution $99^2 - 2(70^2) = 1$. Of course, these don't represent all solutions because we could take any of these solutions and stick a minus sign in front of the number as we wish, leaving their squares unchanged. In any event, the numbers appear random, and it takes a few moments before one is inspired enough to see a pattern: each pair can be written in terms of the pair before it! Take a moment to see if you can determine how.

Now we conjecture, if $a, b$ are two positive solutions and $b < a$, then the pair $a+2b, a+b$ gives a new solution! Doing the needed algebra,


$(a+2b)^2 - 2(a+b)^2 = a^2 + 4b^2 + 4ab - 2(a^2 + b^2 + 2ab) = -a^2 + 2b^2$




Which is of course $-(a^2 - 2b^2)$, giving the opposite of our original solution, and our two numbers are strictly larger in absolute value, so we just generated a bona fide new solution! Continuing in this manner indefinitely will clearly produce an infinite sequence of distinct solutions, proving the theorem.




Now we get a bunch of extra things for free: If there is any element $x$ of our ring which has $N(x)=k$, then there are infinitely many such elements. In other words, for any integer $k$, if there is a single solution to the integer equation $a^2 - 2b^2 =k$, then there are infinitely many. Going back to the ring $\mathbb{Z}[\sqrt{2}]$, the natural next step is to show that this process generates all such units, after appropriately including the negative counterparts. (Or does it? We leave it to the reader to decide. Can you find a closed form for the units?)




This proof is nice for two reasons. First, it uses the heavy machinery of algebraic structures to give elegant proofs of difficult-to-prove elementary statements (this is an algebraist's dream). Second, when at a loss, we used a computer program to give us a leg up. It would have taken quite a while even to find the solution {17,12,-1}. But after spending two minutes writing a computer program, we got a definitive answer for all numbers up to a thousand. We were able to study the pattern, make a conjecture, and then finally proving the conjecture was trivial. The inspiration to see the pattern was the hard part.




Of course, one cannot always just "extrapolate" the solutions to difficult theorems by just looking at tables of numbers. There are plenty of open problems which have been validated by computers well into the hundred-thousand-digit numbers, but still remain unsolved in general. But as we have shown, computers can give one a nudge in the right direction, and if there's nobody to provide a helpful hint (and no solution to look up online), the program provide the most efficient (perhaps, the most elegant) route to a solution.
