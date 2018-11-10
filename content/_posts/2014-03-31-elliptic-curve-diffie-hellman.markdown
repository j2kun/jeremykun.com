---
author: jeremykun
date: 2014-03-31 15:22:51+00:00
draft: false
title: Elliptic Curve Diffie-Hellman
type: post
url: /2014/03/31/elliptic-curve-diffie-hellman/
categories:
- Algorithms
- Cryptography
- Discrete
- Field Theory
- Group Theory
- Number Theory
tags:
- cryptography
- diffie-hellman
- discrete logarithm
- elliptic curves
- rsa
---

So far in [this series](http://jeremykun.com/2014/02/08/introducing-elliptic-curves/) we've seen elliptic curves from many perspectives, including the [elementary](http://jeremykun.com/2014/02/10/elliptic-curves-as-elementary-equations/), [algebraic](http://jeremykun.com/2014/02/16/elliptic-curves-as-algebraic-structures/), and [programmatic](http://jeremykun.com/2014/02/24/elliptic-curves-as-python-objects/) ones. We implemented [finite field arithmetic](http://jeremykun.com/2014/03/13/programming-with-finite-fields/) and [connected it to our elliptic curve code](http://jeremykun.com/2014/03/19/connecting-elliptic-curves-with-finite-fields-a-reprise/). So we're in a perfect position to feast on the main course: how do we use elliptic curves to actually do cryptography?

## History

As the reader has heard countless times in this series, an elliptic curve is a geometric object whose points have a surprising and well-defined notion of addition. That you can add some points on some elliptic curves was a well-known technique since antiquity, discovered by Diophantus. It was not until the mid 19th century that the general question of whether addition always makes sense was answered by [Karl Weierstrass](http://en.wikipedia.org/wiki/Karl_Weierstrass). In 1908 [Henri Poincaré](http://en.wikipedia.org/wiki/Henri_Poincar%C3%A9) asked about how one might go about classifying the structure of elliptic curves, and it was not until 1922 that [Louis Mordell](http://en.wikipedia.org/wiki/Louis_J._Mordell) proved the [fundamental theorem of elliptic curves](http://en.wikipedia.org/wiki/Mordell%E2%80%93Weil_theorem), classifying their algebraic structure for most important fields.

While mathematicians have always been interested in elliptic curves (there is currently a million dollar prize out for a solution to [one problem](http://en.wikipedia.org/wiki/Birch_and_Swinnerton-Dyer_conjecture) about them), its use in cryptography was not suggested until 1985. Two prominent researchers independently proposed it: [Neal Koblitz](http://en.wikipedia.org/wiki/Neal_Koblitz) at the University of Washington, and [Victor Miller](http://en.wikipedia.org/wiki/Victor_S._Miller) who was at IBM Research at the time. Their proposal was solid from the start, but elliptic curves didn't gain traction in practice until around 2005. More recently, the NSA was revealed to have [planted vulnerable national standards](http://en.wikipedia.org/wiki/Dual_EC_DRBG) for elliptic curve cryptography so they could have backdoor access. You can see a proof and implementation of the backdoor at [Aris Adamantiadis's blog](http://blog.0xbadc0de.be/archives/155). For now we'll focus on the cryptographic protocols themselves.

## The Discrete Logarithm Problem

Koblitz and Miller had insights aplenty, but the central observation in all of this is the following.

<blockquote>Adding is easy on elliptic curves, but **undoing** addition seems hard.</blockquote>

What I mean by this is usually called the _discrete logarithm problem._ Here's a formal definition. Recall that an additive group is just a set of things that have a well-defined addition operation, and the that notation $ny$ means $y + y + \dots + y$ ($n$ times).

**Definition: **Let $G$ be an additive group, and let $x, y$ be elements of $G$ so that $x = ny$ for some integer $n$. The _discrete logarithm problem_ asks one to find $n$ when given $x$ and $y$.

I like to give super formal definitions first, so let's do a comparison. For _integers_ this problem is very easy. If you give me 12 and 4185072, I can take a few seconds and compute that $4185072 = (348756) 12$ using the elementary-school division algorithm (in the above notation, $y=12, x=4185072$, and $n = 348756$). The division algorithm for integers is _efficient, _and so it gives us a nice solution to the discrete logarithm problem for the additive group of integers $\mathbb{Z}$.

The reason we use the word "logarithm" is because if your group operation is multiplication instead of addition, you're tasked with solving the equation $x = y^n$ for $n$. With real numbers you'd take a logarithm of both sides, hence the name. Just in case you were wondering, we can also solve the multiplicative logarithm problem efficiently for rational numbers (and hence for integers) using the [square-and-multiply algorithm](http://en.wikipedia.org/wiki/Exponentiation_by_squaring). Just square $y$ until doing so would make you bigger than $x$, then multiply by $y$ until you hit $x$.

But integers are _way nicer_ than they need to be. They are selflessly well-ordered. They give us division for free. It's a computational charity! What happens when we move to settings where we don't have a division algorithm? In mathematical lingo: we're really interested in the case when $G$ is _just_ a group, and doesn't have additional structure. The less structure we have, the harder it should be to solve problems like the discrete logarithm. Elliptic curves are an excellent example of such a group. There is no sensible ordering for points on an elliptic curve, and we don't know how to do division efficiently. The best we can do is add $y$ to itself over and over until we hit $x$, and it could easily happen that $n$ (as a number) is exponentially larger than the number of bits in $x$ and $y$.

What we really want is a _polynomial time algorithm_ for solving discrete logarithms. Since we can take multiples of a point very fast using the double-and-add algorithm [from our previous post](http://jeremykun.com/2014/02/24/elliptic-curves-as-python-objects/), if there is _no_ polynomial time algorithm for the discrete logarithm problem then "taking multiples" fills the role of a theoretical [one-way function](http://en.wikipedia.org/wiki/One-way_function), and as we'll see this opens the door for secure communication.

Here's the formal statement of the discrete logarithm problem for elliptic curves.

**Problem: **Let $E$ be an elliptic curve over a finite field $k$. Let $P, Q$ be points on $E$ such that $P = nQ$ for some integer $n$. Let $|P|$ denote the number of bits needed to describe the point $P$. We wish to find an algorithm which determines $n$ and has runtime polynomial in $|P| + |Q|$. If we want to allow randomness, we can require the algorithm to find the correct $n$ with probability at least 2/3.

So this problem seems hard. And when mathematicians and computer scientists try to solve a problem for many years and they can't, the cryptographers get excited. They start to wonder: under the assumption that the problem has no efficient solution, can we use that as the foundation for a secure communication protocol?

## The Diffie-Hellman Protocol and Problem

Let's spend the rest of this post on the simplest example of a cryptographic protocol based on elliptic curves: the Diffie-Hellman key exchange.

A lot of cryptographic techniques are based on two individuals sharing a secret string, and using that string as the key to encrypt and decrypt their messages. In fact, if you have enough secret shared information, and you only use it once, you can have _provably unbreakable _encryption! We'll cover this idea in a future series on the theory of cryptography (it's called a [one-time pad](http://en.wikipedia.org/wiki/One-time_pad), and it's not all that complicated). All we need now is motivation to get a shared secret.

Because what if your two individuals have never met before and they want to generate such a shared secret? Worse, what if their only method of communication is being monitored by nefarious foes? Can they possibly exchange public information and use it to construct a shared piece of secret information? Miraculously, the answer is yes, and one way to do it is with the _Diffie-Hellman _protocol. Rather than explain it abstractly let's just jump right in and implement it with elliptic curves.

As hinted by the discrete logarithm problem, we only really have one tool here: taking multiples of a point. So say we've chosen a curve $C$ and a point on that curve $Q$. Then we can take some secret integer $n$, and publish $Q$ and $nQ$ for the world to see. If the discrete logarithm problem is truly hard, then we can rest assured that nobody will be able to discover $n$.

How can we use this to established a shared secret? This is where Diffie-Hellman comes in. Take our two would-be communicators, Alice and Bob. Alice and Bob each pick a binary string called a _secret key,_ which in interpreted as a number in this protocol. Let's call_ _Alice's secret key $s_A$ and Bob's $s_B$, and note that they don't have to be the same. As the name "secret key" suggests, the secret keys are held secret. Moreover, we'll assume that everything else in this protocol, including all data sent between the two parties, is public.

So Alice and Bob agree ahead of time on a public elliptic curve $C$ and a public point $Q$ on $C$. We'll sometimes call this point the _base point _for the protocol.

Bob can cunningly do the following trick: take his secret key $s_B$ and send $s_B Q$ to Alice. Equally slick Alice computes $s_A Q$ and sends that to Bob. Now Alice, having $s_B Q $, computes $s_A s_B Q$. And Bob, since he has $s_A Q$, can compute $s_B s_A Q$. But since addition is commutative in elliptic curve groups, we know $s_A s_B Q = s_B s_A Q$. The secret piece of shared information can be anything derived from this new point, for example its $x$-coordinate.

If we want to talk about security, we have to describe what is public and what the attacker is trying to determine. In this case the public information consists of the points $Q, s_AQ, s_BQ$. What is the attacker trying to figure out? Well she really wants to eavesdrop on their subsequent conversation, that is, the stuff that encrypt with their new shared secret $s_As_BQ$. So the attacker wants find out $s_As_BQ$. And we'll call this the Diffie-Hellman problem.

**Diffie-Hellman Problem: **Suppose you fix an elliptic curve $E$ over a finite field $k$, and you're given four points $Q, aQ, bQ$ and $P$ for some unknown integers $a, b$. Determine if $P = abQ$ in polynomial time (in the lengths of $Q, aQ, bQ, P$).

On one hand, if we had an efficient solution to the discrete logarithm problem, we could easily use that to solve the Diffie-Hellman problem because we could compute $a,b$ and them quickly compute $abQ$ and check if it's $P$. In other words discrete log is at least as hard as this problem. On the other hand nobody knows if you can do this without solving the discrete logarithm problem. Moreover, we're making this problem as easy as we reasonably can because we don't require you to be able to compute $abQ$. Even if some prankster _gave_ you a candidate for $abQ$, all you have to do is check if it's correct. One could imagine some test that rules out all fakes but still doesn't allow us to compute the true point, which would be one way to solve this problem without being able to solve discrete log.

So this is our hardness assumption: assuming this problem has no efficient solution then no attacker, even with really lucky guesses, can feasibly determine Alice and Bob's shared secret.

## Python Implementation

The Diffie-Hellman protocol is just as easy to implement as you would expect. Here's some Python code that does the trick. Note that all the code produced in the making of this post is available on [this blog's Github page](github.com/j2kun).

{{< highlight python >}}
def sendDH(privateKey, generator, sendFunction):
   return sendFunction(privateKey * generator)

def receiveDH(privateKey, receiveFunction):
   return privateKey * receiveFunction()
{{< /highlight >}}

And using our code from the previous posts in [this series](http://jeremykun.com/2014/02/08/introducing-elliptic-curves/) we can run it on a small test.

{{< highlight python >}}
import os

def generateSecretKey(numBits):
   return int.from_bytes(os.urandom(numBits // 8), byteorder='big')

if __name__ == "__main__":
   F = FiniteField(3851, 1)
   curve = EllipticCurve(a=F(324), b=F(1287))
   basePoint = Point(curve, F(920), F(303))

   aliceSecretKey = generateSecretKey(8)
   bobSecretKey = generateSecretKey(8)

   alicePublicKey = sendDH(aliceSecretKey, basePoint, lambda x:x)
   bobPublicKey = sendDH(bobSecretKey, basePoint, lambda x:x)

   sharedSecret1 = receiveDH(bobSecretKey, lambda: alicePublicKey)
   sharedSecret2 = receiveDH(aliceSecretKey, lambda: bobPublicKey)
   print('Shared secret is %s == %s' % (sharedSecret1, sharedSecret2))
{{< /highlight >}}

Pythons os module allows us to access the operating system's random number generator (which is supposed to be cryptographically secure) via the function urandom, which accepts as input the number of bytes you wish to generate, and produces as output a Python bytestring object that we then convert to an integer. Our simplistic (and totally insecure!) protocol uses the elliptic curve $C$ defined by $y^2 = x^3 + 324 x + 1287$ over the finite field $\mathbb{Z}/3851$. We pick the base point $Q = (920, 303)$, and call the relevant functions with placeholders for actual network transmission functions.

There is one issue we have to note. Say we fix our base point $Q$. Since an elliptic curve over a finite field can only have finitely many points (since the field only has finitely many possible pairs of numbers), it will eventually happen that $nQ = 0$ is the ideal point. Recall that the smallest value of $n$ for which $nQ = 0$ is called the _order_ of $Q$. And so when we're generating secret keys, we have to pick them to be smaller than the order of the base point. Viewed from the other angle, we want to pick $Q$ to have large order, so that we can pick large and difficult-to-guess secret keys. In fact, no matter what integer you use for the secret key it will be equivalent to some secret key that's less than the order of $Q$. So if an attacker could guess the smaller secret key he wouldn't need to know your larger key.

The base point we picked in the example above happens to have order 1964, so an 8-bit key is well within the bounds. A_ real_ industry-strength elliptic curve (say, [Curve25519](http://en.wikipedia.org/wiki/Curve25519) or the curves used in the [NIST standards](http://csrc.nist.gov/groups/ST/toolkit/documents/dss/NISTReCur.pdf)*) is designed to avoid these problems. The order of the base point used in the Diffie-Hellman protocol for Curve25519 has [gargantuan order](http://crypto.stackexchange.com/a/12614/12701) (like $2^{256}$). So 256-bit keys can easily be used. I'm brushing some important details under the rug, because the key as an actual string is derived from 256 pseudorandom bits in a highly nontrivial way.

So there we have it: a simple cryptographic protocol based on elliptic curves. While we didn't experiment with a truly secure elliptic curve in this example, we'll eventually extend our work to include Curve25519. But before we do that we want to explore some of the other algorithms based on elliptic curves, including random number generation and factoring.

## Comments on Insecurity

Why do we use elliptic curves for this? Why not do something like [RSA](http://jeremykun.com/2011/07/29/encryption-rsa/) and do multiplication (and exponentiation) modulo some large prime?

Well, it turns out that algorithmic techniques are getting better and better at solving the discrete logarithm problem for integers mod $p$, leading some to claim that [RSA is dead](http://rjlipton.wordpress.com/2013/05/06/a-most-perplexing-mystery/). But even if we will never find a genuinely efficient algorithm (polynomial time is good, but might not be good enough), these techniques have made it clear that the key size required to maintain high security in RSA-type protocols needs to be really big. Like 4096 bits. But for elliptic curves we can get away with 256-bit keys. The reason for this is essentially mathematical: addition on elliptic curves is not as well understood as multiplication is for integers, and the more complex structure of the group makes it seem inherently more difficult. So until some powerful general attacks are found, it seems that we can get away with higher security on elliptic curves with smaller key sizes.

I mentioned that the particular elliptic curve we chose was insecure, and this raises the natural question: what makes an elliptic curve/field/basepoint combination secure or insecure? There are a few mathematical pitfalls (including [certain attacks](http://en.wikipedia.org/wiki/Small_subgroup_confinement_attack) we won't address), but one major non-mathematical problem is called a side-channel attack. A [_side channel attack_](http://en.wikipedia.org/wiki/Side_channel_attack) against a cryptographic protocol is one that gains additional information about users' secret information by monitoring side-effects of the physical implementation of the algorithm.

The problem is that different operations, doubling a point and adding two different points, have very different algorithms. As a result, they take different amounts of time to complete and they require differing amounts of power. Both of these can be used to reveal information about the secret keys. Despite the different algorithms for arithmetic on Weierstrass normal form curves, one can still implement them to be secure. Naively, one might pad the two subroutines with additional (useless) operations so that they have more similar time/power signatures, but I imagine there are better methods available.

But much of what makes a curve's domain parameters mathematically secure or insecure is still unknown. There are a handful of known attacks against very specific families of parameters, and so cryptography experts simply avoid these as they are discovered. Here is a short list of pitfalls, and links to overviews:

	  1. Make sure the order of your basepoint has a short facorization (e.g., is $2p, 3p,$ or $4p$ for some prime $p$). Otherwise you risk attacks based on the Chinese Remainder Theorem, the most prominent of which is called [Pohlig-Hellman](http://en.wikipedia.org/wiki/Pohlig%E2%80%93Hellman_algorithm).
	  2. Make sure your curve is not _[supersingular](http://en.wikipedia.org/wiki/Supersingular_elliptic_curve)_. If it is you can reduce the discrete logarithm problem to one in a different and much simpler group.
	  3. If your curve $C$ is defined over $\mathbb{Z}/p$, make sure the number of points on $C$ is not equal to $p$. Such a curve is called _[prime-field anomalous](http://books.google.com/books?id=bhMPt3I3J_UC&pg=PA168&lpg=PA168&dq=prime-field+anomalous+curve&source=bl&ots=NjkXAPG52n&sig=Ak56Gvn7kfGQkDeW1tjqDAAgXXc&hl=en&sa=X&ei=XDA3U_7yHpHhsAS7p4CgCw&ved=0CEUQ6AEwAg#v=onepage&q=prime-field%20anomalous%20curve&f=false)_, and its discrete logarithm problem can be reduced to the (additive) version on integers.
	  4. Don't pick a small underlying field like $\mathbb{F}_{2^m}$ for small $m$. [General-purpose attacks](http://en.wikipedia.org/wiki/Pollard's_rho_algorithm_for_logarithms) can be sped up significantly against such fields.
	  5. If you use the field $\mathbb{F}_{2^m}$, ensure that $m$ is prime. Many believe that if $m$ has small divisors, attacks based on [some very complicated algebraic geometry](https://eprint.iacr.org/2004/240.pdf) can be used to solve the discrete logarithm problem more efficiently than any general-purpose method. This gives evidence that $m$ being composite at all is dangerous, so we might as well make it prime.

This is a sublist of the list provided on page 28 of [this white paper](http://cs.ucsb.edu/~koc/ccs130h/notes/ecdsa-cert.pdf).

The interesting thing is that there is little about the algorithm and protocol that is vulnerable. Almost all of the vulnerabilities come from using bad curves, bad fields, or a bad basepoint. Since the known attacks work on a pretty small subset of parameters, one potentially secure technique is to just generate a random curve and a random point on that curve! But apparently all respected national agencies will refuse to call your algorithm "standards compliant" if you do this.

Next time we'll continue implementing cryptographic protocols, including the more general public-key message sending and signing protocols.

Until then!
