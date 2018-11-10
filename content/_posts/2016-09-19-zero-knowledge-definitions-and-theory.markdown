---
author: jeremykun
date: 2016-09-19 16:00:00+00:00
draft: false
title: 'Zero-Knowledge: Definitions and Theory'
type: post
url: /2016/09/19/zero-knowledge-definitions-and-theory/
categories:
- General
---

<blockquote>_The next Monday, when the fathers were all back at work, we kids were playing in a field. One kid says to me, “See that bird? What kind of bird is that?” I said, “I haven’t the slightest idea what kind of a bird it is.” He says, “It’s a brown-throated thrush. Your father doesn’t teach you anything!” But it was the opposite. He had already taught me: “See that bird?” he says. “It’s a Spencer’s warbler.” (I knew he didn’t know the real name.) “Well, in Italian, it’s a Chutto Lapittida. In Portuguese, it’s a Bom da Peida. In Chinese, it’s a Chung-long-tah, and in Japanese, it’s a Katano Tekeda. You can know the name of that bird in all the languages of the world, but when you’re finished, you’ll know absolutely nothing whatever about the bird. You’ll only know about humans in different places, and what they call the bird. So let’s look at the bird and see what it’s doing—that’s what counts.” I learned very early the difference between knowing the name of something and knowing something._</blockquote>

In the [first post in this series](http://jeremykun.com/2016/07/05/zero-knowledge-proofs-a-primer/), we defined and implemented a simple zero-knowledge proof for graph isomorphism. In [the second post](http://jeremykun.com/2016/08/01/zero-knowledge-proofs-for-np/), we saw a different protocol with a much heftier tagline: it gives a zero knowledge proof for any problem in the class NP. These two protocols used the same underlying framework—an interaction between a prover and a verifier—but they were actually very different.

Indeed, the graph isomorphism proof was "perfect" in two senses. First, it didn't require any assumptions about cryptography. Nobody knows how to prove the Blum-Blum-Shub function is actually a one-way permutation (at the least, this would imply $\textup{P} \neq \textup{NP}$, so it's probably hard to prove).

Second, in the graph isomorphism proof, the simulator produced transcripts of the protocol that came from the _exact_ same distribution as the true transcripts created by the prover and verifier. This is why we called it zero-knowledge; anything the verifier can do with the output of the protocol, the simulator could do too. The verifier can't be making use of the prover's secret knowledge, since that information isn't even in the simulator's universe but the simulator can still compute what the verifier can.

But I didn't tell you precisely why the 3-coloring protocol is a zero-knowledge proof, and in particular why it's different from the graph isomorphism protocol. I also hinted that I had been misleading you, dear reader, as to the full 3-coloring proof of zero-knowledge. So in this post we'll get into those nitty-gritty definitions that make the math rigorous. We'll give a short sketch of the proof of zero-knowledge (the full proof would take many pages, not because it's hard but because there are a lot of annoying details). And then we'll give an overview of the landscape of theorems and conjectures about zero knowledge.

## Information vs. knowledge

You can't understand where the following definitions come from without the crucial distinction between _information_ and _knowledge_ from the computer scientist's perspective. _Information_ concerns how many essential bits are encoded in a message, and nothing more. In particular, information is not the same as _computational complexity_, the required amount of computational resources required to actually do something. _Knowledge,_ on the other hand, refers to the computational abilities you gain with the information provided.

Here's an example in layman's terms: say I give you a zero-knowledge proof that cancer can be cured using a treatment that takes only five days. Even though I might thoroughly convince you my cure works by exhibiting patients with vanishing tumors, you'll still struggle to _find_ a cure. This is despite the fact that there might be _more_ bits of information relayed in the messages sent during my "zero-knowledge proof" than the number of bits needed to describe the cure! On the other hand, every proof that 1+1=2 is a zero-knowledge proof, because it's not computationally difficult to prove this on your own in the first place. You don't gain any new computational powers even if I tell you flat out what the proof is.

Knowledge is Richard Feynman's worldview, information is knowing the many names for a bird.

From this perspective information theory is abstruse, though it's [much easier to prove theoretical limits](http://jeremykun.com/2015/02/16/a-proofless-introduction-to-information-theory/) on computation in terms of information theory than in terms of computational complexity. However, the theoretical limits of computation are _lower_ that the limits of information theory, which is the essence of what enables cryptography (from an information theory standpoint, all public-key cryptography is broken!). Reframing what's possible in terms of computation opens a treasure chest of useful algorithms.

From here we'll explore three definitions of zero-knowledge. First, we'll see "perfect" zero knowledge, which is believed to be too strong to be practical. We'll give a sketch of the "right" proof that graph isomorphism has a perfect zero-knowledge proof. Then we'll see two relaxations to "statistical" and "computational" zero knowledge. We'll discuss their theoretical relationships to each other and the rest of the world from a high level.

## Perfect zero-knowledge

Recall from our [first post](http://jeremykun.com/2016/07/05/zero-knowledge-proofs-a-primer/), the interactive protocol for graph isomorphism has a very nice property. Say you took all the messages sent back and forth between the prover and verifier, and say you think of those messages as a random outcome of a probabilistic event. Then a simulator could have produced a set of messages drawn from the _same_ distribution, without needing to see the messages from the protocol in the first place! So anything that the verifier could compute as a result of participating in the protocol, the simulator could compute without needing the protocol in the first place. The simulator just needs to assume the truth of the claim. This type of zero-knowledge is called _perfect_ zero-knowledge.

Let's distill this into some notation. In order to do this, we'll shift to the theoretical way of discussing a "problem" as a _language_, i.e., a set of strings. For example, for 3-coloring you fix a method for describing graphs as strings (it doesn't really matter which method you use), and the language is the set of strings

$\displaystyle \{ G : G \textup{ has a valid 3-coloring } \}$

Membership in the set is the same as saying an instance of the problem "does $G$ have a 3-coloring?" has a yes answer. Throughout the entire discussion we will fix a generic way to encode any object as a binary string, and we'll implicitly equate $G$ with the string representing $G$, and call them both $G$. In this post I'll always use $L$ for a language.

Now say that $P$ is an algorithm for the prover (a probabilistic Turing machine of arbitrary complexity), $V$ is the analogous polynomial-time algorithm for the verifier, and $M(P,V)$ is the resulting concatenated string of messages from one run of a zero-knowledge proof. Because $P$ and $V$ may be randomized, $M(P,V)$ is a distribution over strings $\{ 0, 1\}^m$, and one run of the protocol is equivalent to drawing $y \sim \{0,1\}^m$ according to this distribution. This just means: run an instance of the the protocol, which is random, and encode the output messages as a single string.

Now define a _simulator_ as any probabilistic polynomial-time turing machine $S$. We interpret the simulator as trying to reproduce the output of the protocol without having access to the protocol's messages, but with computational limits. The prover, verifier, and simulator all take as input the claim $x$ of length $n$, and the verifier and simulator run in time polynomial in $n$. Reminder: in order to be an interactive proof for the language $L$, if $x \in L$ then the verifier must be convinced with probability $1$, and if $x \not \in L$ then the verifier must reject with probability at least $1/2$.

**Definition (not quite correct): **An interactive proof $M(P,V)$ for a language $L$ is said to have _perfect zero-knowledge_ if some simulator $S$ exists such that for every input $x \in L$, the distributions of the random variables $M(P,V)(x)$ and $S(x)$ are equal.

This definition isn't quite correct, but it's correct in spirit so that's why we used it in our first post. Now let's see a bit more detail about what _really_ makes a zero-knowledge proof. Let's remind ourselves of the argument for graph isomorphism, and then see why it's not strong enough. The protocol we described is summed up as: prover has $G_1, G_2$, and sends a random permutation of $G_1$ to the verifier, calls it $H$. The verifier picks a random integer $k$ which is either 1 or 2, sends it the prover. The prover produces an isomorphism between $G_k$ and $H$, and sends the isomorphism back to the verifier, who checks to make sure the isomorphism is valid and accepts (otherwise, rejects).

In our argument, we said the simulator could simulate messages by picking $k$ for the verifier _before_ choosing the random permutation $H$, and this is the nit we need to pick. The problem is that the prover doesn't trust the verifier, but the simulator _does_ trust the verifier, and performs actions for the verifier that are faithful to the protocol!

What if a naughty verifier were able to glean more information by misbehaving in the protocol? Say, instead of randomly choosing $k$ as 1 or 2, the verifier might always just pick $k=1$. Could such a misbehavior give the verifier _more knowledge_ than strictly following the protocol?

Sure, maybe if the verifier did that, he wouldn't end up with a valid proof (his acceptances and rejections may not be valid or sound), but it might be worth it if he can get a small bit of information about the hidden isomorphism. The goal is to treat the verifier like a hacker, but our simulator only simulates honest verifiers.

So a _real_ zero-knowledge proof needs to account for a misbehaving verifier. One way to do this is to give the simulator black-box access to the verifier $V$, and prove that the distribution of messages produced by the simulator $S(V, x)$ is equal to the true distribution of messages produced in the actual protocol with the same (possibly misbehaving) verifier, $M(P,V)(x)$. Note that $S$ can still know about the protocol that $V$ is _supposed_ to follow, but he can't know exactly how $V$ is defined.

Unfortunately, there is no known zero-knowledge proof for a nontrivial problem that satisfies this stronger criterion for _perfect_ zero knowledge, and the graph isomorphism proof in particular doesn't satisfy it. The way to fix it, which I'll just say informally, is to **allow the simulator to fail with probability at most 1/2**. So to summarize, the simulator gets black-box access to the verifier and is guaranteed an input $x \in L$, and has to sample from the exact distribution of messages as the real protocol, _but _the simulator is allowed to say "KAPUT!" at most half the time, when it thinks the output will be bad. The distribution of simulator outputs (conditioned on no-KAPUT) should be equal to the true distribution of outputs.

Now we can sketch the real graph isomorphism proof. The simulator is defined as follows:

	  1. Pick $i \in \{ 1, 2 \}$ randomly and let $H$ be a random permutation of $G_i$.
	  2. Invoke the verifier $V(H)$ as a subroutine with input $H$, and call the output $k$, which is either 1 or 2.
	  3. If $k \neq i$, output "KAPUT!", otherwise invoke $V$ as a subroutine with the isomorphism $H \to G_i$ as input.

Now to show the message distributions are equal. The message sent in step 2 is produced with a different process from the actual zero knowledge protocol (since the prover just takes a random isomorphic copy of $G_1$), but since we know $G_1, G_2$ are isomorphic, the distribution over $H$ is the same in both cases.

Now when we invoke the verifier subroutine, we can't know what the verifier will choose. But the point is that regardless of what the verifier does, there's still a 50% chance it will pick $k=i$ since we chose $i$ randomly and independently of the definition of $V$.

If you ignore that we need to prove a few probability-theory facts (like that the choice of $H$ really is uniformly random), then this completes the proof.

$\square$

## Statistical and computational zero-knowledge

While perfect zero-knowledge is the strongest form of zero-knowledge, it's believed to be too strong. A more tractable definition is called _statistical_ zero-knowledge, and for this we relax the requirement that the message distributions are equal to the requirement that they're "very similar." Informally, by "very similar" I mean that if the output strings have length $m$, then the sum of the differences of the probabilities is "basically" exponentially small in $m$.

More formally, if $D_1, D_2$ are two distributions over $\{0,1\}^m$, then we say they're _statistically close_ if the following distance function vanishes (asymptotically in $m$) faster than $1/m^c$ for any $c > 0$.

$\displaystyle d(D_1, D_2) = \sum_{x \in \{0,1\}^m} \left | \Pr_{y \sim D_1}[y=x] - \Pr_{y \sim D_2}[y=x] \right |$

This distance function just sums, for every outcome, the difference between the probabilities of those outcomes. In other words, being statistically close means that the two distributions can't disagree on any particular input too much, nor can they disagree on most the outputs more than a tiny bit.

In little-o notation, statistically close means $d(D_1, D_2) = o(1/m^c)$ for every constant $c > 0$. It could be like $2^{-m}$ or something vanishing much slower like $1/m^{\log \log m}$. A function of $m$ which has this property is called _negligible,_ and it's the standard choice of a security guarantee for cryptography.

**Definition:** Using the same notation as perfect zero-knowledge, an interactive proof is said to have _statistical zero-knowledge_ if there is a simulator such that for every input $x \in L$, the distributions of $M(P,V)(x)$ and $S(x)$ are statistically close.

Interestingly, for this definition and the next (computational zero-knowledge), giving the simulator the power to output KAPUT with probability 1/2 doesn't add any power. It turns out that any KAPUTful simulator can be transformed into a KAPUTless simulator with polynomial overhead. A sketch of how this works: run the simulator until either it does not KAPUT, or else you've tried $n^2$ times with all KAPUTs. The latter event happens with exponentially small probability, so in that case the KAPUTless simulator outputs a uniformly random string (it's a "don't care"). This maintains statistical closeness (and, as we'll see, computational indistinguishability).

Finally, the weakest form of zero-knowledge isn't so much a property of the two message distributions, but a property of a computationally limited algorithm _trying to distinguish_ between them. We model this by having a probabilistic polynomial-time algorithm $A$ which accepts as input the ability to draw from a distribution, and $A$ produces as output a single bit. We interpret this bit as $A$'s claim that the two distributions are "_different._" $A$'s goal is to answer correctly. If $A$ can do that with non-negligible probability, then $A$ wins and "distinguishes" between the two input distributions. So we'll call $A$ the _distinguisher._  Note that $A$ can do things like draw a $\textup{poly}(m)$ number of samples and do any polynomial-time computation with those samples.

**Definition: **An interactive proof $M(P,V)$ is said to have _computational zero-knowledge_ if there is a simulator $S$ such that for every input $x$, and for every probabilistic polynomial-time algorithm $A$, the following probability is negligible.

$\displaystyle \Pr[A(M(P,V)(x)) \neq A(S(x))]$

In words, $A$ fails to distinguish between $M(P,V)(x)$ and $S(x)$ with a significant (non-negligible) edge over random guessing. Another way to say it is that the distributions $A(M(P,V)(x))$ and $A(S(x))$ are statistically close. So the simulator can't necessarily produce a statistically close distribution on messages, but the simulator _can_ produce a distribution that fools a computationally limited observer.

If general, two distributions $D_1, D_2$ are called _computationally indistinguishable_ if they don't have a distinguisher. I.e., no polynomial-time adversary can distinguish between them with non-negligible probability, in the same way we described above.

So our landscape consists of three classes of problems nested as follows:

Perfect ZK $\subset $ statistical ZK $\subset$ Computational ZK

An interesting question we'll discuss by towards the end of this post is whether these classes of problems are actually different.

## Back to 3-coloring

This computational distinguishing property shows up all over cryptography. The reason is simple: almost all cryptographic hardness assumptions can be rephrased as the computational indistinguishability properties. The hardness of one-way functions, predicting pseudorandom generators, all of it is the inability of a polynomial-time adversary to solve a problem.

From this perspective, we can already see why it should be obvious that the zero-knowledge proof for 3-coloring has computational zero knowledge: we used crypto to commit to a coloring, and revealed the secret key later. If the verifier could break the zero-knowledge aspect, then they could defeat the underlying cryptographic primitive. The formal proof of computational zero-knowledge is a drawn-out, detail-oriented quest to entrench this idea in formalism and fit the simulator definition.

Nevertheless, it's interesting to see where precisely the assumption makes its way into the simulator. Reminder of the protocol:

	  1. The prover has a 3-coloring, and publicly commits to a random permutation of that coloring, sends it to the verifier.
	  2. The verifier picks an edge uniformly at random, sends it to the prover.
	  3. The prover reveals the colors for that edge, sends them to the verifier.
	  4. The verifier checks that the revealed colors were indeed the ones committed to, and accepts if they are different colors.

Here's the graph 3-coloring simulator, which involves some KAPUTing:

	  1. Pick $n$ colors $c_1, \dots, c_n \in \{ 1,2,3 \}$ uniformly at random. Commit to these as the "coloring."
	  2. Invoke the verifier with the committed "coloring" as input, and receive an edge $(i,j)$ as output.
	  3. If $c_i = c_j$, KAPUT, else, run the verifier as a subroutine with the true $c_i, c_j$.

Note that if an honest verifier picks the edge randomly, then it will be properly colored with probability $2/3$, and the simulator wins.

A dishonest verifier is trickier, because it gets access to the entire committed coloring. A priori there might be a devious way to select a bad edge. So let's suppose for the sake of contradiction that the verifier has a method for choosing an improperly colored edge. While it takes a few steps to get here (and a lot more detail), in the end this means that the verifier can determine, with probability better at least $\frac{1}{3} + \frac{1}{n^c}$ for some constant $c$, the difference between a commitment of the bit zero and a commitment of the bit one.

In other words, we can _use_ a verifier that breaks zero-knowledge of this protocol as a bit-commitment-scheme breaker! But the verifier is a probabilistic polynomial-time algorithm, which contradicts the security assumption of a bit-commitment scheme.

Actually, I don't think I ever formally said what the security assumption for a bit commitment scheme is, since in the previous posts I hadn't provided the definition of computational indistinguishability. So here it is: a bit-commitment scheme, which is defined by a one-way permutation $G$ with a hard-core predicate $f$, maps $b \mapsto (G(x), f(x) \oplus b)$ and has the property that the distributions committing to zero and one are computationally indistinguishable. That is, the following two distributions:

$\textup{commit}_n(0) = \{ (G(x), f(x) \oplus 0): x \in \{ 0,1 \}^n \}$

$\textup{commit}_n(1) = \{ (G(x), f(x) \oplus 1): x \in \{ 0,1 \}^n \}$

So the verifier can pick a bad edge with probability as most $1/3 + \textup{negligible}$, which is far less than 1/2. Then you can use the trick we showed earlier to get a good enough simulator that never KAPUTs. And that proves computational zero-knowledge.

## Theorems and limitations

Here's an interesting theorem:

**Theorem: **Any zero-knowledge protocol which doesn't use randomization (on both sides) can be solved in randomized polynomial time (is in BPP).

So the random choices made by the prover/verifier are actually essential to the novelty of this concept.

I haven't yet said anything about statistical zero-knowledge beyond the definition. It turns out there are a lot of interesting problems with statistical zero-knowledge proofs. I should really expand the discussion of statistical zero knowledge into its own post, but I want to wrap up this series and explore some other projects.

One such problem is pretty meta: the problem of telling whether two distributions are statistically close. In fact, this problem is _[complete](http://web.cs.ucla.edu/~sahai/work/web/2003%20Publications/J.ACM2003.pdf)_ for the class of problems with statistical zero-knowledge proofs, in the same sense that 3-coloring is NP-complete; any problem which has a statistical zero-knowledge proof can be reduced to a question about statistical closeness of two _specific_ distributions. The class of problems with statistical zero-knowledge proofs is usually shortened to SZK (along with PZK for perfect zero-knowledge and CZK for computational zero-knowledge).

In addition to being interesting from a theoretical perspective, it's a very practical question to study: if you can sample from a distribution efficiently, which properties of that distribution can you estimate efficiently? The completeness result says that the inherent complexity of this class of problems is captured by statistical zero-knowledge proofs.

As a theoretical object of study, SZK has massive advantages over perfect/computational zero-knowledge. In particular,

**Theorem: **Every interactive proof that has statistical zero-knowledge against an honest verifier can be transformed into a statistical zero-knowledge proof against an arbitrary adversary.

So the entire "gotcha" content of this post, which we had to worry about with perfect zero-knowledge, doesn't exist for statistical zero-knowledge. It still exists for computational zero-knowledge, as far as I know, because it's not know that every computational zero-knowledge proof also has statistical zero-knowledge (a stronger property).

On another front, people are relatively convinced that perfect zero-knowledge is too restrictive to be useful. This comes from the following theorem [due to Fortnow](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.42.5483&rep=rep1&type=pdf)

**Theorem:** If an NP-complete problem has a statistical zero-knowledge proof, then the [polynomial hierarchy](https://en.wikipedia.org/wiki/Polynomial_hierarchy) collapses.

Without going into detail about what the polynomial hierarchy is, suffice it to say that most people believe it's unlikely. And because this means that SZK probably does not contain all of NP, we can ask natural followup questions like, can problems in SZK be solved by polynomial-time _quantum_ algorithms? It's also open whether these can solve NP-complete problems.

Statistical zero-knowledge can be specialized even further.

**Theorem: **Every problem with a statistical zero-knowledge proof has a statistical zero-knowledge proof in which the _only_ messages the verifier sends are random coin flips.

This is a so-called "public coin" protocol, which makes zero-knowledge proofs much easier to reason about.

For further reading, see this introduction by [Salil Vadhan](http://people.seas.harvard.edu/~salil/research/complexityZK.pdf), arguably the world's leading expert on the topic. Particularly interesting is sections 3-5 in which Vadhan describes more detail about how zero-knowledge has been used as an "interface" for techniques to pass between complexity theory and cryptography.

For further reading with on the excruciating details of the definitions and proofs presented in this series, see Oded Goldreich's _[Foundations of Cryptography](http://www.wisdom.weizmann.ac.il/~oded/foc-vol1.html) (_Volume I, Chapter 4). I have mixed feelings about this book because, despite the fact that I've found it enlightening, the book somehow manages to be simultaneously dense and scattered. It leaves no snag unsmoothed, for better or worse.

Until next time!
