---
author: jeremykun
date: 2012-02-09 01:42:22+00:00
draft: false
title: Busy Beavers, and the Quest for Big Numbers
type: post
url: /2012/02/08/busy-beavers-and-the-quest-for-big-numbers/
categories:
- Analysis
- Combinatorics
- Logic
- Number Theory
tags:
- ackermann function
- busy beaver
- primer
- turing machine
---

## [![](http://jeremykun.files.wordpress.com/2012/02/beaver-pair.jpg)
](http://jeremykun.files.wordpress.com/2012/02/beaver-pair.jpg)Finding Bigger Numbers, a Measure of Human Intellectual Progress


Before we get into the nitty gritty mathematics, I'd like to mirror the philosophical and historical insights that one can draw from the study of large numbers.

That may seem odd at first. What does one even mean by "studying" a large number? Of course, I don't mean we stare at the number 1,000,000,000,000, which is quite large, and wonder how mankind can benefit from its elusive properties. What I really mean is that scientific and mathematical discoveries are very closely tied in our collective ability to _describe_ large numbers.

That may seem even odder, but let's enjoy a short historical digression to illustrate the point. Note that much of this historical information is borrowed from an essay by [Scott Aaronson](http://www.scottaaronson.com/writings/bignumbers.html). He gives a wonderfully entertaining essay on the topic of Busy Beavers, but where he assumes the reader has no background knowledge of computing theory, we will assume the reader is familiar with the relevant computational topics in our [primers](http://jeremykun.wordpress.com/primers/).

[![](http://jeremykun.files.wordpress.com/2012/02/sahara-desert-morocco.jpg?w=300)
](http://jeremykun.files.wordpress.com/2012/02/sahara-desert-morocco.jpg)In the age of the Greeks, it was generally believed that some quantities were beyond counting. Things like the number of grains of sand in the desert were forfeit to the realm of "infinity." But in the third century B.C.E., Archimedes recognized that they weren't beyond counting. And in his treatise _The Sand Reckoner_, he developed a rudimentary notion of exponentials, and was able to provide an upper bound on such mysterious numbers:


<blockquote>There are some [...] who think that the number of the sand is infinite in multitude [...] again there are some who, without regarding it as infinite, yet think that no number has been named which is great enough to exceed its multitude [...] But I will try to show you [numbers that] exceed not only the number of the mass of sand equal in magnitude to the earth [...] but also that of a mass equal in magnitude to the universe.</blockquote>


He proceeded to give an upper bound on the number of grains of sand needed to fill the universe: $10^{63}$. Now this was a quite large number, and certainly beyond most people's ability to visualize in quantity. But by the time Arabic numerals and algebra became common worldly knowledge in the Middle Ages, exponentiation became a paradigm trivially expressed, allowing people to write such large numbers as $10^{10^{10}}$ with the same ease we do today. These sorts of counting exercises became the topic of mathematical folklore (think of the tale of [rice filling a chessboard](http://en.wikipedia.org/wiki/Wheat_and_chessboard_problem)), and they run amok in contemporary discussions of finance, statistics, physics, economics, and computer science.

Let's take a moment to investigate exactly how ridiculously huge exponentials are. And in spite of the awe we show for such gargantuan quantities, we foreshadow that exponents are far from the biggest numbers we can grapple.

Let's take a large digit, say, 9, and repeat it a thousand times to make a number. By all rights, this is a big number! It has a whopping one thousand digits, and each decimal place is as large as it can be. Now, consider the meager $9^9$. Given a few annoying minutes, we could actually perform nine multiplications and get this number exactly; we'll save you the trouble, it's 387,420,489, a number with nine digits. Now, let's inspect $9^{9^9}$. This number, requiring us to write only one more digit on the page, is $9^{387,420,489}$, a number with a staggering 369,693,100 decimal digits! Raising 9 to this power once more, to get $9^{9^{9^9}}$ is [already too large for Wolfram Alpha to give much information about](http://www.wolframalpha.com/input/?i=9%5E9%5E9%5E9).

Now, come the 20th century we see two big jumps in the expression of large numbers. The first is the [Ackermann Function](http://en.wikipedia.org/wiki/Ackermann_function). For the purposes of this post, we can think of it as simply a sequence of numbers, which is constructed as follows. The first number in the sequence, $A(1)$, is simply $1+1$. The next is $A(2) = 2*2$, then $A(3) = 3^3$, and so on. Of course, defining "and so on" is tough, because we don't have commonly known names for such operations. The fourth number in this sequence $A(4)$, is 4 _raised to the power of itself four times_. I.e., $A(4) = 4^{4^{4^4}}$. We call this operation a _tetration_ of the number 4 to the height of 4, and don it with the notation $4 \uparrow \uparrow 4$. This isn't so hard to visualize, but while it's a huge number in itself (it has $10^{154}$ decimal digits), the best is yet to come. The _fifth_ element of this sequence, $A(5)$, is the _nested tetration of 5 with itself 5 times_. In other words, it is


$A(5) = 5 \uparrow \uparrow (5 \uparrow \uparrow (5 \uparrow \uparrow (5 \uparrow \uparrow 5)))$




For convenience, we give this the notation $5 \uparrow \uparrow \uparrow 5$, and call it _pentation_. Of course, $A(6)$ would then be 6 _hexated_ to the height of 6, and so on forever. The brave reader will take this to its extreme, and imagine how huge $A(A(5))$ is... Mind blowing.




Of course, one might ask: where the hell did this beast come from? What are Ackermann numbers good for anyway? The Ackermann Function and it's associated sequence, it turns out, serve as important counterexamples in the theory of computable functions. The familiar reader will recognize the claim that the Ackermann Function is computable, but not primitive recursive. For the rest of the world, here's a historical explanation of its origin.




[caption id="attachment_1691" align="alignright" width="223"][![](http://jeremykun.files.wordpress.com/2012/02/alan_turing_photo.jpg)
](http://jeremykun.files.wordpress.com/2012/02/alan_turing_photo.jpg) Alan Turing, the inventor of the Turing machine.[/caption]


Back in the days before computers (the early 20th century), mathematicians were fiercely interested in the theory of computing things. The common visitor to this blog will recall our primers on [Finite Automata](http://jeremykun.wordpress.com/2011/07/02/determinism-and-finite-automata-a-primer/), [Turing Machines](http://jeremykun.wordpress.com/2011/07/04/turing-machines-a-primer/), and such things as the [Game of Life](http://jeremykun.wordpress.com/2011/06/29/conways-game-of-life/). It might not be a surprise to hear that there are many many different models of computation, and before real computers actually came along it was the job of mathematicians to compare them, sorting out which were "more useful" or "more expressive" than others. In the end, the Turing machine model was actually used to create rudimentary computers, which have since evolved into the supercomputers and iPads we have today. The mathematicians exploring computation during this era were at the forefront of a technological and intellectual revolution. On their shoulders, humanity entered the so-called Age of Information.




Perhaps the original such study of computation was the idea of a _computable function _of the natural numbers. Given a set of elementary functions which are axiomatically defined to be computable, and a way of combining these elementary functions to make more complicated functions, mathematicians constructed a huge class of functions that were computable. For instance, the function which adds two numbers together is computable; we all learned a nice algorithm to perform addition in grade school. The definitions and axioms were chosen in order to affirm such easy tasks, and then mathematicians explored the axioms to see how far they could push them. This line of reasoning would bring one to the ultimate quest: for a given model of computation, figure out what sorts of things are _not computable_.


Of course, even without a firm foundation in the theory of computable functions, we would guess that the sequence of Ackermann numbers is computable. In fact, using the model of Turing machines (which happens to be equivalent to the theory of computable functions, insofar as the tasks it deems computable) we can prove it so. We have unbounded space and unbounded time, and we know for a fact that all of these mathematical operations boil down to repeated multiplication. We can even present pseudocode, and such sites as RosettaCode have [hundreds of implementations](http://rosettacode.org/wiki/Ackermann_function), ranging from a single line of [K](http://en.wikipedia.org/wiki/K_(programming_language)) to a tail-recursive implementation in [OCaml](http://en.wikipedia.org/wiki/OCaml). There is no doubt about it, the Ackermann function is computable. In a somewhat naive sense, the Ackermann sequence is no deeper or more insightful than Archimedes's first attempt at exponentiation. It just carries the idea of exponentiation as far as it can go.

The next natural question is: are there any sequences of numbers which grow so ridiculously fast that they simply cannot be computed? Of course, we know already of one undecidable (non-computable) task: the halting problem. Recall that the halting problem asks if it is possible to design a computer program $T$ which, when given the source code of _any_ other computer program $S$ and an input to that program $w$, can determine in a finite amount of time whether $S$ will loop infinitely on the input $w$, or whether it will halt. The blatant fact is that this is impossible. A hint at the proof is the question: how would this program analyze itself? What about it's evil twin that does exactly the opposite? Here's a comical version of [the proof in Dr. Seuss form](http://ebiquity.umbc.edu/blogger/2008/01/19/how-dr-suess-would-prove-the-halting-problem-undecidable/), and a more formal proof can be found in [our primers on the subject](http://jeremykun.wordpress.com/2011/07/04/turing-machines-a-primer/).

As we have seen before, one way to prove that something is not computable is to first assume that it is computable, and then use that to construct a program that solves the halting problem. This results in a contradiction, and we conclude that the original problem could not be computable. In other words, we are looking for a sequence of numbers which has the following property: if we were able to compute an arbitrarily large entry of the sequence in a finite amount of time, we could use that ability to determine whether any program will halt or loop infinitely in a finite amount of time.

Of course, the idea that such a sequence should even exist is dubious. But amazingly enough, we will construct one, and find the next level of big numbers.


## Busy Beaver Numbers


The idea behind Busy Beavers is quite simple. It was discovered by [Tibor Radó](http://en.wikipedia.org/wiki/Tibor_Rad%C3%B3), a Hungarian mathematician, in May of 1962, and does not rely at all on the arithmetic expressions of the past. The idea requires a bit of knowledge about Turing machines, so after promoting our [primer](http://jeremykun.wordpress.com/2011/07/04/turing-machines-a-primer/) once more, we will reiterate the ideas.

A Turing machine is essentially an infinite strip of paper called the _tape_ on which one scribbles symbols in a deterministic way. In order to know what to do at each step, a Turing machine has an internal state record, with a finite set of rules for how to transition from state to state and manipulate the tape (write new symbols, erase old symbols, and move around to different places on the tape). In full rigor, the Turing machine is only allowed to look at one of the symbols on the tape at a time. So one should truly imagine a little beaver running back and forth across his dam, making tick marks in the wood and never knowing what he's going to do next until he sees the tick mark next to the one he just made. The Turing machine has no limit on the amount of time it can run, and the tape is infinite, so it can write as many symbols as it needs to do its work. In the end, it will either stop, report a  "yes" or a "no," or it will keep on going until the end of time, never to halt.

Perhaps understandably, the Busy Beaver numbers have to do with counting steps of computation in Turing machines. In particular, for a fixed number $n$, it is possible to look at _all_ Turing machines which have exactly $n$ states in their internal record (indeed, there can only be finitely many, and it is not too difficult to come up with an exact number). Among these Turing machines, some will run forever and some will eventually stop. We only care about the ones that stop, and the largest possible number of steps that those machines take before stopping.

**Definition**: The $n$th Busy Beaver number, denoted $BB(n)$, is the largest number of steps taken by a Turing machine with exactly $n$ states, which uses only two symbols on the tape (say 0 and 1), and which begins with an initially blank tape (all of the entries start as 0).

In other words, $BB(n)$ is the number of steps taken by the _buiest_ beaver of all. We call a Turing Machine which achieves the required number of steps a _busy beaver_.

[caption id="attachment_1687" align="aligncenter" width="500"][![](http://jeremykun.files.wordpress.com/2012/02/busy-beaver-turing-machine.jpg)
](http://jeremykun.files.wordpress.com/2012/02/busy-beaver-turing-machine.jpg) Look at that cute little beaver run along.[/caption]

Unsurprisingly, there are very few one-state busy beavers. Recalling the formal definition of a Turing machine, it must have either an accept state or a reject state, and if there is only one state and the machine halts, then it takes only one step before halting. Hence, $BB(1) = 1$. A bit of number crunching will convince the reader that the second Busy Beaver number is in fact $BB(2) = 6$. Not impressed? Well it took a bit of research to get there, but Radó (the original discoverer of the Busy Beaver numbers) proved $BB(3) = 21$. This required a mountain of work and many different partial results to acquire. Why is it so hard, you ask? The fact is, there is no algorithm to list the Busy Beaver numbers. It is an uncomputable function. Let's give a proof of this before we get to the other known values of $BB(n)$.

**Theorem:** $BB(n)$ is uncomputable. That is, there is no Turing machine that can takes as input $n$ and computes $BB(n)$.

_Proof._ Suppose to the contrary that such a machine existed, and call it $A$. We will use $A$ to construct another machine, say $M$ which solves the halting problem as follows. We will use the version of the halting problem where the input is assumed to be the empty string (i.e., there is no input); this problem is also undecidable.

When $M$ is given the input $\left \langle T \right \rangle$, a description of a Turing machine, $M$ determines in finite time the number of states that $T$ has (it is encoded in the description of $T$), and then uses $A$ to compute $BB(n)$, where $n$ is the number of states in $T$. The machine $M$ then simulates $T$ on the empty string input, counting its steps as it proceeds. Eventually the simulation of $T$ either halts, or makes more steps than $BB(n)$. In the former case, $M$ may stop the computation and declare that $T$ halts. In the latter, we know that $BB(n)$ is the maximal number of steps that can occur for _any_ Turing machine with $n$ states that eventually halts. Therefore, if $T$ had not halted, it must never halt. We may stop our computation there, proclaim an infinite loop, and thereby solve the halting problem.

This is a contradiction, so the sequence $BB(n)$ cannot be computable.


$\square$


This gives some insight into how ridiculously fast $BB(n)$ grows. In fact, it not only grows faster than the Ackermann function, but it grows faster than _any sequence of numbers that could ever be computed by a machine!_ Even with infinite time to do so! Indeed, if $BB(n)$ were bounded by some computable function, then we could compute the upper bounds for $BB(n)$, use that to eliminate Turing machines that run too long until we narrow down the exact answer, and this would all happen in a finite amount of time.

In a sense, this is completely understandable. Computers are extremely complex! Applications like web browsers only need millions or billions of states, and in the proof above we're pretending we could determine what all programs would do, even if they have _trillions _or _quadrillions_ or $A(1000)$ states! Imagine all of the crazy things that could happen with that amount of computing power. The colloquial thesis is that a single program is simply not powerful enough to know all of that. It's like asking a human to read the minds of every human on the planet, all of the conscious thoughts of simpler animals, and all of the minds of aliens that planet Earth has never dreamed of, but which perhaps reside in faraway galaxies. For indeed, a Turing machine that could count Busy Beaver numbers must itself have finitely many states, and halt on any well-formed input, but be able to reason about such mysterious behaviors of Turing machines that have never been created.

The first three values of $BB(n)$ were indeed wimpy, but now that we know it grows unfathomably quickly, we can mention the remaining known results. First, $BB(4) = 107$ was proved in the 1980's. But for $BB(5)$, the best known lower bound is 47,176,870, and this was found as recently as 1990. On the other hand, in July of 2010 $BB(6)$ was discovered to be no smaller than  $7.412 \cdot 10^{36,534}$, and it is generally believed that this value will never be known. Nobody is brave enough to give a stab at such higher numbers in the sequence as $BB(10)$, and understandably so.

[caption id="attachment_1688" align="alignleft" width="220"][![](http://jeremykun.files.wordpress.com/2012/02/plato_aristotle.jpg)
](http://jeremykun.files.wordpress.com/2012/02/plato_aristotle.jpg) Plato: "One day, mankind will bask in enlightenment, having computed the Busy Beaver function!" Aristotle: "Word."[/caption]

In this light, the Ackermann function is a wimp. But there are some important philosophical issues to consider once more. In Archimedes's day, people generally believed the sands were beyond counting, and they were later enlightened to know better. Even Archimedes would have been baffled by such modern constructions as pentation and hexation, but nowadays a high school mathematics student can handle the idea (at least, without attempting to visualize it). The day may come to pass when we invent a new way of defining large numbers, some which make the Busy Beaver numbers seem like plain old exponentiation. In those days, perhaps we will define a _new _model of computation that defies the halting problem and ushers in a new era of mathematical insight and technological prowess.

Indeed, such a model would make long-standing mathematical problems moot. With the power to compute Busy Beaver numbers, it would certainly be trivial to come up with a way to definitively answer the [Goldbach Conjecture](http://en.wikipedia.org/wiki/Goldbach's_conjecture), or any other mathematical question which can be verified for a single number. In fact, we know already of a simple way to prove the Goldbach Conjecture using Busy Beavers. We leave this as an exercise to the aspiring reader.

[Heiner Marxen's page](http://www.drb.insel.de/~heiner/BB/) provides an up-to-date account of the current state of the Busy Beaver Problem, and a list of possible candidates for BB(5), the estimates on BB(6), and links to relevant papers. Scott Aaronson's [essay on Busy Beavers](http://www.scottaaronson.com/writings/bignumbers.html) delves deeper into the philosophical implications of solving the Busy Beaver problem (and gives rich analogies), but these considerations, which are essentially fanciful speculation, are beyond the scope of this blog.

Speaking of the scope of this blog, we have yet to write any programs! This will not do, and so next time we will write a program which simulates the currently known busy beavers (or busy beaver candidates) for $n \leq 6$, and displays the changing tape as the beaver runs his route. In a sense, we will be writing a universal Turing machine, which is a commonly used tool in the theory, and not hard to implement.

Until next time!
