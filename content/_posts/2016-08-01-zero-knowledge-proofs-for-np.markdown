---
author: jeremykun
date: 2016-08-01 15:00:53+00:00
draft: false
title: Zero Knowledge Proofs for NP
type: post
url: /2016/08/01/zero-knowledge-proofs-for-np/
categories:
- Algorithms
- Cryptography
- Graph Theory
- Number Theory
tags:
- computational complexity
- cryptography
- mathematics
- one-way functions
- programming
- python
- random number generators
- zero knowledge
---

[Last time](https://jeremykun.com/2016/07/05/zero-knowledge-proofs-a-primer/), we saw a specific zero-knowledge proof for graph isomorphism. This introduced us to the concept of an interactive proof, where you have a prover and a verifier sending messages back and forth, and the prover is trying to prove a specific claim to the verifier.

A zero-knowledge proof is a special kind of interactive proof in which the prover has some secret piece of knowledge that makes it very easy to verify a disputed claim is true. The prover's goal, then, is to convince the verifier (a polynomial-time algorithm) that the claim is true without revealing any knowledge at all about the secret.

In this post we'll see that, using a bit of cryptography, zero-knowledge proofs capture a much wider class of problems than graph isomorphism. Basically, if you believe that cryptography exists, every problem whose answers can be easily verified have zero-knowledge proofs (i.e., all of the class NP). Here are a bunch of examples. For each I'll phrase the problem as a question, and then say what sort of data the prover's secret could be.



	  * Given a boolean formula, is there an assignment of variables making it true? Secret: a satisfying assignment to the variables.
	  * Given a set of integers, is there a subset whose sum is zero? Secret: such a subset.
	  * Given a graph, does it have a 3-coloring? Secret: a valid 3-coloring.
	  * Given a boolean circuit, can it produce a specific output? Secret: a choice of inputs that produces the output.

The common link among all of these problems is that they are NP-hard (graph isomorphism isn't known to be NP-hard). For us this means two things: (1) we think these problems are actually hard, so the verifier can't solve them, and (2) if you show that one of them has a zero-knowledge proof, then they all have zero-knowledge proofs.

We're going to describe and implement a zero-knowledge proof for graph 3-colorability, and in the next post we'll dive into the theoretical definitions and talk about the proof that the scheme we present is zero-knowledge. As usual, all of the code used in making this post is available in [a repository](https://github.com/j2kun/zero-knowledge-proofs) on [this blog's Github page](https://github.com/j2kun). In the [follow up to this post](https://jeremykun.com/2016/09/19/zero-knowledge-definitions-and-theory/), we'll dive into more nitty gritty details about the proof that this works, and study different kinds of zero-knowledge.


## One-way permutations


In a recent program gallery post we introduced the [Blum-Blum-Shub pseudorandom generator](http://jeremykun.com/2016/07/11/the-blum-blum-shub-pseudorandom-generator/). A pseudorandom generator is simply an algorithm that takes as input a short random string of length $s$ and produces as output a longer string, say, of length $3s$. This output string should not be random, but rather "indistinguishable" from random in a sense we'll make clear next time. The underlying function for this generator is the "modular squaring" function $x \mapsto x^2 \mod M$, for some cleverly chosen $M$. The $M$ is chosen in such a way that makes this mapping a permutation. So this function is more than just a pseudorandom generator, it's a _one-way permutation_.

If you have a primality-checking algorithm on hand ([we do](http://jeremykun.com/2013/06/16/miller-rabin-primality-test/)), then preparing the Blum-Blum-Shub algorithm is only about 15 lines of code.

{{< highlight python >}}
def goodPrime(p):
    return p % 4 == 3 and probablyPrime(p, accuracy=100)

def findGoodPrime(numBits=512):
    candidate = 1

    while not goodPrime(candidate):
        candidate = random.getrandbits(numBits)

    return candidate

def makeModulus(numBits=512):
    return findGoodPrime(numBits) * findGoodPrime(numBits)

def blum_blum_shub(modulusLength=512):
    modulus = makeModulus(numBits=modulusLength)

    def f(inputInt):
        return pow(inputInt, 2, modulus)

    return f
{{< /highlight >}}

The interested reader should check out the [proof gallery post](http://jeremykun.com/2016/07/11/the-blum-blum-shub-pseudorandom-generator/) for more details about this generator. For us, having a one-way permutation is the important part (and we're going to defer the formal definition of "one-way" until next time, just think "hard to get inputs from outputs").

The other concept we need, which is related to a one-way permutation, is the notion of a _hardcore predicate. _Let $G(x)$ be a one-way permutation, and let $f(x) = b$ be a function that produces a single bit from a string. We say that $f$ is a _hardcore predicate_ for $G$ if you can't reliably compute $f(x)$ when given only $G(x)$.

Hardcore predicates are important because there are many one-way functions for which, when given the output, you can guess _part_ of the input very reliably, but not the rest (e.g., if $g$ is a one-way function, $(x, y) \mapsto (x, g(y))$ is also one-way, but the $x$ part is trivially guessable). So a hardcore predicate formally measures, when given the output of a one-way function, what information derived from the input is hard to compute.

In the case of Blum-Blum-Shub, one hardcore predicate is simply the parity of the input bits.

{{< highlight python >}}
def parity(n):
    return sum(int(x) for x in bin(n)[2:]) % 2
{{< /highlight >}}


## Bit Commitment Schemes


A core idea that will makes zero-knowledge proofs work for NP is the ability for the prover to publicly "commit" to a choice, and later reveal that choice in a way that makes it infeasible to fake their commitment. This will involve not just the commitment to a single bit of information, but also the transmission of auxiliary data that is provably infeasible to fake.

Our pair of one-way permutation $G$ and hardcore predicate $f$ comes in very handy. Let's say I want to commit to a bit $b \in \{ 0,1 \}$. Let's fix a security parameter that will measure how hard it is to change my commitment post-hoc, say $n = 512$. My process for committing is to draw a random string $x$ of length $n$, and send you the pair $(G(x), f(x) \oplus b)$, where $\oplus$ is the XOR operator on two bits.

The guarantee of a one-way permutation with a hardcore predicate is that if you only see $G(x)$, you can't guess $f(x)$ with any reasonable edge over random guessing. Moreover, if you fix a bit $b$, and take an unpredictably random bit $y$, the XOR $b \oplus y$ is also unpredictably random. In other words, if $f(x)$ is hardcore, then so is $x \mapsto f(x) \oplus b$ for a fixed bit $b$. Finally, to reveal my commitment, I just send the string $x$ and let you independently compute $(G(x), f(x) \oplus b)$. Since $G$ is a permutation, that $x$ is the _only_ $x$ that could have produced the commitment I sent you earlier.

Here's a Python implementation of this scheme. We start with a generic base class for a commitment scheme.

{{< highlight python >}}
class CommitmentScheme(object):
    def __init__(self, oneWayPermutation, hardcorePredicate, securityParameter):
        '''
            oneWayPermutation: int -> int
            hardcorePredicate: int -> {0, 1}
        '''
        self.oneWayPermutation = oneWayPermutation
        self.hardcorePredicate = hardcorePredicate
        self.securityParameter = securityParameter

        # a random string of length `self.securityParameter` used only once per commitment
        self.secret = self.generateSecret()

    def generateSecret(self):
        raise NotImplemented

    def commit(self, x):
        raise NotImplemented

    def reveal(self):
        return self.secret
{{< /highlight >}}

Note that the "reveal" step is always simply to reveal the secret. Here's the implementation subclass. We should also note that the security string should be chosen at random anew for every bit you wish to commit to. In this post we won't reuse `CommitmentScheme` objects anyway.

{{< highlight python >}}
class BBSBitCommitmentScheme(CommitmentScheme):
    def generateSecret(self):
        # the secret is a random quadratic residue
        self.secret = self.oneWayPermutation(random.getrandbits(self.securityParameter))
        return self.secret

    def commit(self, bit):
        unguessableBit = self.hardcorePredicate(self.secret)
        return (
            self.oneWayPermutation(self.secret),
            unguessableBit ^ bit,  # python xor
        )
{{< /highlight >}}

One important detail is that the Blum-Blum-Shub one-way permutation is only a permutation when restricted to quadratic residues. As such, we generate our secret by shooting a random string through the one-way permutation to get a random residue. In fact this produces a uniform random residue, since the Blum-Blum-Shub modulus is chosen in such a way that ensures every residue has exactly four square roots.

Here's code to check the verification is correct.

{{< highlight python >}}
class BBSBitCommitmentVerifier(object):
    def __init__(self, oneWayPermutation, hardcorePredicate):
        self.oneWayPermutation = oneWayPermutation
        self.hardcorePredicate = hardcorePredicate

    def verify(self, securityString, claimedCommitment):
        trueBit = self.decode(securityString, claimedCommitment)
        unguessableBit = self.hardcorePredicate(securityString)  # wasteful, whatever
        return claimedCommitment == (
            self.oneWayPermutation(securityString),
            unguessableBit ^ trueBit,  # python xor
        )

    def decode(self, securityString, claimedCommitment):
        unguessableBit = self.hardcorePredicate(securityString)
        return claimedCommitment[1] ^ unguessableBit
{{< /highlight >}}

and an example of using it

{{< highlight python >}}
if __name__ == "__main__":
    import blum_blum_shub
    securityParameter = 10
    oneWayPerm = blum_blum_shub.blum_blum_shub(securityParameter)
    hardcorePred = blum_blum_shub.parity

    print('Bit commitment')
    scheme = BBSBitCommitmentScheme(oneWayPerm, hardcorePred, securityParameter)
    verifier = BBSBitCommitmentVerifier(oneWayPerm, hardcorePred)

    for _ in range(10):
        bit = random.choice([0, 1])
        commitment = scheme.commit(bit)
        secret = scheme.reveal()
        trueBit = verifier.decode(secret, commitment)
        valid = verifier.verify(secret, commitment)

        print('{} == {}? {}; {} {}'.format(bit, trueBit, valid, secret, commitment))
{{< /highlight >}}

Example output:

{{< highlight python >}}
1 == 1? True; 524 (5685, 0)
1 == 1? True; 149 (22201, 1)
1 == 1? True; 476 (34511, 1)
1 == 1? True; 927 (14243, 1)
1 == 1? True; 608 (23947, 0)
0 == 0? True; 964 (7384, 1)
0 == 0? True; 373 (23890, 0)
0 == 0? True; 620 (270, 1)
1 == 1? True; 926 (12390, 0)
0 == 0? True; 708 (1895, 0)
{{< /highlight >}}

As an exercise, write a program to verify that no other input to the Blum-Blum-Shub one-way permutation gives a valid verification. Test it on a small security parameter like $n=10$.

It's also important to point out that the verifier needs to do some additional validation that we left out. For example, how does the verifier know that the revealed secret actually is a quadratic residue? In fact, detecting quadratic residues is believed to be hard! To get around this, we could change the commitment scheme reveal step to reveal the random string that was used as input to the permutation to get the residue (cf. `[BBSCommitmentScheme.generateSecret](https://github.com/j2kun/zero-knowledge-proofs/blob/master/part2/commitment.py#L30)` for the random string that needs to be saved/revealed). Then the verifier could generate the residue in the same way. As an exercise, upgrade the bit commitment an verifier classes to reflect this.

In order to get a zero-knowledge proof for 3-coloring, we need to be able to commit to one of three colors, which requires _two_ bits. So let's go overkill and write a generic integer commitment scheme. It's simple enough: specify a bound on the size of the integers, and then do an independent bit commitment for every bit.

{{< highlight python >}}
class BBSIntCommitmentScheme(CommitmentScheme):
    def __init__(self, numBits, oneWayPermutation, hardcorePredicate, securityParameter=512):
        '''
            A commitment scheme for integers of a prespecified length `numBits`. Applies the
            Blum-Blum-Shub bit commitment scheme to each bit independently.
        '''
        self.schemes = [BBSBitCommitmentScheme(oneWayPermutation, hardcorePredicate, securityParameter)
                        for _ in range(numBits)]
        super().__init__(oneWayPermutation, hardcorePredicate, securityParameter)

    def generateSecret(self):
        self.secret = [x.secret for x in self.schemes]
        return self.secret

    def commit(self, integer):
        # first pad bits to desired length
        integer = bin(integer)[2:].zfill(len(self.schemes))
        bits = [int(bit) for bit in integer]
        return [scheme.commit(bit) for scheme, bit in zip(self.schemes, bits)]
{{< /highlight >}}

And the corresponding verifier

{{< highlight python >}}
class BBSIntCommitmentVerifier(object):
    def __init__(self, numBits, oneWayPermutation, hardcorePredicate):
        self.verifiers = [BBSBitCommitmentVerifier(oneWayPermutation, hardcorePredicate)
                          for _ in range(numBits)]

    def decodeBits(self, secrets, bitCommitments):
        return [v.decode(secret, commitment) for (v, secret, commitment) in
                zip(self.verifiers, secrets, bitCommitments)]

    def verify(self, secrets, bitCommitments):
        return all(
            bitVerifier.verify(secret, commitment)
            for (bitVerifier, secret, commitment) in
            zip(self.verifiers, secrets, bitCommitments)
        )

    def decode(self, secrets, bitCommitments):
        decodedBits = self.decodeBits(secrets, bitCommitments)
        return int(''.join(str(bit) for bit in decodedBits))
{{< /highlight >}}

A sample usage:

{{< highlight python >}}
if __name__ == "__main__":
    import blum_blum_shub
    securityParameter = 10
    oneWayPerm = blum_blum_shub.blum_blum_shub(securityParameter)
    hardcorePred = blum_blum_shub.parity

    print('Int commitment')
    scheme = BBSIntCommitmentScheme(10, oneWayPerm, hardcorePred)
    verifier = BBSIntCommitmentVerifier(10, oneWayPerm, hardcorePred)
    choices = list(range(1024))
    for _ in range(10):
        theInt = random.choice(choices)
        commitments = scheme.commit(theInt)
        secrets = scheme.reveal()
        trueInt = verifier.decode(secrets, commitments)
        valid = verifier.verify(secrets, commitments)

        print('{} == {}? {}; {} {}'.format(theInt, trueInt, valid, secrets, commitments))
{{< /highlight >}}

And a sample output:

{{< highlight python >}}
527 == 527? True; [25461, 56722, 25739, 2268, 1185, 18226, 46375, 8907, 54979, 23095] [(29616, 0), (342, 1), (54363, 1), (63975, 0), (5426, 0), (9124, 1), (23973, 0), (44832, 0), (33044, 0), (68501, 0)]
67 == 67? True; [25461, 56722, 25739, 2268, 1185, 18226, 46375, 8907, 54979, 23095] [(29616, 1), (342, 1), (54363, 1), (63975, 1), (5426, 0), (9124, 1), (23973, 1), (44832, 1), (33044, 0), (68501, 0)]
729 == 729? True; [25461, 56722, 25739, 2268, 1185, 18226, 46375, 8907, 54979, 23095] [(29616, 0), (342, 1), (54363, 0), (63975, 1), (5426, 0), (9124, 0), (23973, 0), (44832, 1), (33044, 1), (68501, 0)]
441 == 441? True; [25461, 56722, 25739, 2268, 1185, 18226, 46375, 8907, 54979, 23095] [(29616, 1), (342, 0), (54363, 0), (63975, 0), (5426, 1), (9124, 0), (23973, 0), (44832, 1), (33044, 1), (68501, 0)]
614 == 614? True; [25461, 56722, 25739, 2268, 1185, 18226, 46375, 8907, 54979, 23095] [(29616, 0), (342, 1), (54363, 1), (63975, 1), (5426, 1), (9124, 1), (23973, 1), (44832, 0), (33044, 0), (68501, 1)]
696 == 696? True; [25461, 56722, 25739, 2268, 1185, 18226, 46375, 8907, 54979, 23095] [(29616, 0), (342, 1), (54363, 0), (63975, 0), (5426, 1), (9124, 0), (23973, 0), (44832, 1), (33044, 1), (68501, 1)]
974 == 974? True; [25461, 56722, 25739, 2268, 1185, 18226, 46375, 8907, 54979, 23095] [(29616, 0), (342, 0), (54363, 0), (63975, 1), (5426, 0), (9124, 1), (23973, 0), (44832, 0), (33044, 0), (68501, 1)]
184 == 184? True; [25461, 56722, 25739, 2268, 1185, 18226, 46375, 8907, 54979, 23095] [(29616, 1), (342, 1), (54363, 0), (63975, 0), (5426, 1), (9124, 0), (23973, 0), (44832, 1), (33044, 1), (68501, 1)]
136 == 136? True; [25461, 56722, 25739, 2268, 1185, 18226, 46375, 8907, 54979, 23095] [(29616, 1), (342, 1), (54363, 0), (63975, 0), (5426, 0), (9124, 1), (23973, 0), (44832, 1), (33044, 1), (68501, 1)]
632 == 632? True; [25461, 56722, 25739, 2268, 1185, 18226, 46375, 8907, 54979, 23095] [(29616, 0), (342, 1), (54363, 1), (63975, 1), (5426, 1), (9124, 0), (23973, 0), (44832, 1), (33044, 1), (68501, 1)]
{{< /highlight >}}

Before we move on, we should note that this integer commitment scheme "blows up" the secret by quite a bit. If you have a security parameter $s$ and an integer with $n$ bits, then the commitment uses roughly $sn$ bits. A more efficient method would be to simply use a good public-key encryption scheme, and then reveal the secret key used to encrypt the message. While we [implemented such schemes](http://jeremykun.com/2014/02/08/introducing-elliptic-curves/) previously on this blog, I thought it would be more fun to do something new.


## A zero-knowledge proof for 3-coloring


First, a high-level description of the protocol. The setup: the prover has a graph $G$ with $n$ vertices $V$ and $m$ edges $E$, and also has a secret 3-coloring of the vertices $\varphi: V \to \{ 0, 1, 2 \}$. Recall, a 3-coloring is just an assignment of colors to vertices (in this case the colors are 0,1,2) so that no two adjacent vertices have the same color.

So the prover has a coloring $\varphi$ to be kept secret, but wants to prove that $G$ is 3-colorable. The idea is for the verifier to pick a random edge $(u,v)$, and have the prover reveal the colors of $u$ and $v$. However, if we run this protocol only once, there's nothing to stop the prover from just lying and picking two distinct colors. If we allow the verifier to run the protocol many times, and the prover actually reveals the colors from their secret coloring, then after roughly $|V|$ rounds the verifier will know the entire coloring. Each step reveals more knowledge.

We can fix this with two modifications.



	  1. The prover first publicly commits to the coloring using a commitment scheme. Then when the verifier asks for the colors of the two vertices of a random edge, he can rest assured that the prover fixed a coloring that does not depend on the verifier's choice of edge.
	  2. The prover doesn't reveal colors from their secret coloring, but rather from a random permutation of the secret coloring. This way, when the verifier sees colors, they're equally likely to see _any_ two colors, and all the verifier will know is that those two colors are different.

So the scheme is: prover commits to a random permutation of the true coloring and sends it to the verifier; the verifier asks for the true colors of a given edge; the prover provides those colors and the secrets to their commitment scheme so the verifier can check.

The key point is that now the verifier has to commit to a coloring, and if the coloring isn't a proper 3-coloring the verifier has a reasonable chance of picking an improperly colored edge (a one-in-$|E|$ chance, which is at least $1/|V|^2$). On the other hand, if the coloring is proper, then the verifier will always query a properly colored edge, and it's zero-knowledge because the verifier is equally likely to see every pair of colors. So the verifier will always accept, but won't know anything more than that the edge it chose is properly colored. Repeating this $|V|^2$-ish times, with high probability it'll have queried every edge and be certain the coloring is legitimate.

Let's implement this scheme. First the data types. As in the previous post, graphs are represented by edge lists, and a coloring is represented by a dictionary mapping a vertex to 0, 1, or 2 (the "colors").

{{< highlight python >}}
# a graph is a list of edges, and for simplicity we'll say
# every vertex shows up in some edge
exampleGraph = [
    (1, 2),
    (1, 4),
    (1, 3),
    (2, 5),
    (2, 5),
    (3, 6),
    (5, 6)
]

exampleColoring = {
    1: 0,
    2: 1,
    3: 2,
    4: 1,
    5: 2,
    6: 0,
}
{{< /highlight >}}

Next, the Prover class that implements that half of the protocol. We store a list of integer commitment schemes for each vertex whose color we need to commit to, and send out those commitments.

{{< highlight python >}}
class Prover(object):
    def __init__(self, graph, coloring, oneWayPermutation=ONE_WAY_PERMUTATION, hardcorePredicate=HARDCORE_PREDICATE):
        self.graph = [tuple(sorted(e)) for e in graph]
        self.coloring = coloring
        self.vertices = list(range(1, numVertices(graph) + 1))
        self.oneWayPermutation = oneWayPermutation
        self.hardcorePredicate = hardcorePredicate
        self.vertexToScheme = None

    def commitToColoring(self):
        self.vertexToScheme = {
            v: commitment.BBSIntCommitmentScheme(
                2, self.oneWayPermutation, self.hardcorePredicate
            ) for v in self.vertices
        }

        permutation = randomPermutation(3)
        permutedColoring = {
            v: permutation[self.coloring[v]] for v in self.vertices
        }

        return {v: s.commit(permutedColoring[v])
                for (v, s) in self.vertexToScheme.items()}

    def revealColors(self, u, v):
        u, v = min(u, v), max(u, v)
        if not (u, v) in self.graph:
            raise Exception('Must query an edge!')

        return (
            self.vertexToScheme[u].reveal(),
            self.vertexToScheme[v].reveal(),
        )
{{< /highlight >}}

In `commitToColoring` we randomly permute the underlying colors, and then compose that permutation with the secret coloring, committing to each resulting color independently. In `revealColors` we reveal only those colors for a queried edge. Note that we don't actually need to store the permuted coloring, because it's implicitly stored in the commitments.

It's crucial that we reject any query that doesn't correspond to an edge. If we don't reject such queries then the verifier can break the protocol! In particular, by querying non-edges you can determine which pairs of nodes have the same color in the secret coloring. You can then chain these together to partition the nodes into color classes, and so color the graph. (After seeing the `Verifier` class below, implement this attack as an exercise).

Here's the corresponding `Verifier`:

{{< highlight python >}}
class Verifier(object):
    def __init__(self, graph, oneWayPermutation, hardcorePredicate):
        self.graph = [tuple(sorted(e)) for e in graph]
        self.oneWayPermutation = oneWayPermutation
        self.hardcorePredicate = hardcorePredicate
        self.committedColoring = None
        self.verifier = commitment.BBSIntCommitmentVerifier(2, oneWayPermutation, hardcorePredicate)

    def chooseEdge(self, committedColoring):
        self.committedColoring = committedColoring
        self.chosenEdge = random.choice(self.graph)
        return self.chosenEdge

    def accepts(self, revealed):
        revealedColors = []

        for (w, bitSecrets) in zip(self.chosenEdge, revealed):
            trueColor = self.verifier.decode(bitSecrets, self.committedColoring[w])
            revealedColors.append(trueColor)
            if not self.verifier.verify(bitSecrets, self.committedColoring[w]):
                return False

        return revealedColors[0] != revealedColors[1]
{{< /highlight >}}

As expected, in the acceptance step the verifier decodes the true color of the edge it queried, and accepts if and only if the commitment was valid and the edge is properly colored.

Here's the whole protocol, which is syntactically very similar to the one for graph isomorphism.

{{< highlight python >}}
def runProtocol(G, coloring, securityParameter=512):
    oneWayPermutation = blum_blum_shub.blum_blum_shub(securityParameter)
    hardcorePredicate = blum_blum_shub.parity

    prover = Prover(G, coloring, oneWayPermutation, hardcorePredicate)
    verifier = Verifier(G, oneWayPermutation, hardcorePredicate)

    committedColoring = prover.commitToColoring()
    chosenEdge = verifier.chooseEdge(committedColoring)

    revealed = prover.revealColors(*chosenEdge)
    revealedColors = (
        verifier.verifier.decode(revealed[0], committedColoring[chosenEdge[0]]),
        verifier.verifier.decode(revealed[1], committedColoring[chosenEdge[1]]),
    )
    isValid = verifier.accepts(revealed)

    print("{} != {} and commitment is valid? {}".format(
        revealedColors[0], revealedColors[1], isValid
    ))

    return isValid
{{< /highlight >}}

And an example of running it

{{< highlight python >}}
if __name__ == "__main__":
    for _ in range(30):
        runProtocol(exampleGraph, exampleColoring, securityParameter=10)
{{< /highlight >}}

Here's the output

{{< highlight python >}}
0 != 2 and commitment is valid? True
1 != 0 and commitment is valid? True
1 != 2 and commitment is valid? True
2 != 0 and commitment is valid? True
1 != 2 and commitment is valid? True
2 != 0 and commitment is valid? True
0 != 2 and commitment is valid? True
0 != 2 and commitment is valid? True
0 != 1 and commitment is valid? True
0 != 1 and commitment is valid? True
2 != 1 and commitment is valid? True
0 != 2 and commitment is valid? True
2 != 0 and commitment is valid? True
2 != 0 and commitment is valid? True
1 != 0 and commitment is valid? True
1 != 0 and commitment is valid? True
0 != 2 and commitment is valid? True
2 != 1 and commitment is valid? True
0 != 2 and commitment is valid? True
0 != 2 and commitment is valid? True
2 != 1 and commitment is valid? True
1 != 0 and commitment is valid? True
1 != 0 and commitment is valid? True
2 != 1 and commitment is valid? True
2 != 1 and commitment is valid? True
1 != 0 and commitment is valid? True
0 != 2 and commitment is valid? True
1 != 2 and commitment is valid? True
1 != 2 and commitment is valid? True
0 != 1 and commitment is valid? True
{{< /highlight >}}


So while we haven't proved it rigorously, we've seen the zero-knowledge proof for graph 3-coloring. This automatically gives us a zero-knowledge proof for all of NP, because given any NP problem you can just convert it to the equivalent 3-coloring problem and solve that. Of course, the blowup required to convert a random NP problem to 3-coloring can be polynomially large, which makes it unsuitable for practice. But the point is that this gives us a theoretical justification for which problems have zero-knowledge proofs _in principle. _Now that we've established that you can go about trying to find the most efficient protocol for your favorite problem.





## Anticipatory notes


When we covered graph isomorphism last time, we said that a _simulator_ could, without participating in the zero-knowledge protocol or knowing the secret isomorphism, produce a transcript that was drawn from the same distribution of messages as the protocol produced. That was all that it needed to be "zero-knowledge," because anything the verifier could do with its protocol transcript, the simulator could do too.

We can do exactly the same thing for 3-coloring, exploiting the same "reverse order" trick where the simulator picks the random edge first, then chooses the color commitment post-hoc.

Unfortunately, both there and here I'm short-changing you, dear reader. The elephant in the room is that our naive simulator _assumes the verifier is playing by the rules!_ If you want to define security, you have to define it against a verifier who breaks the protocol in an arbitrary way. For example, the simulator should be able to produce an equivalent transcript even if the verifier deterministically picks an edge, or tries to pick a non-edge, or tries to send gibberish. It takes a lot more work to prove security against an arbitrary verifier, but the basic setup is that the simulator can no longer make choices for the verifier, but rather has to invoke the verifier subroutine as a black box. (To compensate, the requirements on the simulator are relaxed quite a bit; more on that next time)

Because an implementation of such a scheme would involve a lot of validation, we're going to defer the discussion to [next time](https://jeremykun.com/2016/09/19/zero-knowledge-definitions-and-theory/). We also need to be more specific about the different kinds of zero-knowledge, since we won't be able to achieve _perfect_ zero-knowledge with the simulator drawing from an identical distribution, but rather a _computationally indistinguishable_ distribution.

We'll define all this rigorously [next time](https://jeremykun.com/2016/09/19/zero-knowledge-definitions-and-theory/), and discuss the known theoretical implications and limitations. Next time will be cuffs-off theory, baby!

Until then!
