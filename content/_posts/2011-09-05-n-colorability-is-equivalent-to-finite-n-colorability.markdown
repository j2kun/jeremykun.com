---
author: jeremykun
date: 2011-09-05 03:41:27+00:00
draft: false
title: n-Colorability is Equivalent to Finite n-Colorability (A Formal Logic Proof)
type: post
url: /2011/09/04/n-colorability-is-equivalent-to-finite-n-colorability/
categories:
- Graph Theory
- Logic
- Proof Gallery
tags:
- graph coloring
---

_Warning: this proof requires a bit of familiarity with the terminology of propositional logic _and_ graph theory._

**Problem**: Let $G$ be an infinite graph. Show that $G$ is $n$-colorable if and only if every finite subgraph $G_0 \subset G$ is $n$-colorable.

**Solution**: One of the many equivalent versions of the Compactness Theorem for the propositional calculus states that if $\Sigma \subset \textup{Prop}(A)$, where $A$ is a set of propositional atoms, then $\Sigma$ is satisfiable if and only if any finite subset of $\Sigma$ is satisfiable. (Recall that a set of propositions is satisfiable if for some truth valuation $t:A \to \left \{ 0,1 \right \}$ the unique extension $\hat{t}:\Sigma \to \left \{ 0,1 \right \}$ satisfies $\hat{t}(p) = 1$ for all $p \in \Sigma$. The function $t$ is called a _model_ for $\Sigma$). This is equivalent to the Completeness Theorem, which says that if one can use $\Sigma$ to prove $p$, then every model of $\Sigma$ satisfies $\hat{t}(p) = 1$. Both are fundamental results in logic.

And so we will convert this graph coloring problem into a logical set of propositions, and use the Compactness Theorem against it. We want a set of propositions $\Sigma$ which has a model if and only if the corresponding graph is n-colorable. Then we will use the n-colorability of finite subgraphs, to show that all finite subsets of $\Sigma$ have models, and this implies by the compactness theorem that $\Sigma$ has a model, so the original infinite graph is n-colorable.

We may think of a coloring of a graph $G$ as a function on the set of vertices: $c:V \to \left \{ 1, 2, \dots, n \right \}$. Define our set of propositional atoms as $A = V \times \left \{ 1, 2, \dots, n \right \}$. In other words, we identify a proposition $p_{v,i}$ to each vertex and possible color. So we will define three sets of propositions using these atoms, which codify the conditions of a valid coloring:



	  * $\left \{ p_{v,1} \vee p_{v,2} \vee \dots \vee p_{v,n} : v \in V \right \}$ i.e. every vertex must have some color,
	  * $\left \{ \lnot (p_{v,i} \wedge p_{v,j}) : i,j = 1, \dots, n, i \neq j, v \in V \right \}$ i.e. no vertex may have two colors, and
	  * $\left \{ \lnot (p_{v,i} \wedge p_{w,i}) : \textup{whenever } (v,w) \textup{ is an edge in } G \right \}$ i.e. no two adjacent vertices may have the same color.

Let $\Sigma$ be the union of the above three sets. Take $\Sigma_0 \subset \Sigma$ to be any finite set of the above propositions. Let $V_0$ be the finite subset of vertices of $G$ which are involved in some proposition of $\Sigma_0$ (i.e., $p_{v,i} \in \Sigma_0$ if and only if $v \in V_0$). Since every proposition involves finitely many atoms, $V_0$ is finite, and hence the subgraph of vertices of $V_0$ is n-colorable, with some coloring $c: V_0 \to \left \{ 1, 2, \dots, n \right \}$. We claim that this $c$ induces a model on $\Sigma_0$.

Define a valuation $t:A \to \left \{ 0,1 \right \}$ as follows. If $v \notin V_0$, then we (arbitrarily) choose $t(p_{v,i}) = 1$. If $v \in V_0$ and $c(v) = i$ then $t(p_{v,1}) = 1$. Finally, if $v \in V_0$ and $c(v) \neq i$ then $t(p_{v,i} = 0)$.

Clearly each of the possible propositions in the above three sets is true under the extension $\hat{t}$, and so $\Sigma_0$ has a model. Since $\Sigma_0$ was arbitrary, $\Sigma$ is finitely satisfiable. So by the Compactness Theorem, $\Sigma$ is satisfiable, and any model $s$ for $\Sigma$ gives a valid graph coloring, simply by choosing $i$ such that the proposition $p_{v,i}$ satisfies $s(p_{v,i}) = 1$. Our construction forces that such a proposition exists, and hence $G$ is n-colorable. $_\square$.

Note that without translating this into a logical system, we would be left with the mess of combining n-colorable finite graphs into larger n-colorable finite graphs. The number of cases we imagine encountering are mind-boggling. Indeed, there is probably a not-so-awkward graph theoretical approach to this problem, but this proof exemplifies the elegance that occurs when two different fields of math interact.
