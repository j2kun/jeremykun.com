---
author: jeremykun
date: 2011-07-04 23:35:44+00:00
draft: false
title: Turing Machines - A Primer
type: post
url: /2011/07/04/turing-machines-a-primer/
categories:
- Algorithms
- Logic
- Primers
- Set Theory
tags:
- acceptance
- computability theory
- decidability
- halting problem
- mathematics
- primer
- turing machines
---

_We assume the reader is familiar with the concepts of determinism and finite automata, or has read [the corresponding primer](http://jeremykun.wordpress.com/2011/07/02/determinism-and-finite-automata-a-primer/) on this blog._

## The Mother of All Computers

Last time we saw some models for computation, and saw in turn how limited they were. Now, we open Pandrora's hard drive:

**Definition**: A _Turing machine_ is a tuple $(S, \Gamma, \Sigma, s_0, F, \tau)$, where

	  * $S$ is a set of states,
	  * $\Gamma$ is a set of _tape symbols_, including a special _blank symbol_ $b$,
	  * $\Sigma \subset \Gamma$ is a set of input symbols, not including $b$,
	  * $s_0$ is the initial state,
	  * $A \subset S$ is a set of accepting states,
	  * $R \subset S$ is a set of rejecting states,
	  * $\tau: S - (A \cup R) \times \Gamma \to S \times \Gamma \times \left \{ L, R \right \}$ is a partial function called the _transition function_, where $L, R$ correspond to "left shift" and "right shift," respectively.

There are a few extra components we must address to clearly see how a Turing machine operates. First, the Turing machine has a _tape_ of cells, infinite in length, upon which the machine may read and write letters from $\Gamma$. The process of reading a letter, analogous to our encounter with pushdown automata, is encapsulated in the $\Gamma$ component of the domain of $\tau$. In other words, this machine no longer is "fed" input in sequence. Rather, input is initially written to the tape, and the Turing machine receives this input by reading the tape. The rest of the tape (the complement of the finitely many cells containing input) is filled with $b$. Similarly, the process of writing to the tape is encapsulated in the $\Gamma$ component of the codomain of $\tau$.

The "shifting" part of $\tau$ requires another explanation. First, we restrict the Turing machine to being able to see only one cell of the tape at a time. In order to better visualize this, we invent a _read-write head_ for the machine, which can by construction only process one cell at a time. Hence, the sequence of state transition goes: read a symbol from the cell currently under the read-write head, transition from one state to another, write a symbol to the same cell, then shift the read-write head one cell to the left or right.

Finally, we only allow entry into an accept or reject state. Once the machine enters one such state, it halts and outputs its respective determination.

Now, we could provide a detailed example of a Turing machine, with every aspect of the above definition accounted for. However, that is an unnecessarily bloated endeavor, and we leave such obsequiousness to [Wikipedia](http://en.wikipedia.org/wiki/Turing_machine#Examples_of_Turing_machines), instead focusing on the bigger picture at hand. We gratefully take the liberty to stand on the lemma-encrusted shoulders of giants, and simply describe algorithms that are provably encodable on a Turing machine. The nature of permissible algorithms will become clearer as we give more examples.

## The Halting Problem

We now find ourselves capable of performing a very important new operation: infinitely looping. Specifically, it is not hard to design a Turing machine which never enters an accepting or rejecting state. Simply have one non-accept/reject state, $s$, and if we are in state $s$, shift left and write a 1. Despite having a finite input, this operation will never cease, nor will it ever be in the same configuration twice. This was never possible with a DFA, NFA, or PDA, because computation always ended with the last input symbol!

We require some new terminology to deal with this:

**Definition**: If a Turing machine halts on a given input, either accepting or rejecting, then it _decides_ the input. We call an acceptance problem _decidable_ if there exists some Turing machine that halts on every input for that problem. If no such Turing machine exists, we call the problem _undecidable_ over the class of Turing machines.

In particular, we may describe our algorithms as vaguely as we wish, as long as it is clear that each step is provably decidable. Further, we may now write algorithms which loop over some decidable condition:

    
    while the number of '1's on the tape is even:
       move the head to a blank cell
       write 'x' to the tape
    
    accept

Notice that the above algorithm halts if and only if the tape begins with an odd number of '1's written to it, and it never rejects.

Now we are threatened with a very dangerous question: how can we know a Turing machine will halt, accepting or rejecting appropriately? Rather than tackle this hard question, we will use it to our advantage to prove some amazing things. But first, we need to build up more machinery.

A Turing machine may additionally simulate storage: it may box off arbitrarily large portions of the tape to contain data we wish to save, including bounded numbers, characters (or numerical representations of characters), and larger compound data structures.

Finally, and this requires a small leap of faith, we may encode within a Turing machine descriptions of other Turing machines, and then process them. Indeed, we must accept that these descriptions are finite, for any Turing machine with infinite description would be effectively useless. Then, we may develop some fixed process for encoding a Turing machine as a string of 1's and 0's (say, a collapsed table of its state transitions). This is a function from the set of Turing machines to the set of descriptions, and we denote the encoding of $T$ as $[T]$.

Before actually using Turing machines as inputs to other Turing machine, we glean some important information about encodings. Since the set of finite strings (encodings) over any fixed alphabet is countable, we conclude that there are only countably many possible Turing machines. However, the set of subsets (possibly infinite) of the same fixed alphabet is uncountably large. Since every Turing machine can only decide one problem, there must exist uncountably many problems which are undecidable by the class Turing machines! Now, if we really wish, we may encode Turing machines by a single natural number, with respect to a fixed bijection with $\mathbb{N}$. For a refresher on countability and uncountability, see [our primer on the subject](http://jeremykun.wordpress.com/2011/07/09/set-theory-a-primer/).

Since we may encode the logic of one Turing machine, say $T$, within another, say $U$ we may use the tape and head of $U$ to simulate $T$ on a given input! We leave it as an exercise to the reader to figure out how to manage the tape when it must contain an encoding of $T$ and still simulate the tape of $T$. We call $U$ a _universal Turing machine_, or UTM. Now we see that Turing machines can reason about other Turing machines. Brilliant!

But now that we've established the existence of undecidable problems, we are given the task of finding one. We do so by construction, and arrive at the famous _halting problem_.

We denote an encoding of a Turing machine $T$ and an input $w$ to $T$ together as a pair $[T,w]$. Then, we construct the set of halting machine-input pairs:

$H = \left \{ [T,w] | T \textup{ is a Turing machine, } w \textup{ is an input to } T, \textup{ and } T \textup{ halts on } w \right \}$

We conjecture that this problem is undecidable, and prove it so by contradiction. _Proof_. Suppose $U$ is a Turing machine which decides acceptance in $H$. Construct another Turing machine $V$ as follows.

    
    On input [T] (T is a Turing machine):
       run U on [T,T]
       if U rejects, accept
       if U accepts, loop infinitely

Before the crux of the proof, let us recall that $U$ simply determines whether $T$ halts on an input. Then, when we run $V$ on $[T]$, we have the sub-computation of deciding whether $T$ halts when run on its own description. In this case, $V$ accepts when $T$ loops infinitely when run on itself, and $V$ loops infinitely otherwise.

Now (the magic!) run $V$ on $[V]$. If $V$ accepts, that means $V$, when run on itself, does not halt (i.e. $U$ rejects $[V,V]$), a contradiction. On the other hand, if $V$ loops infinitely, then $U$ rejects $[V,V]$, implying $V$ accepts, a contradiction.

Thus, we have proven that $V$ both halts and does not halt when run on itself! This glaring contradiction implies that $V$ cannot exist. But we built $V$ up from $U$ without logical error, so we conclude that $U$ cannot exist, and the theorem is proved.

## Wrapping Up

The theory of computing goes much further than the halting problem. Indeed, most undecidable problems are proven so by reducing them to the halting problem (if one can decide problem $X$ then one can decide the halting problem, a contradiction). But beyond decidability, there is a large field of study in computational efficiency, in which all studied algorithms are run on a Turing machine. Further, studies of complexity and alternative computational models abound, including a persistent problem of classifying "how hard" problems are to compute. The interested reader should Google "P vs. NP" for more information. Unfortunately, an adequate description of the various time classes and problems therein is beyond the scope of this blog. All we require is a working knowledge of the terminology used in speaking of Turing machines, and an idea of what kinds of algorithms can be implemented on one.

That's all for now!
