---
author: jeremykun
date: 2012-12-04 14:30:08+00:00
draft: false
title: Information Distance — A Primer
type: post
url: /2012/12/04/information-distance-a-primer/
categories:
- Computing Theory
- Discrete
- Primers
tags:
- compression
- computing
- information theory
- kolmogorov complexity
- metric
- turing machines
- universality
---

_This post assumes familiarity with our [primer on Kolmogorov complexity](http://jeremykun.wordpress.com/2012/04/21/kolmogorov-complexity-a-primer/). We recommend the uninformed reader begin there. We will do our best to keep consistent notation across both posts._





## Kolmogorov Complexity as a Metric


Over the past fifty years mathematicians have been piling up more and more theorems about Kolmogorov complexity, and for good reason. One of the main interpretations of the Kolmogorov complexity function $K$ is that for a given string $x$, $K(x)$ is the best theoretical compression of $x$ under any compression scheme. So a negative result about $K$ can provide useful bounds on how good a real-world compressor can be. It turns out that these properties also turn $K$ into a useful tool for machine learning. The idea is summarized as follows:

Let $x,y$ be binary strings, and as usual let's fix some universal programming language $L$ in which to write all of our programs. Let $p(x,y)$ be the shortest program which computes both $y$ when given $x$ as an input, and $x$ given $y$. We would imagine that if $x,y$ are unrelated, then the length of the program $|p(x,y)|$ would be roughly $K(x) + K(y)$, simply by running the shortest program to output $x$ using no inputs, followed by the same thing for $y$. As usual there will be some additive constant term independent of both $x$ and $y$. We denote this by $c$ or $O(1)$ interchangeably.

We would further imagine that if $x,y$ are related (that is, if there is some information about $x$ contained in $y$ or vice versa), then the program $p(x,y)$ would utilize that information and hence be shorter than $K(x) + K(y)$. It turns out that there is an even better way to characterize $p$, and with a few modifications we can turn the length of $p$ into something similar to a metric on the set of all strings.

This metric has some strikingly attractive features. We will see that it is "universal" with respect to a certain class of distance functions (which is unfortunately _not_ the class of all metrics). In particular, for any of these functions $f$, the length of $|p(x,y)|$ will be at worst a small amount larger than $f(x,y)$. In words, if $x$ and $y$ are similar according to _any_ of these distance functions, then they will be similar according to $p$. Of course the devil is in the details, but this is the right idea to have in mind while we wade through the computations.


## An Aside on Metrics, and Properties of Kolmogorov Complexity


In recent posts on this blog we've covered a number of important [examples of metrics](http://jeremykun.wordpress.com/2012/08/26/metric-spaces-a-primer/) and investigated [how a metric creates structure in a space](http://jeremykun.wordpress.com/2012/11/04/topological-spaces-a-primer/). But as powerful and rare as fruitful metrics are, we have barely scratched the surface of [the vast amount of literature on the subject](http://www.ohli.de/download/papers/Deza2009.pdf).

As usual with our computations in Kolmogorov complexity, all of our equalities will be true up to some kind of additive sloppiness. Most of the time it will be an additive constant $O(1)$ which is independent of anything else in the equation. We will usually omit the constant with that implicit understanding, and instead we will specify the times when it is an exact equality (or when the additive sloppiness is something other than a constant).

And so, unavoidably, the "metric" we define won't be a true metric. It will only satisfy the metric properties (positive definite, symmetric, triangle inequality) up to a non-constant additive sloppiness. This will be part of the main theorem of this post.

Before we can reach the heart of the matter (and as a nice warm-up), we need to establish a few more properties of $K$. Recall that by $K(x|y)$ we mean the shortest program which computes $x$ when provided $y$ as an auxiliary input. We call this the _conditional complexity of_ $x$ _given_ $y$. Further, recall that $K(x,y)$ is the length of the shortest program which outputs both $x$ and $y$, and a way to distinguish between the two (if everything is in binary, the distinguishing part is nontrivial; should the reader be interested, this sort of conversation is made for comment threads). Finally, the comma notation works for auxiliary inputs as well: $K(x|y,z)$ is the length of the shortest program outputting $x$ when given $y,z$ and a way to distinguish them as input.

For example, the conditional Kolmogorov complexity $K(1^n | n) = c$ is constant: the length of the string $1^n$ provides all but a finite amount of information about it. On the other hand, if $x,y$ are random strings (their bits are generated independently and uniformly at random), then $K(y|x) = K(y)$; there is no information about $y$ contained in $x$.

**Definition:** Let $x$ be a (binary) string. We denote by $x^*$ the shortest program which computes $x$. That is, $K(x) = |x^*|$. If there are two shortest programs which compute $x$, then $x^*$ refers to the first in the standard enumeration of all programs.

As a quick aside, the "standard enumeration" is simple: treat a binary string as if it were a natural number written in base 2, and enumerate all strings in increasing order of their corresponding number. The choice of enumeration is irrelevant, though; all that matters is that it is consistent throughout our theory.

**Proposition:** Kolmogorov complexity has the following properties up to additive constants:



	  1. $K(x|y^*) = K(x|y,K(y))$
	  2. $K(x|y^*) \leq K(x|y)$, and $K(x|y) \leq K(x|y^*) + O(\log(K(y)))$
	  3. $K(x,y) = K(x) + K(y|x^*)$

The first item simply states that giving $y^*$ as input to a program is the same as giving $y$ and $K(y)$. This is not hard to prove. If $p$ is the shortest program computing $x$ from $y,K(y)$, then we can modify it slightly to work with $y^*$ instead. Just add to the beginning of $p$ the following instructions:

    
    Compute K(y) as the length of the input y*
    Simulate y* and record its output y


Since $y^*$ is a finite string and represents a terminating program, these two steps produce the values needed to run $p$. Moreover, the program description is constant in length, independent of $y^*$.

On the other hand, if $q$ is a program computing $x$ from $y^*$, we are tasked with finding $y^*$ given $y, K(y)$. The argument a standard but slightly more complicated technique in theoretical computer science called [dovetailing](http://en.wikipedia.org/wiki/Dovetailing_(computer_science)). In particular, since we know the length of $y^*$, and there are only finitely many programs of the same length, we can get a list $p_1, p_2, \dots p_n$ of all programs of length $K(y)$. We then interleave the simulation of each of these programs; that is, we run the first step of all of the $p_i$, then the second, third, and so on. Once we find a program which halts and outputs $y$ (and we are guaranteed that one will do so) we can stop. In pseudocode, this is just the subroutine:

    
    L = [all programs of length K(y) in lexicographic order]
    i = 1
    while True:
       for program in L:
          run step i of program
          if program terminates and outputs y:
             return program


The fact that this algorithm will terminate proves the claim.

The second item in the proposition has a similar proof, and we leave it as an exercise to the reader. (Hint: the logarithm in the second part of the statement comes from the hard-coding of a binary representation of the _number_ $K(y)$)

The third item, that $K(x,y) = K(x) + K(y|x^*)$ has a much more difficult proof, and its consequences are far-reaching. We will use it often in our computations. The intrepid reader will see Theorem 3.9.1 in [the text of Li & Vitanyi](http://www.amazon.com/Introduction-Kolmogorov-Complexity-Applications-Computer/dp/0387339981) for a complete proof, but luckily one half of the proof is trivial. That is, the proof that $K(x,y) \leq K(x) + K(y|x^*) + c$ is similar to the argument we used above. Let $p,q$ be the shortest programs computing $x$ and $y$ given $x^*$, respectively. We can combine them into a program computing $x$ and $y$. First run $p$ to compute $x$ and compute the length of $p$. As we saw, these two pieces of data are equivalent to $x^*$, and so we can compute $y$ using $q$ as above, adding at most a finite amount program text to do so.

This property is so important it has a name.

**Lemma: **(Symmetry of information)


$\displaystyle K(x,y) = K(x) + K(y|x^*) = K(y) + K(x|y^*)$




This is true (and named appropriately) since there is symmetry in the quantity $K(x,y) = K(y,x)$. Note in particular that this doesn't hold without the star: $K(x,y) = K(x) + K(y|x) + O(\log(K(x)))$. Those readers who completed the exercise above will know where the logarithm comes from.





## The Almost-Triangle Inequality


The first application of the symmetry of information is (surprisingly) a variant of the triangle inequality. Specifically, the function $f(x,y) = K(x|y^*)$ satisfies the metric inequalities up to an additive constant sloppiness.


$\displaystyle K(x|y^*) \leq K(x|z^*) + K(z|y^*) + c$




where $c$ does not depend on $x, y, z$. To prove this, see that




$\displaystyle K(x,z | y^*) = K(x,y,z) - K(y) \leq K(z) + K(x|z^*) + K(y|z^*) - K(y)$




The first equality is by the symmetry of information $K(x,y,z) = K(y) + K(x,z|y^*)$, and the second follows from the fact that $K(x,y,z) \leq K(z) + K(x|z^*) + K(y|z^*)$. This is the same argument we used to prove the $\leq$ case of the symmetry of information lemma.




Now we can rearrange the terms and use the symmetry of information twice, $K(z) + K(y|z^*) = K(y,z)$ and $K(y,z) - K(y) = K(z|y^*)$, to reach the final result.




This is interesting because it's our first indication that Kolmogorov complexity can play a role in a metric. But there are some issues: $K(x|y)$ is in general not symmetric. We need to some up with a symmetric quantity to use instead. There are quite a few details to this process ([see this paper if you want to know them all](http://www.cs.bu.edu/~gacs/papers/info-distance.pdf)), but the result is quite nice.




**Theorem:** Let $E(x,y)$ be the length of the shortest program which computes $x$ given $y$ as input and $y$ given $x$. Then




$\displaystyle E(x,y) = \max (K(x|y), K(y|x)) + O(\log(M))$




where $M = \max(K(x|y), K(y|x))$.




That is, our intuitive idea of what the "information distance" from $x$ to $y$ should be coincides up to an additive logarithmic factor with the maximum of the conditional Kolmogorov complexities. If two strings are "close" with respect to $E$, then there is a lot of mutual information between them. In the same paper listed above, the researchers (Bennett et al.) prove that $E$ is a "metric" (up to additive constants) and so this gives a reasonable estimate for the true information distance in terms of conditional Kolmogorov complexities.




However, $E$ is not the final metric used in applications, but just an inspiration for other functions. This is where the story gets slightly more complicated.





## Normalized Information Distance(s)


At this point we realize that the information distance $E$ defined above is not as good as we'd like it to be. One of its major deficiencies is that it does not compute _relative_ distances very well. That is, it doesn't handle strings of varying size as well as it should.

For example, take $x$ to be a random string of length $n$ for arbitrary $n$.   The quantity $E(x, \varepsilon)$, where $\varepsilon$ is the empty string is just $K(x) + c$ (if the input is empty, compute $x$, otherwise output the empty string). But in a sense there is no information about $\varepsilon$ in any string. In other words, $\varepsilon$ is _maximally_ dissimilar to all nonempty strings. But according to $E$, the empty string is variably dissimilar to other strings: it's "less similar" to strings with higher Kolmogorov complexity. This is counter-intuitive, and hence undesirable.

Unfortunately the literature is littered with alternative distance functions, and the researchers involved spend little effort relating them to each other (this is part of the business of defining things "up to sloppiness"). We are about to define the principal example we will be concerned with, and we will discuss its relationship with its computationally-friendly cousins at the end.

The link between all of these examples is normalization. That is (again up to minor additive sloppiness we'll make clear shortly) the distance functions take values in $[0,1]$, and a value of 0 means the strings are maximally similar, and a value of 1 implies maximal dissimilarity.

**Definition:** Let $\Sigma = \left \{ 0,1 \right \}^*$ be the set of binary strings. A _normalized distance_ $f$ is a function $\Sigma \times \Sigma \to [0,1]$ which is symmetric and satisfies the following density condition for all $x \in \Sigma$ and all $0 \leq e \leq 1$:


$\displaystyle |\left \{ y : d(x,y) \leq e \right \}| < 2^{eK(x) + 1}$




That is, there is a restriction on the number of strings that are close to $x$. There is a sensible reason for such a convoluted condition: this is the Kolmogorov-complexity analogue of the [Kraft inequality](http://en.wikipedia.org/wiki/Kraft's_inequality). One of the picky details we've blatantly left out in our discussion of Kolmogorov complexity is that the programs we're allowed to write must collectively form a prefix-code. That is, no program is a proper prefix of another program. If the implications of this are unclear (or confusing), the reader may safely ignore it. It is purely a tool for theoretical analysis, and the full details are again in [the text of Li & Vitanyi](http://www.amazon.com/Introduction-Kolmogorov-Complexity-Applications-Computer/dp/0387339981). We will come back to discuss other issues with this density condition later (in the mean time, think about why it's potentially dubious), but now let us define our similarity metric.




**Definition: **The _normalized information distance_ $d(x,y)$ is defined by




$\displaystyle d(x,y) = \frac{\max(K(x|y^*), K(y|x^*))}{\max(K(x), K(y))}$




The reason we switched from $K(x|y)$ to $K(x|y^*)$ will become apparent in our calculations (we will make heavy use of the symmetry of information, which does not hold by a constant factor for $K(x|y)$).




Quickly note that this alleviates our empty string problem we had with the non-normalized metric. $d(x,\varepsilon) = K(x)/K(x) = 1$, so they are maximally dissimilar regardless of what $x$ is.




We will prove two theorems about this function:




**Theorem 1:** (Metric Axioms) $d(x,y)$ satisfies the metric axioms up to additive $O(1/M)$ precision, where $M$ is the _maximum_ of the Kolmogorov complexities of the strings involved in the (in)equality.




**Theorem 2:** (Universality) $d(x,y)$ is universal with respect to the class of computable normalized distance functions. That is, if $f$ is a normalized distance, then for all $x,y$ we have the following inequality:




$d(x,y) \leq f(x,y) + O(1/M)$




where again $M$ is the _minimum_ of the Kolmogorov complexities of the strings involved.




We should note that in fact theorem 2 holds for even more general normalized distance functions, the so-called "upper semi-computable" functions. Skipping [the rigorous definition](http://en.wikipedia.org/wiki/Semicomputable_function), this just means that one can recursively approximate the true value by giving a consistently improved upper bound which converges to the actual value. It is not hard to see that $K$ is an upper semi-computable function, although it is unknown whether $d$ is (and many believe it is not).




The proof of the first theorem is straightforward but notationally dense.




_Proof of Theorem 1 (Metric Axioms): _The value $d(x,x) = K(x|x^*)/K(x) = O(1/K(x))$, since $K(x|x^*) = K(x|x,K(x))$ is trivially constant, and $d(x,y) \geq 0$ since Kolmogorov complexity is non-negative. Moreover, $d(x,y)$ is exactly symmetric, so the proof boils down to verifying the triangle inequality holds.




Let $x,y,z$ be strings. We gave a proof above that $K(x|y^*) \leq K(x|z^*) + K(z|y^*) + O(1)$. We will modify this inequality to achieve our desired result, and there are two cases:




Case 1: $K(z) \leq \max(K(x), K(y))$. Take the maximum of each side of the two inequalities for $K(x|y^*), K(y|x^*)$ to get




$\displaystyle \max(K(x|y^*), K(y|x^*)) \leq \max(K(x|z^*) + K(z|y^*) , K(y|z^*) + K(z|x^*)) + O(1)$




We can further increase the right hand side by taking termwise maxima




$\displaystyle \max(K(x|y^*), K(y|x^*)) \leq \max(K(x|z^*), K(z|x^*)) + \max(K(y|z^*), K(z|y^*)) + O(1)$




Now divide through by $\max(K(x), K(y))$ to get




$\displaystyle \frac{\max(K(x|y^*), K(y|x^*))}{\max(K(x), K(y))} \leq \frac{\max(K(x|z^*), K(z|x^*))}{\max(K(x), K(y))} + \frac{\max(K(y|x^*), K(z|y^*))}{\max(K(x), K(y))} + O(1/M)$




Finally, since $K(z)$ is smaller than the max of $K(x), K(y)$, we can replace the  $K(y)$ in the denominator of the first term of the right hand side by $K(z)$. This will only possibly increase the fraction, and for the same reason we can replace $K(x)$ by $K(z)$ in the second term. This achieves the triangle inequality up to $O(1/M)$, as desired.




Case 2: $K(z) = \max(K(x), K(y), K(z))$. Without loss of generality we may also assume $K(x) \geq K(y)$, for the other possibility has an identical argument. Now we can boil the inequality down to something simpler. We already know the denominators have to all be $K(z)$ in the right hand side, and $K(x)$ in the left. Moreover, we claim $K(z|x^*) \geq K(x|z^*)$. This is by the symmetry of information:




$\displaystyle K(x,z) = K(x|z^*) + K(z) = K(z|x^*) + K(x) \leq K(z|x^*) + K(z)$




Subtracting $K(z)$ establishes the claim, and similarly we have $K(z|y^*) \geq K(y|z^*)$. So the triangle inequality reduces to




$\displaystyle \frac{K(x|y^*)}{K(x)} \leq \frac{K(z|x^*)}{K(z)} + \frac{K(z|y^*)}{K(z)} + O(1/K(z))$




Applying our original inequality again to get $K(x|y^*) \leq K(x|z^*) + K(z|y^*) + O(1)$, we may divide through by $K(x)$ and there are two additional cases.




$\displaystyle \frac{K(x|y^*)}{K(x)} \leq \frac{K(x|z^*) + K(z|y^*) + O(1)}{K(x)}$




If the right-hand side is less than or equal to 1, then adding a constant $c$ to the top and bottom of the fraction only increases the value of the fraction, and doesn't violate the inequality. So we choose to add $K(z)-K(x)$ to the top and bottom of the right-hand side and again using the symmetry of information, we get exactly the required value.




If the right-hand side is greater than 1, then adding any constant to the top and bottom decreases the value of the fraction, but it still remains greater than 1. Since $K(x|y^*) \leq K(x)$ (a simple exercise), we see that the left-hand side is at most 1, and our same trick of adding $K(z) - K(x)$ works. $\square$




The proof of the universality theorem is considerably more elegant.




_Proof of Theorem 2 (Universality):_ Let $f$ be any normalized distance function, and set $e = f(x,y)$. Suppose further that $K(x) \leq K(y)$.




Let us enumerate all strings $v$ such that $f(x,v) \leq e$. In particular, since $e = f(x,y)$, $y$ is included in this enumeration. By the density condition, the number of such strings is at most $2^{eK(x) + 1}$. The index of $y$ in this enumeration can be used as an effective description of $y$ when given $x$ as input. That is, there is a program which includes in its description the index of $y$ and outputs $y$ given $x$. Since the number of bits needed to describe the index of $y$ is at most $\log(2^{eK(x) + 1}) = eK(x) + 1$, we have




$\displaystyle K(y|x) \leq eK(x) + 1$




Again the symmetry of information lemma gives us $K(x|y^*) \leq K(y|x^*)$. And now




$\displaystyle d(x,y) = \frac{K(y|x^*)}{K(y)} \leq \frac{K(y|x) + O(1)}{K(y)} \leq \frac{eK(x) + O(1)}{K(y)}$




Since $K(x) \leq K(y)$, we can replace the denominator of the last expression with $K(x)$ (only increasing the fraction) to get $d(x,y) \leq e + O(1/K(x))$. But $e$ was just $f(x,y)$, so this completes the proof of this case.




In the case $K(y) < K(x)$, the proof is similar (enumerating the index of $x$ instead), and at the end we get




$\displaystyle d(x,y) = \frac{K(x|y^*)}{K(x)} \leq \frac{eK(y) + O(1)}{K(y)} = f(x,y) + O(1/K(y))$




The theorem is proved. $\square$





## Why Normalized Distance Functions?


The practical implications of the two theorems are immense. What we're saying is that if we can represent some feature of string similarity by a normalized distance function, then that feature will be captured automatically by the normalized information distance $d$. The researchers who discovered normalized information distance (and proved its universality) argue that in fact upper semi-computable normalized distance functions encapsulate all real-world metrics we would ever care about! Of course, there is still the problem that Kolmogorov complexity is uncomputable, but we can certainly come up with reasonable approximations (we will see precisely this in our next post).

And these same researchers have shown that approximations to $d$ do represent a good deal of universality in practice. They've applied the same idea to fields as varied as genome clustering, language clustering, and music clustering. We will of course investigate the applications for ourselves on this blog, but their results seem to apply to data mining in any field.

But still this raises the obvious question (which goes unaddressed in any research article this author has read): does every metric have a sensible interpretation (or modification) as a normalized distance function? That awkward density condition seems particularly suspect, and is at the core of this author's argument that the answer is no.

Consider the following example. Let $f$ be a normalized distance function, and fix $e = 1$. The density condition says that for any $x$ we want, the number of strings which are within distance 1 of $x$ is bounded by $2^{K(x) + 1}$. In particular, this quantity is finite, so there can only be finitely many strings which are within distance 1 of $x$. But there are infinitely many strings, so this is a contradiction!

Even if we rule out this (arguably trivial) case of $e=1$, we still run into problems. Let $e = 1 - \varepsilon$ for any sufficiently small $\varepsilon > 0$. Then fix $x = 0$ (the string consisting of the single bit 0). The number of strings which are within distance $e$ of $x$ is bounded by $2^{eK(x) + 1} < 2^{K(x) + 1}$ is again finite (and quite small, since $K(0)$ is about as simple as it gets). In other words, there are only a finite number of strings that are _not_ maximally dissimilar to $0$. But one can easily come up with an infinite number of strings which share something in common with $0$: just use $0^n$ for any $n$ you please. It is ludicrous to say that every metric should call $0$ as dissimilar to $0^n$ as the empty string is to a random string of a thousand bits.

In general, this author doesn't find it likely that one can take any arbitrary $f(x,y)$ which is both symmetric and has values in $[0,1]$ and modify it to satisfy the density condition. Indeed, this author has yet to see _any_ example of a natural normalized similarity metric. There is one which is a modification of Hamming distance, but it is relatively awkward and involves the Kolmogorov complexity of the strings involved. If the reader has any ideas to the contrary, please share them in the comments.

So it appears that the class of normalized distance functions is not as large as we might wish, and in light of this the universality theorem is not as impressive. On the other hand, there is no denying the success of applying the normalized information distance to complex real-world problems. Something profound is going on, but from this author's viewpoint more theoretical work is needed to establish why.


## Friendly Cousins of Normalized Information Distance


In practice we want to compute $K(x|y^*)$ in terms of quantities we can actually approximate. Due to the symmetry of information, we can rewrite the metric formula as


$\displaystyle d(x,y)=\frac{K(x,y) - \min(K(x), K(y))}{\max(K(x), K(y))}$




Indeed, since our main interpretation of $K(x)$ is as the size of the smallest "compressed version" of the string $x$, it would seem that we can approximate the function $K$ by using real-world compression algorithms. And for the $K(x,y)$ part, we recognize that (due to the need to specify a way to distinguish between the outputs $x,y$)




$K(x,y) \leq K(xy) + O(\log(\max(K(x), K(y))))$,




where $K(xy)$ is the Kolmogorov complexity of the concatenation of the two strings. So if we're willing to forgive additive logarithmic sloppiness (technically, $O(\log(K(x))/K(x))$ sloppiness, which goes to zero asymptotocally), we can approximate normalized information distance as




$\displaystyle d(x,y) = \frac{K(xy) - \min(K(x), K(y))}{\max(K(x), K(y))}$




In the literature researchers will also simplify the metric by removing the "star" notation




$\displaystyle d(x,y) = \frac{\max(K(x|y), K(y|x))}{\max(K(x), K(y))}$




Unfortunately these two things aren't equivalent. As we saw in our "basic properties" of $K(x|y)$,




$K(x|y) \leq K(x|y^*) + O(\log(K(y)))$




Indeed, it is not the case that $K(x|y) = K(x|y^*)$. An easy counterexample is by trying to equate $K(K(x) | x) = K(K(x) | x^*)$. We have already proven that the right hand side is always constant, but the left hand side could not be. An exercise in Li & Vitanyi shows there is an infinite family of strings $x$ for which $K(K(x) | x) \geq \log(|x|)$.




And so these two metrics cannot be equal, but they are close. In fact, denoting the non-star version by $d_2$ and the regular version by $d_1$, we have $d_2(x,y) \leq d_1(x,y) + O(1)$. This changes the metric properties and the universality claim, because $O(1/K)$ precision is stronger than $O(1)$ precision. Indeed, the true constant is always less than 1 (e.g. when $K(y) > K(x)$ it is $K(y^*)/K(y)$), but this means the metric can potentially take values in the range $[0,2]$, which is edging further and further away from the notion of normalization we originally strove for.




Finally, the last example of a cousin metric is




$\displaystyle d_3(x,y) = \frac{K(x|y^*) + K(y|x^*)}{K(x,y)}$




We will leave it to the reader to verify this function again satisfies the metric inequalities (in the same way that the original normalized information distance does). On the other hand, it only satisfies universality up to a factor of 2. So while it still may give some nice results in practice (and it is easy to see how to approximate this), the first choice of normalized information distance was theoretically more precise.





## Applications


We've just waded through a veritable bog of theory, but we've seen some big surprises along the way. Next time we'll put these theoretical claims to the test by seeing how well we can cluster and classify data using the normalized information distance (and introducing as little domain knowledge as possible). Until then!
