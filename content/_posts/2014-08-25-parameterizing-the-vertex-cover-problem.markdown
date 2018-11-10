---
author: jeremykun
date: 2014-08-25 11:50:11+00:00
draft: false
title: Parameterizing the Vertex Cover Problem
type: post
url: /2014/08/25/parameterizing-the-vertex-cover-problem/
categories:
- Algorithms
- Computing Theory
- Graph Theory
tags:
- complexity theory
- computational complexity
- conferences
- fixed parameter tractability
- kernelization
- vertex cover
---

I'm presenting [a paper](http://arxiv.org/abs/1402.4376) later this week at the [Matheamtical Foundations of Computer Science 2014](http://www.inf.u-szeged.hu/mfcs2014/) in Budapest, Hungary. This conference is an interesting mix of logic and algorithms that aims to bring together researchers from these areas to discuss their work. And right away the first session on the first day focused on an area I know is important but have little experience with: fixed parameter complexity. From what I understand it's not that popular of a topic at major theory conferences in the US (there appears to be only one paper on it [at this year's FOCS conference](http://www.boazbarak.org/focs14/accepted.html)), but the basic ideas are worth knowing.

The basic idea is pretty simple: some hard computational problems become easier (read, polynomial-time solvable) if you fix some parameters involved to constants. Preferably small constants. For example, finding cliques of size $k$ in a graph is NP-hard if $k$ is a parameter, but if you fix $k$ to a constant then you can check all possible subsets of size $k$ in $O(n^k)$ time. This is kind of a silly example because there are much faster ways to find triangles than checking all $O(n^3)$ subsets of vertices, but part of the point of fixed-parameter complexity is to find the fastest algorithms in these fixed-parameter settings. Since in practice parameters are often small [[citation needed]](http://xkcd.com/285/), this analysis can provide useful practical algorithmic alternatives to heuristics or approximate solutions.

One important tool in the theory of fixed-parameter tractability is the idea of a kernel. I think it's an unfortunate term because it's massively [overloaded in mathematics](http://en.wikipedia.org/wiki/Kernel), but the idea is to take a problem instance with the parameter $k$, and carve out "easy" regions of the instance (often reducing $k$ as you go) until the runtime of the trivial brute force algorithm only depends on $k$ and not on the size of the input. The point is that the solution you get on this "carved out" instance is either the same as the original, or can be extended back to the original with little extra work. There is a more formal definition we'll state, but there is a canonical example that gives a great illustration.

Consider the vertex cover problem. That is, you give me a graph $G = (V,E)$ and a number $k$ and I have to determine if there is a subset of $\leq k$ vertices of $G$ that touch all of the edges in $E$. This problem is fixed-parameter tractable because, as with $k$-clique one can just check all subsets of size $k$. The kernel approach we'll show now is much smarter.

What you do is the following. As long as your graph has a vertex of degree $> k$, you remove it and reduce $k$ by 1. This is because a vertex of degree $> k$ will always be chosen for a vertex cover. If it's not, then you need to include all of its neighbors to cover its edges, but there are $> k$ neighbors and your vertex cover is constrained by size $k$. And so you can automatically put this high-degree vertex in your cover, and use induction on the smaller graph.

Once you can't remove any more vertices there are two cases. In the case that there are more than $k^2$ edges, you output that there is no vertex cover. Indeed, if you only get $k$ vertices in your cover and you removed all vertices of degree $> k$, then each can cover at most $k$ edges, giving a total of at most $k^2$. Otherwise, if there are at most $k^2$ edges, then you can remove all the isolated vertices and show that there are only $\leq 2k^2$ vertices left. This is because each edge touches only two vertices, so in the worst case they're all distinct. This smaller subgraph is called a _kernel_ of the vertex cover, and the fact that its size depends only on $k$ is the key. So you can look at all $2^{2k^2} = O(1)$ subsets to determine if there's a cover of the size you want. If you find a cover of the kernel, you add back in all the large-degree vertices you deleted and you're done.

Now, even for small $k$ this is a pretty bad algorithm ($k=5$ gives $2^{50}$ subsets to inspect), but with more detailed analysis you can do significantly better. In particular, the best known bound reduces vertex cover to a kernel of size $2k - c \log(k)$ vertices for any constant $c$ you specify. Getting $\log(k)$ vertices is known to imply P = NP, and with more detailed complexity assumptions it's even hard to get a graph with fewer than $O(k^{2-\varepsilon})$ _edges_ for any $\varepsilon > 0$. These are all relatively recent results whose associated papers I have not read.

Even with these hardness results, there are two reasons why this kind of analysis is useful. The first is that it gives us a clearer picture of the complexity of these problems. In particular, the reduction we showed for vertex cover gives a time $O(2^{2k^2} + n + m)$-time algorithm, which you can then compare directly to the trivial $O(n^k)$ time brute force algorithm and measure the difference. Indeed, if $k = o(\sqrt{(k/2) log(n)})$ then the kernelized approach is faster.

The second reason is that the kernel approach usually results in simple and quick checks for _negative_ answers to a problem. In particular, if you want to check for $k$-sized set covers in a graph in the real world, this analysis shows that the first thing you should do is check if the kernel has size $> k^2$. If so, you can immediately give a "no" answer. So useful kernels can provide insight into the structure of a problem that can be turned into heuristic tools even when it doesn't help you solve the problem exactly.

So now let's just see the prevailing definition of a "kernelization" of a problem. This comes from the [text of Downey and Fellows](http://www.springer.com/computer/theoretical+computer+science/book/978-0-387-94883-6).

**Definition: **A _kernelization_ of a parameterized problem $L$ (formally, a language where each string $x$ is paired with a positive integer $k$) is a $\textup{poly}(|x|, k)$-time algorithm that converts instances $(x,k)$ into instances $(x', k')$ with the following three properties.

	  * $(x,k)$ is a yes instance of $L$ if and only if $(x', k')$ is.
	  * $|x'| \leq f(k)$ for some computable function $f: \mathbb{N} \to \mathbb{N}$.
	  * $k' \leq g(k)$ for some computable function $g: \mathbb{N} \to \mathbb{N}$.

The output $(x', k')$ is called a _kernel_, and the problem is said to admit a _polynomial kernel_ if $f(k) = O(k^c)$ for some constant $c$.

So we showed that vertex cover admits a polynomial kernel (in fact, a quadratic one).

Now the nice theorem is that a problem is fixed-parameter tractable _if and only if_ it admits a polynomial kernel. Finding a kernel is conceptually easier because, like in vertex cover, it allows you to introduce additional assumptions on the structure of the instances you're working with. But more importantly from a theoretical standpoint, measuring the size and complexity of kernels for NP-hard problems gives us a way to discriminate among problems within NP. That and the chance to get some more practical tools for NP-hard problems makes parameterized complexity more interesting than it sounds at first.

Until next time!
