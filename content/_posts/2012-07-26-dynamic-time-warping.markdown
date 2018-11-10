---
author: jeremykun
date: 2012-07-26 01:11:39+00:00
draft: false
title: Dynamic Time Warping for Sequence Comparison
type: post
url: /2012/07/25/dynamic-time-warping/
categories:
- Algorithms
- Discrete
- Program Gallery
tags:
- dynamic programming
- mathematics
- programming
- python
---

**Problem:** Write a program that compares two sequences of differing lengths for similarity.

**Solution:** (In Python)

{{< highlight python >}}import math

def dynamicTimeWarp(seqA, seqB, d = lambda x,y: abs(x-y)):
    # create the cost matrix
    numRows, numCols = len(seqA), len(seqB)
    cost = [[0 for _ in range(numCols)] for _ in range(numRows)]

    # initialize the first row and column
    cost[0][0] = d(seqA[0], seqB[0])
    for i in xrange(1, numRows):
        cost[i][0] = cost[i-1][0] + d(seqA[i], seqB[0])

    for j in xrange(1, numCols):
        cost[0][j] = cost[0][j-1] + d(seqA[0], seqB[j])

    # fill in the rest of the matrix
    for i in xrange(1, numRows):
        for j in xrange(1, numCols):
            choices = cost[i-1][j], cost[i][j-1], cost[i-1][j-1]
            cost[i][j] = min(choices) + d(seqA[i], seqB[j])

    for row in cost:
       for entry in row:
          print "%03d" % entry,
       print ""
    return cost[-1][-1]
{{< /highlight >}}

**Discussion: **Comparing sequences of numbers can be tricky business. The simplest way to do so is simply component-wise. However, this will often disregard more abstract features of a sequence that we intuitively understand as "shape."

For example, consider the following two sequences.

    
    0 0 0 3 6 13 25 22 7 2 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4 5 12 24 23 8 3 1 0 0 0 0 0


They both have the same characteristics — a bump of height roughly 25 and length 8 — but comparing the two sequences entrywise would imply they are not similar. According to the standard Euclidean norm, they are 52 units apart. For motivation, according to the dynamic time warping function above, they are a mere 7 units apart. Indeed, if the two bumps consisted of the same numbers, the dynamic time warp distance between the entire sequences would be zero.

These kinds of sequences show up in many applications. For instance, in speech recognition software one often has many samples of the a single person speaking, but there is a difference in the instant during the sample at which the person begins speaking. Similarly, the rate at which the person speaks may be slightly different. In either event, we want the computed "distance" between two such samples to be small. That is, we're looking for a measurement which is time-insensitive both in scaling and in position. Historically, the dynamic time warping solution was [designed in 1978](http://www.laps.ufpa.br/aldebaro/classes/03asr2sem/documentation/papers/dtw-sakoe-chiba78.pdf) to solve this problem.

The idea is similar to the Levenshtein metric we implemented for "edit distance" measurements in our [Metrics on Words](http://jeremykun.wordpress.com/2011/12/19/metrics-on-words/) post. Instead of inserting or deleting sequence elements, we may optionally "pause" our usual elementwise comparison on one sequence while continuing on the other. The trick is in deciding whether to "pause," and when to switch the "pausing" from one sequence to the other; this will require a dynamic program (as did the Levenshtein metric).

In order to compare two sequences, one needs to have some notion of a local comparison. That is, we need to be able to compare any entry from one sequence to any entry in the other. While there are many such options that depend on the data type used in the sequence, we will use the following simple numeric metric:


$\displaystyle d(x,y) = |x-y|$




This is just the Euclidean metric in $\mathbb{R}$. More generally, this assumes that two numbers are similar when they are close together (and this is in fact an important assumption; [not all number systems are like this](http://en.wikipedia.org/wiki/P-adic_number)).




Now given two sequences $a_i, b_j$, we can compare them by comparing their local distance for a specially chosen set of indices given by $m_k$ for $a_i$ and $n_k$ for $b_j$. That is, the dynamic time warping distance will end up being the quantity:




$\displaystyle C(a_i, b_j) = \sum_{k=0}^{M} d(a_{m_k}, b_{n_k})$




Of course, we should constrain the indices $m_k, n_k$ so that the result is reasonable. A good way to do that is to describe the conditions we want it to satisfy, and then figure out how to compute such indices. In particular, let us assume that $a_i$ has length $M$, $b_j$ has length $N$. Then we have the following definition.




**Definition:** A _warping path_ for $a_i, b_j$ is a pair of sequences $(m_k, n_k)$, both of some length $L$, satisfying the following conditions:






	  1. $1 \leq m_k \leq M$ and $1 \leq n_k \leq N$ for all $k$.
	  2. The sequences have endpoints $(m_1, n_1) = (1,1), (m_L, n_L) = (M, N)$
	  3. The seqences $m_k, n_k$ are monotonically increasing.
	  4. $(m_k - m_{k-1}, n_k - n_{k-1})$ must be one of $(1,0), (0,1), (1,1)$.

The first condition is obvious, or else the $m_k, n_k$ could not be indexing $a_i, b_j$. The second condition ensures that we use all of the information in both sequences in our comparison. The third condition implies that we cannot "step backward" in time as we compare local sequence entries. We wonder offhand if anything interesting could be salvaged from the mess that would ensue if one left this condition out. And the fourth condition allows the index of one sequence to be stopped while the other continues. This condition creates the "time warping" effect, that some parts of the sequence can be squeezed or stretched in comparison with the other sequence.

We also note as an aside that the fourth condition listed implies the third.

Of course there are many valid warping paths for any two sequences, but we need to pick one which has our desired feature. That is, it minimizes the sum of the local comparisons (the formula for $C(a_i, b_j)$ above). We denote this optimal value as $DTW(a_i, b_j)$.

The fourth condition in the list above should give it away that to compute the optimal path requires a dynamic program. Specifically, the optimal path can be computed by solving the three sub-problems of finding the optimal warping path for


$\displaystyle (a_{1 \dots M-1}, b_{1 \dots N}), (a_{1 \dots M}, b_{1 \dots N-1}), \textup{ and } (a_{1 \dots M-1}, b_{1 \dots N-1})$




The clueless reader should refer to [this blog's primer on Python and dynamic programming](http://jeremykun.wordpress.com/2012/01/12/a-spoonful-of-python/). In any event, the program implementing this dynamic program is given in the solution above.




[caption id="attachment_2300" align="alignright" width="448"][![](http://jeremykun.files.wordpress.com/2012/07/dtwmap-with-axes.png)
](http://jeremykun.files.wordpress.com/2012/07/dtwmap-with-axes.png) A visualization of the dynamic time warp cost matrix for two sequences. The algorithm attempts to find the least expensive path from the bottom left to the top right, where the darker regions correspond to low local cost, and the lighter regions to high local cost. The arrows point in the forward direction along each sequence, showing the monotonicity requirement of an optimal warping path.[/caption]

The applications of this technique certainly go beyond speech recognition. Dynamic time warping can essentially be used to compare any data which can be represented as one-dimensional sequences. This includes video, graphics, financial data, and plenty of others.

We may also play around with which metric is used in the algorithm. When the elements of the lists are themselves points in Euclidean space, you can swap out the standard Euclidean metric with metrics like the [Manhattan metric](http://en.wikipedia.org/wiki/Taxicab_geometry), the [maximum metric](http://en.wikipedia.org/wiki/Maximum_metric), the [discrete metric](http://mathworld.wolfram.com/DiscreteMetric.html), or your [mother's favorite](http://en.wikipedia.org/wiki/Lp_norm#The_p-norm_in_finite_dimensions) $L^p$ [norm](http://en.wikipedia.org/wiki/Lp_norm#The_p-norm_in_finite_dimensions).

While we use a metric for elementwise comparisons in the algorithm above, the reader must note that the dynamic time warping distance _is not a [metric](http://en.wikipedia.org/wiki/Metric_(mathematics)#Definition)! _In fact, it's quite far from a metric. The casual reader can easily come up with an example of two non-identical sequences $x, y$ for which $DTW(x,y) = 0$, hence denying positive-definiteness. The more intrepid reader will come up with three sequences which give a counterexample to satisfy the triangle inequality (hint: using the [discrete metric](http://mathworld.wolfram.com/DiscreteMetric.html) as the local comparison metric makes things easier).

In fact, the failure to satisfy positive-definiteness and the triangle inequality means that the dynamic time warping "distance" is not even a [semimetric](http://en.wikipedia.org/wiki/Metric_(mathematics)#Semimetrics). To be completely pedantic, it would fit in as a symmetric [premetric](http://en.wikipedia.org/wiki/Metric_(mathematics)#Premetrics). Unfortunately, this means that we don't get the benefits of geometry or topology to analyze dynamic time warping as a characteristic feature of the space of all numeric sequences. In any event, it's still proven to be useful in applications, so it belongs here in the program gallery.
