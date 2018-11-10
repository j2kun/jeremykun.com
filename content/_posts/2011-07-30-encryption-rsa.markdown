---
author: jeremykun
date: 2011-07-30 06:55:57+00:00
draft: false
title: Encryption & RSA
type: post
url: /2011/07/29/encryption-rsa/
categories:
- Number Theory
tags:
- encryption
- java
- mathematics
- primes
- programming
- rsa
---

_This post assumes working knowledge of elementary number theory. Luckily for the non-mathematicians, we cover all required knowledge and notation in [our number theory primer](http://jeremykun.wordpress.com/2011/07/30/number-theory-a-primer/)._

## So Three Thousand Years of Number Theory Wasn't Pointless

It's often tough to come up with concrete applications of pure mathematics. In fact, before computers came along mathematics was used mostly for navigation, astronomy, and war. In the real world it almost always coincided with the physical sciences. Certainly the esoteric field of number theory didn't help to track planets or guide ships. It was just for the amusement and artistic expression of mathematicians.

Despite number theory's apparent uselessness, mathematicians invested a huge amount of work in it, searching for distributions of primes and inventing ring theory in the pursuit of algebraic identities. Indeed some of the greatest open problems in mathematics today are still number theoretical: the infamous [Goldbach Conjecture](http://en.wikipedia.org/wiki/Goldbach's_conjecture), the [Twin Prime Conjecture](http://en.wikipedia.org/wiki/Twin_prime_conjecture), and the [Collatz Conjecture](http://en.wikipedia.org/wiki/Collatz_conjecture) all have simple statements, but their proofs or counterexamples have eluded mathematicians for hundreds of years. Solutions to these problems, which are generally deemed beyond the grasp of an average mathematician, would certainly bring with them large prizes and international fame.

Putting aside its inherent beauty, until recently there was no use for number theory at all. But nowadays we have complex computer simulated models, statistical analysis, graphics, computing theory, signal processing, and optimization problems. So even very complex mathematics finds its way into most of what we do on a daily basis.

And, of course, number theory also has its place: in cryptography.

The history of cryptography is long and fascinating. The interested reader will find a wealth of information through [the article and subsequent links on Wikipedia](http://en.wikipedia.org/wiki/History_of_cryptography). We focus on one current method whose security is mathematically sound.

## The Advent of Public Keys

Until 1976 (two years before the RSA method was born), all encryption methods followed the same pattern:

	  1. At an earlier date, the sender and recipient agree on a secret parameter called a _key_, which is used both to encrypt and decrypt the message.
	  2. The message is encrypted by the sender, sent to the recipient, and then decrypted in privacy.

This way, any interceptor could not read the message without knowing the key and the encryption method. Of course, there were various methods of attacking the ciphers, but for the most part this was a safe method.

The problem is protecting the key. Since the two communicating parties had to agree on a key that nobody else could know, they either had to meet in person or trust an aide to communicate the key separately. Risky business for leaders of distant allied nations.

Then, in 1976, [two researchers](http://en.wikipedia.org/wiki/Diffie%E2%80%93Hellman_key_exchange) announced a breakthrough: the sender and recipient need not share the same key! Instead, everybody who wanted private communication has two keys: one private, and one public. The public key is published in a directory, while the private key is kept secret, so that only the recipient need know it.

Anyone wishing to send a secure message would then encrypt the message with the recipient's public key. The message could only be decrypted with the recipient's private key. Even the sender couldn't decrypt his own message!

The astute reader might question whether such an encryption method is possible: certainly every deterministic computation is reversible. Indeed, in theory it is possible to reverse the encryption method. However, as we will see it is computationally unfeasible. With the method we are about to investigate (disregarding any future mathematical or quantum breakthroughs), it would take a mind-bogglingly long time to do so. And, of course, the method works through the magic of number theory.

## RSA

[caption id="" align="alignleft" width="223"]![](http://casacaseycourtney.files.wordpress.com/2008/08/rsa1.jpg)
Rivest, Shamir, and Adleman. They look like pretty nice guys.[/caption]

RSA, an acronym which stands for the algorithm's inventors, Rivest, Shamir, and Adleman, is such a public-key encryption system. It is one of the most widely-used ciphers, and it depends heavily on the computational intractability of two problems in number theory: namely factoring integers and taking modular roots.

But before we get there, let us develop the method. Recall Euler's totient function, $\varphi(n)$.

**Definition**: Let $n$ be a positive integer. $\varphi(n)$ is the number of integers between 1 and $n$ relatively prime to $n$.

There is a famous theorem due to Euler that states if $a, n$ are relatively prime integers, then

$\displaystyle a^{\varphi(n)} \equiv 1 \mod{n}$

In other words, if we raise $a$ to that power, its remainder after dividing by $n$ is 1. Group theorists will recognize this immediately from Lagrange's Theorem. While it is possible to prove it with elementary tools, we will not do so here. We cover the full proof of this theorem in [our number theory primer](http://jeremykun.wordpress.com/2011/07/30/number-theory-a-primer/).

In particular, we notice the natural next result that $a^{k \varphi(n) + 1} \equiv a \mod{n}$ for any $k$, since this is just

$\displaystyle (a^{\varphi(n)})^k \cdot a \equiv 1^ka \equiv a \mod{n}$.

If we could break up $k \varphi(n) + 1$ into two smaller numbers, say $e,d$, then we could use exponentiation as our encryption and decryption method. While that is the entire idea of RSA in short, it requires a bit more detail:

Let $M$ be our message, encoded as a single number less than $n$. We call $n$ the _modulus_, and for the sake of argument let us say $M$ and $n$ are relatively prime. Then by Euler's theorem, $M^{\varphi(n)} \equiv 1 \mod{n}$. In particular, let us choose a _public key_ $e$ (for encryption), and raise $M^e \mod{n}$. This is the encrypted message. Note that both $e$ and $n$ are known to the encryptor, and hence the general public. Upon receiving such a message, the recipient may use his _private key_ $d = e^{-1} \mod{\varphi(n)}$ to decrypt the message. We may pick $e$ to be relatively prime to $\varphi(n)$, to ensure that such a $d$ exists. Then $ed \equiv 1 \mod{\varphi(n)}$, and so by Euler's theorem

$\displaystyle (M^e)^d = M^{ed} = M^{k \varphi(n) + 1} \equiv M \mod{n}$

By exponentiating the encrypted text with the right private key, we recover the original message, and our secrets are safe from prying eyes.

Now for the messy detail: Where did $n$ come from? And how we can actually compute all this junk?

First, in order to ensure $M < n$ for a reasonably encoded message $M$, we require that $n$ is large. Furthermore, since we make both $n$ and $e$ public, we have to ensure that $\varphi(n)$ is hard to compute, for if an attacker could determine $\varphi(n)$ from $n$, then $e^{-1} \mod{\varphi(n)}$ would be [trivial to compute](http://en.wikipedia.org/wiki/Modular_multiplicative_inverse#Computation). In addition, one could theoretically compute all the $e$th roots of $M^e$ modulo $n$.

We solve these problems by exploiting their computational intractability. We find two enormous primes $p,q$, and set $n = pq$. First, recall that the best known way to compute $\varphi(n)$ is by the following theorem:

**Theorem**: For $p,q$ primes, $\varphi(p^k) = p^k - p^{k-1}$, and $\varphi(p^j q^k) = \varphi(p^j)\varphi(q^k)$.

In this way, we can compute $\varphi(n)$ easily if we know it's prime factorization. Therein lies the problem and the solution: factorizing large numbers is hard. Indeed, it is an unsolved problem in computer science as to whether integers can be factored by a polynomial-time algorithm. Quickly finding arbitrary roots mod $n$ is a [similarly hard problem](http://en.wikipedia.org/wiki/RSA_problem).

To impress the difficulty of integer factorization, we visit its world record. In 2009, a team of researchers successfully factored a 678-bit (232-digit) integer, and it required [a network of hundreds of computers and two years to do](http://eprint.iacr.org/2010/006.pdf). The algorithms were quite sophisticated and at some times fickle, failing when one node in the network went down. On the other hand, our $p,q$ will each be 2048-bit numbers, and so their product is astronomical in comparison. In fact, even 1024-bit numbers are thousands of times harder to factor than 678-bit numbers, meaning that with the hugest of networks, it would take far longer than our lifespans just to factor a "weak" RSA modulus with the methods known today. In this respect, and for the foreseeable future, RSA is watertight.

Since we constructed $n$ as the product of two primes, we know

$\varphi(n) = \varphi(p)\varphi(q) = (p-1)(q-1)$,

so we can compute $\varphi(n)$ trivially. Then, if we pick any $e < \varphi(n)$ which is relatively prime to $\varphi(n)$ (for instance, $e$ itself could be prime), then we may compute the public key $d$ via the [extended Euclidean algorithm](http://en.wikipedia.org/wiki/Extended_Euclidean_algorithm).

For a clean-cut worked example of RSA key generation and encryption, see [the subsection on Wikipedia](http://en.wikipedia.org/wiki/RSA#A_worked_example). We admit that an example couldn't be done much better than theirs, and we use the same notation here as the writers do there.

## Big Random Primes

There is one remaining problem that requires our attention if we wish to implement an RSA encryption scheme. We have to generate huge primes.

To do so, we note that we don't actually care what the primes are, only how big they are. Generating large random _odd_ numbers is easy: we can simply randomly generate each of its 2,048 bits, ensuring the smallest bit is a 1. Since we recall that primes are distributed roughly according to $x / \log(x)$, we see that the chance of getting a prime at random is roughly $2 / \log(2^{2048})$, which is about $1 / 710$. Thus, on average we can expect to generate 710 random numbers before we get a prime.

Now that we know we'll probably find a prime number fast, we just have to determine which is prime. There is essentially only one sure-fire primality test: the [Sieve of Eratosthenes](http://en.wikipedia.org/wiki/Sieve_of_Eratosthenes), in which we simply test all the primes from 2 to the square root of $n$. If none divide $n$, then $n$ is prime.

Unfortunately, this is far too slow, and would require us to generate a list of primes that is unreasonably large (indeed, if we already had that list of primes we wouldn't need to generate any more!). So we turn to probabilistic tests. In other words, there are many algorithms which determine the _likelihood_ of a candidate being composite (not prime), and then repeat the test until that likelihood is sufficiently close to $0$, and hence a certainty. Generally this bound is $2^{-100}$, and the existing algorithms achieve it in polynomial time.

Unfortunately an in-depth treatment of one such primality test is beyond the scope of this post. In addition, most contemporary programming languages come equipped with one such primality test, so we put their implementations aside for a later date. To read more about probabilistic primality tests, see the [list of them on Wikipedia](http://en.wikipedia.org/wiki/List_of_number_theory_topics#Primality_tests). They are all based on special cases of Euler's theorem, and the distribution of multiplicative inverses modulo $n$.

## Implementation

In a wild and unprecedented turn of events, we did _not_ use Mathematica to implement RSA! The reason for this is so that anyone (especially the author's paranoid father) can run it. So we implemented it in Java. As always, [the entire source code](https://github.com/j2kun/rsa) (and this time, an executable jar file) is available on [this blog's Github page](https://github.com/j2kun?tab=repositories).

Despite its relative verbosity, Java has a few advantages. The first of these is the author's familiarity with its GUI (graphical user interface) libraries. The second benefit is that all of the important functions we need are part of the BigInteger class. BigInteger is a built-in Java class that allows us to work with numbers of unbounded size. Recall that in Mathematica unbounded arithmetic is built into the language, but older and more general-purpose languages like Java and C adhere to fixed-length arithmetic. Disregarding the debates over which is better, we notice that BigInteger has the functions:

    
    static BigInteger probablePrime(int bitLength, Random rnd)
    BigInteger modPow(BigInteger exponent, BigInteger m)
    BigInteger modInverse(BigInteger m)

For clarity, the first function generates numbers which are not prime with probability at most $2^{-100}$, the second computes exponents modulo "m", and the third computes the multiplicative inverse modulo "m". The "modPow" and "modInverse" functions operate on the context object, or the implicit "this" argument (recall Java is object-oriented [see upcoming primer on object-oriented programming]).

Indeed, this is all we need to write our program! But there are a few more specifics:

First, we need a good random number generator to feed BigInteger's "probablePrime" function. It turns out that Java's built-in random number generator is just not secure enough. To remedy this, we could use the "java.security.secureRandom" class, part of Java's cryptography package; but for the sake of brevity, we instead import an implementation of the [Mersenne Twister](http://www.cs.gmu.edu/~sean/research/), a fast prime number generator which is not secure.

Second, there are known factoring methods for $n=pq$ if $p \pm 1$ or $q \pm 1$ has only small prime factors. These are due to [Pollard ](http://mathworld.wolfram.com/Pollardp-1FactorizationMethod.html)and [Williams](http://mathworld.wolfram.com/WilliamspPlus1FactorizationMethod.html). So we include a special method called "isDivisibleByLargePrime", and screen our candidate prime numbers against its negation. The largest prime we test for is 65537, the 6543rd prime. The details of this function are in the source code, which again is available on [this blog's Github page](https://github.com/j2kun?tab=repositories). It is not very interesting.

Third, we notice that the choice of public key is arbitrary. Since everyone is allowed to know it, it shouldn't matter what we pick. Of course, this is a bit too naive, and it has been proven that if the public key $e$ is small (say, $3$), then the RSA encryption is less secure. After twenty years of attacks trying to break RSA, it has been generally accepted that public keys with moderate bit-length and small Hamming weight (few 1's in their binary expansion) are secure. The most commonly used public key is 65537, which is the prime $2^{16} +1 = \textup{0x10001}$. So in our implementation, we fix the public key at 65537.

Finally, in order to make our String representations of moduli, public keys, and private keys slightly shorter, we use [alphadecimal notation](http://en.wikipedia.org/wiki/Base_36) (base 36) for inputting and outputting our numbers. This has the advantage that it uses all numerals and characters, thus maximizing expression without getting funky symbols involved.

## Results

Here is a snapshot of the resulting Java application:

[![](http://jeremykun.files.wordpress.com/2011/07/rsa-screenshot.png)
](http://jeremykun.files.wordpress.com/2011/07/rsa-screenshot.png)
As you can see, the encrypted messages are quite long, but very copy-pasteable. Also, generating the keys can take up to a minute, so have patience when pressing the "Generate Keys" button under the tab of the same name.

There you have it! Enjoy the applet; it's for everyone to use, but despite all my due diligence in writing the software, I wouldn't recommend anyone to rely on it for national security.

Feel free to leave me a comment with a super-secret RSA-encoded message! Here is my encryption modulus and my public key:

    
    public key: 1ekh
    
    encryption modulus:
    5a1msbciqctepss5dfpp76rdb5selhybzhzerklbomyvwlohasuy81r9rbd3scvujpqn9e7m5hp52qv4fli9f4bupg23060wmaf94zq94s4j22hwyi764kk0k6w8is05tyg7029ub6ux4vb4bq9xxzw9nkfs0pfteq7wnm6hya7b2l2i1w8jh25913qye67gz8z4xrep1dcj8qpyxyi56ltukqyv366hei4nme6h9x00z16cbf8g76me1keccicsgd268u3iocvb6c5lw00j234270608f24qelu8xfjcddc7n9u0w2tf46bl1yzsjb8kb5ys9gh51l0ryetge1lwh1ontenraq35wv5f4ea57zae1ojcsxp3cxpx84mbg0duoln2vny7uixl3ti4n2flvfats4wz0h1c34cgxdyixb7ylci6t4dk8raqcbdi3yxclktvb7yv1sb61nxk1kylfp0h7wqtrogf8c039mc6bqe8b7eixb72pfz4sajw1rf170ck2vysy1z6bgyngrhyn8kpepd0btcyuyj0scdshlexlg4uolls8p6frxj8dt4ykcnddeuvf7dfz1qyqpjk7ljwr1hdgaecyqa6gsxryodrup1qpwgieot6v8c5bbizxm45qj4nez5cpe9q12m0pyeszic5dtb1yc0rm7lzzddg254uf390rk4irecfxibpv2lnk9zper3kg729w32n7u0qn8mamtmh80fo6hd0n5a50d9kzft1g3bky2t2d2f1a574ukigx1dfgqrtehnmx5nd

Until next time!
