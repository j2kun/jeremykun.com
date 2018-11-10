---
author: alelkes
date: 2014-03-03 16:00:38+00:00
draft: false
title: Martingales and the Optional Stopping Theorem
type: post
url: /2014/03/03/martingales-and-the-optional-stopping-theorem/
categories:
- Discrete
- Primers
- Probability Theory
tags:
- 2-sat
- conditional probability
- expectation
- gambling
- martingales
- mathematics
- optional stopping theorem
- primer
- random variables
- randomized algorithm
- stochastic processes
---

_This is a guest post by my colleague [Adam Lelkes](http://homepages.math.uic.edu/~alelkes/)._

The goal of this primer is to introduce an important and beautiful tool from probability theory, a model of fair betting games called martingales. In this post I will assume that the reader is familiar with the basics of probability theory. For those that need to refresh their knowledge, Jeremy's excellent primers ([1](http://jeremykun.com/2013/01/04/probability-theory-a-primer/), [2](http://jeremykun.com/2013/03/28/conditional-partitioned-probability-a-primer/)) are a good place to start.


## The Geometric Distribution and the ABRACADABRA Problem


Before we start playing with martingales, let's start with an easy exercise. Consider the following experiment: we throw an ordinary die repeatedly until the first time a six appears. How many throws will this take in expectation? The reader might recognize immediately that this exercise can be easily solved using the basic properties of the geometric distribution, which models this experiment exactly. We have independent trials, every trial succeeding with some fixed probability $p$. If $X$ denotes the number of trials needed to get the first success, then clearly $\Pr(X = k) = (1-p)^{k-1} p$ (since first we need $k-1$ failures which occur independently with probability $1-p$, then we need one success which happens with probability $p$). Thus the expected value of $X$ is


$\displaystyle E(X) = \sum_{k=1}^\infty k P(X = k) = \sum_{k=1}^\infty k (1-p)^{k-1} p = \frac1p$


by basic calculus. In particular, if success is defined as getting a six, then $p=1/6$ thus the expected time is $1/p=6$.

Now let us move on to a somewhat similar, but more interesting and difficult problem, the ABRACADABRA problem. Here we need two things for our experiment, a monkey and a typewriter. The monkey is asked to start bashing random keys on a typewriter. For simplicity's sake, we assume that the typewriter has exactly 26 keys corresponding to the 26 letters of the English alphabet and the monkey hits each key with equal probability. There is a famous theorem in probability, the infinite monkey theorem, that states that given infinite time, our monkey will almost surely type the complete works of William Shakespeare. Unfortunately, according to astronomists the sun will begin to die in a few billion years, and the expected time we need to wait until a monkey types the complete works of William Shakespeare is orders of magnitude longer, so it is not feasible to use monkeys to produce works of literature.

So let's scale down our goals, and let's just wait until our monkey types the word ABRACADABRA. What is the expected time we need to wait until this happens? The reader's first idea might be to use the geometric distribution again. ABRACADABRA is eleven letters long, the probability of getting one letter right is $\frac{1}{26}$, thus the probability of a random eleven-letter word being ABRACADABRA is exactly $\left(\frac{1}{26}\right)^{11}$. So if typing 11 letters is one trial, the expected number of trials is


$\displaystyle \frac1{\left(\frac{1}{26}\right)^{11}}=26^{11}$


which means $11\cdot 26^{11}$ keystrokes, right?

Well, not exactly. The problem is that we broke up our random string into eleven-letter blocks and waited until one block was ABRACADABRA. However, this word can start in the middle of a block. In other words, we considered a string a success only if the starting position of the word ABRACADABRA was divisible by 11. For example, FRZUNWRQXKLABRACADABRA would be recognized as success by this model but the same would not be true for AABRACADABRA. However, it is at least clear from this observation that $11\cdot 26^{11}$ is a strict upper bound for the expected waiting time. To find the exact solution, we need one very clever idea, which is the following:


## Let's Open a Casino!


Do I mean that abandoning our monkey and typewriter and investing our time and money in a casino is a better idea, at least in financial terms? This might indeed be the case, but here we will use a casino to determine the expected wait time for the ABRACADABRA problem. Unfortunately we won't make any money along the way (in expectation) since our casino will be a fair one.

Let's do the following thought experiment: let's open a casino next to our typewriter. Before each keystroke, a new gambler comes to our casino and bets $1 that the next letter will be A. If he loses, he goes home disappointed. If he wins, he bets all the money he won on the event that the next letter will be B. Again, if he loses, he goes home disappointed. (This won't wreak havoc on his financial situation, though, as he only loses $1 of his own money.) If he wins again, he bets all the money on the event that the next letter will be R, and so on.

If a gambler wins, how much does he win? We said that the casino would be fair, i.e. the expected outcome should be zero. That means that it the gambler bets $1, he should receive $26 if he wins, since the probability of getting the next letter right is exactly $\frac{1}{26}$ (thus the expected value of the change in the gambler's fortune is $\frac{25}{26}\cdot (-1) + \frac{1}{26}\cdot (+25) = 0$.

Let's keep playing this game until the word ABRACADABRA first appears and let's denote the number of keystrokes up to this time as $T$. As soon as we see this word, we close our casino. How much was the revenue of our casino then? Remember that before each keystroke, a new gambler comes in and bets $1, and if he wins, he will only bet the money he has received so far, so our revenue will be exactly $T$ dollars.

How much will we have to pay for the winners? Note that the only winners in the last round are the players who bet on A. How many of them are there? There is one that just came in before the last keystroke and this was his first bet. He wins $26. There was one who came three keystrokes earlier and he made four successful bets (ABRA). He wins $\$26^4$. Finally there is the luckiest gambler who went through the whole ABRACADABRA sequence, his prize will be $\$26^{11}$. Thus our casino will have to give out $26^{11}+26^4+26$ dollars in total, which is just under the price of 200,000 WhatsApp acquisitions.

Now we will make one crucial observation: even at the time when we close the casino, the casino is fair! Thus in expectation our expenses will be equal to our income. Our income is $T$ dollars, the expected value of our expenses is $26^{11}+26^4+26$ dollars, thus $E(T)=26^{11}+26^4+26$. A beautiful solution, isn't it? So if our monkey types at 150 characters per minute on average, we will have to wait around 47 million years until we see ABRACADABRA. Oh well.


## Time to be More Formal


After giving an intuitive outline of the solution, it is time to formalize the concepts that we used, to translate our fairy tales into mathematics. The mathematical model of the fair casino is called a martingale, named after a class of betting strategies that enjoyed popularity in 18th century France. The gambler's fortune (or the casino's, depending on our viewpoint) can be modeled with a sequence of random variables. $X_0$ will denote the gambler's fortune before the game starts, $X_1$ the fortune after one round and so on. Such a sequence of random variables is called a _stochastic process_. We will require the expected value of the gambler's fortune to be always finite.

How can we formalize the fairness of the game? Fairness means that the gambler's fortune does not change in expectation, i.e. the expected value of $X_n$, given $X_1, X_2, \ldots, X_{n-1}$ is the same as $X_{n-1}$. This can be written as $E(X_n | X_1, X_2, \ldots, X_{n-1}) = X_{n-1}$ or, equivalently, $E(X_n - X_{n-1} | X_1, X_2, \ldots, X_{n-1}) = 0$.

The reader might be less comfortable with the first formulation. What does it mean, after all, that the conditional expected value of a random variable is another random variable? Shouldn't the expected value be a number? The answer is that in order to have solid theoretical foundations for the definition of a martingale, we need a more sophisticated notion of conditional expectations. Such sophistication involves measure theory, which is outside the scope of this post. We will instead naively accept the definition above, and the reader can look up all the formal details in any serious probability text (such as [1]).

Clearly the fair casino we constructed for the ABRACADABRA exercise is an example of a martingale. Another example is the simple symmetric random walk on the number line: we start at 0, toss a coin in each step, and move one step in the positive or negative direction based on the outcome of our coin toss.


## The Optional Stopping Theorem


Remember that we closed our casino as soon as the word ABRACADABRA appeared and we claimed that our casino was also fair at that time. In mathematical language, the closed casino is called a stopped martingale. The stopped martingale is constructed as follows: we wait until our martingale X exhibits a certain behaviour (e.g. the word ABRACADABRA is typed by the monkey), and we define a new martingale X' as follows: let $X'_n = X_n$ if $n < T$ and $X'_n = X_T$ if $n \ge T$ where $T$ denotes the stopping time, i.e. the time at which the desired event occurs. Notice that $T$ itself is a random variable.

We require our stopping time $T$ to depend only on the past, i.e. that at any time we should be able to decide whether the event that we are waiting for has already happened or not (without looking into the future). This is a very reasonable requirement. If we could look into the future, we could obviously cheat by closing our casino just before some gambler would win a huge prize.

We said that the expected wealth of the casino at the stopping time is the same as the initial wealth. This is guaranteed by Doob's optional stopping theorem, which states that under certain conditions, the expected value of a martingale at the stopping time is equal to its expected initial value.

**Theorem: **(Doob's optional stopping theorem) Let $X_n$ be a martingale stopped at step $T$, and suppose one of the following three conditions hold:



	  1. The stopping time $T$ is almost surely bounded by some constant;
	  2. The stopping time $T$ is almost surely finite and every step of the stopped martingale $X_n$ is almost surely bounded by some constant; or
	  3. The expected stopping time $E(T)$ is finite and the absolute value of the martingale increments $|X_n-X_{n-1}|$ are almost surely bounded by a constant.

Then $E(X_T) = E(X_0).$

We omit the proof because it requires measure theory, but the interested reader can see it [in these notes](http://www.math.dartmouth.edu/~pw/math100w13/lalonde.pdf).

For applications, (1) and (2) are the trivial cases. In the ABRACADABRA problem, the third condition holds: the expected stopping time is finite (in fact, we showed using the geometric distribution that it is less than $26^{12}$) and the absolute value of a martingale increment is either 1 or a net payoff which is bounded by $26^{11}+26^4+26$. This shows that our solution is indeed correct.


## Gambler's Ruin


Another famous application of martingales is the gambler's ruin problem. This problem models the following game: there are two players, the first player has $a$ dollars, the second player has $b$ dollars. In each round they toss a coin and the loser gives one dollar to the winner. The game ends when one of the players runs out of money. There are two obvious questions: (1) what is the probability that the first player wins and (2) how long will the game take in expectation?

Let $X_n$ denote the change in the second player's fortune, and set $X_0 = 0$. Let $T_k$ denote the first time $s$ when $X_s = k$. Then our first question can be formalized as trying to determine $\Pr(T_{-b} < T_a)$. Let $t = \min \{ T_{-b}, T_a\}$. Clearly $t$ is a stopping time. By the optional stopping theorem we have that


$\displaystyle 0=E(X_0)=E(X_t)=-b\Pr(T_{-b} < T_a)+a(1-\Pr(T_{-b} < T_a))$


thus $\Pr(T_{-b} < T_a)=\frac{a}{a+b}$.

I would like to ask the reader to try to answer the second question. It is a little bit trickier than the first one, though, so here is a hint: $X_n^2-n$ is also a martingale (prove it), and applying the optional stopping theorem to it leads to the answer.


## A Randomized Algorithm for 2-SAT


The reader is probably familiar with [3-SAT](http://en.wikipedia.org/wiki/3SAT#3-satisfiability), the first problem shown to be [NP-complete](http://jeremykun.com/2012/02/23/p-vs-np-a-primer-and-a-proof-written-in-racket/). Recall that 3-SAT is the following problem: given a boolean formula in conjunctive normal form with at most three literals in each clause, decide whether there is a satisfying truth assignment. It is natural to ask if or why 3 is special, i.e. why don't we work with $k$-SAT for some $k \ne 3$ instead? Clearly the hardness of the problem is monotone increasing in $k$ since $k$-SAT is a special case of $(k+1)$-SAT. On the other hand, SAT (without any bound on the number of literals per clause) is clearly in NP, thus 3-SAT is just as hard as $k$-SAT for any $k>3$. So the only question is: what can we say about 2-SAT?

It turns out that 2-SAT is easier than satisfiability in general: 2-SAT is in P. There are many algorithms for solving 2-SAT. Here is one deterministic algorithm: associate a graph to the 2-SAT instance such that there is one vertex for each variable and each negated variable and the literals $x$ and $y$ are connected by a directed edge if there is a clause $(\bar x \lor y)$. Recall that $\bar x \lor y$ is equivalent to $x \implies y$, so the edges show the implications between the variables. Clearly the 2-SAT instance is not satisfiable if there is a variable x such that there are directed paths $x \to \bar x$ and $\bar x \to x$ (since $x \Leftrightarrow \bar x$ is always false). It can be shown that this is not only a sufficient but also a necessary condition for unsatisfiability, hence the 2-SAT instance is satisfiable if and only if there is are no such path. If there are directed paths from one vertex of a graph to another and vice versa then they are said to belong to the same _strongly connected component._ There are several graph algorithms for finding strongly connected components of directed graphs, the most well-known algorithms are all based on [depth-first search](http://jeremykun.com/2013/01/22/depth-and-breadth-first-search/).

Now we give a very simple randomized algorithm for 2-SAT (due to [Christos Papadimitriou](http://www.cs.berkeley.edu/~christos/) in a ['91 paper](http://www.cs.ubc.ca/~davet/ubcsat/algorithms/Papadimitriou91.pdf)): start with an arbitrary truth assignment and while there are unsatisfied clauses, pick one and flip the truth value of a random literal in it. Stop after $O(n^2)$ rounds where $n$ denotes the number of variables. Clearly if the formula is not satisfiable then nothing can go wrong, we will never find a satisfying truth assignment. If the formula is satisfiable, we want to argue that with high probability we will find a satisfying truth assignment in $O(n^2)$ steps.

The idea of the proof is the following: fix an arbitrary satisfying truth assignment and consider the Hamming distance of our current assignment from it. The _Hamming distance_ of two truth assignments (or in general, of two binary vectors) is the number of coordinates in which they differ. Since we flip one bit in every step, this Hamming distance changes by $\pm 1$ in every round. It also easy to see that in every step the distance is at least as likely to be decreased as to be increased (since we pick an unsatisfied clause, which means at least one of the two literals in the clause differs in value from the satisfying assignment).

Thus this is an unfair "gambler's ruin" problem where the gambler's fortune is the Hamming distance from the solution, and it decreases with probability at least $\frac{1}{2}$. Such a stochastic process is called a _supermartingale_ — and this is arguably a better model for real-life casinos. (If we flip the inequality, the stochastic process we get is called a _submartingale_.) Also, in this case the gambler's fortune (the Hamming distance) cannot increase beyond $n$. We can also think of this process as a random walk on the set of integers: we start at some number and in each round we make one step to the left or to the right with some probability. If we use random walk terminology, 0 is called an _absorbing barrier_ since we stop the process when we reach 0. The number $n$, on the other hand, is called a _reflecting barrier:_ we cannot reach $n+1$, and whenever we get close we always bounce back.

There is an equivalent version of the optimal stopping theorem for supermartingales and submartingales, where the conditions are the same but the consequence holds with an inequality instead of equality. It follows from the optional stopping theorem that the gambler will be ruined (i.e. a satisfying truth assignment will be found) in $O(n^2)$ steps with high probability.

[1] For a reference on stochastic processes and martingales, see [the text of Durrett](http://www.amazon.com/Probability-Cambridge-Statistical-Probabilistic-Mathematics/dp/0521765390) ↑.
