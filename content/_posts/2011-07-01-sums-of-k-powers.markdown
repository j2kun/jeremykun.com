---
author: jeremykun
date: 2011-07-01 19:52:29+00:00
draft: false
title: Sums of k Powers
type: post
url: /2011/07/01/sums-of-k-powers/
categories:
- Number Theory
- Proof Gallery
---

**Problem:** Prove that for all $n,k \in \mathbb{N}, k > 1$, we have


$\sum \limits_{i=0}^{n} k^i = \frac{k^{n+1}-1}{k-1}$




**Solution**: Representing the numbers in base $k$, we have that each term of the sum is all 0's except for a 1 in the $i$th place. Hence, the sum of all terms is the $n$-digit number comprised of all 1's. Multiplying by $k-1$ gives us the $n$-digit number where every digit is $k-1$. Adding one to this gives us the next power of $k$ which is the number $100 \dots 0$ ($n+1$ digits).




This author thinks that proofs by induction are often tedious and unenlightening. This proof gives a good reason why the identity should be true in the first place, and moreover gives an easy way to remember the statement itself.




There is a shorter, more general, and more elegant proof, which makes use of slightly more sophisticated technology (specifically, polynomials). It is easy to see that the polynomial $x^n - 1$ factors as $(x-1)(x^{n-1} + x^{n-2} + \dots + 1)$. Since the factoring is true in the context of polynomials, we may plug in any number for $x$ and the following equation holds:




$\displaystyle \frac{x^n-1}{x-1} = x^{n-1} + x^{n-2} + \dots + 1$




Note that now we have extended the theorem, not only to all real numbers, but to all numbers in any field (e.g. complex numbers, finite fields, and the field of [p-adics](http://en.wikipedia.org/wiki/P-adic_number)). This is true because the factorization holds in the polynomial ring over any field. The only numbers we use are 1 and -1, which exist in every field. Indeed, we could also extend it to commutative rings with unity, but the conditions on the ring start to come into play there. (For instance, what does it mean to "divide" by $x-1$? What if when we plug in some value for $x$, we don't get an inverse? We can work around this, but it takes some more effort.)




And finally, as a reader pointed out, the proof by induction is not so terrible. We repeat it here:




Let $k$ be an arbitrary number. The base case where n = 0 is trivial. Suppose it holds for $n-1$:




$\displaystyle \sum_{i = 0}^n k^i = k^n + \sum_{i = 0}^{n-1} k^i$




Using the induction hypothesis, this is just




$\displaystyle k^n + \frac{k^{(n-1)+1} - 1}{k-1} = \frac{k^n(k-1) + k^n - 1}{k-1} = \frac{k^{n+1} - 1}{k-1}$




Completing the proof.
