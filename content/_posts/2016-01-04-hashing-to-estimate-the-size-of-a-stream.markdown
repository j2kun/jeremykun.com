---
author: jeremykun
date: 2016-01-04 15:00:37+00:00
draft: false
title: Hashing to Estimate the Size of a Stream
type: post
url: /2016/01/04/hashing-to-estimate-the-size-of-a-stream/
categories:
- Algorithms
- Combinatorics
- Discrete
- Group Theory
- Probability
tags:
- approximation algorithms
- hashing
- mathematics
- programming
- python
- sublinear algorithms
---

**Problem: **Estimate the number of distinct items in a data stream that is too large to fit in memory.

**Solution: **(in python)

{{< highlight python >}}
import random

def randomHash(modulus):
   a, b = random.randint(0,modulus-1), random.randint(0,modulus-1)
   def f(x):
      return (a*x + b) % modulus
   return f

def average(L):
   return sum(L) / len(L)

def numDistinctElements(stream, numParallelHashes=10):
   modulus = 2**20
   hashes = [randomHash(modulus) for _ in range(numParallelHashes)]
   minima = [modulus] * numParallelHashes
   currentEstimate = 0

   for i in stream:
      hashValues = [h(i) for h in hashes]
      for i, newValue in enumerate(hashValues):
         if newValue < minima[i]:
            minima[i] = newValue

      currentEstimate = modulus / average(minima)

      yield currentEstimate
{{< /highlight >}}

**Discussion:** The technique used here is to use random hash functions. The central idea is the same as the general principle presented in [our recent post](http://jeremykun.com/2015/12/28/load-balancing-and-the-power-of-hashing/) on hashing for load balancing. In particular, if you have an algorithm that works under the assumption that the data is uniformly random, then the same algorithm will work (up to a good approximation) if you process the data through a randomly chosen hash function.

So if we assume the data in the stream consists of $N$ uniformly random real numbers between zero and one, what we would do is the following. Maintain a single number $x_{\textup{min}}$ representing the minimum element in the list, and update it every time we encounter a smaller number in the stream. A simple probability calculation or an argument by symmetry shows that the expected value of the minimum is $1/(N+1)$. So your estimate would be $1/(x_{\textup{min}}+1)$. (The extra +1 does not change much as we'll see.) One can spend some time thinking about the variance of this estimate (indeed, [our earlier post](http://jeremykun.com/2015/12/28/load-balancing-and-the-power-of-hashing/) is great guidance for how such a calculation would work), but since the data is not random we need to do more work. If the elements are actually integers between zero and $k$, then this estimate can be scaled by $k$ and everything basically works out the same.

Processing the data through a hash function $h$ chosen randomly from a 2-universal family (and we proved in the aforementioned post that this modulus thing is 2-universal) makes the outputs "essentially random" enough to have the above technique work with some small loss in accuracy. And to reduce variance, you can process the stream in parallel with many random hash functions. This rough sketch results in the code above. Indeed, before I state a formal theorem, let's see the above code in action. First on truly random data:

{{< highlight python >}}
S = [random.randint(1,2**20) for _ in range(10000)]

for k in range(10,301,10):
   for est in numDistinctElements(S, k):
      pass
   print(abs(est))

# output
18299.75567190227
7940.7497160166595
12034.154552410098
12387.19432959244
15205.56844547564
8409.913113220158
8057.99978043693
9987.627098464103
10313.862295081966
9084.872639057356
10952.745228373375
10360.569781803211
11022.469475216301
9741.250165892501
11474.896038520465
10538.452261306533
10068.793492995934
10100.266495424627
9780.532155130093
8806.382800033594
10354.11482578643
10001.59202254498
10623.87031408308
9400.404915767062
10710.246772348424
10210.087633885101
9943.64709187974
10459.610972568578
10159.60175069326
9213.120899718839
{{< /highlight >}}

As you can see the output is never off by more than a factor of 2. Now with "adversarial data."

{{< highlight python >}}
S = range(10000) #[random.randint(1,2**20) for _ in range(10000)]

for k in range(10,301,10):
   for est in numDistinctElements(S, k):
      pass
   print(abs(est))

# output

12192.744186046511
15935.80547112462
10167.188106011634
12977.425742574258
6454.364151175674
7405.197740112994
11247.367453263867
4261.854392115023
8453.228233608026
7706.717624577393
7582.891328643745
5152.918628936483
1996.9365093316926
8319.20208545846
3259.0787592465967
6812.252720480753
4975.796789951151
8456.258064516129
8851.10133724288
7317.348220516398
10527.871485943775
3999.76974425661
3696.2999065091117
8308.843106180666
6740.999794281012
8468.603733730935
5728.532232608959
5822.072220349402
6382.349459544548
8734.008940222673
{{< /highlight >}}

The estimates here are off by a factor of up to 5, and this estimate seems to get better as the number of hash functions used increases. The formal theorem is this:

**Theorem: **If $S$ is the set of distinct items in the stream and $n = |S|$ and $m > 100 n$, then with probability at least 2/3 the estimate $m / x_{\textup{min}}$ is between $n/6$ and $6n$.

We omit the proof (see below for references and better methods). As a quick analysis, since we're only storing a constant number of integers at any given step, the algorithm has space requirement $O(\log m) = O(\log n)$, and each step takes time polynomial in $\log(m)$ to update in each step (since we have to compute multiplication and modulus of $m$).

This method is just the first ripple in a lake of research on this topic. The general area is called "streaming algorithms," or "sublinear algorithms." This particular problem, called _cardinality estimation_, is related to a family of problems called _estimating frequency moments. _The literature gets pretty involved in the various tradeoffs between space requirements and processing time per stream element.

As far as estimating cardinality goes, the first major results were due to Flajolet and Martin in 1983, where they provided [a slightly more involved version](https://en.wikipedia.org/wiki/Flajolet%E2%80%93Martin_algorithm) of the above algorithm, which uses logarithmic space.

[Later revisions](http://hci.iwr.uni-heidelberg.de/Staff/ukoethe/lehre/AlgorithmsForBigData/durand_03_loglog-counting.pdf) to the algorithm (2003) got the space requirement down to $O(\log \log n)$, which is exponentially better than our solution. And further tweaks and analysis improved the variance bounds to something like a multiplicative factor of $\sqrt{m}$. This is called the [HyperLogLog](http://algo.inria.fr/flajolet/Publications/FlFuGaMe07.pdf) algorithm, and it has been [tested in practice at Google](http://research.google.com/pubs/pub40671.html).

Finally, a theoretically optimal algorithm (achieving an arbitrarily good estimate with logarithmic space) was presented and analyzed by [Kane et al in 2010](http://dl.acm.org/citation.cfm?doid=1807085.1807094).
