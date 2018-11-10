---
author: jeremykun
date: 2016-03-28 14:00:46+00:00
draft: false
title: Tensorphobia and the Outer Product
type: post
url: /2016/03/28/tensorphobia-outer-product/
categories:
- Linear Algebra
- Primers
tags:
- mathematics
- matrices
- primer
- tensors
---

## Variations on a theme


Back in 2014 I wrote a post called [How to Conquer Tensorphobia](http://jeremykun.com/2014/01/17/how-to-conquer-tensorphobia/) that should end up on Math $\cap$ Programming's "greatest hits" album. One aspect of tensors I neglected to discuss was the connection between the modern views of tensors and the practical views of linear algebra. I feel I need to write this because every year or two I forget why it makes sense.

The basic question is:


What the hell is going on with the [outer product](https://en.wikipedia.org/wiki/Outer_product) of vectors?




The simple answer, the one that has never satisfied me, is that the outer product of $v,w$ is the matrix $vw^T$ whose $i,j$ entry is the product $v_i w_j$. This doesn't satisfy me because it's an explanation by fiat. It lacks motivation and you're supposed to trust (or verify) things magically work out. To me this definition is like the definition of matrix multiplication: having it dictated to you before you understand why it makes sense is a cop out. Math isn't magic, it needs to make perfect sense.




The answer I like, and the one I have to re-derive every few years because I never wrote it down, is a little bit longer.


To borrow a programming term, the basic confusion is a type error. We start with two vectors, $v,w$ in some vector space $V$ (let's say everything is finite dimensional), and we magically turn them into a matrix. Let me reiterate for dramatic effect: we start with vectors, which I have always thought of as _objects_, things you can stretch, rotate, or give as a gift to your cousin Mauricio. While a matrix is a _mapping_, a thing that takes vectors as input and spits out new vectors. Sure, you can play with the mappings, feed them kibble and wait for them to poop or whatever. And sure, sometimes vectors _are themselves_ maps, like in the vector space of real-valued functions (where the word "matrix" is a stretch, since it's infinite dimensional).

But to take two vectors and *poof* get a mapping of _all_ vectors, it's a big jump. And part of the discomfort is that it feels random. To be happy we have to understand that the construction is natural, or even better _canonical_, meaning this should be the _only_ way to turn two vectors into a linear map. Then the definition would make sense.

So let's see how we can do that. Just to be clear, everything we do in this post will be for finite-dimensional vector spaces over $\mathbb{R}$, but we'll highlight the caveats when they come up.


## Dual vector spaces


The first step is understanding how to associate a vector with a linear map in a "natural" or "canonical" way. There is one obvious candidate: if you give me a vector $v$, I can make a linear map by taking the dot product of $v$ with the input. So I can associate


$\displaystyle v \mapsto \langle v,- \rangle$




The dash is a placeholder for the input. Another way to say it is to define $\varphi_v(w) = \langle v,w \rangle$ and say the association takes $v \mapsto \varphi_v$. So this "association," taking $v$ to the inner product, is itself  a mapping from $V$ to "maps from $V$ to $\mathbb{R}$." Note that $\varphi_v(w)$ is linear in $v$ and $w$ because that's part of the definition of an inner product.




To avoid saying "maps from $V$ to $\mathbb{R}$" all the time, we'll introduce some notation.




**Definition: **Let $V$ be a vector space over a field $k$. The set of $k$-linear maps from $V \to k$ is called $\textup{Hom}(V,k)$. More generally, the set of $k$-linear maps from $V$ to another $k$-vector space $W$ is called $\textup{Hom}(V,W)$.




"Hom" stands for "homomorphism," and in general it just means "maps with the structure I care about." For this post $k = \mathbb{R}$, but most of what we say here will be true for any field. If you go deeply into this topic, it matters whether $k$ is algebraically closed, or has finite characteristic, but for simplicity we'll ignore all of that. We'll also ignore the fact that these maps are called _linear functionals_ and this is where the name "functional analysis" comes from. All we really want to do is understand the definition of the outer product.




Another bit of notation for brevity:




**Definition:** Let $V$ be a $\mathbb{R}$-vector space. The _dual vector space_ for $V$, denoted $V^*$, is $\textup{Hom}(V, \mathbb{R})$.




So the "vector-to-inner-product" association we described above is a map $V \to V^*$. It takes in $v \in V$ and spits out $\varphi_v \in V^*$.




Now here's where things start to get canonical (interesting). First, $V^*$ is itself a vector space. This is an easy exercise, and the details are not too important for us, but I'll say the key: if you want to add two functions, you just add their (real number) outputs. In fact we can say more:




**Theorem:** $V$ and $V^*$ are isomorphic as vector spaces, and the map $v \mapsto \varphi_v$ is the canonical isomorphism.




Confessions of a mathematician: we're sweeping some complexity under the rug. When we upgraded our vector space to an inner product space, we fixed a specific (but arbitrary) inner product on $V$. For finite dimensional vector spaces it makes no difference, because every finite-dimensional $\mathbb{R}$-inner product space is isomorphic to $\mathbb{R}^n$ with the usual inner product. But the theorem is devastatingly false for infinite-dimensional vector spaces. There are two reasons: (1) there are many (non-canonical) choices of inner products and (2) the mapping for any given inner product need not span $V^*$. Luckily we're in finite dimensions so we can ignore all that. [Edit: see [Emilio's comments](https://jeremykun.com/2016/03/28/tensorphobia-outer-product/#comment-53990) for a more detailed discussion of what's being swept under the rug, and how we're ignoring the categorical perspective when we say "natural" and "canonical."]




Before we make sense of the isomorphism let's talk more about $V^*$. First off, it's not even entirely obvious that $V^*$ is finite-dimensional. On one hand, if $v_1, \dots, v_n$ is a basis of $V$ then we can quickly prove that $\varphi_{v_1}, \dots ,\varphi_{v_n}$ are linearly independent in $V^*$. Indeed, if they weren't then there'd be some linear combination $a_1 \varphi_{v_1} + \dots + a_n \varphi_{v_n}$ that is the zero function, meaning that for _every _vector $w$, the following is zero




$\displaystyle a_1 \langle v_1, w \rangle + \dots + a_n \langle v_n, w \rangle = 0.$




But since the inner product is linear in both arguments we get that $\langle a_1 v_1 + \dots + a_n v_n , w \rangle = 0$ for every $w$. And this can only happen when $a_1v_1 + \dots + a_nv_n$ is the zero vector (prove this).




One consequence is that the linear map $v \mapsto \varphi_v$ is injective. So we can think of $V$ as "sitting inside" $V^*$. Now here's a very slick way to show that the $\varphi_{v_i}$ span all of $V^*$. First we can assume our basis $v_1, \dots, v_n$ is actually an _orthonormal_ basis with respect to our inner product (this is without loss of generality). Then we write any linear map $f \in V^*$ as




$f = f(v_1)\varphi_{v_1} + \dots + f(v_n) \varphi_{v_n}$




To show these two are actually equal, it's enough to show they agree on a basis for $V$. That is, if you plug in $v_1$ to the function on the left- and right-hand side of the above, you'll get the same thing. The orthonormality of the basis makes it work, since all the irrelevant inner products are zero.




In case you missed it, that completes the proof that $V$ and $V^*$ are isomorphic. Now when I say that the isomorphism is "canonical," I mean that if you're willing to change the basis of $V$ and $V^*$, then $v \mapsto \varphi_v$ is the square identity matrix, i.e. the only isomorphism between any two finite vector spaces (up to a change of basis).





## Tying in tensors


At this point we have a connection between single vectors $v$ and linear maps $V^*$ whose codomain has dimension 1. If we want to understand the outer product, we need a connection between _pairs_ of vectors and matrices, i.e. $\textup{Hom}(V,V)$. In other words, we'd like to find a canonical isomorphism between $V \times V$ and $\textup{Hom}(V,V)$. But already it's not possible because the spaces have different dimensions. If $\textup{dim}(V) = n$ then the former has dimension $2n$ and the latter has dimension $n^2$. So any "natural" relation between these spaces has to be a way to embed $V \times V \subset \textup{Hom}(V,V)$ as a subspace via some injective map.

There are two gaping problems with this approach. First, the outer product is _not linear_ as a map from $V \times V \to \textup{Hom}(V,V)$. To see this, take any $v,w \in V$, pick any scalar $\lambda \in \mathbb{R}$. Scaling the pair $(v,w)$ means scaling both components to $(\lambda v, \lambda w)$, and so the outer product is the matrix $(\lambda v)(\lambda w^T) = \lambda^2 vw^T$.

The second problem is that the only way to make $V \times V$ a subspace of $\textup{Hom}(V,V)$ (up to a change of basis) is to map $v,w$ to the first two rows of a matrix with zeros elsewhere. This is canonical but it doesn't have the properties that the outer product promises us. Indeed, the outer product let's us uniquely decompose a matrix as a "sum of rank 1 matrices," but we don't get a _unique_ decomposition of a matrix as a sum of these two-row things. We also don't even get a well-defined rank by decomposing into a sum of two-row matrices (you can get cancellation by staggering the sum). This injection is decisively useless.

It would seem like we're stuck, until we think back to our association between $V$ and $V^*$. If we take one of our two vectors, say $v$, and pair it with $w$, we can ask how $(\varphi_v, w)$ could be turned into a linear map in $\textup{Hom}(V,V)$. A few moments of guessing and one easily discovers the map


$\displaystyle x \mapsto \varphi_v(x) w = \langle v,x \rangle w$




In words, we're scaling $w$ by the inner product of $x$ and $v$. In geometric terms, we project onto $v$ and scale $w$ by the signed length of that projection. Let's call this map $\beta_{v,w}(x)$, so that the association maps $(v,w) \mapsto \beta_{v,w}$. The thought process of "easily discovering" this is to think, "What can you do with a function $\varphi_v$ and an input $x$? Plug it in. Then what can you do with the resulting number and a vector $w$? Scale $w$."




If you look closely you'll see we've just defined the outer product. This is because the outer product works by saying $uv^T$ is a matrix, which acts on a vector $x$ by doing $(uv^T)x = u(v^T x)$. But the important thing is that, because $V$ and $V^*$ are canonically isomorphic, this is a mapping




$\displaystyle V \times V = V^* \times V \to \textup{Hom}(V,V)$




Now again, this mapping is not linear. In fact, it's _bilinear_, and if there's [one thing we know](http://jeremykun.com/2014/01/17/how-to-conquer-tensorphobia/) about bilinear maps, it's that tensors are their gatekeepers. If you recall our previous post on tensorphobia, this means that this bilinear map "factors through" the tensor product in a canonical way. So the true heart of this association $(v,w) \mapsto \beta_{v,w}$ is a map $B: V \otimes V \to \textup{Hom}(V,V)$ defined by




$\displaystyle B(v \otimes w) = \beta_{v,w}$




And now the punchline,




**Theorem: **$B$ is an isomorphism of vector spaces.




_Proof._ If $v_1, \dots, v_n$ is a basis for $V$ then it's enough to show that $\beta_{v_i, v_j}$ forms a basis for $\textup{Hom}(V,V)$. Since we already know $\dim(\textup{Hom}(V,V)) = n^2$ and there are $n^2$ of the $\beta_{v_i, v_j}$, all we need to do is show that the $\beta$'s are linearly independent. For brevity let me remove the $v$'s and call $\beta_{i,j} =\beta_{v_i, v_j}$.




Suppose they are not linearly independent. Then there is some choice of scalars $a_{i,j}$ so that the linear combination below is the identically zero function




$\displaystyle \sum_{i,j=1}^n a_{i,j}\beta_{i,j} = 0$




In other words, if I plug in any $v_i$ from my (orthonormal) basis, the result is zero. So let's plug in $v_1$.




$\displaystyle \begin{aligned} 0 &= \sum_{i,j=1}^n a_{i,j} \beta_{i,j}(v_1) \\ &= \sum_{i,j=1}^n a_{i,j} \langle v_i, v_1 \rangle v_j \\ &= \sum_{j=1}^n a_{1,j} \langle v_1, v_1 \rangle v_j \\ &= \sum_{j=1}^n a_{1,j} v_j \end{aligned}$




The orthonormality makes all of the $\langle v_i ,v_1 \rangle = 0$ when $i \neq 1$, so we get a linear combination of the $v_j$ being zero. Since the $v_i$ form a basis, it must be that all the $a_{1,j} = 0$. The same thing happens when you plug in $v_2$ or any other $v_k$, and so all the $a_{i,j}$ are zero, proving linear independence.




$\square$




This theorem immediately implies some deep facts, such as that every matrix can be uniquely decomposed as a sum of the $\beta_{i,j}$'s. Moreover, facts like the $\beta_{i,j}$'s being rank 1 are immediate: by definition the maps scale a single vector by some number. So of course the image will be one-dimensional. Finding a useful basis $\{ v_i \}$ with which to decompose a matrix is where things get truly fascinating, and we'll see that [next time](https://jeremykun.com/2016/04/18/singular-value-decomposition-part-1-perspectives-on-linear-algebra/) when we study the singular value decomposition.




In the mean time, this understanding generalizes nicely (via induction/recursion) to higher dimensional tensors. And you don't need to talk about slices or sub-tensors or lose your sanity over $n$-tuples of indices.




Lastly, all of this duality stuff provides a "coordinate-free" way to think about the transpose of a linear map. We can think of the "transpose" operation as a linear map $-^T : \textup{Hom}(V,W) \to \textup{Hom}(W^*,V^*)$ which (even in infinite dimensions) has the following definition. If $f \in \textup{Hom}(V,W)$ then $f^T$ is a linear map taking $h \in W^*$ to $f^T(h) \in V^*$. The latter is a function in $V^*$, so we need to say what it does on inputs $v \in V$. The only definition that doesn't introduce any type errors is $(f^T(h))(v) = h(f(v))$. A more compact way to say this is that $f^T(h) = h \circ f$.




Until [next time](https://jeremykun.com/2016/04/18/singular-value-decomposition-part-1-perspectives-on-linear-algebra/)!
