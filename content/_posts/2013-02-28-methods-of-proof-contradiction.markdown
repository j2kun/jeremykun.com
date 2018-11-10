---
author: jeremykun
date: 2013-02-28 17:46:02+00:00
draft: false
title: Methods of Proof — Contradiction
type: post
url: /2013/02/28/methods-of-proof-contradiction/
categories:
- Number Theory
- Primers
- Set Theory
- Teaching
tags:
- bijections
- countability
- diagonalization
- mathematics
- methods of proof
- proof by contradiction
---

In this post we'll expand our toolbox of proof techniques by adding the proof by contradiction. We'll also expand on our knowledge of functions on sets, and tackle our first nontrivial theorem: that there is more than one kind of infinity.

## Impossibility and an Example Proof by Contradiction

Many of the most impressive results in all of mathematics are proofs of impossibility. We see these in lots of different fields. In number theory, [plenty of numbers](http://en.wikipedia.org/wiki/Irrational_number) cannot be expressed as fractions. In geometry, [certain geometric constructions](http://en.wikipedia.org/wiki/Squaring_the_circle) are impossible with a straight-edge and compass. In computing theory, [certain programs](http://en.wikipedia.org/wiki/Halting_problem) cannot be written. And in logic even [certain mathematical statements](http://en.wikipedia.org/wiki/G%C3%B6del's_incompleteness_theorems) can't be proven or disproven.

In some sense proofs of impossibility are hardest proofs, because it's unclear to the layman how anyone could prove it's _not_ possible to do something. Perhaps this is part of human nature, [that nothing is too impossible](http://onlinelibrary.wiley.com/doi/10.1111/j.2044-835X.1991.tb00865.x/abstract) to escape the realm of possibility. But perhaps it's more surprising that the main line of attack to prove something is impossible is to _assume_ it's possible, and see what follows as a result. This is precisely the method of proof by contradiction:

<blockquote>Assume the claim you want to prove is false, and deduce that something obviously impossible must happen.</blockquote>

There is a simple and very elegant example that I use to explain this concept to high school students in my guest lectures.

Image you're at a party of a hundred people, and any pair of people are either mutual friends or not mutual friends. Being a mathematical drama queen, you decide to count how many friends each person has at the party. You notice that there are two people with the _same number of friends_, and you wonder if it will always be the case for any party. And so the problem is born: prove or disprove that at every party of $n$ people, there exist two people with the same number of friends at the party.

If we believe this is true, and we can't seem to find a direct proof, then we can try a proof by contradiction. That is, we assume that there are _not_ two people with the same number of friends. Equivalently, we can assume that everybody has a distinct number of friends. Well what could the possibilities be? On one hand, if there are $n$ people at the party, then the minimum number of friends one could have is zero (if you're quite lonely), and the maximum is $n-1$ (if you're friends with everybody). So there are $n$ distinct numbers, and $n$ people, and everyone has to have a different number. That means someone has to have zero friends, and someone has to be friends with everybody. But this can't possibly be true: if you're friends with everyone (and we're only counting mutual friendships) then nobody can be friendless. Thus, we have arrived at a contradiction, and our original assumption must have been incorrect. That is, every party has two people with the same number of friends at the party.

There are certainly other proofs of this fact (I know of a direct proof which is essentially the same proof as the one given above), and there are [more mathematical ways to think about the problem](http://jeremykun.com/2011/06/26/teaching-mathematics-graph-theory/). But this is a wonderful example of a proof which requires little else than the method of contradiction.

## A Reprise on Truth Tables, and More Examples

Just as with our post on [contrapositive implication](http://jeremykun.com/2013/02/22/methods-of-proof-contrapositive/), we can analyze proof by contradiction from the standpoint of truth tables. Recall the truth table for an implication $p \to q$:

    
    p  q  p->q
    T  T   T
    T  F   F
    F  T   T
    F  F   T

We notice that an implication can only be false if the hypothesis $p$ is true _and__ _the consequence $q$ is false. This is the motivation for a proof by contradiction: if we show this case can't happen, then there's no other option: the statement $p \to q$ must be true. In other words, if supposing "p and not q" is true implies something which we know to be false, then by the very same truth table argument it must be that either "q" is true or "p" is false. In any of these cases "p implies q" is true.

But all of this truth table juggling really takes us away from the heart of the method. Let's do some proofs.

First, we will prove that the square root of 2 is not a rational number. That is, we are proving the statement that if $x$ is a number such that $x^2 = 2$, then it cannot be true that $x = p/q$ where $p,q$ are integers.

Suppose to the contrary (this usually marks the beginning of a proof by contradiction) that $x = p/q$ is a ratio of integers. Then we can square both sides to get $2 = x^2 = p^2 / q^2$, and rearrange to arrive at $2q^2 = p^2$. Now comes the tricky part: if a number is a divisor of $p$, then its square must divide $p^2$; this is true of all square numbers. In particular, it must be the case that the largest power of 2 dividing any square number is _even_ (and $2^0$ counts as an even power). Now in the equation $2q^2 = p^2$ the right hand side is a square, so the largest power of two dividing it is even, and the right hand side is two times a square, so the largest power of 2 dividing it is _odd_ (2 times an even power of 2 gives an odd power of two). But the two sides are equal! They can't possibly have _different_ largest powers of 2 dividing them. So we have arrived at a contradiction, and it must not be the case that $x$ is rational.

This is quite a nice result, and a true understanding of the proof comes when you see why it fails for numbers which actually do have rational square roots (for instance, try it for the square root of 9 or 36/25). But the use of the method is clear: we entered a magical fairy land where the square root of 2 is a rational number, and by using nothing but logical steps, we proved that this world is a farce. It cannot exist.

Often times the jump from "suppose to the contrary" to the contradiction requires a relatively small piece of insight, but in other times it is quite large. In our example above, the insight was related to divisors (or prime factorizations) of a number, and these are not at all as obvious to the layman as our "having no friends" contradiction earlier.

For instance, [here is another version of the square root of two proof](http://jeremykun.com/2011/08/14/the-square-root-of-2-is-irrational-geometric-proof/), proved by contradiction, but this time using geometry. Another example is on [tiling chessboards with dominoes](http://jeremykun.com/2011/06/26/tiling-a-chessboard/) (though the application of the proof by contradiction in this post is more subtle; can you pick out exactly when it's used?). Indeed, most proofs of the fundamental theorem of algebra (these are much more advanced: [[1]](http://jeremykun.com/2012/01/17/the-fundamental-theorem-of-algebra-with-liouville/) [[2]](http://jeremykun.com/2012/01/22/the-fundamental-theorem-of-algebra-with-the-fundamental-group/) [[3]](http://jeremykun.com/2012/02/02/the-fundamental-theorem-of-algebra-galois-theory/) [[4]](http://jeremykun.com/2012/02/07/fundamental-theorem-of-algebra-with-picards-little-theorem/)) follow the same basic recipe: suppose otherwise, and find a contradiction.

Instead of a obviously ridiculous statement like "1 = 0", often times the "contradiction" at the end of a proof will contradict the original hypothesis that was assumed. This happens in a famous proof that there are infinitely many prime numbers.

Indeed, if we suppose that there are finitely many prime numbers, we can write them all down: $p_1 , \dots, p_n$. That is, we are assuming that this is a list of _all_ prime numbers. Since the list is finite, we can multiply them all together and add 1: let $q = p_1 \dots p_n + 1$. Indeed, as the reader will prove in the exercises below, every number has a prime divisor, but it is not hard to see that no $p_i$ divides $q$. This is because no matter what some number $x$ is, no number except 1 can divide both $x$ and $x-1$ (one can prove this fact by contradiction if it is not obvious), and we already know that all the $p_i$ divide $q-1$ . So $q$ must have some prime divisor which was not in the list we started with. This contradicts that we had a complete list of primes to begin with. And so there must be infinitely many primes.

Here are some exercises to practice the proof by contradiction:

	  1. Prove that the base 2 logarithm of 3 is irrational.
	  2. More generally that $\log_a(b)$ is irrational if there is any prime $p$ dividing $a$ but not $b$, or vice versa.
	  3. Prove the fundamental theorem of arithmetic, that every natural number $n \geq 2$ is a product of primes (hint: inspect the smallest failing example).

## A Few More Words on Functions and Sets

[Last time](http://jeremykun.com/2013/02/22/methods-of-proof-contrapositive/) we defined what it means for a function $f: X \to Y$ on sets to be injective: different things in $X$ get mapped to different things in $Y$. Indeed, there is another interesting notion called _surjectivity_, which says that $f$ "hits" everything in $Y$ by something in $X$.

**Definition: **A function $f: X \to Y$ is _surjective_ if for every element $y \in Y$ there is an $x \in X$ for which $f(x) = y$. A surjective function is called a _surjection_. A synonym often used in place of surjective_ _is _onto._

For finite sets, we use surjections to prove something nice about the sets it involves. If $f:X \to Y$ is a surjection, then $X$ has at least as many elements as $Y$. The reader can prove this easily by contradiction. In [our previous post](http://jeremykun.com/2013/02/22/methods-of-proof-contrapositive/) we proved an analogous proposition for injective functions: if $f: X \to Y$ is injective, then there are at least as many elements of $Y$ as there are of $X$. If we combine the two notions, we can see that $X$ and $Y$ have exactly the same size.

**Definition: **A function $f: X \to Y$ which is both injective and surjective is called a _bijection_. The adjectival form of bijection is _bijective_.

So for finite sets, if there exists a bijection $X \to Y$, then $X$ and $Y$ have the same number of elements. The converse is also true, if two finite sets have the same size one can make a bijection between them (though a strictly formal proof of this would require induction, which we haven't covered yet). The main benefit of thinking about size this way is that it extends to infinite sets!

**Definition:** Two arbitrary sets $X,Y$ are said to have the same _cardinality_ if there exists a bijection $f : X \to Y$. If there is a bijection $f: \mathbb{N} \to X$ then $X$ is said to have _countably infinite cardinality_, or simply _countably infinite_. If no such bijection exists (and $X$ is not a finite set), then $X$ is said to be _uncountably infinite._

So we can say two infinite sets have the same cardinality if we can construct a bijection between them. For instance, we can prove that the even natural numbers have the same cardinality as the regular natural numbers. If $X$ is the set of even natural numbers, just construct a function $\mathbb{N} \to X$ by sending $x \mapsto 2x$. This is manifestly surjective and injective (one can prove it with whatever method one wants, but it is obviously true). A quick note on notation: when mathematicians want to define a function without giving it a name, they use the "maps to" arrow $\mapsto$. The reader can think of this as the mathematician's version of lambda expression. So the above map would be written in python: lambda x: 2*x.

So we have proved, as curious as it sounds to say it, that there are just as many even numbers as all natural numbers. Even more impressive, one can construct a bijection between the natural numbers and the _rational_ numbers. Mathematicians denote the latter by $\mathbb{Q}$, and typically this proof is done by first finding a bijection from $\mathbb{N} \to \mathbb{Z}$ and then from $\mathbb{Z} \to \mathbb{Q}$. We are implicitly using the fact that a composition of two bijections is a bijection. The diligent reader has already proved this for injections, so if one can also prove it for surjections, by definition it will be satisfied for bijections.

## Diagonalization, and a Non-Trivial Theorem

We now turn to the last proof of this post, and our first non-trivial theorem: that there is no bijection between the set of real numbers and the set of natural numbers. Before we start, we should mention that calling this theorem 'non-trivial' might sound insulting to the non-mathematician; the reader has been diligently working to follow the proofs in these posts and completing exercises, and they probably all feel non-trivial. In fact, mathematicians don't use trivial with the intent to insult (most of the time) or to say something is easy or not worth doing. Instead, 'trivial' is used to say that a result follows naturally, that it comes from nothing but applying the definitions and using the basic methods of proof. Of course, since we're learning the basic methods of proof nothing can really be trivial, but if we say a theorem is _non-trivial _that means the opposite: there is some genuinely inspired idea that sits at the focal point of the proof, more than just direct or indirect inference. Even more, a proof is called "highly non-trivial" if there are multiple novel ideas or a menagerie of complicated details to keep track of.

In any case, we have to first say what the real numbers are. Instead we won't actually work with the entire set of real numbers, but with a "small" subset: the real numbers between zero and one. We will also view these numbers in a particular representation that should be familiar to the practicing programmer.

**Definition:** The set of $[0,1]$ is the set of all infinite sequences of zeroes and ones, interpreted as the set of all binary decimal expansions of numbers between zero and one.

If we want to be rigorous, we can define an _infinite sequence_ to either be an infinite tuple (falling back on our definition of a tuple as a set), or we can define it to be a function $f : \mathbb{N} \to \left \{ 0, 1 \right \}$. Taking the latter view, we add one additional piece of notation:

**Definition:** An _infinite binary sequence_ $(b_i) = (b_1, b_2, \dots)$ is a function $b : \mathbb{N} \to \left \{ 0, 1 \right \}$ where we denote by $b_i$ the value $b(i)$.

So now we can state the theorem.

**Theorem:** The set $[0,1]$ of infinite binary sequences is uncountably infinite. That is, there is no bijection $\mathbb{N} \to [0,1]$.

The proof, as we said, is non-trivial, but it starts off in a familiar way: we assume there is such a bijection. Suppose to the contrary that $f : \mathbb{N} \to [0,1]$ is a bijection. Then we can list the values of $f$ in a table. Since we want to use $b_i$ for all of the values of $f$, we will call

$\displaystyle f(n) = (b_{n,i}) = b_{n,1}, b_{n,2}, \dots$

This gives us the following infinite table:

$\displaystyle \begin{matrix} f(1) &=& b_{1,1}, & b_{1,2}, & \dots \\ f(2) &=& b_{2,1}, & b_{2,2}, & \dots \\ f(3) &=& b_{3,1}, & b_{3,2}, & \dots \\ \vdots & & \vdots & & \end{matrix}$

Now here is the tricky part. We are going to define a _new_ binary sequence which we can guarantee does not show up in this list. This will be our contradiction, because we assumed at first that this list consisted of all of the binary sequences.

The construction itself is not so hard. Start by taking $c_i = b_{i,i}$ for all $i$. That is, we are using all of the diagonal elements of the table above. Now take each $c_i$ and replace it with its opposite (i.e., flip each bit in the sequence, or equivalently apply $b \mapsto 1-b$ to each entry). The important fact about this new sequence is it differs from every entry in this table. By the way we constructed it, no matter which $lateex n$ one chooses, this number differs from the table entry $f(n)$ at digit $n$ (and perhaps elsewhere). Because of this, it can't occur as an entry in the table. So we just proved our function $f$ isn't surjective, contradicting our original hypothesis, and proving the theorem._
_

The discovery of this fact was an [important step forward](http://en.wikipedia.org/wiki/Cantor's_theorem#History) in the history of mathematics. The particular technique though, using the diagonal entries of the table and changing each one, comes with a name of its own: the _diagonalization argument_. It's quite a bit more specialized of a proof technique than, say, the contrapositive implication, but it shows up in quite a range of mathematical literature (for instance, diagonalization is by far the most common way to prove that [the Halting problem is undecidable](http://en.wikipedia.org/wiki/Halting_problem#Sketch_of_proof)). It is worth noting diagonalization was not the first known way to prove this theorem, just the cleanest.

The fact itself has interesting implications that lends itself nicely to confusing normal people. For instance, it implies not only that there is more than one kind of infinity, but that there are an _infinity of _infinities. Barring a full discussion of how far down the set-theory rabbit hole one can go, we look forward to next time, when we meet the final of the four basic methods of proof: proof by induction.

Until then!
