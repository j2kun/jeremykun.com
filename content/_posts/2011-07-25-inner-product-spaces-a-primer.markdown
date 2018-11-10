---
author: jeremykun
date: 2011-07-25 07:29:00+00:00
draft: false
title: Inner Product Spaces - A Primer
type: post
url: /2011/07/25/inner-product-spaces-a-primer/
categories:
- Linear Algebra
- Primers
tags:
- big-o notation
- eigenvectors
- mathematics
- matrices
- orthogonality
- vector spaces
---

_This primer is a precursor to a post on eigenfaces, a technique for facial recognition. For a more basic introduction to linear algebra, see [our first primer on the subject](http://jeremykun.wordpress.com/2011/06/19/linear-algebra-a-primer/)._

## Motivations

Vector spaces alone are not enough to do a lot of the interesting things we'd like them to do. Since a vector space is a generalization of Euclidean space, it is natural for us to investigate more specific types of vector spaces which are more akin to Euclidean space. In particular, we want to include the notion of a dot product. By admitting additional structure to a vector space, we may perform more computations, and hopefully get more interesting results.

Again, since we are developing mathematics for use in computing, all vector spaces in this post are finite-dimensional, and the field under question is always $\mathbb{R}$ or $\mathbb{C}$, but usually the former. It suffices to recognize the vast amount of work and results in infinite-dimensional spaces, but we will not need it here.

## Inner Product Spaces

The standard dot product operation in Euclidean space is defined as

$\left \langle (x_1, \dots , x_n), (y_1, \dots, y_n) \right \rangle = \sum \limits_{i = 1}^n x_iy_i$

So we take the dot product and generalize it to an operation on an arbitrary vector space.

**Definition**: An _inner product_ on a vector space $V$ over a field $F$ is a function $\left \langle \cdot, \cdot \right \rangle : V \times V \to F$ which satisfies the following properties for all $x,y,z \in V, c \in F$:

	  * $\left \langle x,y \right \rangle = \overline{ \left \langle y, x\right \rangle }$, where the bar denotes complex conjugate. For real fields, this is just symmetry in the arguments.
	  * $\left \langle cx, y \right \rangle = c \left \langle x,y \right \rangle$
	  * $\left \langle x+y, z \right \rangle = \left \langle x,z \right \rangle + \left \langle y,z \right \rangle$
	  * $\left \langle x,x \right \rangle \geq 0$ and $\left \langle x,x \right \rangle = 0$ if and only if $x=0$.

We recommend the novice reader invent some simple and wild operations on two vectors, and confirm or deny that they are inner products.

Notice that the second and third conditions imply that if the second argument of an inner product is fixed, then the resulting map $V \to F$ is a linear map (since it maps vectors to the underlying field, it has a special name: a _linear functional_). We leave it as an exercise to the reader to investigate linearity facts about the map resulting from fixing the first argument (hint: things get conjugated).

We call a vector space with an associated inner product and _inner product space_. Of course, the most natural example of an inner product space is any Euclidean space $\mathbb{R}^n$ with the dot product. However, there are many other interesting inner products, including ones which involve [matrix multiplication](http://mathworld.wolfram.com/HermitianInnerProduct.html), [integration](http://mathworld.wolfram.com/L2-InnerProduct.html), and [random variables](http://en.wikipedia.org/wiki/Covariance#Relationship_to_inner_products). As interesting as they may be (and though the results we develop here hold for them), we have no need for them at this point in time. We will stick entirely to inner product spaces embedded in $\mathbb{R}^n$, and the standard dot product will suffice.

Now from any inner product we may induce a _norm_ on $V$, which is colloquially the "distance" of a vector from the origin.

**Definition**: A _norm_ on $V$ is a function $\left \| \cdot \right \| : V \to R$ which satisfies the following for all $x,y \in V, c \in F$:

	  * $\left \| x \right \| \geq 0$, with equality if and only if $x=0$
	  * $\left \| cx \right \| = |c| \left \| x \right \|$
	  * $\left \| x+y \right \| \leq \left \| x \right \| + \left \| y \right \|$ (the infamous triangle inequality)

If we recall the standard Euclidean norm, we see that it is just $\left \| x \right \| = \sqrt{\left \langle x,x \right \rangle}$. Indeed, for any inner product this definition satisfies the axioms of a norm, and so it is a natural generalization of "distance" between points in any inner product space.

In particular, those readers familiar with topology (or at least metric space analysis), will immediately recognize that a norm induces a metric on $V$, defined by $d(x,y)= \left \| x-y \right \| $, where of course $x-y$ is the vector between $x$ and $y$. Hence, every inner product space has a very rigid (metrized) topology and a fruitful geometry.

Additionally, any vector of norm 1 is called a _unit vector, _or a _normal_ vector.

Now we look at vectors which have interesting relationships under inner products: specifically, when $\left \langle x,y \right \rangle = 0$.

## Orthogonality and Orthonormal Bases

**Definition**: Two vectors $x,y \in V$ are _orthogonal_ if $\left \langle x,y \right \rangle = 0$. A set $S$ of vectors is called orthogonal if the vectors in $S$ are pairwise orthogonal.

Orthogonal vectors naturally generalize perpendicularity in Euclidean space. In particular, two vectors in $\mathbb{R}^n$ are orthogonal if and only if the subspaces (lines) spanned by them are perpendicular.

The simplest examples of orthogonal vectors are the standard basis vectors $(1,0, \dots, 0) \dots (0, \dots ,1)$, with respect to the usual dot product. Although, any scalar multiple of a basis vector $\lambda e_i$ may replace $e_i$ while still preserving the orthogonality of the set.

Orthogonality gives a new insight into the nature of inner products. Specifically, $\left \langle x,y \right \rangle$ gives (almost) the length of the projection of $x$ onto $y$. In other words, $\left \langle x,y \right \rangle$ is the component of $x$ that points in the direction of $y$ (scaled by the length of $y$).

Now we may define projection maps to get "projection onto $y$" more faithfully than a plain inner product:

**Definition**: The _projection_ of $x$ onto $y$, denoted $p_y(x)$, is the map $V \to V$ defined by $p_y(x) = \left \langle x, y \right \rangle \frac{y}{\left \| y \right \|^2}$.

The reader may easily verify that the vectors $p_y(x)$ and $x-p_y(x)$ are indeed orthogonal, though the computation is awkward. This will come in handy later when we want to build orthogonal sets of vectors.

In addition, we may obviously decompose any vector $v$ into its two orthogonal components with respect to another vector $w$ via this projection: $v = (v-p_w(v)) + p_w(v)$.

In addition to orthogonality, the standard basis vectors have norm 1. We call such a basis for an inner product space an _orthonormal_ basis (a portmanteau of orthogonal and normal). We commonly denote an orthonormal set of vectors $(e_1, \dots, e_n)$, perhaps a ritualistic attempt to summon the power of the standard basis vectors.

Given an orthonormal basis for an inner product space V $(e_1, \dots, e_n)$, we may decompose any vector into its basis representation rather easily:

$\displaystyle v = p_{e_1}(v) + \dots + p_{e_n}(v) = \left \langle v,e_1 \right \rangle e_1 + \dots + \left \langle v,e_n \right \rangle e_n$,

Since the norm of each $e_i$ is 1, we may skip the division by the square norm of $e_i$ in the projection maps. Now, recalling that every vector can be written uniquely as a linear combination of the basis vectors, we see that the inner products $\left \langle v, e_i \right \rangle$ are precisely those coefficients. The recognition of this fact leads us to an important theorem, with a necessary preliminary definition:

**Definition**: Two inner product spaces $V, W$ are _isometric_ if there exists a linear isomorphism $f:V \to W$ which preserves the inner products in the respective spaces. i.e., $\left \langle x, y \right \rangle_V = \left \langle f(x), f(y) \right \rangle_W$ for all $x,y \in V$.

Whereas, linear isomorphisms between vector spaces are the mathematically rigorous way of saying the two vector spaces are identical, isometric vector spaces give the "sameness" of the inner products. Hence, isometric vector spaces have equivalent metrics, topologies, and geometries, with merely a different choice of basis and representation of the vectors. Now, as we had that every finite-dimensional vector space was isomorphic to $\mathbb{R}^n$, we will soon see that every finite-dimensional inner product space is isometric to $\mathbb{R}^n$ with the usual dot product.

**Theorem**: Any finite dimensional real inner product space $V$ which has an orthonormal basis is isometric to $\mathbb{R}^n$ with the usual dot product.

_Proof_: Define $f: \mathbb{R}^n \to V$ by $f((x_1, \dots, x_n)) = x_1e_1 + \dots + x_ne_n$. Now, by computation, we see that

$\left \langle f((a_1, \dots , a_n)), f((b_1, \dots , b_n)) \right \rangle$
$= \left \langle a_1e_1 + \dots + a_ne_n, b_1e_1 + \dots + b_ne_n \right \rangle$
$= \sum \limits_{i=1}^n a_i \left \langle e_i, b_1e_1 + \dots + b_ne_n \right \rangle$
$= \sum \limits_{i=1}^n \sum \limits_{j=1}^n a_i b_j \left \langle e_i, e_j \right \rangle$
$= a_1b_1 + \dots a_nb_n = \left \langle (a_1, \dots a_n), (b_1, \dots b_n) \right \rangle \square$

Now, all we must prove is that every finite-dimensional inner product space has an orthonormal basis.

**Theorem (Gram-Schmidt)**: Every basis of a finite-dimensional inner product space may be transformed into an orthonormal basis.

_Proof_: We do so by construction, using the previously introduced projection maps $p_y(x)$. Given a basis $(x_1, \dots , x_n)$, we compute the following algorithm:

	  1. $\displaystyle e_1 = \frac{x_1}{\left \| x_1 \right \|}$
	  2. For each $i = 2, \dots , n$:
$\ $

	    1. Let $z_i = \sum \limits_{j=1}^{i-1} p_{e_j}(x_i)$
$\ $
	    2. $\displaystyle e_i = \frac{x_i - z_i}{\left \| x_i - z_i \right \|}$

The reader may verify computationally that this process produces orthonormal vectors, but the argument is better phrased geometrically: each $z_i$ is the projection of some new vector onto the subspace generated by all previously computed orthonormal vectors. By subtracting $x_i - z_i$, we take the part of $x_i$ that is orthogonal to all vectors in that subspace. This is guaranteed to be nonzero because of the linear independence of our original list. And so, $e_i$ is orthogonal to every vector preceding it in the algorithm (with indices $j < i$). Finally, we normalize each $e_i$ to make them unit vectors, and we are done. $\square$

We note that this algorithm takes $O(n^3)$, since we may compute the $O(n^2)$ needed inner products ahead of time, and then there remains $O(n)$ steps to compute each of the $e_i$.

This result now proves that every real finite-dimensional inner product space is isometric to $\mathbb{R}^n$. With this new insight, we may effectively do all our work in $\mathbb{R}^n$ with the usual dot product, realizing that the results there hold for all relevant inner product spaces. In other words, our "simplification" at the beginning of this post, restricting our work to $\mathbb{R}^n$, was not at all a simplification. Proving statements about $\mathbb{R}^n$ gives us equivalent statements about all real finite-dimensional inner product spaces. Wonderful!

## Bases of Eigenvectors

There is one more important topic we wish to discuss here: the importance of bases of eigenvectors. In particular, given a linear operator $A: V \to V$, if one has a basis of eigenvectors for $A$, then $A$ has a diagonal representation.

In particular, if $A$ has a basis of eigenvectors $(v_1, \dots , v_n)$, then the expansion of $Av_i$ in terms of the basis vectors is just $\lambda_i v_i$, where $\lambda_i$ is the corresponding eigenvalue. Thus, the matrix corresponding to $A$ looks like:

$\begin{pmatrix} \lambda_1 & 0 & \cdots & 0 \\ 0 & \lambda_2 & \cdots & 0 \\ \vdots & \vdots & \ddots & \vdots \\ 0 & 0 & \cdots & \lambda_n
\end{pmatrix}$

Here we count multiplicity of eigenvalues.

The existence of a diagonal representation for a matrix has interesting computational implications. For instance, we often wish to take high powers of a matrix, such as in counting paths in a graph, or working with graphical computations. Unfortunately, each successive matrix multiplication takes $O(n^2)$ computations. If we wish to compute $A^m$, this takes $O(mn^2)$ time. However, if the matrix has a diagonal representation, we may spend the $O(n^2)$ it takes to convert the matrix to its diagonal form, take powers of the diagonal matrix by simply taking the powers of the diagonal entries, and then convert it back. Indeed, multiplying two diagonal matrices together is just as easy as multiplying the diagonal entries together, as the reader may verify. This optimization reduces computation to $O(n^2 + mn) = O(nm)$, since we are assuming $m$ is very large.

Of course, then we are left with the problem of quickly computing eigenvectors. What worries us even more is that we might not _have_ a basis of eigenvectors (some matrices don't have any!). We instead take a slightly different route, which serves our purposes better. Specifically, we will be using this information to compute eigenvectors of _symmetric _matrices ($A = A^{\textup{T}}$). For this, we refer to a grand theorem:

**The Spectral Theorem**: Every real symmetric matrix has an orthonormal basis consisting of eigenvectors.

The proof goes beyond the scope of this post (see: characteristic polynomials and self-adjoint operators), but it is very useful for us. In particular, by finding these eigenvectors we may both have a diagonal representation for our matrix, and also compute projections in a jiffy! We will see the astounding applications of this quite soon.

So Even with two primers on linear algebra, we have still only scratched the surface of this wonderful subject. In the future we may continue this series of primers by discussing the linear algebra inherent in many optimization problems. Be sure to look out for it.

Until next time!
