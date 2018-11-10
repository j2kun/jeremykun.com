---
author: jeremykun
date: 2011-07-30 22:03:38+00:00
draft: false
title: Number Theory - A Primer
type: post
url: /2011/07/30/number-theory-a-primer/
categories:
- Number Theory
- Primers
tags:
- mathematics
- primer
- primes
- programming
---

_This primer exists for the background necessary to read [our post on RSA encryption](http://jeremykun.wordpress.com/2011/07/29/encryption-rsa/), but it also serves as a general primer to number theory._

## Oh, Numbers, Numbers, Numbers

We start with some easy definitions.

**Definition**: The set of _integers_, denoted $\mathbb{Z}$, is the set $\left \{ \dots -2, -1, 0, 1, 2, \dots \right \}$.

**Definition**: Let $a,b$ be integers, then $a$ _divides_ $b$, denoted $a \mid b$, if there exists an integer $n$ such that $na = b$. We also less commonly say $b$ _is divisible by_ $a$. A _composite _number has a divisor greater than 1, and hence two strictly smaller divisors.

This definition of "dividing" allows us to bypass the more complicated world of fractions and rational numbers, and keep most of what we do in the integers. The novice reader is encouraged to prove the following propositions about divisibility:

	  * If $a \mid b$ then $a \mid kb$ for any $k \in \mathbb{N}$.
	  * If $a \mid b$ and $a \mid c$ then $a \mid b + c, a \mid bc$.
	  * If $a \mid b$ and $b \mid a$ then $a = \pm b$.
	  * Find a counterexample where $a \mid bc$ but neither $a \mid b$ nor $a \mid c$ holds.

**Definition**: A positive integer $p$ is _prime_ if it has exactly two distinct divisors: $1$ and $p$. For the remainder of this post, we will always use $p,q$ to denote primes.

It follows immediately from the definition that if $p,n$ are positive integers and $p$ is prime, then $n \mid p$ if and only if $n = 1$ or $n=p$.

We could work toward the fundamental theorem of arithmetic, that every positive integer factors uniquely as a product of primes, but this would lead us down the road of proving [Bezout's theorem](http://en.wikipedia.org/wiki/B%C3%A9zout%27s_identity), and we want to work quickly toward other things. Instead, we simply prove the existence of such a factoring, and take its uniqueness for granted:

**Theorem**: Every positive integer factors as a product of primes.

_Proof_. Let $S$ be the set of positive integers which do not have a factoring as a product of primes. In particular, $1 \notin S$ since 1 is the product of zero primes, and no prime is in $S$. So $S$ is entirely composed of composite numbers. Take the smallest element $x \in S$, and since it is composite it may be written as $x = ab$, where $a,b$ are both strictly smaller than $x$. But since each of $a,b$ are not in $S$, they factor into products of primes. By combining these factorings, we achieve a factoring of $x$, a contradiction. $\square$

**Definition**: The _greatest common divisor_ of two numbers $a, b$, abbreviated _gcd_ and denoted $(a,b)$ or less commonly $\gcd(a,b)$, is the largest divisor of both $a$ and $b$. We say two numbers are _relatively prime_ if $(a,b) = 1$.

Note that two relatively prime numbers might not be prime. In fact, $(8,9) = 1$, but neither 8 nor 9 are prime. We also sometimes say (though it is probably grammatically incorrect) $a$ is _relatively prime to_ $b$.

We may prove some interesting facts about greatest common divisors, which we leave as exercises to the ambitious reader:

	  * $(a + cb, b) = (a,b)$ for any $c \in \mathbb{Z}$.
	  * $(a,b)$ is the smallest positive linear combination of $a,b$ with integer coefficients.
	  * (Bezout's theorem, a corollary to the above two statements) There is a linear combination of $a,b$ with integer coefficients that equals $(a,b)$.

The last theorem shows up in group theory as a statement about generators of additive integer groups $n\mathbb{Z}$.

## Congruences and Modular Arithmetic

**Definition**: $a$ is _congruent to _$b$ _modulo _$n$, denoted $a \equiv b \mod n$, if $n \mid b-a$.

This definition has a more familiar form for computer scientists, namely the line of code:

    
    a % n == b % n

In plain language, two numbers are congruent modulo $n$ if they have the same remainder when divided by $n$. Usually, however, we make $0 \leq b < n$, so that $b$ is the remainder of $a$ when divided by $n$.

It is a cheap fact that the relation $\cdot \equiv \cdot \mod n$ is an equivalence relation on integers for any fixed $n$. In other words:

	  * $a \equiv a \mod n$
	  * If $a \equiv b \mod n$ then $b \equiv a \mod n$
	  * If $a \equiv b \mod n$ and $b \equiv c \mod n$ then $a \equiv c \mod n$.

This allows us to partition the integers into their congruence classes. In other words, the fact that this is an equivalence relation allows us to identify a number with its remainder modulo $n$. For the sake of consistency, when stating the set of all congruence classes mod $n$, we stick to the classes represented by the positive integers $0, \dots, n-1$.

There is a vast amount of work on solving systems of congruences. The interested reader should investigate the [Chinese Remainder Theorem](http://en.wikipedia.org/wiki/Chinese_Remainder_Theorem) and [Hensel's Lemma](http://en.wikipedia.org/wiki/Hensel%27s_lemma).

**Definition**: A number $b$ is an _inverse_ to a number $a$ modulo $n$ if $ab \equiv 1 \mod n$.

Inverses help to reduce computations by pairing a number with its inverse modulo $n$. Therefore, it is interesting to know when numbers have inverses, and whether one is unique up to congruence.

**Proposition**: An inverse for $a \mod n$ exists if and only if $(a,n) = 1$ ($a$ and $n$ are relatively prime).

_Proof._ Suppose such an inverse $b$ exists. Then by the definition of congruence, $n \mid ab - 1$, and hence $cn = ab-1$, so $ab - cn = 1$. In particular, 1 is a linear combination of $a$ and $n$, and hence it must be the smallest positive linear combination. This is equivalent to $(a,n)$, which is proved by the exercise above.

On the other hand, suppose $(a,n)=1$. We may reverse the computation above to find $b$. Specifically, $b$ is the coefficient of $a$ in the linear combination of $a,n$ that makes 1. This proves the theorem $\square$.

It would be great if we could determine how many numbers have inverses mod $n$. In fact, we will, but first we'd like to investigate a few interesting theorems.

**Theorem**: (Wilson) $(p-1)! \equiv -1 \mod p$ for any prime $p$.

_Proof_. We immediately see that two of these factors are easy: $1 \equiv 1 \mod p$ and $p-1 \equiv -1 \mod p$. We claim that the product of the remaining numbers is always 1.

Since each number $1 < n < p-1$ is relatively prime to $p$ (indeed, all numbers are relatively prime to a prime), each number $n$ has an inverse modulo $p$. As long as this inverse is not $n$ itself, we may pair off each number with its inverse, and see that the entire product is just 1.

To prove that $n^{-1} \neq n$, suppose $n^2 \equiv 1 \mod p$. Then $(n+1)(n-1) \equiv 0 \mod p$. But since $1 < n < p-1$, we must have two numbers $n+1, n-1$ whose product is divisible by $p$. But neither of $n+1, n-1$ has $p$ as a factor. So we conclude that either $n+1 = 0$ or $n-1 = 0$, giving $n \equiv \pm 1 \mod p$, a contradiction.

So we may indeed pair the numbers off as we described above, and see that $(p-1)! \equiv -1 \mod p. \square$

Here is another fundamental result that uses Wilson's theorem as a stepping stone:

**Theorem**: (Fermat's Little Theorem) If $p$ is prime and $0 < a < p$, then $a^{p-1} \equiv 1 \mod p$.

_Proof_. The set $\left \{ 1, 2, \dots, p-1 \right \}$ are the nonzero remainders mod $p$. If we multiply each by $a$, we get another complete set of nonzero residues mod $p$, namely $\left \{ a, 2a, \dots, (p-1)a \right \}$.

Since both of these sets are all the nonzero residues mod $p$, their products are congruent. In particular,

$\displaystyle \prod \limits_{k=1}^{p-1} k \equiv \prod \limits_{k=1}^{p-1}ak \mod n$

Since we may factor out the $a$ from each term, and there are $p-1$ terms, we arrive at $(p-1)! \equiv a^{p-1}(p-1)! \mod p$. But Wilson's theorem proved that $(p-1)!$ is nonzero mod $p$, and hence has a multiplicative inverse. Multiplying both sides of the equation by its inverse (which is obviously -1), we get $a^{p-1} \equiv 1 \mod p$, as desired. $\square$

Fermat's Little Theorem allows us to quickly compute large powers of integers modulo any prime. Specifically, we may break $3^{143} \mod 11$ into $3^{10*14 + 3} = (3^{10})^{14} \cdot 3^3$ By Fermat's Little Theorem, this is just $1^{14} \cdot 27 \mod 11$, and from here we may compute $3^{143} \equiv 5 \mod 11$. Certainly this is much faster than incrementally multiplying 3 to itself 143 times and every so often dividing by 11. We subtly allude to the usefulness of number theory for _computing_ large exponents, which is an important theme in [our post on RSA encryption](http://jeremykun.wordpress.com/2011/07/29/encryption-rsa/).

**Euler's Phi Function**

Our final topic for this primer is Euler's phi function (also called the _totient_ function), which counts the number of positive integers which are relatively prime to $n$.

**Definition**: $\varphi(n)$ is the number of positive integers between 1 and $n$ which are relatively prime to $n$.

Here we have another, more general version of Fermat's Little Theorem, which uses an almost identical proof:

**Theorem**: For any positive integer $n$, if $(a,n) = 1$ then $a^{\varphi(n)} \equiv 1 \mod n$.

_Proof_. Again we use the argument from Fermat's Little Theorem, except here the sets are not all integers from $1$ to $n$, but only those which are relatively prime. Then we notice that if $a, b$ are relatively prime to $n$, then so is their product.

Using the product trick once more, we label the relatively prime integers $r_i$, and see that

$\displaystyle \prod \limits_{k=1}^{\varphi(n)} r_k \equiv a^{\varphi(n)} \prod \limits_{k=1}^{\varphi(n)} r_k \mod n$

Since the product of all relatively prime integers is again relatively prime, it has a multiplicative inverse mod $n$. While we might not know what it is, it certainly exists, so we may cancel both sides of the congruence to get $a^{\varphi(n)} \equiv 1 \mod n$. Therefore, we win. $\square$

Now we would like to have a good way to compute $\varphi(n)$ for a general $n$. First, we see that for powers of primes this is easy:

**Proposition**: $\varphi(p^k) = p^{k-1}(p-1) = p^k - p^{k-1}$ for any prime $p$ and positive integer $k$. In particular, $\varphi(p) = p-1$.

_Proof_. The only numbers which are not relatively prime to $p^k$ are all the multiples of $p$. Since every $p$th number is a multiple of $p$, there are hence $p^k / p$ numbers which are not relatively prime to $p$. Subtracting this from $p^k$ gives our desired formula. $\square$

Finally, we have a theorem that lets us compute $\varphi(n)$ for an arbitrary $n$, from $\varphi$ of its prime power factors.

**Proposition**: $\varphi(nm) = \varphi(n)\varphi(m)$ if $n$ and $m$ are relatively prime.

_Proof_. To each number $a$ relatively prime to $n$, and each number $b$ relatively prime to $m$, we see that $am+bn$ is relatively prime to $mn$. Supposing to the contrary that some prime $p$ divides $(an+bm, mn)$, we see that it must divide one of $m, n$ but not both, since $(m,n) = 1$. Suppose without loss of generality that $p \mid n$. Then since $p \mid an+bm$, we may see that $p \mid m$, a contradiction.

In other words, we have shown that $a,b \mapsto am+bn$ is a function from the set of pairs of relatively prime numbers of $n, m$ to the set of relatively prime numbers to $nm$. It suffices to show this map is injective and surjective.

For injectivity, we require that no two distinct $am+bn$ are congruent. Supposing we have two distinct $a,a'$ and two $b, b'$, with $am+bn \equiv a'm+b'n \mod mn$. Then rearranging terms we get $m(a-a') + n(b-b') \equiv 0 \mod mn. Since $m$ divides both $m(a-a')$ and $0$ under the modulus, we see that $m$ divides $n(b-b')$. But since $(m,n) = 1$, we get that $m \mid b-b'$, so by definition $b \equiv b' \mod m$, contradicting our assumption that the $b$'s were distinct. We get a similar result for the $a$'s, and this proves injectivity.

For surjectivity, let $k$ be a positive integer relatively prime to $nm$. Since $(m,n) = 1$, we may write $am+bn = k$ for some $a,b \in \mathbb{Z}$. This is achieved by finding a linear combination of $m,n$ equal to 1 (their gcd), and then multiplying through by $k$. We claim that $(a,n) = 1$. This is true since if some prime divided both of $a,n$, then it would also divide $am+bn = k$, and also $nm$. But $k$ was assumed to be relatively prime to $nm$, so this cannot happen. Hence, $a$ is relatively prime to $m$. An identical argument gives that $b$ is relatively prime to $n$, so the pair $(a,b) \mapsto am+bn$, proving surjectivity. $\square$

This, we may compute $\varphi(n)$ multiplicatively, by first finding its prime factorization, and then computing $\varphi(p^k)$ for each prime factor, which is easy.

Unfortunately, finding prime factorizations quickly is very hard. Unless we know the factorization of a large $n$ ahead of time (large as in hundreds-of-digits long), computing $\varphi(n)$ is effectively impossible. We cover the implications of this in more detail in [our post on RSA encryption](http://jeremykun.wordpress.com/2011/07/29/encryption-rsa/).

Until next time!
