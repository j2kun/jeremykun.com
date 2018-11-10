---
author: jeremykun
date: 2013-09-09 14:00:00+00:00
draft: false
title: Anti-Coordination Games and Stable Graph Colorings
type: post
url: /2013/09/09/anti-coordination-games-and-stable-graph-colorings/
categories:
- Combinatorics
- Computing Theory
- Game Theory
- Graph Theory
tags:
- anti-coordination
- games on graphs
- graph coloring
- np-completeness
---

## My First Paper


I'm pleased to announce that my first paper, titled "[Anti-Coordination Games and Stable Colorings](http://arxiv.org/abs/1308.3258)," has been accepted for publication! The venue is the [Symposium on Algorithmic Game Theory](http://algo.rwth-aachen.de/sagt2013/), which will take place in Aachen, Germany this October. A professor of mine once told me that everyone puts their first few publications on a pedestal, so I'll do my best to keep things down to earth by focusing on the contents of the paper and not my swirling cocktail of pride. The point of this post is to explain the results of my work to a non-research-level audience; the research level folks will likely feel more comfortable reading the paper itself. So here we'll spend significantly longer explaining the proofs and the concepts, and significantly less time on previous work.

I will assume familiarity with basic graph theory ([we have a gentle introduction to that here](http://jeremykun.com/2011/06/26/teaching-mathematics-graph-theory/)) and NP-completeness proofs (again, [see our primer](http://jeremykun.com/2012/02/23/p-vs-np-a-primer-and-a-proof-written-in-racket/)). We'll give a quick reminder about the latter when we get to it.


## Anti-Coordination Games on Graphs


The central question in the paper is how to find stable strategy profiles for anti-coordination games played on graphs. This section will flush out exactly what all of that means.

The easiest way to understand the game is in terms of fashion. Imagine there is a group of people. Every day they choose their outfits individually and interact with their friends. If any pair of friends happens to choose the same clothing, then they both suffer some embarrassment. We can alternatively say that whenever two friends anti-coordinate their outfits, they each get some kind of reward. If not being embarrassed is your kind of reward, then these really are equivalent. Not every pair of people are friends, so perhaps the most important aspect of this problem is how the particular friendship network considered affects their interactions. This kind of game is called an _anti-coordination game, _and the network of friends makes it a "game on a graph." We'll make this more rigorous shortly.

We can ask questions like, if everyone is acting independently and greedily will their choices converge over time to a single choice of outfit? If so how quickly? How much better could a centralized fashion-planner who knows the entire friendship network fare in choosing outfits? Is the problem of finding a best strategy for picking outfits computationally hard? What if some pairs of people want to coordinate their outfits and others don't? What if caring about another's fashion is only one-sided in some cases?

Already this problem is rooted in the theory of social networks, but the concept of an anti-coordination game played on a graph is quite broad, and the relevance of this model to the real world comes from the generality of a graph. For example, one may consider the trading networks of various countries; in this case not all countries are trading partners, and it is beneficial to produce different commodities than your trading partners so that you actually benefit from the interaction. Likewise, neighboring radio towers want to emit signals on differing wavelengths to minimize interference, and commuters want to pick different roadways to minimize traffic. These are all examples of this model which we're about to formalize.

In place of our "network of friends," the game entails a graph $G = (V,E)$ in which each player is represented by a vertex, and there is an edge between two vertices whenever the corresponding players are trying to anti-coordinate. We will use the terms player and vertex interchangeably. For now the graph is undirected, but later we will relax this assumption and work with directed graphs. In place of "outfits" we'll have a generic set of _strategies_ denoted by the numbers $1, \dots, k$, and each vertex will choose a strategy from this set. In one round of the game, each vertex $v$ chooses a strategy, and this defines a function $f : V \to \left \{ 1, \dots, k \right \}$ from the set of vertices to the set of strategies. Then the _payoff_ of a vertex $v$ in a round, which we denote $\mu_f(v)$, is the number of neighbors of $v$ which have chosen a different strategy than $v$. That is, it is


$\displaystyle \mu_f(v) = \sum_{(v,w) \in E} \mathbf{1}_{\left \{ f(v) \neq f(w) \right \}}$


Where $\mathbf{1}_{A}$ denotes the indicator function for the event $A$, which assumes a value of 1 when the event occurs and 0 otherwise. Here is an example of an instance of the game. We have three strategies, denoted by colors, and the payoff for the vertex labeled $v$ is three.

[![game-example](http://jeremykun.files.wordpress.com/2013/09/game-example.png)
](http://jeremykun.files.wordpress.com/2013/09/game-example.png)

If this game is played over many many rounds, we can ask if there is a so-called _Nash equilibrium_. That is, is there a choice of strategies for the players so that no single player will have an incentive to change in future rounds, assuming nobody else changes? We restrict even further to thinking about _pure strategy Nash equilibria_, which means there are no probabilistic choices made in choosing a strategy. Equivalently, a pure strategy equilibrium is just a choice of a strategy for each vertex which doesn't change across rounds. In terms of the graph, we call a strategy function $f$ which is a Nash equilibrium a _stable equilibrium_ (or, as will be made clear in the next paragraph, a _stable coloring_). It must satisfy the property that no vertex can increase its payoff by switching to a different strategy. So our question now becomes: how can we find a stable coloring which as good as possible for all players involved? Slightly more generally, we call a Nash equilibrium a _strictly stable equilibrium _(or a _strictly stable coloring)_ if every vertex would _strictly decrease_ its payoff by switching to another strategy. As opposed to a plain old stable coloring where one could have the same payoff by switching strategies, if any player tries to switch strategy then it will get a necessarily worse payoff. Though it's not at all clear now, we will see that this distinction is the difference between computational tractability and infeasibility.

We can see a very clear connection between this game and [graph coloring](http://jeremykun.com/2011/07/14/graph-coloring-or-proof-by-crayon/). Here an edge produces a payoff of 1 for each of its two vertices if and only if it's properly colored. And so if the strategy choice function $f$ is also a proper coloring, this will produce the largest possible payoff for all vertices in the graph. But it may not be the case that (for a fixed set of strategies) the graph is properly colorable, and we already know that finding a proper coloring with more than two colors is a computationally hard problem. So this isn't a viable avenue for solving our fashion game. In any case, the connection confuses us enough to interchangeably call the strategy choice function $f$ a _coloring _of $G$.

As an interesting side note, a slight variation of this game was actually tested on humans (with money as payoff!) to see how well they could do. Each human player was only shown the strategies of their neighbors, and received $5 for every round in which they collectively arrived at a proper coloring of the graph. See [this article in Science](http://www.cis.upenn.edu/~mkearns/papers/ScienceFinal.pdf) for more details.

Since our game allows for the presence of improperly colored edges, we could instead propose to find an assignment of colors to vertices which maximizes the sum of the payoffs of all players. In this vein, we define the _social welfare_ of a graph and a coloring, denoted $W(G,f)$, to be the sum of the payoffs for all vertices $\sum_v \mu_f(v)$. This is a natural quantity one wants to analyze. Unfortunately, even in the case of two strategies, this quantity is computationally difficult (NP-hard) to maximize. It's a version of the [MAX-CUT problem](http://en.wikipedia.org/wiki/Maximum_cut), in which we try to separate the graph into two sets $X, Y$ such that the largest number of edges crosses from $X$ to $Y$. The correspondence between the two problems is seen by having $X$ represent those vertices which get strategy 1 and $Y$ represent strategy 2.

So we can't hope to find an efficient algorithm maximizing social welfare. The next natural question is: can we find stable or strictly stable colorings at all? Will they even necessarily exist? The answers to these questions form the main results of our paper.


## An Algorithm for Stable Colorings, and the Price of Anarchy


It turns out that there is a very simple greedy algorithm for finding stable colorings of a graph. We state it in the form of a proposition. By stable $k$-coloring we mean a stable coloring of the graph with $k$ colors (strategies).

**Proposition: **For every graph $G$ and every $k \geq 1$, $G$ admits a stable $k$-coloring, and such a coloring can be found in polynomial time.

_Proof_. The proof operates by using the social welfare function as a so-called potential function. That is, a change in a player's strategy which results in a higher payoff results in a higher value of the social welfare function. It is easy to see why: if a player $v$ changes to a color that helps him, then it will result in more properly colored edges (adjacent to $v$) than there were before. This means that more of $v$'s neighbors receive an additional 1 unit of payoff than those that lost 1 as a result of $v$'s switch. We call a vertex which has the potential to improve its payoff _unhappy, _and one which cannot improve its payoff _happy_.

And so our algorithm to find a stable coloring simply finds some unhappy vertex, switches its color to the most uncommon color among its neighbors, and repeats the process until all vertices are happy. Indeed, this is a local maximum of the social welfare function, and the very definition of a stable coloring.


$\square$


So that was nice, but we might ask: how much worse is the social welfare arrived at by this algorithm than the optimal social welfare? How much do we stand to lose by accepting the condemnation of NP-hardness and settling for the greedy solution we found? More precisely, if we call $Q$ the set of stable colorings and $C$ the set of all possible colorings, what is the value of


$\displaystyle \frac{\max_{c' \in C} W(G, c')}{\min_{c \in Q} W(G, c)}$


This is a well-studied quantity in many games, called the [_price of anarchy_](http://en.wikipedia.org/wiki/Price_of_anarchy). The name comes from the thought: what do we stand to gain by having a central authority, who can see the entire network topology and decide what is best for us, manage our strategies? The alternative (anarchy) is to have each player in the game act as selfishly and rationally as possible without complete information.  It turns out that as the number of strategies grows large in our anti-coordination game, there is no price of anarchy. For our game this obviously depends on the choice of graph, but we know what it is and we formally state the result as a proposition:

**Proposition:** For any graph, the price of anarchy for the $k$ strategy anti-coordination game is at most $k/(k-1)$ and this value is actually achieved by some instances of the game.

_Proof._ The pigeonhole principle says that every vertex can always achieve at least a $(k-1)/k$ fraction of its maximum possible payoff. Specifically, if a vertex $v_i$ can't achieve a proper coloring, then every color must be accounted for among $v_i$'s neighbors. Choosing the minimally occurring color will give $v_i$ at least a payoff of $d_i(k-1)/k$ where $d_i$ is the number of neighbors of $v_i$. Since every stable coloring has to satisfy the condition that no vertex can do any better than the strategy it already has, even in the worst stable coloring every vertex already has chosen such a minority color. Since the maximum payoff is twice the number of edges $2 |E|$, and the sum of the degrees $\sum_i d_i = 2 |E|$, we have that the price of anarchy is at most


$\displaystyle \frac{2|E|}{\frac{k-1}{k} \sum_i d_i} = \frac{k}{k-1}$




Indeed, we can't do any better than this in general, because the following graph gives an example where the price of anarchy exactly meets this bound.




[caption id="attachment_3961" align="aligncenter" width="480"][![An instance of the anti-coordination game with 5 strategies which meets the upper bound on price of anarchy.](http://jeremykun.files.wordpress.com/2013/09/screen-shot-2013-09-05-at-8-03-40-pm.png)
](http://jeremykun.files.wordpress.com/2013/09/screen-shot-2013-09-05-at-8-03-40-pm.png) An instance of the anti-coordination game with 5 strategies which meets the upper bound on price of anarchy.[/caption]

This example can easily be generalized to work with arbitrary $k$. We leave the details as an exercise to the reader.


$\square$





## Strictly Stable Colorings are Hard to Find


Perhaps surprisingly, the relatively minor change of adding strictness is enough to make computability intractable. We'll give an explicit proof of this, but first let's recall what it means to be intractable.

Recall that a problem is in NP if there is an efficient (read, polynomial-time) algorithm which can verify a solution to the problem is actually a solution. For example, the problem of proper graph $k$-coloring is in NP, because if someone gives you a purported coloring all you have to do is verify that each of the $O(n^2)$ edges are properly colored. Similarly, the problem of strictly stable coloring is in NP; all one need do is verify that no choice of a different color for any vertex improves its payoff, and it is trivial to come up with an algorithm which checks this.

Next, call a problem $A$ NP-hard if a solution to $A$ allows you to solve _any _problem in NP. More formally, $A$ being NP-hard means that there is a _polynomial-time reduction_ from any problem in NP $B$ to $A$ in the following (rough) sense: there is a polynomial-time computable function (i.e. deterministic program) $f$ which takes inputs for $B$ and transforms them into inputs for $A$ such that:


$w$ is a solvable instance of $B$ is if and only if $f(w)$ is solvable for $A$.




This is not a completely formal definition (see [this primer on NP-completeness](http://jeremykun.com/2012/02/23/p-vs-np-a-primer-and-a-proof-written-in-racket/) for a more serious treatment), but it's good enough for this post. In order to prove a problem $C$ is NP-hard, all you need to do is come up with a polynomial-time reduction from a known NP-hard problem $A$ to your new problem $C$. The composition of the reduction used for $A$ can be composed with the reduction for $C$ to get a new reduction proving $C$ is NP-hard.




Finally, we call a problem NP-complete if it is both in NP and NP-hard. One natural question to ask is: if we don't already know of any NP-hard problems, how can we prove anything is NP-hard? The answer is: it's very hard, but it was done once and we don't need to do it again (but if you really want to, [see these notes](http://www.cs.ubc.ca/~condon/cpsc506-2005/lectures/lec3.pdf)). As a result, we have generated a huge list of problems that are NP-complete, and unless P = NP none of these algorithms have polynomial-time algorithms to solve them. We need two examples of NP-hard problems for this paper: graph coloring, and boolean satisfiability. Since we assume the reader is familiar with the former, we recall the latter.




Given a set of variables $x_i$, we can form a _boolean formula_ over those variables of the form $\varphi = C_1 \wedge C_2 \wedge \dots \wedge C_m$ where each _clause_ $C_i$ is a disjunction of three _literals_ (negated or unnegated variables). For example, $C_i = (x_2 \vee \bar{x_5} \vee \bar{x_9})$ might be one clause. Here interpret a formula as the $x_i$ having the value true or false, the horizontal bars denoting negation, the wedges $\wedge$ meaning "and" and the vees $\vee$ meaning "or." We call this particular form _conjunctive normal form_. A formula $\varphi$ is called _satisfiable _if there is a choice of true and false assignments to the variables which makes the entire logical formula true. The problem of determining whether there is any satisfying assignment of such a formula, called _3-SAT_, is NP-hard.




Going back to strictly stable equilibria and anti-coordination games, we will prove that the problem of determining whether a graph has a strictly stable coloring with $k$ colors is NP-hard. As a consequence, _finding_ such an equilibrium is NP-hard. Since the problem is also in NP, it is in fact NP-complete.




**Theorem: **For all $k \geq 2$, the problem of determining whether a graph $G$ has a strictly stable coloring with $k$ colors is NP-complete.




_Proof_.  The hardest case is $k =2$, but $k \geq 3$ is a nice warmup to understand how a reduction works, so we start there.




The $k \geq 3$ part works by reducing from graph coloring. That is, our reduction will take an input to the graph $k$-coloring problem (a graph $G$ whose $k$-colorability is in question) and we produce a graph $G'$ such that $G$ is $k$-colorable if and only if $G'$ has a strictly stable coloring with $k$ colors. Since graph coloring is hard for $k \geq 3$, this will prove our problem is NP-hard. More specifically, we will construct $G'$ in such a way that the strictly stable colorings also happen to be proper colorings! So finding a strictly stable coloring of $G'$ will immediately give us a proper coloring of $G$.




The construction of $G'$ is quite straightforward. We start with $G' = G$, and then for each edge $e = (u,v)$ we add a new subgraph which we call $H_e$ that looks like:




[![coloring-reduction-H-e](http://jeremykun.files.wordpress.com/2013/09/screen-shot-2013-09-05-at-8-41-13-pm.png)
](http://jeremykun.files.wordpress.com/2013/09/screen-shot-2013-09-05-at-8-41-13-pm.png)




By $K_{k-2}$ we mean the complete graph on $k-2$ vertices (all possible edges are present), and the vertices $u,v$ are adjacent to all vertices of the $H_e = K_{k-2}$ part. That is, the graph $H_e \cup \left \{ u,v \right \}$ is the complete graph on $k$ vertices. Now if the original graph $G$ was $k$-colorable, then we can use the same colors for the corresponding vertices in $G'$, and extend to a proper coloring (and hence a strictly stable equilibrium) of all of $G'$. Indeed, for any $H_e$ we can use one different color for each vertex of the $K_{k-2}$ part if we don't use either of the colors used for $u,v$, then we'll have a proper coloring.




On the other hand, if $G'$ has a strictly stable equilibrium, then no edge $e$ which originally came from $G$ can be improperly colored. If some edge $e = (u,v)$ were improperly colored, then there would be some vertex in the corresponding $H_e$ which is not strictly stable. To see this, notice that in the $k$ vertices among $H_e \cup \left \{ u,v \right \}$ there can be at most $k-1$ colors used, and so any vertex will always be able to switch to that color without hurting his payoff. That is, the coloring might be stable, but it won't be strictly so. So strictly stable colorings are the same as proper colorings, and we already see that the subgraph $G \subset G'$ is $k$-colorable, completing the reduction.




Well that was a bit of a cheap trick, but it shows the difficulty of working with strictly stable equilibria: preventing vertices from changing with no penalty is hard! What's worse is that it's still hard even if there are only two colors. The reduction here is a lot more complicated, so we'll give a sketch of how it works.




The reduction is from 3-SAT. So given a boolean formula $\varphi = C_1 \wedge \dots \wedge C_m$ we produce a graph $G$ so that $\varphi$ has a satisfying assignment if and only if $G$ has a strictly stable coloring with two colors. The principle part of the reduction is the following gadget which represents the logic inherent in a clause. We pulled the figure directly from our paper, since the caption gives a good explanation of how it works.




[![gadget-figure-k2](http://jeremykun.files.wordpress.com/2013/09/gadget-figure-k2.png)
](http://jeremykun.files.wordpress.com/2013/09/gadget-figure-k2.png)




To reiterate, the two "appendages" labeled by $x$ correspond to the literal $x$, and the choice of colors for these vertices correspond to truth assignments in $\varphi$. In particular, if the two vertices have the same color, then the literal is assigned true. Of course, we have to ensure that any $x$'s showing up in other clause gadgets agree, and any $\bar{x}$'s will have opposite truth values. That's what the following two gadgets do:




[caption id="attachment_3967" align="aligncenter" width="763"][![negationgadgets](http://jeremykun.files.wordpress.com/2013/09/negationgadgets.png)
](http://jeremykun.files.wordpress.com/2013/09/negationgadgets.png) The gadget on the left enforces x's to have the same truth assignment across gadgets (otherwise the center vertex won't be in strict equilibrium). The gadget on the right enforces two literals to be opposites.[/caption]

And if we stitch the clauses together in a particular way (using the two gadgets above) then we will guarantee consistency across all of the literals. All that's left to check is that the clauses do what they're supposed to. That is, we need it to be the case that if all of the literals in a clause gadget are "false," then we can't complete the coloring to be strictly stable, and otherwise we can. Indeed, the following diagram gives all possible cases of this up to symmetry:


[![clause-gadget-lemma-proof](http://jeremykun.files.wordpress.com/2013/09/clause-gadget-lemma-proof.png)
](http://jeremykun.files.wordpress.com/2013/09/clause-gadget-lemma-proof.png)




The last figure deserves an explanation: if the three literals are all false, then we can pick any color we wish for $v_1$, and its two remaining neighbors must both have the same color (or else $v_1$ is not in strict equilibrium). Call this color $a$, and using the same reasoning call the neighbors of $v_2$ and $v_3$ $b$ and $c$, respectively. Now by the pigeonhole principle, either $a=b, b=c,$ or $b=c$. Suppose without loss of generality that $a=b$, then the edge labeled $(a,b)$ will have the $a$ part not in strict equilibrium (it will have two neighbors of its same color and only one of the other color). This shows that no strict equilibrium can exist.




The reduction then works by taking a satisfying assignment for the variables, coloring the literals in $G$ appropriately, and extending to a strictly stable equilibrium of all of $G$. Conversely, if $G$ has a strictly stable coloring, then the literals must be consistent and each clause must be fully colorable, which the above diagram shows is the same as the clauses being satisfiable. So all of $\varphi$ is satisfiable and we're done (excluding a few additional details we describe in the paper).




$\square$





## Directed Graphs and Cooperation




That was the main result of our paper, but we go on to describe some interesting generalizations. Since this post is getting quite long, we'll just give a quick overview of the interesting parts.




The rest of the paper is dedicated to directed graphs, where we define the payoff of a directed edge $(u,v)$ to go to the $u$ player if $u$ and $v$ anti-coordinate, but $v$ gets nothing. Here the computational feasibility is even worse than it was in the undirected case, but the structure is noticeably more interesting. For the former, not only is in NP-hard to compute strictly stable colorings, it's even NP-hard to do so in the non-strict case! One large part of the reason for this is that stable colorings might not even exist: a directed 3-cycle has no stable equilibrium. We use this fact as a tool in our reductions to prove the following theorem.




**Theorem: ** For all $k \geq 2$, determining whether a directed graph has a stable $latex k$-coloring is NP-complete.




[See section 5 of our paper](http://arxiv.org/pdf/1308.3258v1.pdf) for a full proof.




To address the interesting structure that arises in the directed case, we observe that we can use a directed graph to _simulate_ the desire of one vertex to actually _cooperate _with another. To see this for two colors, instead of adding an edge $(u,v)$ we add a proxy edge $u'$ and directed edges $(u,u'), (u',v)$. To be in equilibrium, the proxy has no choice but to anti-coordinate with $v$, and this will give $u$ more incentive to cooperate with $v$ by anti-cooperating with its proxy. This can be extended to $k$ colors by using an appropriately (acyclically) directed copy of $K_{k-1}$.





## Thoughts, and Future Work


While the results in this paper are nice, and I'm particularly proud that I came up with a novel NP-hardness reduction, it is unfortunate that the only results in this paper were hardness results. Because of the ubiquity of NP-hard problems, it's far more impressive to have an algorithm which actually does something (approximate a good solution, do well under some relaxed assumption, do well in expectation with some randomness) than to prove something is NP-hard. To get an idea of the tone set by researchers, NP-hardness results are often called "negative" results (in the sense that they give a "no" answer to the question of whether there is an efficient algorithm) and finding an algorithm that does something is called a positive result. That being said the technique of using two separate vertices to represent a single literal in a reduction proof is a nice trick, and I have since used it in another research paper, so I'm happy with my work.

On the positive side, though, there is some interesting work to be done. We could look at varying types of payoff structures, where instead of a binary payoff it is a function of the colors involved (say, $|i - j|$. Another interesting direction is to consider distributed algorithms (where each player operates independently and in parallel) and see what kinds of approximations of the optimal payoff can be achieved in that setting. Yet another direction favored by a combinatorialist is to generalize the game to [hypergraphs](http://en.wikipedia.org/wiki/Hypergraph), which makes me wonder what type of payoff structure is appropriate (payoff of 1 for a rainbow edge? a non-monochromatic edge?). There is also some more work that can be done in inspecting the relationship between cooperation and anti-cooperation in the directed version. Though I don't have any immediate open questions about it, it's a very interesting phenomenon.

In any event, I'm currently scheduled to give three talks about the results in this paper (one at the conference venue in Germany, and two at my department's seminars). Here's to starting off my research career!
