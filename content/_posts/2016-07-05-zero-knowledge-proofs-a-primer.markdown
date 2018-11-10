---
author: jeremykun
date: 2016-07-05 15:00:29+00:00
draft: false
title: Zero Knowledge Proofs — A Primer
type: post
url: /2016/07/05/zero-knowledge-proofs-a-primer/
categories:
- Algorithms
- Combinatorics
- Computing Theory
- Discrete
- Graph Theory
- Primers
- Probability
tags:
- complexity theory
- cryptography
- graph isomorphism
- mathematics
- programming
- python
- zero knowledge
---

In this post we'll get a strong taste for zero knowledge proofs by exploring the graph isomorphism problem in detail. In the next post, we'll see how this relates to cryptography and the bigger picture. The goal of this post is to get a strong understanding of the terms "prover," "verifier," and "simulator," and "zero knowledge" in the context of a specific zero-knowledge proof. Then [next time](http://jeremykun.com/2016/08/01/zero-knowledge-proofs-for-np/) we'll see how the same concepts (though not the same proof) generalizes to a cryptographically interesting setting.

## Graph isomorphism

Let's start with an extended example. We are given two graphs $G_1, G_2$, and we'd like to know whether they're isomorphic, meaning they're the same graph, but "drawn" different ways.

![](https://jeremykun.files.wordpress.com/2015/11/gi-example.png)

The problem of telling if two graphs are isomorphic seems hard. The pictures above, which are all different drawings of the same graph (or are they?), should give you pause if you thought it was easy.

To add a tiny bit of formalism, a graph $G$ is a list of edges, and each edge $(u,v)$ is a pair of integers between 1 and the total number of vertices of the graph, say $n$. Using this representation, an isomorphism between $G_1$ and $G_2$ is a permutation $\pi$ of the numbers $\{1, 2, \dots, n \}$ with the property that $(i,j)$ is an edge in $G_1$ if and only if $(\pi(i), \pi(j))$ is an edge of $G_2$. You swap around the labels on the vertices, and that's how you get from one graph to another isomorphic one.

Given two arbitrary graphs as input on a large number of vertices $n$, nobody knows of an efficient—i.e., polynomial time in $n$—algorithm that can always decide whether the input graphs are isomorphic. Even if you promise me that the inputs are isomorphic, nobody knows of an algorithm that could construct an isomorphism. (If you think about it, such an algorithm could be used to solve the decision problem!)

## A game

Now let's play a game. In this game, we're given two enormous graphs on a billion nodes. I claim they're isomorphic, and I want to prove it to you. However, my life's fortune is locked behind these particular graphs (somehow), and if you actually had an isomorphism between these two graphs you could use it to steal all my money. But I still want to convince you that I do, in fact, own all of this money, because we're about to start a business and you need to know I'm not broke.

Is there a way for me to convince you beyond a reasonable doubt that these two graphs are indeed isomorphic? And moreover, could I do so without you gaining access to my secret isomorphism? It would be even better if I could guarantee you learn _nothing_ about my isomorphism or _any_ isomorphism, because even the slightest chance that you can steal my money is out of the question.

Zero knowledge proofs have exactly those properties, and here's a zero knowledge proof for graph isomorphism. For the record, $G_1$ and $G_2$ are public knowledge, (common inputs to our protocol for the sake of tracking runtime), and the protocol itself is common knowledge. However, I have an isomorphism $f: G_1 \to G_2$ that you don't know.

**Step 1:** I will start by picking one of my two graphs, say $G_1$, mixing up the vertices, and sending you the resulting graph. In other words, I send you a graph $H$ which is chosen uniformly at random from all isomorphic copies of $G_1$. I will save the permutation $\pi$ that I used to generate $H$ for later use.

**Step 2: **You receive a graph $H$ which you save for later, and then you randomly pick an integer $t$ which is either 1 or 2, with equal probability on each. The number $t$ corresponds to your challenge for me to prove $H$ is isomorphic to $G_1$ or $G_2$. You send me back $t$, with the expectation that I will provide you with an isomorphism between $H$ and $G_t$.

**Step 3:** Indeed, I faithfully provide you such an isomorphism. If I you send me $t=1$, I'll give you back $\pi^{-1} : H \to G_1$, and otherwise I'll give you back $f \circ \pi^{-1}: H \to G_2$. Because composing a fixed permutation with a uniformly random permutation is again a uniformly random permutation, in either case I'm sending you a uniformly random permutation.

**Step 4:** You receive a permutation $g$, and you can use it to verify that $H$ is isomorphic to $G_t$. If the permutation I sent you doesn't work, you'll reject my claim, and if it does, you'll accept my claim.

Before we analyze, here's some Python code that implements the above scheme. You can find the full, working example in a [repository](https://github.com/j2kun/zero-knowledge-proofs) on [this blog's Github page.](https://github.com/j2kun/)

First, a few helper functions for generating random permutations (and turning their list-of-zero-based-indices form into a function-of-positive-integers form)

{{< highlight python >}}
import random

def randomPermutation(n):
    L = list(range(n))
    random.shuffle(L)
    return L

def makePermutationFunction(L):
    return lambda i: L[i - 1] + 1

def makeInversePermutationFunction(L):
    return lambda i: 1 + L.index(i - 1)

def applyIsomorphism(G, f):
    return [(f(i), f(j)) for (i, j) in G]
{{< /highlight >}}

Here's a class for the Prover, the one who knows the isomorphism and wants to prove it while keeping the isomorphism secret:

{{< highlight python >}}
class Prover(object):
    def __init__(self, G1, G2, isomorphism):
        '''
            isomomorphism is a list of integers representing
            an isomoprhism from G1 to G2.
        '''
        self.G1 = G1
        self.G2 = G2
        self.n = numVertices(G1)
        assert self.n == numVertices(G2)

        self.isomorphism = isomorphism
        self.state = None

    def sendIsomorphicCopy(self):
        isomorphism = randomPermutation(self.n)
        pi = makePermutationFunction(isomorphism)

        H = applyIsomorphism(self.G1, pi)

        self.state = isomorphism
        return H

    def proveIsomorphicTo(self, graphChoice):
        randomIsomorphism = self.state
        piInverse = makeInversePermutationFunction(randomIsomorphism)

        if graphChoice == 1:
            return piInverse
        else:
            f = makePermutationFunction(self.isomorphism)
            return lambda i: f(piInverse(i))
{{< /highlight >}}

The prover has two methods, one for each round of the protocol. The first creates an isomorphic copy of $G_1$, and the second receives the challenge and produces the requested isomorphism.

And here's the corresponding class for the verifier

{{< highlight python >}}
class Verifier(object):
    def __init__(self, G1, G2):
        self.G1 = G1
        self.G2 = G2
        self.n = numVertices(G1)
        assert self.n == numVertices(G2)

    def chooseGraph(self, H):
        choice = random.choice([1, 2])
        self.state = H, choice
        return choice

    def accepts(self, isomorphism):
        '''
            Return True if and only if the given isomorphism
            is a valid isomorphism between the randomly
            chosen graph in the first step, and the H presented
            by the Prover.
        '''
        H, choice = self.state
        graphToCheck = [self.G1, self.G2][choice - 1]
        f = isomorphism

        isValidIsomorphism = (graphToCheck == applyIsomorphism(H, f))
        return isValidIsomorphism
{{< /highlight >}}

Then the protocol is as follows:

{{< highlight python >}}
def runProtocol(G1, G2, isomorphism):
    p = Prover(G1, G2, isomorphism)
    v = Verifier(G1, G2)

    H = p.sendIsomorphicCopy()
    choice = v.chooseGraph(H)
    witnessIsomorphism = p.proveIsomorphicTo(choice)

    return v.accepts(witnessIsomorphism)
{{< /highlight >}}

**Analysis:** Let's suppose for a moment that everyone is honestly following the rules, and that $G_1, G_2$ are truly isomorphic. Then you'll _always_ accept my claim, because I can always provide you with an isomorphism. Now let's suppose that, actually I'm lying, the two graphs aren't isomorphic, and I'm trying to fool you into thinking they are. What's the probability that you'll rightfully reject my claim?

Well, regardless of what I do, I'm sending you a graph $H$ and you get to make a random choice of $t = 1, 2$ that I can't control. If $H$ is only actually isomorphic to either $G_1$ or $G_2$ but not both, then so long as you make your choice uniformly at random, half of the time I won't be able to produce a valid isomorphism and you'll reject. And unless you can actually tell which graph $H$ is isomorphic to—an open problem, but let's say you can't—then probability 1/2 is the best you can do.

Maybe the probability 1/2 is a bit unsatisfying, but remember that we can amplify this probability by repeating the protocol over and over again. So if you want to be sure I didn't cheat and get lucky to within a probability of one-in-one-trillion, you only need to repeat the protocol 30 times. To be surer than the chance of picking a specific atom at random from all atoms in the universe, only about 400 times.

If you want to feel small, think of the number of atoms in the universe. If you want to feel big, think of its logarithm.

Here's the code that repeats the protocol for assurance.

{{< highlight python >}}
def convinceBeyondDoubt(G1, G2, isomorphism, errorTolerance=1e-20):
    probabilityFooled = 1

    while probabilityFooled &gt; errorTolerance:
        result = runProtocol(G1, G2, isomorphism)
        assert result
        probabilityFooled *= 0.5
        print(probabilityFooled)
{{< /highlight >}}

Running it, we see it succeeds

{{< highlight python >}}
$ python graph-isomorphism.py
0.5
0.25
0.125
0.0625
0.03125
 ...
&amp;lt;SNIP&amp;gt;
 ...
1.3552527156068805e-20
6.776263578034403e-21
{{< /highlight >}}

So it's clear that this protocol is convincing.

But how can we be sure that there's no leakage of knowledge in the protocol? What does "leakage" even mean? That's where this topic is the most difficult to nail down rigorously, in part because there are at least three a priori _different_ definitions! The idea we want to capture is that anything that you can efficiently compute after the protocol finishes (i.e., you have the content of the messages sent to you by the prover) you could have computed efficiently given _only_ the two graphs $G_1, G_2$, and the claim that they are isomorphic.

Another way to say it is that you may go through the verification process and feel happy and confident that the two graphs are isomorphic. But because it's a zero-knowledge proof, you can't _do_ anything with that information more than you could have done if you just took the assertion on blind faith. I'm confident there's a joke about religion lurking here somewhere, but I'll just trust it's funny and move on.

In the next post we'll expand on this "leakage" notion, but before we get there it should be clear that the graph isomorphism protocol will have the strongest possible "no-leakage" property we can come up with. Indeed, in the first round the prover sends a uniform random isomorphic copy of $G_1$ to the verifier, but the verifier can compute such an isomorphism already without the help of the prover. The verifier can't necessarily _find_ the isomorphism that the prover used _in retrospect_, because the verifier can't solve graph isomorphism. Instead, the point is that the probability space of "$G_1$ paired with an $H$ made by the prover" and the probability space of "$G_1$ paired with $H$ as made by the verifier" are equal. No information was leaked by the prover.

For the second round, again the permutation $\pi$ used by the prover to generate $H$ is uniformly random. Since composing a fixed permutation with a uniform random permutation also results in a uniform random permutation, the second message sent by the prover is uniformly random, and so again the verifier could have constructed a similarly random permutation alone.

Let's make this explicit with a small program. We have the honest protocol from before, but now I'm returning the set of messages sent by the prover, which the verifier can use for additional computation.

{{< highlight python >}}
def messagesFromProtocol(G1, G2, isomorphism):
    p = Prover(G1, G2, isomorphism)
    v = Verifier(G1, G2)

    H = p.sendIsomorphicCopy()
    choice = v.chooseGraph(H)
    witnessIsomorphism = p.proveIsomorphicTo(choice)

    return [H, choice, witnessIsomorphism]
{{< /highlight >}}

To say that the protocol is zero-knowledge (again, this is still colloquial) is to say that anything that the verifier could compute, given as input the return value of this function along with $G_1, G_2$ and the claim that they're isomorphic, the verifier could also compute given only $G_1, G_2$ and the claim that $G_1, G_2$ are isomorphic.

It's easy to prove this, and we'll do so with a python function called `simulateProtocol.`

{{< highlight python >}}
def simulateProtocol(G1, G2):
    # Construct data drawn from the same distribution as what is
    # returned by messagesFromProtocol
    choice = random.choice([1, 2])
    G = [G1, G2][choice - 1]
    n = numVertices(G)

    isomorphism = randomPermutation(n)
    pi = makePermutationFunction(isomorphism)
    H = applyIsomorphism(G, pi)

    return H, choice, pi
{{< /highlight >}}

The claim is that the distribution of outputs to `messagesFromProtocol` and `simulateProtocol` are _equal._ But `simulateProtocol` will work regardless of whether $G_1, G_2$ are isomorphic. Of course, it's not convincing to the verifier because the simulating function made the choices in the wrong order, choosing the graph index before making $H$. But the distribution that results is the same either way.

So if you were to use the actual Prover/Verifier protocol outputs as input to another algorithm (say, one which tries to compute an isomorphism of $G_1 \to G_2$), you might as well use the output of your simulator instead. You'd have no information beyond hard-coding the assumption that $G_1, G_2$ are isomorphic into your program. Which, as I mentioned earlier, is no help at all.

In this post we covered one detailed example of a zero-knowledge proof. [Next time](http://jeremykun.com/2016/08/01/zero-knowledge-proofs-for-np/) we'll broaden our view and see the more general power of zero-knowledge (that it captures all of NP), and see some specific cryptographic applications. Keep in mind the preceding discussion, because we're going to re-use the terms "prover," "verifier," and "simulator" to mean roughly the same things as the classes `Prover, Verifier` and the function `simulateProtocol`.

Until then!
