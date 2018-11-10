---
author: jeremykun
date: 2014-02-26 16:00:01+00:00
draft: false
title: (Finite) Fields — A Primer
type: post
url: /2014/02/26/finite-fields-a-primer/
categories:
- Cryptography
- Field Theory
- Group Theory
- Linear Algebra
- Primers
- Ring Theory
tags:
- cryptography
- euclidean domains
- field characteristic
- finite fields
- ideals
- mathematics
- polynomial ring
- vector spaces
---

So far on this blog we've given some introductory notes on a few kinds of algebraic structures in mathematics (most notably [groups](http://jeremykun.com/2012/12/08/groups-a-primer/) and [rings](http://jeremykun.com/2013/04/30/rings-a-primer/), but also [monoids](http://jeremykun.com/2011/12/19/metrics-on-words/)). Fields are the next natural step in the progression.

If the reader is comfortable with rings, then a field is extremely simple to describe: they're just commutative rings with 0 and 1, where every nonzero element has a multiplicative inverse. We'll give a list of all of the properties that go into this "simple" definition in a moment, but an even more simple way to describe a field is as a place where "arithmetic makes sense." That is, you get operations for $+,-, \cdot , /$ which satisfy the expected properties of addition, subtraction, multiplication, and division. So whatever the objects in your field are (and sometimes they are quite weird objects), they behave like usual numbers in a very concrete sense.

So here's the official definition of a field. We call a set $F$ a _field _if it is endowed with two binary operations addition ($+$) and multiplication ($\cdot$, or just symbol juxtaposition) that have the following properties:



	  * There is an element we call 0 which is the identity for addition.
	  * Addition is commutative and associative.
	  * Every element $a \in F$ has a corresponding _additive inverse_ $b$ (which may equal $a$) for which $a + b = 0$.

These three properties are just the axioms of a (commutative) group, so we continue:

	  * There is an element we call 1 (distinct from 0) which is the identity for multiplication.
	  * Multiplication is commutative and associative.
	  * Every nonzero element $a \in F$ has a corresponding _multiplicative inverse_ $b$ (which may equal $a$) for which $ab = 1$.
	  * Addition and multiplication distribute across each other as we expect.

If we exclude the existence of multiplicative inverses, these properties make $F$ a commutative ring, and so we have the following chain of inclusions that describes it all


$\displaystyle \textup{Fields} \subset \textup{Commutative Rings} \subset \textup{Rings} \subset \textup{Commutative Groups} \subset \textup{Groups}$




The standard examples of fields are the real numbers $\mathbb{R}$, the rationals $\mathbb{Q}$, and the complex numbers $\mathbb{C}$. But of course there are many many more. The first natural question to ask about fields is: what can they look like?




For example, can there be any _finite_ fields? A field $F$ which as a set has only finitely many elements?




As we saw in our studies of groups and rings, the answer is yes! The simplest example is the set of integers modulo some prime $p$. We call them $\mathbb{Z} / p \mathbb{Z},$ or sometimes just $\mathbb{Z}/p$ for short, and let's rederive what we know about them now.




As a set, $\mathbb{Z}/p$ consists of the integers $\left \{ 0, 1, \dots, p-1 \right \}$. The addition and multiplication operations are easy to define, they're just usual addition and multiplication followed by a modulus. That is, we add by $a + b \mod p$ and multiply with $ab \mod p$. This thing is clearly a commutative ring (because the integers form a commutative ring), so to show this is a field we need to show that everything has a multiplicative inverse.




There is a nice fact that allows us to do this: an element $a$ has an inverse if and only if the only way for it to divide zero is the trivial way $0a = 0$. Here's a proof. For one direction, suppose $a$ divides zero nontrivially, that is there is some $c \neq 0$ with $ac = 0$. Then if $a$ had an inverse $b$, then $0 = b(ac) = (ba)c = c$, but that's very embarrassing for $c$ because it claimed to be nonzero. Now suppose $a$ only divides zero in the trivial way. Then look at all possible ways to multiply $a$ by other nonzero elements of $F$. No two can give you the same result because if $ax = ay$ then (without using multiplicative inverses) $a(x-y) = 0$, but we know that $a$ can only divide zero in the trivial way so $x=y$. In other words, the map "multiplication by $a$" is injective. Because the set of nonzero elements of $F$ is _finite _you have to hit everything (the map is in fact a bijection), and some $x$ will give you $ax = 1$.




Now let's use this fact on $\mathbb{Z}/p$ in the obvious way. Since $p$ is a prime, there are no two smaller numbers $a, b < p$ so that $ab = p$. But in $\mathbb{Z}/p$ the number $p$ is equivalent to zero (mod $p$)! So $\mathbb{Z}/p$ has no nontrivial zero divisors, and so every element has an inverse, and so it's a finite field with $p$ elements.




The next question is obvious: can we get finite fields of other sizes? The answer turns out to be yes, but you can't get finite fields of _any _size. Let's see why.





## Characteristics and Vector Spaces




Say you have a finite field $k$ (lower-case k is the standard letter for a field, so let's forget about $F$). Beacuse the field is finite, if you take 1 and keep adding it to itself you'll eventually run out of field elements. That is, $n = 1 + 1 + \dots + 1 = 0$ at some point. How do I know it's zero and doesn't keep cycling never hitting zero? Well if at two points $n = m \neq 0$, then $n-m = 0$ is a time where you hit zero, contradicting the claim.




Now we define $\textup{char}(k)$, the _characteristic _of $k$, to be the smallest $n$ (sums of 1 with itself) for which $n = 0$. If there is no such $n$ (this can happen if $k$ is infinite, but doesn't always happen for infinite fields), then we say the characteristic is zero. It would probably make more sense to say the characteristic is infinite, but that's just the way it is. Of course, for finite fields the characteristic is always positive. So what can we say about this number? We have seen lots of example where it's prime, but is it _always _prime? It turns out the answer is yes!




For if $ab = n = \textup{char}(k)$ is composite, then by the _minimality_ of $n$ we get $a,b \neq 0$, but $ab = n = 0$. This can't happen by our above observation, because being a zero divisor means you have no inverse! Contradiction, sucker.




But it might happen that there are elements of $k$ that can't be written as $1 + 1 + \dots + 1$ for any number of terms. We'll construct examples in a minute (in fact, we'll _classify all finite fields_), but we already have a lot of information about what those fields might look like. Indeed, since every field has 1 in it, we just showed that every finite field contains a smaller field (a subfield) of all the ways to add 1 to itself. Since the characteristic is prime, the subfield is a copy of $\mathbb{Z}/p$ for $p = \textup{char}(k)$. We call this special subfield the _prime subfield of _$k$.




The relationship between the possible other elements of $k$ and the prime subfield is very neat. Because think about it: if $k$ is your field and $F$ is your prime subfield, then the elements of $k$ can interact with $F$ just like any other field elements. But if we separate $k$ from $F$ (make a separate copy of $F$), and just think of $k$ as having addition, then the relationship with $F$ is that of a _vector space! _In fact, whenever you have two fields $k \subset k'$, the latter has the structure of a vector space over the former.




Back to finite fields, $k$ is a vector space over its prime subfield, and now we can impose all the power and might of linear algebra against it. What's it's dimension? Finite because $k$ is a finite set! Call the dimension $m$, then we get a basis $v_1, \dots, v_m$. Then the crucial part: every element of $k$ has a _unique_ representation in terms of the basis. So they are expanded in the form




$\displaystyle f_1v_1 + \dots + f_mv_m$




where the $f_i$ come from $F$. But now, since these are all just field operations, every possible choice for the $f_i$ has to give you a different field element. And how many choices are there for the $f_i$? Each one has exactly $|F| = \textup{char}(k) = p$. And so by counting we get that $k$ has $p^m$ many elements.




This is getting exciting quickly, but we have to pace ourselves! This is a constraint on the possible size of a finite field, but can we realize it for all choices of $p, m$? The answer is again yes, and in the next section we'll see how.  But reader be warned: the formal way to do it requires a little bit of familiarity with [ideals in rings](http://jeremykun.com/2013/06/01/rings-a-second-primer/) to understand the construction. I'll try to avoid too much technical stuff, but if you don't know what an ideal is, you should expect to get lost (it's okay, that's the nature of learning new math!).





## Constructing All Finite Fields


Let's describe a construction. Take a finite field $k$ of characteristic $p$, and say you want to make a field of size $p^m$. What we need to do is construct a _field extension, _that is, find a bigger field containing $k$ so that the vector space dimension of our new field over $k$ is exactly $m$.

What you can do is first form the _ring _of polynomials with coefficients in $k$. This ring is usually denoted $k[x]$, and it's easy to check it's a ring (polynomial addition and multiplication are defined in the usual way). Now if I were speaking to a mathematician I would say, "From here you take an _irreducible __monic_ polynomial $p(x)$ of degree $m$, and quotient your ring by the principal ideal generated by $p$. The result is the field we want!"

In less compact terms, the idea is exactly the same as modular arithmetic on integers. Instead of doing arithmetic with integers modulo some prime (an _irreducible _integer), we're doing arithmetic with polynomials modulo some irreducible polynomial $p(x)$. Now you see the reason I used $p$ for a polynomial, to highlight the parallel thought process. What I mean by "modulo a polynomial" is that you divide some element $f$ in your ring by $p$ as much as you can, until the degree of the remainder is smaller than the degree of $p(x)$, and that's the element of your quotient. The [Euclidean algorithm](http://en.wikipedia.org/wiki/Euclidean_division_of_polynomials#Euclidean_division) guarantees that we can do this no matter what $k$ is (in the formal parlance, $k[x]$ is called a _[Euclidean domain](http://jeremykun.com/2013/06/01/rings-a-second-primer/) _for this very reason). In still other words, the "quotient structure" tells us that two polynomials $f, g \in k[x]$ are considered to be the same in $k[x] / p$ if and only if $f - g$ is divisible by $p$. This is actually the same definition for $\mathbb{Z}/p$, with polynomials replacing numbers, and if you haven't already you can start to imagine why people decided to study rings in general.

Let's do a specific example to see what's going on. Say we're working with $k = \mathbb{Z}/3$ and we want to compute a field of size $27 = 3^3$. First we need to find a monic irreducible polynomial of degree $3$. For now, I just happen to know one: $p(x) = x^3 - x + 1$. In fact, we can check it's irreducible, because to be reducible it would have to have a linear factor and hence a root in $\mathbb{Z}/3$. But it's easy to see that if you compute $p(0), p(1), p(2)$ and take (mod 3) you never get zero.

So I'm calling this new ring


$\displaystyle \frac{\mathbb{Z}/3[x]}{(x^3 - x + 1)}$




It happens to be a field, and we can argue it with a whole lot of ring theory. First, we know an irreducible element of this ring is also prime (because the ring is a unique factorization domain), and prime elements generate maximal ideals (because it's a principal ideal domain), and if you quotient by a maximal ideal you get a field (true of all rings).




But if we want to avoid that kind of argument and just focus on this ring, we can explicitly construct inverses. Say you have a polynomial $f(x)$, and for illustration purposes we'll choose $f(x) = x^4 + x^2 - 1$. Now in the quotient ring we could do polynomial long division to find remainders, but another trick is just to notice that the quotient is equivalent to the condition that $x^3 = x - 1$. So we can reduce $f(x)$ by applying this rule to $x^4 = x^3 x$ to get




$\displaystyle f(x) = x^2 + x(x-1) - 1 = 2x^2 - x - 1$




Now what's the inverse of $f(x)$? Well we need a polynomial $g(x) = ax^2 + bx + c$ whose product with $f$ gives us something which is equivalent to 1, after you reduce by $x^3 - x + 1$. A few minutes of algebra later and you'll discover that this is equivalent to the following polynomial being identically 1




$\displaystyle (a-b+2c)x^2 + (-3a+b-c)x + (a - 2b - 2c) = 1$




In other words, we get a system of linear equations which we need to solve:




$\displaystyle \begin{aligned} a & - & b & + & 2c & = 0 \\ -3a & + & b & - & c &= 0 \\ a & - & 2b & - & 2c &= 1 \end{aligned}$




And from here you can solve with your favorite linear algebra techniques. This is a good exercise for working in fields, because you get to abuse the prime subfield being characteristic 3 to say terrifying things like $-1 = 2$ and $6b = 0$. The end result is that the inverse polynomial is $2x^2 + x + 1$, and if you were really determined you could write a program to compute these linear systems for any input polynomial and ensure they're all solvable. We prefer the ring theoretic proof.




In any case, it's clear that taking a polynomial ring like this and quotienting by a monic irreducible polynomial gives you a field. We just control the size of that field by choosing the degree of the irreducible polynomial to our satisfaction. And that's how we get all finite fields!





## One Last Word on Irreducible Polynomials


One thing we've avoided is the question of why irreducible monic polynomials exist of all possible degrees $m$ over any $\mathbb{Z}/p$ (and as a consequence we can actually construct finite fields of all possible sizes).

The answer requires [a bit of group theory](http://en.wikipedia.org/wiki/Frobenius_automorphism) to prove this, but it turns out that the polynomial $x^{p^m} - x$ has all degree $m$ monic irreducible polynomials as factors. But perhaps a better question (for computer scientists) is how do we work over a finite field in practice? One way is to work with polynomial arithmetic as we described above, but this has some downsides: it requires us to compute these irreducible monic polynomials (which doesn't sound so hard, maybe), to do polynomial long division every time we add, subtract, or multiply, and to compute inverses by solving a linear system.

But we can do better for some special finite fields, say where the characteristic is 2 (smells like binary) or we're only looking at $F_{p^2}$. The benefit there is that we aren't _forced_ to use polynomials. We can come up with some other kind of structure (say, matrices of a special form) which happens to have the same field structure and makes computing operations relatively painless. We'll see how this is done in the future, and see it applied to cryptography when we continue with our series on [elliptic curve cryptography](http://jeremykun.com/2014/02/08/introducing-elliptic-curves/).

Until then!
