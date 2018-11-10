---
author: jeremykun
date: 2012-06-07 01:57:05+00:00
draft: false
title: Generalized Functions — A Primer
type: post
url: /2012/06/06/generalized-functions/
categories:
- Analysis
- Linear Algebra
- Primers
tags:
- fourier analysis
- fourier transform
- functional analysis
- generalized functions
---

Last time we investigated the naive (which I'll henceforth call "classical") notion of the Fourier transform and its inverse. While the development wasn't quite rigorous, we nevertheless discovered elegant formulas and interesting properties that proved useful in at least solving differential equations. Of course, we wouldn't be following this trail of mathematics if it didn't result in some worthwhile applications to programming. While we'll get there eventually, this primer will take us deeper down the rabbit hole of abstraction. We will develop the necessary framework required to reason about Fourier transforms in a mathematically rigorous manner. Most importantly, we will avoid the divergent integrals which, when we try to use them in an otherwise rigorous proof, make our stomachs heave.




It turns out the rigorous theory is wholly neat and tidy. The whole idea hinges on a part of linear algebra which is slightly more advanced than what we've seen so far on this blog, but it is by all means accessible to the reader who has mastered our relevant primers. And even though we still will overlook some of the more minute details of the theory, we will cover a nontrivial portion of it, and leave further exploration to the reader's whim and discretion.





## A Bit of Motivation


Every tidy mathematical theory deserves some kind of motivation, and the theory of Fourier transforms is no different. The primary motivating question, however, does not often change. That is, we want to ask, "Which functions make the classical Fourier transform as nice as possible?" and build our theory from that foundation. The tricky part is rigorously defining what it means to be "good" for the Fourier transform. One obvious condition we should require is that such a function have a classically-defined Fourier transform (that is, the integral defining its transform converges), but is that enough?

It turns out that this is not enough. Taking for granted the many years of mathematical development and genius that resulted in the correct conditions, we state the following criteria:

**Criteria:** A class of functions $C$ is good for Fourier transforms if it satisfies the following two criteria:



	  1. If $f \in C$ then $\mathscr{F}f \in C$ and $\mathscr{F}^{-1}f \in C$.
	  2. $\mathscr{FF}^{-1}f = f = \mathscr{F}^{-1}\mathscr{F}f$ for all $f \in C$.

Now if we can find a class of functions which satisfies these two criteria, then it should be a good candidate to base our formal theory of Fourier transforms on. But this raises the obvious question: what does one mean by "basing a theory" on a class of functions? It would be a waste of time to try to put it in less general non-mathematical terms, so let's just slide right into it.


## Generalized Functions


We'll begin with the complete unabridged definition:

**Definition:** Given a space $A$ of functions $f: \mathbb{R} \to \mathbb{R}$, a _generalized function_ on $A$ is a continuous linear functional on $A$.

Breaking the definition down, a _linear functional _is a function $A \to \mathbb{R}$ which is linear. Explicitly, if $T$ is a linear functional, then $T$ operates on functions, and outputs complex numbers in a way that the following identity holds:


$\displaystyle T(af + bg) = aTf + bTg$




for all $a, b \in \mathbb{C}, f,g \in A$.




The requirements on the space $A$ are a bit tricky to pin down, and [the details](http://en.wikipedia.org/wiki/Test_functions#Test_function_space) begin to overwhelm the reader quite quickly. We will be content to say that $A$ has some notion of distance which is _complete_. That is, sequences of functions which converge have their limit inside the space. Such a notion is required to talk about continuity.




With all that securely bolted down, we can finally say that a generalized function is just a continuous linear functional, i.e., a linear mapping $T: A \to \mathbb{C}$ which satisfies




$T(f_n) \to Tf$ whenever $f_n \to f$ in $A$.




Often generalized functions on $A$ are simply called _distributions_ on $A$, but this author thinks that term clashes with probability distributions in an unnatural way. In fact, all probability distributions can be realized as generalized functions on some suitably chosen function space, so the name isn't there without a reason. But for a student with no formal measure theory or probability theory under his belt, the coincidence of names can be confusing. We will stick to the term generalized function.




There is another interesting bit of notation that accompanies generalized functions, and that is to write a generalized function as if it were an inner product. i.e., instead of writing $Tf$ for a linear functional $T$ operating on a function $f$, one writes $\left \langle T, f \right \rangle$. We personally think this is silly, but we will bring it up later when we discuss the Fourier transform, because this choice of notation hints at a deep mathematical theorem. The interpretation usually given to physics students is that this notation represents a "pairing" between $T$ and $f$, and that the way you can tell a generalized function from a regular function is by the fact that it's defined by how it "operates" with other functions.




The most prominent example of this is the Dirac delta function $\delta$. When trying to define it, one might say ridiculous things like "it's zero everywhere except at the origin, where it's infinite," and, "the integral from $-\infty$ to $\infty$ of the delta function is 1." Both of these claims ludicrously defy classical analysis; the delta simply cannot be defined as a function. On the other hand, it has a very natural definition in terms of how it operates when "multiplied" by another function and then integrated. In our pairing notation, this definition is that $\left \langle \delta, f \right \rangle = f(0)$.




To prove this works rigorously, let $A$ be any space of functions for which convergence in $A$ implies pointwise convergence. Consider the mapping $\delta(f) = f(0)$ extended linearly from any basis. The linearity condition is manifestly held, and given a convergent sequence $f_n \to f$, the sequence $\delta(f_n) = f_n(0) \to f(0)$, since we required pointwise convergence.




In fact, it will work in situations with weaker hypotheses (and for Fourier transforms the hypotheses certainly are weaker), but these details are beyond the scope of this primer (for instance, see this [necessary and sufficient condition](http://en.wikipedia.org/wiki/Dirac_delta#As_a_distribution)).




For the purpose of working with Fourier transforms, our generalized functions will be defined almost always by integration. That is, even though we have yet to figure out what $A$ is, we want a generalized function $T$ to act on a function using the usual kinds of inner products on function spaces like $L^2$.




One large class of examples of generalized functions are those which are induced by regular functions. That is, we will be able to take any function $g$ (discontinuous or wild as you like), and define the generalized function $T_g$ by




$\displaystyle T_g(f) = \int_{-\infty}^{\infty} g(x)f(x)dx$




Now, of course we require that $f$ satisfy whatever conditions we impose on $A$, and these will ensure that the integral always converges, no matter what $g$ is.




Now supposing our criteria for being "good for Fourier transforms" holds for $A$, and we have such a class where we can define linear functionals by integration. Then we can define quite easily the Fourier transform of a generalized function on $A$.




There is a nice derivation here, and it goes like this: if $T$ is a generalized function and it happens to be induced by a Fourier-transformable function $g(x)$, then the Fourier transform of $T$ is defined by




$\displaystyle (\mathscr{F}T)(\varphi) = \int_{-\infty}^{\infty} \mathscr{F}g(x)\varphi(x)dx$




And since $g$ is transformable, we can expand the classical definition as an integral, giving




$\displaystyle \int_{-\infty}^{\infty} \left ( \int_{-\infty}^{\infty} e^{-2\pi ixy} g(y) dy \right ) \varphi(x) dx$




Swapping the order of integration we get




$\displaystyle \int_{-\infty}^{\infty} \left ( \int_{-\infty}^{\infty} e^{-2 \pi ixy} \varphi(x) dx \right ) g(y)dy$




And the inner integral is simply $\mathscr{F}\varphi$, giving




$\displaystyle \int_{-\infty}^{\infty} \mathscr{F}\varphi(y) g(y) dy = T(\mathscr{F}\varphi)$




Since the pairing of $T$ is defined by integrating with a product of $g$.




But notice that the final form of our expression for $(\mathscr{F}T)(\varphi)$ does not at all require that $T$ is induced by $g$. All that we require is that $\varphi$ is transformable, and that is always true by our assumption that $A$ satisfies our original criterion. This motivates the definition:




**Definition: **The _Fourier transform of a generalized function_ $T$ is defined by $(\mathscr{F}T)(f) = T(\mathscr{F}f)$. Similarly, the _inverse Fourier transform_ is defined by $(\mathscr{F}^{-1}T)(f) = T(\mathscr{F}^{-1}f)$.




This is much neater, and in fact more general than a definition based on integration. The point of deriving it the way we did is so that we can have a theory which reduces to our classical notions given the right assumptions, but can be framed in other, perhaps unexpected contexts. Such is the beauty of mathematics.




Moreover, we note that the "pairing" notation hints at an interesting fact about Fourier transforms. In particular, the above definition says that $\left \langle \mathscr{F}T,f \right \rangle = \left \langle T, \mathscr{F}f \right \rangle$. One familiar with the basics of finite-dimensional functional analysis will recognize this immediately as the condition for $\mathscr{F}$ to be a self-adjoint operator. While we won't discuss self-adjoint operators in this primer (we'll save it for a future primer on functional analysis; we foresee this topic surfacing again when we cover support vector machines), we will note for the knowledgable reader that with a few additional conditions, this is precisely what is going on with the Fourier transform. However, since we're dealing with an infinite-dimensional vector space, we can't quite say it's a diagonalizable matrix, but it is "multiplication by a constant" in a sense. The relationship is most evident when again $T$ is induced by a  regular function, and then the pairing is given by integration after multiplication by the "constant" $g$. Additionally, the fact that we represent a generalized function by the inner product notation hints at [Riesz-type representation theorems](http://en.wikipedia.org/wiki/Riesz_representation_theorem), but we will press the issue no further here.




Sticking in this abstract land of an unknown $A$ a little longer, we can reprove some of the basic facts about Fourier transforms in this general setting. For instance,




$\displaystyle (\mathscr{F}\mathscr{F}^{-1}T)(f) = (\mathscr{F}^{-1}T)(\mathscr{F}f) = T(\mathscr{F}^{-1}\mathscr{F}f) = T(f)$




since the function $f$ is required to satisfy the criteria. So in other words, $\mathscr{F}\mathscr{F}^{-1}T = T$, and it is trivial to see the reverse composition yields the same.




A similarly easy proof recovers the identity that confused us last time, namely that $(\mathscr{FF}T)(f) = -Tf$. We leave it as an exercise to the reader





## Schwartz Functions, and Tempered Distributions


It's time to forego the stalling and declare what the set of functions $A$ should be to make this all work. This bit is generally considered the hard work and inspired genius of a man named Laurent Schwartz, and so they are appropriately called Schwartz functions.

**Definition:** The class $S$ of _rapidly decreasing functions_ on $\mathbb{R}$, or _Schwartz functions_, is the set of the smooth functions $f : \mathbb{R} \to \mathbb{R}$ which satisfy the following condition for all $m, n \in \mathbb{N}$:


$\displaystyle |x|^n \left | \frac{d^m}{dx^m} f(x) \right | \to 0$ as $x \to \pm \infty$




Recall, if forgotten, that smooth simply means infinitely differentiable. While we won't get into the nitty gritty of proving the following facts (they're quite analytic, and this author is an algebraist), we will state the important properties of $S$.




First and foremost, $S$ is a vector space which satisfies our criteria for being "good for Fourier transforms." Another way of saying this is that the Fourier transform is a linear isomorphism on $S$. Second, $S$ includes all smooth functions with compact support; that is, it includes all functions which are nonzero except on a closed and bounded set. Moreover, $S$ includes all Gaussian curves. Third, all functions in $S$ are uniformly continuous. And finally, $S \subset L^p$ for all $p \geq 1$.




In other words, things are as nice as we could ever hope for them to be, with respect to taking Fourier transforms.  Things converge, transforms are defined, and things just work.




But of course, the real meat of the discussion comes when we analyze generalized functions on $S$. When the class is specifically $S$, these generalized functions are called _tempered distributions_. As we have already seen, the Dirac delta "function" is a tempered distribution. And with this new framework, we can start to compute the Fourier transforms of functions we couldn't previously. For instance, the Fourier transform of the Dirac delta is the constant 1 function:




$\displaystyle \mathscr{F}\delta(\varphi) = \delta(\mathscr{F}\varphi) = \mathscr{F}\varphi(0)$




But $\mathscr{F}\varphi(0)$ is classically computable, and it's just $\int_{-\infty}^{\infty}\varphi(x)dx$, which is another way to say $1(\varphi)$, where 1 is understood to be the tempered distribution induced by the constant 1 function. We just showed that $\mathscr{F}\delta(\varphi) = 1(\varphi)$ for all $\varphi \in S$. In other words, $\mathscr{F}\delta = 1$.




This has the nice interpretation that being infinitely concentrated in the time domain (as is the delta) corresponds to being infinitely spread out in the frequency domain. Similarly, being spread out infinitely in the time domain is equivalent to being concentrated at a single point in the frequency domain, as the reader will have no trouble proving that $\mathscr{F}1 = -\delta$. The eager reader will go ahead and find the Fourier transforms of the complex exponential $e^{2\pi iax}$ and $\cos(2 \pi i ax), \sin(2 \pi i ax)$.





## Operations on Tempered Distributions


Now that we have tempered distributions, it makes sense to start investigating the various operations we can perform on them. As we just saw, the Fourier transform is one of them, but it is useful to have a couple of others.

We should note that even some basic operations aren't defined for generalized functions. For instance, with regular functions $f,g$, we could compute the product $fg$. This is not defined for all generalized functions. In fact, since the space of generalized functions is a vector space, the only kinds of operations we can apply are linear ones. The Fourier transform counts as one, and so does addition and multiplication by a constant. Multiplication is not a linear operation.

On the other hand, if one restricts to tempered distributions, one can compute the product of a tempered distribution with a function in $S$. The derivation of the definition follows the same philosophy that it did for the definition of the Fourier transform, and the computation is quite trivial. In fact, we get something slightly more general:

**Definition: **Given a function $f$ such that $f\varphi \in S$ for all $\varphi \in S$ and a tempered distribution $T$, we define $fT$ by $fT(\varphi) = T(f\varphi)$.

Continuing with the same derivation philosophy, we can define the derivative of a tempered distribution $T$:

**Definition:** The _derivative_ of a tempered distribution $T$, denoted $T'$, is defined by $T'(\varphi) = -T(\varphi')$.

A special case of this occurs when $T$ is the delta function; we have $f\delta = f(0)\delta$ as tempered distributions. Moreover, from this definition it is easy to reprove the classical identities $\mathscr{F}T' = (2\pi is)\mathscr{F}T$, and $(\mathscr{F}T)' = \mathscr{F}(-2\pi it T)$.

Finally, while the convolution of two tempered distributions is also undefined in general, some additional hypotheses allow it to work ([see here](http://en.wikipedia.org/wiki/Distribution_(mathematics)#Convolution)), and then we can regain the theorem that $\mathscr{F}(f * T) = (\mathscr{F}f)(\mathscr{F}T)$. Again, a special case of this is the delta function: $f * \delta =f$ as tempered distributions.

This menagerie of properties all works toward reclaiming the theorems we proved about the classical Fourier transform. For the purpose of this blog, we will henceforth blur the distinction between the classical theory and this more complicated (and correct) theory of Fourier transforms. It's a lame cop out, we admit, but it allows us to focus on the less pedantic aspects of the theory and applications. This stuff took decades to iron out, and for good reason!

So next time we will continue with discrete Fourier transforms and multidimensional Fourier transforms. Until then!
