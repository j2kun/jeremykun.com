---
author: jeremykun
date: 2015-01-26 15:00:00+00:00
draft: false
title: Multiple Qubits and the Quantum Circuit
type: post
url: /2015/01/26/multiple-qubits-and-the-quantum-circuit/
categories:
- Linear Algebra
- Quantum
tags:
- circuits
- entanglement
- linear algebra
- quantum computing
- tensor product
- tensors
---

[Last time](http://jeremykun.com/2014/12/15/the-quantum-bit/) we left off with the tantalizing question: how do you do a quantum "AND" operation on two qubits? In this post we'll see why the tensor product is the natural mathematical way to represent the joint state of multiple qubits. Then we'll define some basic quantum gates, and present the definition of a quantum circuit.

## Working with Multiple Qubits

In a classical system, if you have two bits with values $b_1, b_2$, then the "joint state" of the two bits is given by the concatenated string $b_1b_2$. But if we have two qubits $v, w$, which are vectors in $\mathbb{C}^2$, how do we represent their joint state?

There are seemingly infinitely many things we could try, but let's entertain the simplest idea for the sake of exercising our linear algebra intuition. The simplest idea is to just "concatenate" the vectors as one does in linear algebra: represent the joint system as $(v, w) \in \mathbb{C}^2 \oplus \mathbb{C}^2$. Recall that the _direct sum_ of two vector spaces is just what you'd want out of "concatenation" of vectors. It treats the two components as completely independent of each other, and there's an easy way to take any vector in the sum and decompose it into two vectors in the pieces.

Why does this fail to meet our requirements of qubits? Here's one reason: $(v, w)$ is not a unit vector when $v$ and $w$ are separately unit vectors. Indeed, $\left \| (v,w) \right \|^2 = \left \| v \right \|^2 + \left \| w \right \|^2 = 2$. We could normalize everything, and that would work for a while, but we would still run into problems. A better reason is that direct sums screw up measurement. In particular, if you have two qubits (and they're independent, in a sense we'll make clear later), you should be able to measure one without affecting the other. But if we use the direct sum method for combining qubits, then measuring one qubit would collapse the other! There are times when we want this to happen, but we don't _always_ want it to happen. Alas, there should be better reasons out there (besides, "physics says so") but I haven't come across them yet.

So the nice mathematical alternative is to make the joint state of two qubits $v,w$ the _tensor product_ $v \otimes w$. For a review of the basic properties of tensors and multilinear maps, see [our post on the subject](http://jeremykun.com/2014/01/17/how-to-conquer-tensorphobia/). Suffice it for now to remind the reader that the basis of the tensor space $U \otimes V$ consists of all the tensors of the basis elements of the pieces $U$ and $V$: $u_i \otimes v_j$. As such, the dimension of $U \otimes V$ is the product of the dimensions $\text{dim}(U) \text{dim}(V)$.

As a consequence of this and the fact that all $\mathbb{C}$-vector spaces of the same dimension are the same (isomorphic), the state space of a set of $n$ qubits can be identified with $\mathbb{C}^{2^n}$. This is one way to see why quantum computing has the potential to be strictly more powerful than classical computing: $n$ qubits provide a state space with $2^n$ coefficients, each of which is a complex number. With classical probabilistic computing we only get $n$ "coefficients." This isn't a proof that quantum computing is more powerful, but a wink and a nudge that it could be.

While most of the time we'll just write our states in terms of tensors (using the $\otimes$ symbol), we could write out the vector representation of $v \otimes w$ in terms of the vectors $v = (v_1, v_2), w=(w_1, w_2)$. It's just $(v_1w_1, v_1w_2, v_2w_1, v_2w_2)$, with the obvious generalization to vectors of any dimension. This already fixes our earlier problem with norms: the norm of a tensor of two vectors is the _product_ of the two norms. So tensors of unit vectors are unit vectors. Moreover, if you measure the first qubit, that just sets the $v_1, v_2$ above to zero or one, leaving a joint state that is still a valid

Likewise, given two linear maps $A, B$, we can describe the map $A \otimes B$ on the tensor space both in terms of pure tensors ($(A \otimes B)(v \otimes w) = Av \otimes Bw$) and in terms of a matrix. In the same vein as the representation for vectors, the matrix corresponding to $A \otimes B$ is

$\displaystyle \begin{pmatrix}
a_{1,1}B & a_{1,2}B & \dots & a_{1,n}B \\
a_{2,1}B & a_{2,2}B & \dots & a_{2,n}B \\
\vdots & \vdots & \ddots & \vdots \\
a_{n,1}B & a_{n,2}B & \dots & a_{n,n}B
\end{pmatrix}$

This is called [the Kronecker product](http://en.wikipedia.org/wiki/Kronecker_product).

One of the strange things about tensor products, which very visibly manifests itself in "strange quantum behavior," is that not every vector in a tensor space can be represented as a single tensor product of some vectors. Let's work with an example: $\mathbb{C}^2 \otimes \mathbb{C}^2$, and denote by $e_0, e_1$ the computational basis vectors (the same letters are used for each copy of $\mathbb{C}^2$). Sometimes you'll get a vector like

$\displaystyle v = \frac{1}{\sqrt{2}} e_0 \otimes e_0 + \frac{1}{\sqrt{2}} e_1 \otimes e_0$

And if you're lucky you'll notice that this can be factored and written as $\frac{1}{\sqrt{2}}(e_0 + e_1) \otimes e_0$. Other times, though, you'll get a vector like

$\displaystyle \frac{1}{\sqrt{2}}(e_0 \otimes e_0 + e_1 \otimes e_1)$

And it's a deep fact that this cannot be factored into a tensor product of two vectors (prove it as an exercise). If a vector $v$ in a tensor space _can_ be written as a single tensor product of vectors, we call $v$ a _pure tensor__. _Otherwise, using some physics lingo, we call the state represented by $v$ _entangled. _So if you did the exercise you proved that not all tensors are pure tensors, or equivalently that there exist entangled quantum states. The latter sounds so much more impressive. We'll see in a future post why these entangled states are so important in quantum computing.

Now we need to explain how to extend gates and qubit measurements to state spaces with multiple qubits. The first is easy: just as we often restrict our classical gates to a few bits (like the AND of two bits), we restrict multi-qubit quantum gates to operate on at most three qubits.

**Definition: **A quantum gate $G$ is a unitary map $\mathbb{C}^{2^n} \to \mathbb{C}^{2^n}$ where $n$ is at most 3, (recall, $(\mathbb{C}^2)^{\otimes 3} = \mathbb{C}^{2^3}$ is the state space for 3 qubits).

Now let's see how to implement AND and OR for two qubits. You might be wondering why we need three qubits in the definition above, and, perhaps surprisingly, we'll see that AND and OR require us to work with three qubits.

Because how would one compute an AND of two qubits? Taking a naive approach from how we did the quantum NOT, we would label $e_0$ as "false" and $e_1$ as "true," and we'd want to map $e_1 \otimes e_1 \mapsto e_1$ and all other possibilities to $e_0$. The main problem is that this is not an invertible function! Remember, all quantum operations are unitary matrices and all unitary matrices have inverses, so we have to model AND and OR as an invertible operation. We also have a "type error," since the output is not even in the same vector space as the input, but any way to fix that would still run into the invertibility problem.

The way to deal with this is to add an extra "scratch work" qubit that is used for nothing else except to make the operation invertible. So now say we have three qubits $a, b, c$, and we want to compute $a$ AND $b$ in the sensible way described above. What we do is map

$\displaystyle a \otimes b \otimes c \mapsto a \otimes b \otimes (c \oplus (a \wedge b))$

Here $a \wedge b$ is the usual AND (where we interpret, e.g., $e_1 \wedge e_0 = e_0$), and $\oplus$ is the exclusive or operation on bits. It's clear that this mapping makes sense for "bits" (the true/false interpretation of basis vectors) and so we can extend it to a linear map by writing down the matrix.

[![quantum-AND](https://jeremykun.files.wordpress.com/2014/11/quantum-and.png)
](https://jeremykun.files.wordpress.com/2014/11/quantum-and.png)

This gate is often called the _Toffoli gate_ by physicists, but we'll just call it the (quantum) AND gate. Note that the column $ijk$ represents the input $e_i \otimes e_j \otimes e_k$, and the 1 in that column denotes the row whose label is the output. In particular, if we want to do an AND then we'll ensure the "scratch work" qubit is $e_0$, so we can ignore half the columns above where the third qubit is 1. The reader should write down the analogous construction for a quantum OR.

From now on, when we're describing a basis state like $e_1 \otimes e_0 \otimes e_1$, we'll denote it as $e_{101}$, and more generally when $i$ is a nonnegative integer or a binary string we'll denote the basis state as $e_i$. We're taking advantage of the correspondence between the $2^n$ binary strings and the $2^n$ basis states, and it compactifies notation.

Once we define a quantum circuit, it will be easy to show that using quantum AND's, OR's and NOT's, we can achieve any computation that a classical circuit can.

We have one more issue we'd like to bring up before we define quantum circuits. We're being a bit too slick when we say we're working with "at most three qubits." If we have ten qubits, potentially all entangled up in a weird way, how can we apply a mapping to only some of those qubits? Indeed, we only defined AND for $\mathbb{C}^8$, so how can we extend that to an AND of three qubits sitting inside any $\mathbb{C}^{2^n}$ we please? The answer is to apply the Kronecker product with the identity matrix appropriately. Let's do a simple example of this to make everything stick.

Say I want to apply the quantum NOT gate to a qubit $v$, and I have four other qubits $w_1, w_2, w_3, w_4$ so that they're all in the joint state $x = v \otimes w_1 \otimes w_2 \otimes w_3 \otimes w_4$. I form the NOT gate, which I'll call $A$, and then I apply the gate $A \otimes I_{2^4}$ to $x$ (since there are 4 of the $w_i$). This will compute the tensor $Av \otimes I_2 w_1 \otimes I_2 w_2 \otimes I_2 w_3 \otimes I_2 w_4$, as desired.

In particular, you can represent a gate that depends on only 3 qubits by writing down the 3x3 matrix and the three indices it operates on. Note that this requires only 12 (possibly complex) numbers to write down, and so it takes "constant space" to represent a single gate.

## Quantum Circuits

Here we are at the definition of a quantum circuit.

**Definition: **A _quantum circuit_ is a list $G_1, \dots, G_T$ of $2^m \times 2^m$ unitary matrices, such that each $G_i$ depends on at most 3 qubits.

We'll write down what it means to "compute" something with a quantum circuit, but for now we can imagine drawing it like a usual circuit. We write the input state as some unit vector $x \in C^{2^n}$ (which may or may not be a pure tensor), each qubit making up the vector is associated to a "wire," and at each step we pick three of the wires, send them to the next quantum gate $G_i$, and use the three output wires for further computations. The final output is the matrix product applied to the input $G_T \dots G_1x$. We imagine that each gate takes only one step to compute (recall, in our [first post](http://jeremykun.com/2014/12/08/a-motivation-for-quantum-computing/) one "step" was a photon flying through a special material, so it's not like we have to multiply these matrices by hand).

So now we have to say how a quantum circuit could solve a problem. At all levels of mathematical maturity we should have some idea how a regular circuit solves a problem: there is some distinguished output wire or set of wires containing the answer. For a quantum circuit it's basically the same, except that at the end of the circuit we get a single quantum state (a tensor in this big vector space), and we just measure that state. Like the case of a single qubit, if the vector has coordinates $x = (x_1, \dots, x_{2^n})$, they must satisfy $\sum_i |x_i|^2 = 1$, and the probability of the measurement producing index $j$ is $|x_j|^2$. The result of that measurement is an integer (some classical bits) that represent our answer. As a side effect, the vector $x$ is mutated into the basis state $e_j$. As we've said we may need to repeat a quantum computation over and over to get a good answer with high probability, so we can imagine that a quantum circuit is used as some subroutine in a larger (otherwise classical) algorithm that allows for pre- and post-processing on the quantum part.

The final caveat is that we allow one to include as many scratchwork qubits as one needs in their circuit. This makes it possible already to simulate any classical circuit using a quantum circuit. Let's prove it as a theorem.

**Theorem: **Given a classical circuit $C$ with a single output bit, there is a quantum circuit $D$ that computes the same function.

_Proof._ Let $x$ be a binary string input to $C$, and suppose that $C$ has $s$ gates $g_1, \dots, g_s$, each being either AND, OR, or NOT, and with $g_s$ being the output gate. To construct $D$, we can replace every $g_i$ with their quantum counterparts $G_i$. Recall that this takes $e_{b_1b_20} \mapsto e_{b_1b_2(g_i(b_1, b_2))}$. And so we need to add a single scratchwork qubit for each one (really we only need it for the ANDs and ORs, but who cares). This means that our start state is $e_{x} \otimes e_{0^s} = e_{x0^s}$. Really, we need one of these gates $G_i$ for each wire _going out_ of the classical gate $g_i$, but with some extra tricks one can do it with a single quantum gate that uses multiple scratchwork qubits. The crucial thing to note is that the state vector is always a basis vector!

If we call $z$ the contents of all the scratchwork after the quantum circuit described above runs and $z_0$ the initial state of the scratchwork, then what we did was extend the function $x \mapsto C(x)$ to a function $e_{xz_0} \mapsto e_{xz}$. In particular, one of the bits in the $z$ part is the output of the last gate of $C$, and everything is 0-1 valued. So we can measure the state vector, get the string $xz$ and inspect the bit of $z$ which corresponds to the output wire of the final gate of the original circuit $C$. This is your answer.

$\square$

It should be clear that the single output bit extends to the general case easily. We can split a circuit with lots of output bits into a bunch of circuits with single output bits in the obvious way and combine the quantum versions together.

Next time we'll finally look at our first quantum algorithms. And along the way we'll see some more significant quantum operations that make use of the properties that make the quantum world interesting. Until then!
