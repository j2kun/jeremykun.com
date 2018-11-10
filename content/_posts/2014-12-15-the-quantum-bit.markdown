---
author: jeremykun
date: 2014-12-15 16:00:52+00:00
draft: false
title: The Quantum Bit
type: post
url: /2014/12/15/the-quantum-bit/
categories:
- Computing Theory
- Linear Algebra
- Quantum
tags:
- circuits
- mathematics
- measurement
- quantum computing
- quantum mechanics
- qubit
- unitary matrices
---

The best place to start our journey through quantum computing is to recall how classical computing works and try to extend it. Since our final quantum computing model will be a circuit model, we should informally discuss circuits first.

A circuit has three parts: the "inputs," which are bits (either zero or one); the "gates," which represent the lowest-level computations we perform on bits; and the "wires," which connect the outputs of gates to the inputs of other gates. Typically the gates have one or two input bits and one output bit, and they correspond to some logical operation like AND, NOT, or XOR.

[caption id="attachment_5503" align="aligncenter" width="655"][![A simple example of a circuit.](https://jeremykun.files.wordpress.com/2014/11/example-circuit.png)
](https://jeremykun.files.wordpress.com/2014/11/example-circuit.png) A simple example of a circuit. The V's are "OR" and the Λ's are "AND." Image source: [Ryan O'Donnell](http://www.contrib.andrew.cmu.edu/~ryanod/?p=819)[/caption]

If we want to come up with a different model of computing, we could start regular circuits and generalize some or all of these pieces. Indeed, in our [motivational post](https://jeremykun.wordpress.com/2014/12/08/a-motivation-for-quantum-computing/?preview=true) we saw a glimpse of a probabilistic model of computation, where instead of the inputs being bits they were probabilities in a probability distribution, and instead of the gates being simple boolean functions they were linear maps that preserved probability distributions (we called such a matrix "stochastic").

Rather than go through that whole train of thought again let's just jump into the definitions for the quantum setting. In case you missed last time, our goal is to avoid as much physics as possible and frame everything purely in terms of linear algebra.


## Qubits are Unit Vectors


The generalization of a bit is simple: it's a unit vector in $\mathbb{C}^2$. That is, our most atomic unit of data is a vector $(a,b)$ with the constraints that $a,b$ are complex numbers and $|a|^2 + |b|^2 = 1$. We call such a vector a _qubit._

A qubit can assume "binary" values much like a regular bit, because you could pick two distinguished unit vectors, like $(1,0)$ and $(0,1)$, and call one "zero" and the other "one." Obviously there are many more possible unit vectors, such as $\frac{1}{\sqrt{2}}(1, 1)$ and $(-i,0)$. But before we go romping about with what qubits can do, we need to understand how we can extract information from a qubit. The definitions we make here will motivate a lot of the rest of what we do, and is in my opinion one of the major hurdles to becoming comfortable with quantum computing.

A bittersweet fact of life is that bits are comforting. They can be zero or one, you can create them and change them and read them whenever you want without an existential crisis. The same is not true of qubits. This is a large part of what makes quantum computing so weird: _you can't just read the information in a qubit!_ Before we say why, notice that the coefficients in a qubit are complex numbers, so being able to read them exactly would potentially encode an infinite amount of information (in the infinite binary expansion)! Not only would this be an [undesirably powerful property](http://www.computational-geometry.org/mailing-lists/compgeom-announce/2003-December/000852.html) of a circuit, but physicists' experiments tell us it's not possible either.

So as we'll see when we get to some algorithms, the main difficulty in getting useful quantum algorithms is not necessarily figuring out how to compute what you want to compute, it's figuring out how to tease useful information out of the qubits that otherwise directly contain what you want. And the reason it's so hard is that when you read a qubit, most of the information in the qubit is _destroyed_. And what you get to see is only a small piece of the information available. Here is the simplest example of that phenomenon, which is called the _measurement in the computational basis_.

**Definition: **Let $v = (a,b) \in \mathbb{C}^2$ be a qubit. Call the standard basis vectors $e_0 = (1,0), e_1 = (0,1)$ the _computational basis_ of $\mathbb{C}^2$. The process of _measuring $v$ in the computational basis _consists of two parts.



	  1. You observe (get as output) a random choice of $e_0$ or $e_1$. The probability of getting $e_0$ is $|a|^2$, and the probability of getting $e_1$ is $|b|^2$.
	  2. As a side effect, the qubit $v$ instantaneously becomes whatever state was observed in 1. This is often called a _collapse of the waveform_ by physicists.

There are more sophisticated ways to measure, and more sophisticated ways to express the process of measurement, but we'll cover those when we need them. For now this is it.

Why is this so painful? Because if you wanted to try to estimate the probabilities $|a|^2$ or $|b|^2$, not only would you get an estimate at best, but you'd have to _repeat_ whatever computation prepared $v$ for measurement over and over again until you get an estimate you're satisfied with. In fact, we'll see situations like this, where we actually have a perfect representation of the data we need to solve our problem, but we just can't get at it because the measurement process destroys it once we measure.

Before we can talk about those algorithms we need to see how we're allowed to manipulate qubits. As we said before, we use unitary matrices to preserve unit vectors, so let's recall those and make everything more precise.


## Qubit Mappings are Unitary Matrices


Suppose $v = (a,b) \in \mathbb{C}^2$ is a qubit. If we are to have any mapping between vector spaces, it had better be a linear map, and the linear maps that send unit vectors to unit vectors are called _unitary matrices_. An equivalent definition that seems a bit stronger is:

**Definition:** A linear map $\mathbb{C}^2 \to \mathbb{C}^2$ is called _unitary_ if it preserves the inner product on $\mathbb{C}^2$.

Let's remember the inner product on $\mathbb{C}^n$ is defined by $\left \langle v,w \right \rangle = \sum_{i=1}^n v_i \overline{w_i}$ and has some useful properties.



	  * The square norm of a vector is $\left \| v \right \|^2 = \left \langle v,v \right \rangle$.
	  * Swapping the coordinates of the complex inner product conjugates the result: $\left \langle v,w \right \rangle = \overline{\left \langle w,v \right \rangle}$
	  * The complex inner product is a linear map if you fix the second coordinate, and a conjugate-linear map if you fix the first. That is, $\left \langle au+v, w \right \rangle = a \left \langle u, w \right \rangle + \left \langle v, w \right \rangle$ and $\left \langle u, aw + v \right \rangle = \overline{a} \left \langle u, w \right \rangle + \left \langle u,v \right \rangle$

By the first bullet, it makes sense to require unitary matrices to preserve the inner product instead of just the norm, though the two are equivalent (see the derivation on page 2 of [these notes](http://www.cmth.ph.ic.ac.uk/people/d.vvedensky/groups/Chapter9.pdf)). We can obviously generalize unitary matrices to any complex vector space, and unitary matrices have some nice properties. In particular, if $U$ is a unitary matrix then the important property is that the columns (and rows) of $U$ form an orthonormal basis. As an immediate result, if we take the product $U\overline{U}^\text{T}$, which is just the matrix of all possible inner products of columns of $U$, we get the identity matrix. This means that unitary matrices are invertible and their inverse is $\overline{U}^\text{T}$.

Already we have one interesting philosophical tidbit. Any unitary transformation of a qubit is reversible because all unitary matrices are invertible. Apparently the only _non-reversible_ thing we've seen so far is measurement.

Recall that $\overline{U}^\text{T}$ is the [_conjugate transpose_](http://en.wikipedia.org/wiki/Conjugate_transpose) of the matrix, which I'll often write as $U^*$. Note that there is a way to define $U^*$ without appealing to matrices: it is a notion called the [adjoint](http://en.wikipedia.org/wiki/Hermitian_adjoint), which is that linear map $U^*$ such that $\left \langle Uv, w \right \rangle = \left \langle v, U^*w \right \rangle$ for all $v,w$. Also recall that "unitary matrix" for complex vector spaces means precisely the same thing as "orthogonal matrix" does for real numbers. The only difference is the inner product being used (indeed, if the complex matrix happens to have real entries, then orthogonal matrix and unitary matrix mean the same thing).

**Definition: **A _single qubit gate_ is a unitary matrix $\mathbb{C}^2 \to \mathbb{C}^2$.

So enough with the properties and definitions, let's see some examples. For all of these examples we'll fix the basis to the computational basis $e_0, e_1$. One very important, but still very simple example of a single qubit gate is the _Hadamard gate_. This is the unitary map given by the matrix


$\displaystyle \frac{1}{\sqrt{2}}\begin{pmatrix}
1 & 1 \\
1 & -1
\end{pmatrix}$




It's so important because if you apply it to a basis vector, say, $e_0 = (1,0)$, you get a uniform linear combination $\frac{1}{\sqrt{2}}(e_1 + e_2)$. One simple use of this is to allow for unbiased coin flips, and as readers of this blog know [unbiased coins can efficiently simulate biased coins](http://jeremykun.com/2014/02/12/simulating-a-biased-coin-with-a-fair-coin/). But it has many other uses we'll touch on as they come.




Just to give another example, the _quantum NOT gate_, often called a _Pauli X_ gate, is the following matrix




$\displaystyle \begin{pmatrix}
0 & 1 \\
1 & 0
\end{pmatrix}$




It's called this because, if we consider $e_0$ to be the "zero" bit and $e_1$ to be "one," then this mapping swaps the two. In general, it takes $(a,b)$ to $(b,a)$.




As the reader can probably imagine by the suggestive comparison with classical operations, quantum circuits can do everything that classical circuits can do. We'll save the proof for a future post, but if we want to do some kind of "quantum AND" operation, we get an obvious question. How do you perform an operation that involves multiple qubits? The short answer is: you represent a collection of bits by their tensor product, and apply a unitary matrix to that tensor.




We'll go into more detail on this next time, and in the mean time we suggest checking out this blog's primer on the [tensor product](http://jeremykun.com/2014/01/17/how-to-conquer-tensorphobia/). Until then!
