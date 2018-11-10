---
author: jeremykun
date: 2013-03-21 16:36:44+00:00
draft: false
title: Methods of Proof — Induction
type: post
url: /2013/03/21/methods-of-proof-induction/
categories:
- Number Theory
- Set Theory
- Teaching
tags:
- induction
- mathematics
- methods of proof
---

In this final post on the basic four methods of proof (but perhaps not our last post on proof methods), we consider the proof by induction.


## Proving Statements About All Natural Numbers


Induction comes in many flavors, but the goal never changes. We use induction when we want to prove something is true about all natural numbers. These statements will look something like this:


_For all natural numbers n, _$1 + 2 + \dots + n = n(n+1)/2$.


Of course, there are many [ways to prove this fact](http://jeremykun.com/2011/06/24/sums-of-the-first-n-numbers-squares/), but induction relies on one key idea: if we know the statement is true for some specific number $n$, then that gives us information about whether the statement is true for $n+1$. If this isn't true about the problem, then proof by induction is hopeless.

Let's see how we can apply it to the italicized statement above (though we haven't yet said what induction is, this example will pave the way for a formal description of the technique). The first thing we notice is that indeed, if we know something about the first $n$ numbers, then we can just add $n+1$ to it to get the sum of the first $n+1$ numbers. That is,


$\displaystyle 1 + \dots + n + (n+1) = (1 + \dots + n) + (n+1)$




Reiterating our key point, this is how we know induction is a valid strategy: the statement written for a fixed $n$ translates naturally into the statement about $n+1$. Now suppose we know the theorem is true for $n$. Then we can rewrite the above sum as follows:




$\displaystyle 1 + \dots + n + (n+1) = \frac{n(n+1)}{2} + (n+1)$




With some algebra, we can write the left-hand side as a single fraction:




$\displaystyle 1 + \dots + (n+1) = \frac{n(n+1) + 2(n+1)}{2}$




and factoring the numerator gives




$\displaystyle 1 + \dots + (n+1) = \frac{(n+1)(n+2)}{2}$




Indeed, this is precisely what we're looking for! It's what happens when you replace $n$ by $n+1$ in the original statement of the problem.




At this point we're very close to being finished. We proved that _if_ the statement is true for $n$, then it's true for $n+1$. And by the same reasoning, it will be true for $n+2, n+3, $ and all numbers after $n$. But this raises the obvious question: what's the smallest number that it's true for?




For this problem, it's easy to see the answer is $n=1$. A mathematician would say: the statement is _trivially_ true for $n=1$ (here trivial means there is no thinking required to show it: you just plug in $n=1$ and verify). And so by our reasoning, the statement is true for $n=2, n=3, $ and so on forever. This is the spirit of mathematical induction.





## Formal Nonsense


Now that we've got a taste of how to use induction in practice, let's formally write down the rules for induction. Let's have a statement which depends on a number $n$, and call it $p(n)$. This is written as a function because it actually is one (naively). It's a function from the set of natural numbers to the set of all mathematical statements. In our example above, $p(n)$ was the statement that the equality $1 + \dots + n = n(n+1)/2$ holds.

We can plug in various numbers into this function, such as $p(1)$ being the statement "$1 = 1(1+1)/2$ holds," or $p(n+1)$ being "$1 + \dots + (n+1) = (n+1)(n+1+1)/2$ holds."

The basic recipe for induction is then very simple. Say you want to prove that $p(n)$ is true for all $n \geq 1$. First you prove that $p(1)$ is true (this is called the _base case_), and then you prove the implication $p(n) \to p(n+1)$ for an arbitrary $n$. Each of these pieces can be proved with any method one wishes ([direct](http://jeremykun.com/2013/02/16/methods-of-proof-direct-implication/), [contrapositive](http://jeremykun.com/2013/02/22/methods-of-proof-contrapositive/), [contradiction](http://jeremykun.com/2013/02/28/methods-of-proof-contradiction/), etc.). Once they are proven, we get that $p(n)$ is true for all $n$ automatically.

Indeed, [we can even prove it](http://en.wikipedia.org/wiki/Mathematical_induction#Proof_of_mathematical_induction). A rigorous proof requires a bit of extra knowledge, but we can easily understand the argument: it's just a proof by contradiction. Here's a quick sketch. Let $X$ be the set of all natural numbers $n$ for which $p(n)$ is false. Suppose to the contrary that $X$ is not empty. Every nonempty set of natural numbers has a smallest element, so let's call $m$ the smallest number for which $p(m)$ is false. Now $m-1 < m$, so $p(m-1)$ must be true. But we proved that whenever $p(n)$ is true then so is $p(n+1)$, so $p(m-1 + 1) = p(m)$ is true, a contradiction.

Besides practicing proof by induction, that's all there is to it. One more caveat is that the base case can be some number other than 1. For instance, it is true that $n! > 2^n$, but only for $n \geq 4$. In this case, we prove $p(4)$ is true, and $p(n) \to p(n+1)$ with the extra assumption that $n \geq 4$. The same inductive result applies.

Here are some exercises the reader can practice with, and afterward we will explore some variants of induction.



	  1. Prove that $n! > 2^n$ for all $n \geq 4$.
	  2. Prove that for all $n \geq 1$ the following equality holds: $1/(1 \cdot 2) + 1/(2 \cdot 3) + \dots + 1/(n \cdot (n+1)) = n/(n+1)$.
	  3. Prove that for every natural number $n$, a set of $n$ elements has $2^n$ subsets (including the empty subset).

This last exercise gives a hint that induction can prove more than arithmetic formulas. Indeed, if we have any way to associate a mathematical object with a number, we can potentially use induction to prove things about those objects. Unfortunately, we don't have any mathematical objects to work with (except for sets and functions), and so we will stick primarily to proving facts about numbers.

One interesting observation about proof by induction is very relevant to programmers: it's just recursion. That is, if we want to prove a statement $p(n)$, it suffices to prove it for $p(n-1)$ and do some "extra computation" to arrive at the statement for $p(n)$. And of course, we want to make sure the recursion terminates, so we add in the known result for $p(1)$.


## Variations on Induction, and Connections to Dynamic Programming


The first variation of induction is simultaneous induction on multiple quantities. That is, we can formulate a statement $p(n,m)$ which depends on two natural numbers independently of one another. The base case is a bit trickier, but paralleling the above remark about recursion, double-induction follows the same pattern as a two-dimensional [dynamic programming algorithm](http://jeremykun.com/2012/01/12/a-spoonful-of-python/). The base cases would consist of all $p(1,m)$ and all $p(n,1)$, and the inductive step to get $p(n,m)$ requires $p(n-1,m)$ and $p(n,m-1)$ (and potentially $p(n-1, m-1)$ or others; it depends on the problem).

Unfortunately, natural instances where double induction is useful (or anywhere close to necessary) are rare. Here is an example of a (tricky) but elementary example. Call


$\displaystyle C(m,n) = \frac{(2m)!(2n)!}{m!n!(m+n)!}$,


where the exclamation point denotes the factorial function. We will outline a proof that $C(m,n)$ is always an integer for all $m, n \geq 0$. If we look at the base cases, $C(0,n), C(m,0)$ (recalling that 0! = 1), we get $(2n!)/(n! n!)$, and this happens to be in the form of a [binomial coefficient](http://en.wikipedia.org/wiki/Binomial_coefficient) (here, the number of ways to choose $n!$ objects from a collection of $(2n)!$ objects), and binomial coefficients are known to be integers. Now the inductive step relies on the fact that $C(m,n-1)$ and $C(m+1, n-1)$ are both integers. If this is true then


$\displaystyle C(m,n) = 4C(m,n-1) - C(m+1, n-1)$,




which is obviously again an integer.


If we write these values in a table, we can see how the induction progresses in a "dynamic programming" fashion:

[![dynamic-programming-table](http://jeremykun.files.wordpress.com/2013/03/dynamic-programming-table.png)
](http://jeremykun.files.wordpress.com/2013/03/dynamic-programming-table.png)

In order to fill the values in the next $n$ column (prove the statement for those values of $n$), we need to fill the entire $n-1$ column (for indeed, we rely on the inductive hypothesis for both the $m+1$ and $m$ row). But since our base case was the entire $n=0$ column, we can fill the entire table. In fact, we have just described a dynamic programming algorithm for computing the value of $C(m,n)$ in $mn$ steps. The correctness of the algorithm is indeed an inductive proof of the theorem.

Perhaps uninterestingly, this is asymptotically slower than the naive algorithm of computing $C(m,n)$ directly by computing $(2n)!, (2m)!, (n+m)!$ directly; this would take a linear number of steps in $n$, assuming $n > m$. In passing, this author wonders if, when the numbers are really large, the lack of division and multiplication in the dynamic program (multiplying by 4 using bit shifting instead) would overtake the naive algorithm. But $C(m,n)$ is certainly not interesting enough in its own right for anyone to care :)

At this point, we have noticed that we sometimes use induction and assume that _many_ smaller instances of the statement are true. Indeed, why not inductively assume that the statement holds for _all_ smaller $n$. This would certainly give the prover more tools to work with. Indeed, this technique is sometimes called _strong induction_, in the sense that we assume a stronger inductive hypothesis when we're trying to prove $p(n+1)$. It may not be entirely obvious (especially to one well versed in the minutiae of formal logic) that this is actually equivalent to normal induction, but it is. In fact, the concept of "strong" induction is [entirely pedagogical in nature](http://mathoverflow.net/questions/37944/induction-vs-strong-induction). Most working mathematicians will not mention the difference in their proofs.

The last variant we'll mention about induction is that of transfinite induction. The concept is that if you have _any_ set $X$ which is [well-ordered](http://mathworld.wolfram.com/WellOrderedSet.html) (essentially this means: allowing one to prove induction applies as we did earlier in the post), then we can perform induction its elements. In this way, we can "parameterize" statements by elements of an arbitrary well-ordered set, so that instead of $p(n)$ being a function from natural numbers to mathematical statements, it's a function from $X$ to mathematical statements. One somewhat common example of when $X$ is something besides natural numbers is when we use the so-called [cardinal numbers](http://en.wikipedia.org/wiki/Cardinal_number). We have already seen two distinct infinite cardinal numbers in this series: the cardinality of the integers and the cardinality of the real numbers (indeed, "cardinal number" just means a number which is the cardinality of a set). It turns out that there are many more kinds of cardinal numbers, and you can do induction on them, but this rarely shows up outside of mathematical logic.

And of course, we should close this post on an example of when induction goes wrong. For this we point the reader to our proof gallery, and the false proof that [all horses are the same color](http://jeremykun.com/2011/07/16/false-proof-all-horses-are-the-same-color/). It's quite an amusing joke, and hopefully it will stimulate the reader's mind to recognize the pitfalls that can occur in a proof by induction.

So those are the basic four proof techniques! Fortunately for the reader, pretty much all proofs presented on this blog follow one of these four techniques. I imagine many of my readers skip over the proofs entirely (if only I could put proofs in animated gifs, with claims illustrated by grumpy cats!). So hopefully, if you have been intimidated or confused by the structure of the proofs on this blog, this will aid you in your future mathematical endeavors.  Butchering an old phrase for the sake of a bad pun, the eating of the pudding is in the proof. :)

Until next time!
