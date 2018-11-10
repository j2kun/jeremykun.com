---
author: jeremykun
date: 2011-06-20 01:39:40+00:00
draft: false
title: Linear Algebra - A Primer
type: post
url: /2011/06/19/linear-algebra-a-primer/
categories:
- Linear Algebra
- Primers
tags:
- eigenvalues
- eigenvectors
- history
- linear independence
- linear maps
- mathematics
- matrices
- primer
- vector spaces
---

## Story Time




Linear algebra was founded around the same time as Calculus (think Leibniz, circa 1700) solely for the purpose of solving general systems of linear equations. The coefficients of a system were written in a grid form, with rows corresponding to equations and columns to the unknown variables. Using a computational tool called the _determinant_ (an awkward, but computable formula involving only the coefficients of the equations in a system), researchers were able to solve these systems, opening a world of information about the positions of celestial bodies and large-scale measurements (of geodesic arcs) on the surface of the earth.




By the 1850's, Arthur Cayley was representing matrices as abstract objects. He defined matrix multiplication and nurtured matrix theory as its own field, recognizing a vast wealth of theoretical knowledge underlying the theory of determinants. Around turn of the century, a formal system of vector algebra was invented which relied heavily on interpreting matrices as so-called _linear transformations__. _Linear transformations are intuitively those maps of everyday space ($\mathbb{R}^n$) which preserve "linear" things. Specifically, they send lines to lines, planes to planes, etc., and they preserve the origin (one which does not preserve the origin is very similar but has a different name; see [Affine Transformation](http://en.wikipedia.org/wiki/Affine_transformation)). Soon enough the mathematical focus shifted to the foundations of such an algebra, and later with the advent of computers to rapid calculations in one.





## Motivations




Linear algebra sits at the crossroads of many areas of mathematics. Keeping close to its roots, linear algebra is primarily a tool for computation. Unsurprisingly, a huge chunk of mathematical research has been solely to phrase things in terms of matrices and their associated linear transformations. For instance, an undirected graph on $n$ vertices can be modeled as a matrix of integer entries, with the $i,j$ entry containing the number of edges from vertex $i$ to vertex $j$. This is called the _adjacency matrix _of a graph. Suddenly, a wealth of information about the graph translates to simple matrix computations. For instance, we can compute the number of paths from one vertex to another of length $m$ as the appropriate entry of $A^m$. (more formally,these are _walks_, which are allowed to repeat edge traversals and visited vertices)




Even in advanced, purely theoretical mathematics, objects are commonly represented in terms of coordinates in some vector space, and are subsequently studied using all of the great things we know about linear transformations and their matrices. And so, without further ado, we will present the terminology and working concepts necessary for the content elsewhere in this blog.





## Vector Spaces


The setting for all of linear algebra is in some vector space. Intuitively this is just a collection of objects, which we call _vectors_, with some rules on how you can combine vectors to get other vectors. This treatment wouldn't do that idea justice without an axiomatic definition, so here it is.

**Definition:** A _vector space_ is a quadruple $(V, F, +, \cdot)$, where $V$ is a set of vectors (points in our space), $F$ is a scalar field (coefficients), $+:V \times V \to V$ is a commutative, associative operation to combine vectors, and $\cdot: F \times V \to V$ is an operation to "scale" vectors. In addition, we need the following properties to hold:



	  * Addition and multiplication distribute (as we are used to with traditional algebra).
	  * There must be an additive identity, which we call $0$, giving $0 + v = v$ for all $v \in V$.
	  * Every vector must have an additive inverse (every $v$ has some $w$ with $v + w = 0$).

This is a lot to swallow at first, but it is general for a good reason: there are _tons_ of different kinds of vector spaces! Many of these are surprising and counter-intuitive. For our purposes, however, we may stick with the nice, small vector spaces. So here is a simplified definition that will suffice:

**Definition: **A _vector space_ is a set $V$ of vectors which are fixed-length lists of real numbers $(v_1, v_2, \dots , v_n) \in \mathbb{R}^n$, where addition between vectors is componentwise, we may scale vectors by any real number, and the following properties hold:



	  * Addition and multiplication distribute (as above).
	  * $(0,0,0, \dots, 0)$ is the additive identity.
	  * $(-v_1, -v_2, \dots , -v_n)$ is the unique additive inverse of $(v_1, v_2, \dots , v_n)$.

Hopefully this is much more familiar to what we think of as "vectors," and with the understanding that we are viewing it as a vector space, we just call it $\mathbb{R}^n$. The closure of operations gives us a nice way to characterize "any combination" of vectors in a vector space.

**Definition:** A _linear combination_ of vectors in a vector space $V$ is the vector


$a_1v_1 + a_2v_2 + \dots + a_kv_k$




for some positive integer $k$, scalars $a_i$, and vectors $v_i$.




We may speak of the _span_ of a set of vectors as the set of all possible linear combinations of those vectors. Furthermore, we call a set of vectors _linearly independent_ if no vector in the list is in the span of the others. For example, $(1,0,0), (0,1,0),$ and $(0,0,1)$ are linearly independent in $\mathbb{R}^3$. Specifically, $(1,0,0)$ cannot be written as $a(0,1,0) + b(0,0,1) = (0,a,b)$ for any scalars $a,b \in F$, and the other two vectors are similarly so.


As usual, we may describe _subspaces_ of a vector space, which are just subsets of $V$ which are themselves vector spaces with the inherited operations. The simplest examples of these are lines, planes, and hyperplanes through the origin in $\mathbb{R}^n$. Consequently, we may identify $\mathbb{R}^n$ as a subspace of $\mathbb{R}^m$ for any $n \leq m$.

One of the first things we want to ask about a vector space is "how big is it?" While most instances of vector spaces we will see have uncountably many elements, we can characterize "size" in terms of a different metric: the size of a basis.

**Definition:** A list of vectors $(v_1, v_2, \dots v_n)$ is a _basis_ for $V$ if its elements are linearly independent, and their span is $V$. The _dimension_ of a vector space is the length of any basis.

For $\mathbb{R}^n$, and similarly all finite-dimensional vector spaces, it is easy to prove that all bases have the same length, and hence dimension is well-defined. Further, $\mathbb{R}^n$ admits a very natural basis, often called the _standard basis_:


$e_1 = (1,0, \dots, 0)$
$e_2 = (0,1, \dots, 0)$
$\vdots$
$e_n = (0,0, \dots, 1)$




These are best visualized as the coordinate axes in $\mathbb{R}^n$, and it strokes our intuition as to what a basis should be, because any vector in $\mathbb{R}^n$ can be broken down uniquely into a sum of scalar multiples of these unit coordinates. Indeed, this is true of any basis (due to linear independence). Given a fixed basis for $V$, every vector $v \in V$ may be _uniquely_ written as a linear combination of basis vectors.





## Linear Transformations and their Matrix Representations




Moving quickly toward the heart of linear algebra, we may speak of linear transformations (interchangeably, linear maps) between two vector spaces:




**Definition:** A function $f : V \to W$ is a _linear map_ if it preserves the operations of addition and scalar multiplication. In other words, for all $v, w \in V, c \in F, f(v+w) = f(v)+f(w)$ and $f(cv) = cf(v)$.




Examples are bountiful; some geometrically inspired ones include rotations about the origin, shears, and scalings. These are functions you'd likely see in an image manipulation program like photoshop. From this we can prove a few basic facts, like that every linear map sends $0$ to $0$ and additive inverses to additive inverses (try it as an exercise).




One remarkable fact that helps us characterize linear maps is that every linear map is determined completely by what it does to a basis. Since every vector $x \in V$ is a linear combination of basis elements, say $x=a_1v_1 + \dots + a_nv_n$, we see that a linear map plays nicely:




$f(x) = f(a_1v_1 + \dots + a_nv_n) = a_1f(v_1) + \dots + a_nf(v_n)$




In other words, if we know what $f$ does to a basis, then we know everything about $f$. In order to aid our computations, we write what $f$ does to each basis vector in a tabular form. To elaborate on the vague word "does," we need to also fix a basis of our target vector space $W$, say $(w_1, \dots , w_m)$, and describe each $f(v_i)$ in terms of this basis. We write it in tabular form, as follows:




$\begin{pmatrix} | & | & \mathbf{ } & | \\ f(v_1) & f(v_2) & \dots & f(v_n) \\ | & | & \mathbf{ } & | \end{pmatrix}$




The $j$th column corresponds to $f(v_j)$, and the $i$th row corresponds to the $i$th coefficient in the expansion of $f(v_j)$ in terms of the basis for $W$. Here the vertical bars indicate that each element is a column of scalars. We will do an extended example to make this clear.




Consider the map $f$ on $\mathbb{R}^3$ defined as $(x,y,z) \mapsto (y,x,2z+y)$. It is easy to check this map is linear, and using the standard basis we see that




$f(1,0,0) = (0,1,0)$,
$f(0,1,0) = (1,0,1)$, and
$f(0,0,1) = (0,0,2)$.




or,




$f(e_1) = e_2$, $f(e_2) = e_1 + e_3$, and $f(e_3) = 2e_3$.




Hence, the matrix representation of $f$ with respect to the standard basis is




$A = \begin{pmatrix} 0 & 1 & 0 \\ 1 & 0 & 0 \\ 0 & 1 & 2 \end{pmatrix}$




Now we see that if we take a (column) vector $x$, and multiply it on the left by our matrix $A$, the resulting vector is precisely the coordinate representation of $f(x)$ with respect to the basis for $W$. In fact, the rules for matrix multiplication were constructed very particularly so that this would be the case. In this way, we may arbitrarily switch between viewing $f$ as a transformation and a vector computation. Compositions of linear maps translate to multiplication of two matrices, and matrix inversion (if it exists) is precisely function inversion.




Of course, there are many different bases we could have chosen. Even though we are going from $\mathbb{R}^3 \to \mathbb{R}^3$, the column basis could be different from the row basis. Fortunately for our purposes, we are not going to consider what basis is appropriate to choose. All that matters is that fixing a basis, the matrix representation of a linear map is unique, and so we may interchange the notation freely. Even so, the truly interesting things about matrices are those properties which are true no matter which basis we prefer to use.





## Eigenvectors and Eigenvalues


**Definition:** A scalar $\lambda \in F$ is an _eigenvalue_ for the linear map $A$ if there exists a non-zero vector $v \in V$ with $Av = \lambda v$. Any such vector $v$ which satisfies this equation is said to be an _eigenvector_ of $A$ corresponding to $\lambda$.

Eigenvectors and eigenvalues have a [huge number of applications](http://en.wikipedia.org/wiki/Eigenvalues_and_eigenvectors#Applications), including facial recognition software, geology, quantum mechanics, and [web search](http://jeremykun.wordpress.com/2011/06/18/googles-pagerank-a-first-attempt/). So being able to find them quickly is of great significance to researchers and engineers. What's interesting is that while eigenvectors depend on a choice of basis, eigenvalues do not. We prove this now:

**Proposition:** If $A$ and $B$ are different representations of the same linear map, then any eigenvalue of $B$ is an eigenvalue of $A$.

_Proof_. It turns out that the process of "changing a basis" can be [boiled down to matrix multiplication](http://en.wikipedia.org/wiki/Change_of_basis). Specifically, if $A$ and $B$ are two different matrix representations of the same linear map, we have the existence of some invertible matrix $P$ such that $A = PBP^{-1}$, or $AP = PB$. As a result, if $v$ is an eigenvector for $B$ corresponding to the eigenvalue $\lambda$, then for some $APv = PBv = P \lambda v = \lambda Pv$ and so $A(Pv) = \lambda(Pv)$, and $Pv$ is an eigenvector for $A$ corresponding to $\lambda$ as well. This proves that eigenvalues are invariant with respect to a change of basis, as desired. $\square$

The point of this is that we can choose whatever basis we want to work with, and compute the eigenvalues where we're most comfortable. For instance, if we choose a basis that gives the following _diagonal _representation,


$A = \begin{pmatrix} 1 & 0 & 0 \\ 0 & 2 & 0 \\ 0 & 0 & 3 \end{pmatrix}$




then we can just eyeball that the eigenvalues are 1, 2, and 3. In fact, there are some very deep theorems in linear algebra that concern the existence and uniqueness of certain matrix representations. For a more in-depth treatment, see [Axler, Linear Algebra Done Right](http://linear.axler.net/). We will cover all the necessary information in the relevant posts, but until then, we are absolutely pooped from typing. Until next time!



