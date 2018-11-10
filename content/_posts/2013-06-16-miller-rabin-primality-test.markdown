---
author: jeremykun
date: 2013-06-16 23:55:40+00:00
draft: false
title: Miller-Rabin Primality Test
type: post
url: /2013/06/16/miller-rabin-primality-test/
categories:
- Algorithms
- Cryptography
- Number Theory
- Probability Theory
- Program Gallery
tags:
- computational complexity
- miller-rabin
- primes
- programming
- python
- random number generators
- randomized algorithm
---

**Problem: **Determine if a number is prime, with an acceptably small error rate.

**Solution:** (in Python)

{{< highlight python >}}
import random

def decompose(n):
   exponentOfTwo = 0

   while n % 2 == 0:
      n = n/2
      exponentOfTwo += 1

   return exponentOfTwo, n

def isWitness(possibleWitness, p, exponent, remainder):
   possibleWitness = pow(possibleWitness, remainder, p)

   if possibleWitness == 1 or possibleWitness == p - 1:
      return False

   for _ in range(exponent):
      possibleWitness = pow(possibleWitness, 2, p)

      if possibleWitness == p - 1:
         return False

   return True

def probablyPrime(p, accuracy=100):
   if p == 2 or p == 3: return True
   if p < 2: return False

   exponent, remainder = decompose(p - 1)

   for _ in range(accuracy):
      possibleWitness = random.randint(2, p - 2)
      if isWitness(possibleWitness, p, exponent, remainder):
         return False

   return True
{{< /highlight >}}

**Discussion: **This algorithm is known as the Miller-Rabin primality test, and it was a very important breakthrough in the study of probabilistic algorithms.

Efficiently testing whether a number is prime is a crucial problem in cryptography, because the security of many cryptosystems depends on the use of large randomly chosen primes. Indeed, we've seen one on this blog already which is in widespread use: [RSA](http://jeremykun.com/2011/07/29/encryption-rsa/). Randomized algorithms also have quite useful applications in general, because it's often that a solution which is correct with probability, say, $2^{-100}$ is good enough for practice.

But from a theoretical and historical perspective, primality testing lied at the center of a huge problem in complexity theory. In particular, it is unknown whether algorithms which have access to randomness and can output probably correct answers are more powerful than those that don't. The use of randomness in algorithms comes in a number of formalizations, the most prominent of which is called [BPP](http://en.wikipedia.org/wiki/BPP_(complexity)) (Bounded-error Probabilistic Polynomial time). The Miller-Rabin algorithm shows that primality testing is in BPP. On the other hand, algorithms solvable in polynomial time without randomness are in a class called [P](http://jeremykun.com/2012/02/23/p-vs-np-a-primer-and-a-proof-written-in-racket/).

For a long time (from 1975 to 2002), it was unknown whether primality testing was in P or not. There are very few remaining important problems that have BPP algorithms but are not known to be in P. Polynomial identity testing is the main example, and until 2002 primality testing shared its title. Now primality has a known [polynomial-time algorithm](http://en.wikipedia.org/wiki/AKS_primality_test). One might argue that (in theory) the Miller-Rabin test is now useless, but it's still a nice example of a nontrivial BPP algorithm.

The algorithm relies on the following theorem:

**Theorem:** if $p$ is a prime, let $s$ be the maximal power of 2 dividing $p-1$, so that $p-1 = 2^{s}d$ and $d$ is odd. Then for any $1 \leq n \leq p-1$, one of two things happens:



	  * $n^d = 1 \mod p$ or
	  * $n^{2^j d} = -1 \mod p$ for some $0 \leq j < s$.

The algorithm then simply operates as follows: pick nonzero $n$ at random until both of the above conditions fail. Such an $n$ is called a _witness_ for the fact that $p$ is a composite. If $p$ is not a prime, then there is at least a 3/4 chance that a randomly chosen $n$ will be a witness.

We leave the proof of the theorem as an exercise. Start with the fact that $a^{p-1} = 1 \mod p$ (this is Fermat's Little Theorem). Then use induction to take square roots (the result has to be +/-1 mod p), and continue until you get to $a^{d}=1 \mod p$.

The Python code above uses Python's built in modular exponentiation function pow to do fast modular exponents. The isWitness function first checks $n^d = 1 \mod p$ and then all powers $n^{2^j d} = -1 \mod p$. The probablyPrime function then simply generates random potential witnesses and checks them via the previous function. The output of the function is True if and only if all of the needed modular equivalences hold for all witnesses inspected. The choice of endpoints being 2 and $p-2$ are because 1 and $p-1$ will always have exponents 1 mod $p$.
