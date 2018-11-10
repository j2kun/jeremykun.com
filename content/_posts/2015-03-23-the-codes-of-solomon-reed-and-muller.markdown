---
author: jeremykun
date: 2015-03-23 14:00:00+00:00
draft: false
title: The Codes of Solomon, Reed, and Muller
type: post
url: /2015/03/23/the-codes-of-solomon-reed-and-muller/
categories:
- Coding Theory
- Combinatorics
tags:
- coding theory
- information theory
- reed-muller code
- reed-solomon code
---

[Last time](http://jeremykun.com/2015/03/02/hammings-code/) we defined the Hamming code. We also saw that it meets the Hamming bound, which is a measure of how densely a code can be packed inside an ambient space and still maintain a given distance. This time we'll define the Reed-Solomon code which optimizes a different bound called the _Singleton bound_, and then generalize them to a larger class of codes called Reed-Muller codes. In future posts we'll consider algorithmic issues behind decoding the codes, for now we just care about their existence and optimality properties.


## The Singleton bound


Recall that a code $C$ is a set of strings called _codewords_, and that the parameters of a code $C$ are written $(n,k,d)_q$. Remember $n$ is the length of a codeword, $k = \log_q |C|$ is the message length, $d$ is the minimum distance between any two codewords, and $q$ is the size of the alphabet used for the codewords. Finally, remember that for linear codes our alphabets were either just $\{ 0,1 \}$ where $q=2$, or more generally a [finite field](http://jeremykun.com/2014/02/26/finite-fields-a-primer/) $\mathbb{F}_q$ for $q$ a prime power.

One way to motivate for the Singleton bound goes like this. We can easily come up with codes for the following parameters. For $(n,n,1)_2$ the identity function works. And to get a $(n,n-1,2)_2$-code we can encode a binary string $x$ by appending the parity bit $\sum_i x_i \mod 2$ to the end (as an easy exercise, verify this has distance 2). An obvious question is can we generalize this to a $(n, n-d+1, d)_2$-code for any $d$? Perhaps a more obvious question is: why can't we hope for better? A larger $d$ or $k \geq n-d+1$? Because the Singleton bound says so.

**Theorem [Singleton 64]:** If $C$ is an $(n,k,d)_q$-code, then $k \leq n-d+1$.

_Proof._ The proof is pleasantly simple. Let $\Sigma$ be your alphabet and look at the projection map $\pi : \Sigma^n \to \Sigma^{k-1}$ which projects $x = (x_1, \dots, x_n) \mapsto (x_1, \dots, x_{k-1})$. Remember that the size of the code is $|C| = q^k$, and because the codomain of $\pi,$ i.e. $\Sigma^{k-1}$ has size $q^{k-1} < q^k$, it follows that $\pi$ is not an injective map. In particular, there are two codewords $x,y$ whose first $k-1$ coordinates are equal. Even if all of their remaining coordinates differ, this implies that $d(x,y) < n-k+1$.


$\square$




It's embarrassing that such a simple argument can prove that one can do no better. There are codes that meet this bound and they are called _maximum distance separable_ (MDS) codes. One might wonder how MDS codes relate to perfect codes, but they are incomparable; there are perfect codes that are not MDS codes, and conversely MDS codes need not be perfect. The Reed-Solomon code is an example of the latter.





## The Reed-Solomon Code


[caption id="attachment_5677" align="aligncenter" width="300"][![Irving Reed (left) and Gustave Solomon (right).](https://jeremykun.files.wordpress.com/2015/03/rs.jpg)
](https://jeremykun.files.wordpress.com/2015/03/rs.jpg) Irving Reed (left) and Gustave Solomon (right).[/caption]

The Reed-Solomon code has a very simple definition, especially for those of you who have read about [secret sharing](http://jeremykun.com/2014/06/23/the-mathematics-of-secret-sharing/).

Given a prime power $q$ and integers $k \leq n \leq q$, the _Reed-Solomon_ code with these parameters is defined by its encoding function $E: \mathbb{F}_q^k \to \mathbb{F}_q^n$ as follows.



	  1. Generate $\mathbb{F}_q$ [explicitly](http://jeremykun.com/2014/03/13/programming-with-finite-fields/).
	  2. Pick $n$ distinct elements $\alpha_i \in \mathbb{F}_q$.
	  3. A message $x \in \mathbb{F}_q^k$ is a list of elements $c_0 \dots c_{k-1}$. Represent the message as a polynomial $m(x) = \sum_j c_jx^j$.
	  4. The encoding of a message is the tuple $E(m) = (m(\alpha_1), \dots, m(\alpha_n))$. That is, we just evaluate $m(x)$ at our chosen locations in $\alpha_i$.

Here's an example when $q=5, n=3, k=3$. We'll pick the points $1,3,4 \in \mathbb{F}_5$, and let our message be $x = (4,1,2)$, which is encoded as a polynomial $m(x) = 4 + x + 2x^2$. Then the encoding of the message is


$\displaystyle E(m) = (m(1), m(3), m(4)) = (2, 0, 0)$




Decoding the message is a bit more difficult (more on that next time), but for now let's prove the basic facts about this code.




**Fact:** The Reed-Solomon code is linear. This is just because polynomials of a limited degree form a vector space. Adding polynomials is adding their coefficients, and scaling them is scaling their coefficients. Moreover, the _evaluation_ of a polynomial at a point is a linear map, i.e. it's always true that $m_1(\alpha) + m_2(\alpha) = (m_1 + m_2)(\alpha)$, and scaling the coefficients is no different. So the codewords also form a vector space.




**Fact: **$d = n - k + 1$, or equivalently the Reed-Solomon code meets the Singleton bound. This follows from a simple fact: any two _different_ single-variable polynomials of degree at most $k-1$ agree on at most $k-1$ points. Indeed, otherwise two such polynomials $f,g$ would give a new polynomial $f-g$ which has more than $k-1$ roots, but the fundamental theorem of algebra (the adaptation for finite fields) says the only polynomial with this many roots is the zero polynomial.




So the Reed-Solomon code is maximum distance separable. Neat!




One might wonder why one would want good codes with large alphabets. One reason is that with a large alphabet we can interpret a byte as an element of $\mathbb{F}_{256}$ to get error correction on bytes. So if you want to encode some really large stream of bytes (like a DVD) using such a scheme and you get bursts of contiguous errors in small regions (like a scratch), then you can do pretty powerful error correction. In fact, this is more or less the idea behind error correction for DVDs. So I hear. You can read more about the famous applications [at Wikipedia](http://en.wikipedia.org/wiki/Reed%E2%80%93Solomon_error_correction#Applications).





## The Reed-Muller code




The Reed-Muller code is a neat generalization of the Reed-Solomon code to multivariable polynomials. The reason they're so useful is not necessarily because they optimize some bound (if they do, I haven't heard of it), but because they specialize to all sorts of useful codes with useful properties. One of these is properties is called _local decodability_, which has big applications in theoretical computer science.




Anyway, before I state the definition let me remind the reader about compact notation for multivariable polynomials. I can represent the variables $x_1, \dots, x_n$ used in the polynomial as a vector $\mathbf{x}$ and likewise a monomial $x_1^{\alpha_1} x_2^{\alpha_2} \dots x_n^{\alpha_n}$ by a "vector power" $\mathbf{x}^\alpha$, where $\sum_i \alpha_i = d$ is the degree of that monomial, and you'd write an entire polynomial as $\sum_\alpha c_\alpha x^{\alpha}$ where $\alpha$ ranges over all exponents you want.




**Definition: **Let $m, l$ be positive integers and $q > l$ be a prime power. The Reed-Muller code with parameters $m,l,q$ is defined as follows:






	  1. The message is the list of multinomial coefficients of a homogeneous degree $l$ polynomial in $m$ variables, $f(\mathbf{x}) = \sum_{\alpha} c_\alpha x^\alpha$.
	  2. You encode a message $f(\mathbf{x})$ as the tuple of all polynomial evaluations $(f(x))_{x \in \mathbb{F}_q^m}$.

Here the actual parameters of the code are $n=q^m$, and $k = \binom{m+l}{m}$ being the number of possible coefficients. Finally $d = (1 - l/q)n$, and we can prove this in the same way as we did for the Reed-Solomon code, using a beefed up fact about the number of roots of a multivariate polynomial:

**Fact: **Two multivariate degree $\leq l$ polynomials over a finite field $\mathbb{F}_q$ agree on at most an $l/q$ fraction of $\mathbb{F}_q^m$.

For messages of desired length $k$, a clever choice of parameters gives a good code. Let $m = \log k / \log \log k$, $q = \log^2 k$, and pick $l$ such that $\binom{m+l}{m} = k$. Then the Reed-Muller code has polynomial length $n = k^2$, and because $l = o(q)$ we get that the distance of the code is asymptotically $d = (1-o(1))n$, i.e. it tends to $n$.

A fun fact about Reed-Muller codes: they were apparently [used on the Voyager space missions](http://space.stackexchange.com/questions/2053/how-was-magnetic-tape-decay-prevented-in-voyager-1) to relay image data back to Earth.


## The Way Forward


So we defined Reed-Solomon and Reed-Muller codes, but we didn't really do any programming yet. The reason is because the encoding algorithms are very straightforward. If you've been following this blog you'll know we have already written code to explicitly represent polynomials over finite fields, and extending that code to multivariable polynomials, at least for the sake of encoding the Reed-Muller code, is straightforward.

The real interesting algorithms come when you're trying to decode. For example, in the Reed-Solomon code we'd take as input a bunch of points in a plane (over a finite field), only some of which are consistent with the underlying polynomial that generated them, and we have to reconstruct the unknown polynomial exactly. Even worse, for Reed-Muller we have to do it with many variables!

We'll see exactly how to do that and produce working code next time.

Until then!

Posts in this series:



	  * [A Proofless Introduction to Coding Theory](https://jeremykun.com/2015/02/16/a-proofless-introduction-to-information-theory/)
	  * [Hamming's Code](https://jeremykun.com/2015/03/02/hammings-code/)
	  * [The Codes of Solomon, Reed, and Muller](https://jeremykun.com/2015/03/23/the-codes-of-solomon-reed-and-muller/)
	  * [The Welch-Berlekamp Algorithm for Correcting Errors in Data](https://jeremykun.com/2015/09/07/welch-berlekamp/)

