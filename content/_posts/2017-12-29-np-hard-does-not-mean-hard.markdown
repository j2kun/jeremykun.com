---
author: jeremykun
date: 2017-12-29 21:30:23+00:00
draft: false
title: NP-hard does not mean hard
type: post
url: /2017/12/29/np-hard-does-not-mean-hard/
categories:
- Computing Theory
tags:
- completeness
- complexity theory
- mario
- mathematics
- np-completeness
- np-hard
- regular languages
---

When NP-hardness pops up on the internet, say because some silly blogger wants to [write about video games](http://jeremykun.com/2012/03/22/nintendo-np-hard/), it's often tempting to conclude that the problem being proved NP-hard is actually very hard!

"Scientists proved Super Mario is NP-hard? I always knew there was a reason I wasn't very good at it!" Sorry, these two are unrelated. NP-hardness means hard in a narrow sense this post should hopefully make clear. After that, we'll explore what "hard" means in a mathematical sense that you can apply beyond NP-hardness to inform your work as a programmer.

When a problem is NP-hard, that simply means that the problem is sufficiently expressive that you can use the problem to express logic. By which I mean boolean formulas using AND, OR, and NOT. In the Super Mario example, the "problem" is a bundle of (1) the controls for the player (2) the allowed tiles and characters that make up a level, and (3) the goal of getting from the start to the end. Logic formulas are encoded in the creation of a level, and solving the problem (completing the level) is the same as finding conditions to make the logical formula true.

[caption id="attachment_1819" align="aligncenter" width="372"]![mario-clause-gadget](https://jeremykun.files.wordpress.com/2012/03/mario-clause-gadget.jpg)
The clause gadget for the original Super Mario Brothers, encoding an OR of three variables.[/caption]

In this sense, NP-hardness doesn't make all of Super Mario hard. The levels designed to encode logical formulas are contrived, convoluted, and contorted. They abuse the rules of the game in order to cram boolean logic into it. These are _worst case levels_. It's using Mario for a completely unintended purpose, not unlike [hacking](https://github.com/j2kun/general-audience-math-essays/blob/master/reductions-mathematical-hacks.md). And so NP-hardness is a worst case claim.

To reiterate, NP-hardness means that Super Mario has _expressive power_. So expressive that it can emulate other problems we believe are hard in the worst case. And, because the goal of mathematical "hardness" is to reason about the limitations of algorithms, being able to solve Super Mario in full generality implies you can solve any hard subproblem, no matter how ridiculous the level design.

The P != NP conjecture says that there's no polynomial time algorithm to determine whether boolean logic formulas are satisfiable, and so as a consequence Super Mario (in full generality) also has no polynomial time algorithm.

That being said, in reality Super Mario levels do not encode logical formulas! If you use the knowledge that real-world Super Mario levels are designed in the way they are (to be solvable, fun), then you can solve Super Mario with algorithms. [There are many examples](https://www.youtube.com/watch?v=qv6UVOQ0F44).

In general, the difficulty of a problem for humans is unrelated to the difficulty for algorithms. Consider multiplication of integers. This is a trivial problem for computers to solve, but humans tend to struggle with it. It's an [amazing feat](https://www.ted.com/talks/arthur_benjamin_does_mathemagic) to be able to multiply two 7 digit numbers in less than 5 seconds, whereas computers can multiply two thousand-digit numbers in milliseconds.

Meanwhile, [protein folding](https://en.wikipedia.org/wiki/Protein_folding) is known to be an NP-hard problem, but it's been turned into a [game sufficiently easy for humans to solve](https://fold.it/) that players have contributed to scientific research. Indeed, even some of the most typically cited NP-hard problems, like [traveling salesman](https://en.wikipedia.org/wiki/Travelling_salesman_problem), have heuristic, practical algorithmic solutions that allow one to solve them (very close to optimally) in hours on inputs as large as [every city on earth](http://www.math.uwaterloo.ca/tsp/world/).

So the mathematical notions of hardness are quite disconnected from practical notions of hardness. This is not even to mention that some NP-hard problems can be efficiently approximated to [within any desired accuracy](https://en.wikipedia.org/wiki/Polynomial-time_approximation_scheme).

Let's dig into the math a bit more. "Hardness" is a family of ideas about comparisons between problems based on reusability of algorithmic solutions. Loosely speaking, a problem $R$ is hard with respect to a class of problems $C$ if an algorithm solving $R$ can be easily transformed into an algorithm solving any problem in $C$. You have to say what kinds of transformations are allowed, and the transformation can be different for different target problems in $C$, but that's the basic idea.

In the Super Mario example, if you want to solve logical formulas, you can transform a hypothetically perfect mario-level-playing algorithm into a logic solver by encoding the formula as a level and running the mario-level-playing algorithm on it as a black box. Add an if statement to the end to translate "level can/can't be finished" to "formula can/can't be satisfied," and the transformation is complete. It's important for NP-hardness that the transformation only takes polynomial time. Other kinds of hardness might admit more or restrict to fewer resources.

And so this is what makes Mario NP-hard, because boolean logic satisfiability is NP-hard. Any problem in NP can be solved by a boolean logic solver, and hence also by a mario-level-player. The fact that boolean logic solving is NP-hard is a [difficult theorem to prove](https://en.wikipedia.org/wiki/Cook%E2%80%93Levin_theorem). But if we assume it's true, you can compose the transformations to get from any NP problem to Super Mario.

As a simple example of a different kind of hardness, you can let $C$ be the class of problems solvable using only a finite amount of memory (independent of the input). You have probably heard of this class of problems by another name, but I'll keep you guessing until the end of the post. A $C$-hard problem $R$ is one for which an algorithmic solution can be repurposed to solve any finite-memory-solvable problem.

We have to be careful: if the transformation between solutions allows us polynomial time (in the size of the input) like it did for NP-hardness, then we might have enough time in the transformation alone to solve the entire problem, removing the need for a solution to $R$ in the first place! For this reason, we have to limit the amount of work that can be done in the transformation. We get a choice here that influences how interesting or useful the definition of hardness is, but let's just pick one and say that the transformation can only use finite _time _(independent of the input).

To be fair, I actually don't know if there are any hard problems with respect to this definition. There probably are, but chances are good that they are not members of $C$, and that's where the definition of hardness gets really interesting. If you have a problem in $C$ which is also $C$-hard, it's called _complete_ for $C$. And once you've found a complete problem, from a theoretical perspective you're a winner. You've found a problem which epitomizes the difficulty of solving problems in $C$. And so it's a central aim of researchers studying a complexity class to find complete problems. As they say in the business, "ABC: always be completing."

As a more concrete and interesting example, the class $P$ of all polynomial-time solvable problems has a complete problem. Here the transformations are a bit up in the air. They could either be logarithmic-space computations, or what's called [NC](https://en.wikipedia.org/wiki/NC_(complexity)), which can be thought of as poly-logarithmic time (very fast) parallel computations. I only mention NC because it allows you to say "P-complete problems are hard to parallelize."

Regardless of the choice, there are a number of very useful problems known to be P-complete. The first is the _Circuit Value Problem_, given a circuit (described by its gates and wires using any reasonable encoding) and an input to the circuit, what is the output?

Others include [linear programming](http://jeremykun.com/2014/06/02/linear-programming-and-the-most-affordable-healthy-diet-part-1/) (optimize this linear function with respect to linear constraints), data compression (does the compressed version of a string $s$ using [Lempel–Ziv–Welch](https://en.wikipedia.org/wiki/Lempel%E2%80%93Ziv%E2%80%93Welch) contain a string $t$?), and type inference for partial types. There are many more in this [compendium of Greenlaw et al.](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.31.2644&rep=rep1&type=pdf) Each one is expressive enough to encode any instance of the other, and any instance of any problem in P. It's quite curious to think that gzip can solve linear programs, but that's surely no curiouser than super mario levels encoding boolean logic.

Just as with NP-hardness, when a problem is P-hard that doesn't automatically mean it's easy or hard for humans, or that typical instances can't be easily parallelized. P-hardness is also a worst case guarantee.

Studying P-completeness is helpful in the same way NP-completeness is helpful. Completeness informs you about whether you should hope to find a perfect solution or be content with approximations and heuristics (or incorporate problem context to make it easier). Knowing a problem is P-complete means you should not expect **perfect** efficient parallel algorithms, or **perfect **efficient algorithms that use severely limited space. Knowing a problem is NP-hard means you should not expect a **perfect** polynomial time solution. In other words, if you are forced to work with those restrictions, the game becomes one of tradeoffs. Hardness and completeness focus and expedite your work, and clarify a principled decision making process.

Until next time!

P.S. The class of problems solvable in a finite amount of memory is just the class of [regular languages](https://en.wikipedia.org/wiki/Regular_language). The "finite memory" is the finite state machine used to solve them.
