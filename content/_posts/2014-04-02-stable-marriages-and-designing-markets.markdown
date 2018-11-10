---
author: jeremykun
date: 2014-04-02 23:21:55+00:00
draft: false
title: Stable Marriages and Designing Markets
type: post
url: /2014/04/02/stable-marriages-and-designing-markets/
categories:
- Algorithms
- Computing Theory
- Discrete
- Graph Theory
- Optimization
tags:
- bipartite graphs
- economics
- matchings
- mathematics
- network science
- programming
- python
- stable marriage
---

Here is a fun puzzle. Suppose we have a group of 10 men and 10 women, and each of the men has sorted the women in order of their preference for marriage (that is, a man prefers to marry a woman earlier in his list over a woman later in the list). Likewise, each of the women has sorted the men in order of marriageability. We might ask if there is any way that we, the omniscient cupids of love, can decide who should marry to make everyone happy.

Of course, the word happy is entirely imprecise. The mathematician balks at the prospect of leaving such terms undefined! In this case, it's quite obvious that not everyone will get their first pick. Indeed, if even two women prefer the same man someone will have to settle for less than their top choice. So if we define happiness in this naive way, the problem is obviously not solvable in general.

Now what if instead of aiming for each individual's maximum happiness we instead shoot for mutual contentedness? That is, what if "happiness" here means that nobody will ever have an incentive to cheat on their spouse? It turns out that for a mathematical version of this condition, we can always find a suitable set of marriages! These mathematical formalisms include some assumptions, such as that preferences never change and that no new individuals are added to the population. But it is nevertheless an impressive theorem that we can achieve stability no matter what everyone's preferences are. In this post we'll give the classical algorithm which constructs so-called "stable marriages," and we'll prove its correctness. Then we'll see a slight generalization of the algorithm, in which the marriages are "polygamous," and we'll apply it to the problem of assigning students to internships.

As usual, [all of the code](https://github.com/j2kun/stable-marriages) used in this post is available for download at [this blog's Github page](https://github.com/j2kun).


## Historical Notes


The original algorithm for computing stable marriages was discovered by [Lloyd Shapley](http://en.wikipedia.org/wiki/Lloyd_Shapley) and [David Gale](http://en.wikipedia.org/wiki/David_Gale) in the early 1960's. Shapely and [Alvin Roth](http://en.wikipedia.org/wiki/Alvin_E._Roth) went on to dedicate much of their career to designing markets and applying the stable marriage problem and its generalizations to such problems. In 2012 they jointly received the Nobel prize in economics for their work on this problem. If you want to know more about what "market design" means and why it's needed (and you have an hour to spare), consider watching the talk below by Alvin Roth at the Simons Institute's 2013 Symposium on the Visions of the Theory of Computing. Roth spends most of his time discussing the state of one particular economy, medical students and residence positions at hospitals, which he was asked to redesign. It's quite a fascinating tale, although some of the deeper remarks assume knowledge of the algorithm we cover in this post.


[youtube=http://www.youtube.com/watch?v=wvG5b2gmk70]


Alvin Roth went on to apply the ideas presented in the video to economic systems in Boston and New York City public schools, kidney exchanges, and others. They all had the same sort of structure: both parties have preferences and stability makes sense. So he actually imposed the protocol we're about to describe in order to guarantee that the process terminates to a stable arrangement (and automating it saves everyone involved a lot of time, stress, and money! Watch the video above for more on that).


## The Monogamous Stable Marriage Algorithm


Let's formally set up the problem. Let $X = \left \{ 1, 2, \dots, n \right \}$ be a set of $n$ suitors and $Y = \left \{ 1,2,\dots ,n \right \}$ be a set of $n$ "suited." Let $\textup{pref}_{X \to Y}: X \to S_n$ be a list of preferences for the suitors. In words, $\textup{pref}_{X \to Y}$ accepts as input a suitor, and produces as output an ordering on the suited members of $Y$. We denote the output set as $S_n$, which the group theory folks will recognize as the permutation group on $1, \dots, n$. Likewise, there is a function $\textup{pref}_{Y \to X}: Y \to S_n$ describing the preferences of each of the suited.

An example will help clarify these stuffy definitions. If $X = \left \{ 1, 2, 3 \right \}$ and $Y = \left \{ 1, 2, 3 \right \}$, then to say that


$\textup{pref}_{X \to Y}(2) = (3, 1, 2)$




is to say that the second suitor prefers the third member of $Y$ the most, and then the first member of $Y$, and then the second. The programmer might imagine that the datum of the problem consists of two dictionaries (one for $X$ and one for $Y$) whose keys are integers and whose values are lists of integers which contain 1 through $n$ in some order.


A solution to the problem, then, is a way to match (or marry) suitors with suited. Specifically, a _matching _is a bijection $m: X \to Y$, so that $x$ is matched with $m(x)$. The reason we use a bijection is because the marriages are monogamous: only one suitor can be matched with one suited and vice versa. Later we'll see this condition dropped so we can apply it to a more realistic problem of institutions (suited) which can accommodate many applicants (suitors). Because suitor and suited are awkward to say, we'll use the familiar, antiquated, and politically incorrect terms "men and women."

Now if we're given a monogamous matching $m$, a pair $x \in X, y \in Y$ is called _unstable_ for $m$ if both $x,y$ prefer each other over their partners assigned by $m$. That is, $(x,y)$ is unstable for $m$ if $y$ appears before $m(y)$ in the preference list for $x$, $\textup{pref}_{X \to Y}(x)$, and likewise $x$ appears before $m^{-1}(y)$ in $\textup{pref}_{Y \to X}(y)$.

Another example to clarify: again let $X = Y = \left \{ 1,2,3 \right \}$ and suppose for simplicity that our matching $m$ pairs $m(i) = i$. If man 2 has the preference list $(3,2,1)$ and woman 3 has the preference list $(2,1,3)$, then 2 and 3 together form an unstable pair for $m$, because they would rather be with each other over their current partners. That is, they have a _mutual incentive_ to cheat on their spouses. We say that the matching is _unstable _or _admits an unstable pair_ if there are any unstable pairs for it, and we call the entire matching _stable_ if it doesn't admit any unstable pairs.

[caption id="attachment_4806" align="aligncenter" width="300"][![Unlike real life, mathematically unstable marriages need not have constant arguments.](http://jeremykun.files.wordpress.com/2014/04/unstable-marriage.jpg?w=300)
](http://jeremykun.files.wordpress.com/2014/04/unstable-marriage.jpg) Unlike real life, mathematically unstable marriages need not feature constant arguments.[/caption]

So the question at hand is: is there an algorithm which, given access to to the two sets of preferences, can efficiently produce a stable matching? We can also wonder whether a stable matching is guaranteed to exist, and the answer is yes. In fact, we'll prove this and produce an efficient algorithm in one fell swoop.

The central concept of the algorithm is called _deferred acceptance_. The gist is like this. The algorithm operates in rounds. During each round, each man will "propose" to a woman, and each woman will pick the best proposal available. But the women will _not commit_ to their pick. They instead reject all other suitors, who go on to propose to their second choices in the next round. At that stage each woman (who now may have a more preferred suitor than in the first round) may replace her old pick with a new one. The process continues in this manner until each man is paired with a woman. In this way, each of the women defers accepting any proposal until the end of the round, progressively increasing the quality of her choice. Likewise, the men progressively propose less preferred matches as the rounds progress.

It's easy to argue such a process must eventually converge. Indeed, the contrary means there's some sort of cycle in the order of proposals, but each man proposes to only _strictly_ less preferred women than any previous round, and the women can only _strictly_ increase the quality of their held pick. Mathematically, we're using an important tool called _monotonicity_. That some quantity can only increase or decrease as time goes on, and since the quantity is bounded, we must eventually reach a local maximum. From there, we can prove that any local maximum satisfies the property we want (here, that the matching is stable), and we win. Indeed, supposing to the contrary that we have a pair $(x,y)$ which is unstable for the matching $m$ produced at the end of this process, then it must have been the case that $x$ proposed to $y$ in some earlier round. But $y$ has as her final match some other suitor $x' = m^{-1}(y)$ whom she prefers _less_ than $x$. Though she may have never picked $x$ at any point in the algorithm, she can only end up with the worse choice $x'$ if at some point $y$ chose a suitor that was less preferred than the suitor she already had. Since her choices are monotonic this cannot happen, so no unstable pairs can exist.

Rather than mathematically implement the algorithm in pseudocode, let's produce the entire algorithm in Python to make the ideas completely concrete.


## Python Implementation


We start off with some simple data definitions for the two parties which, in the renewed interest of generality, refer to as Suitor and Suited.

{{< highlight python >}}
class Suitor(object):
   def __init__(self, id, prefList):
      self.prefList = prefList
      self.rejections = 0 # num rejections is also the index of the next option
      self.id = id

   def preference(self):
      return self.prefList[self.rejections]

   def __repr__(self):
      return repr(self.id)
{{< /highlight >}}

A Suitor is simple enough: he has an `id` representing his "index" in the set of Suitors, and a preference list `prefList` which in its $i$-th position contains the Suitor's $i$-th most preferred Suited. This is identical to our mathematical representation from earlier, where a list like $(2,3,1)$ means that the Suitor prefers the second Suited most and the first Suited least. Knowing the algorithm ahead of time, we add an additional piece of data: the number of rejections the Suitor has seen so far. This will double as the index of the Suited that the Suitor is currently proposing to. Indeed, the `preference` function provides a thin layer of indirection allowing us to ignore the underlying representation, so long as one updates the number of rejections appropriately.

Now for the Suited.

{{< highlight python >}}
class Suited(object):
   def __init__(self, id, prefList):
      self.prefList = prefList
      self.held = None
      self.currentSuitors = set()
      self.id = id

   def __repr__(self):
      return repr(self.id)
{{< /highlight >}}

A Suited likewise has a list of preferences and an id, but in addition she has a `held` attribute for the currently held Suitor, and a list `currentSuitors` of Suitors that are currently proposing to her. Hence we can define a `reject` method which accepts no inputs, and returns a list of rejected suitors, while updating the woman's state to hold onto her most preferred suitor.

{{< highlight python >}}
   def reject(self):
      if len(self.currentSuitors) == 0:
         return set()

      if self.held is not None:
         self.currentSuitors.add(self.held)

      self.held = min(self.currentSuitors, key=lambda suitor: self.prefList.index(suitor.id))
      rejected = self.currentSuitors - set([self.held])
      self.currentSuitors = set()

      return rejected
{{< /highlight >}}

The call to `min` does all the work: finding the Suitor that appears first in her preference list. The rest is bookkeeping. Now the algorithm for finding a stable marriage, following the deferred acceptance algorithm, is simple.

{{< highlight python >}}
# monogamousStableMarriage: [Suitor], [Suited] -> {Suitor -> Suited}
# construct a stable (monogamous) marriage between suitors and suiteds
def monogamousStableMarriage(suitors, suiteds):
   unassigned = set(suitors)

   while len(unassigned) > 0:
      for suitor in unassigned:
         suiteds[suitor.preference()].currentSuitors.add(suitor)
      unassigned = set()

      for suited in suiteds:
         unassigned |= suited.reject()

      for suitor in unassigned:
         suitor.rejections += 1

   return dict([(suited.held, suited) for suited in suiteds])
{{< /highlight >}}

All the Suitors are unassigned to begin with. Each iteration of the loop corresponds to a round of the algorithm: the Suitors are added to the `currentSuitors` list of their next most preferred Suited. Then the Suiteds "simultaneously" reject some Suitors, whose rejection counts are upped by one and returned to the pool of unassigned Suitors. Once every Suited has held onto a Suitor we're done.

Given a matching, we can define a function that verifies by brute force that the marriage is stable.

{{< highlight python >}}
# verifyStable: [Suitor], [Suited], {Suitor -> Suited} -> bool
# check that the assignment of suitors to suited is a stable marriage
def verifyStable(suitors, suiteds, marriage):
   import itertools
   suitedToSuitor = dict((v,k) for (k,v) in marriage.items())
   precedes = lambda L, item1, item2: L.index(item1) < L.index(item2)

   def suitorPrefers(suitor, suited):
      return precedes(suitor.prefList, suited.id, marriage[suitor].id)

   def suitedPrefers(suited, suitor):
      return precedes(suited.prefList, suitor.id, suitedToSuitor[suited].id)

   for (suitor, suited) in itertools.product(suitors, suiteds):
      if suited != marriage[suitor] and suitorPrefers(suitor, suited) and suitedPrefers(suited, suitor):
         return False, (suitor.id, suited.id)

   return
{{< /highlight >}}

Indeed, we can test the algorithm on an instance of the problem.

{{< highlight python >}}
>>> suitors = [Suitor(0, [3,5,4,2,1,0]), Suitor(1, [2,3,1,0,4,5]),
...            Suitor(2, [5,2,1,0,3,4]), Suitor(3, [0,1,2,3,4,5]),
...            Suitor(4, [4,5,1,2,0,3]), Suitor(5, [0,1,2,3,4,5])]
>>> suiteds = [Suited(0, [3,5,4,2,1,0]), Suited(1, [2,3,1,0,4,5]),
...            Suited(2, [5,2,1,0,3,4]), Suited(3, [0,1,2,3,4,5]),
...            Suited(4, [4,5,1,2,0,3]), Suited(5, [0,1,2,3,4,5])]
>>> marriage = monogamousStableMarriage(suitors, suiteds)
{3: 0, 4: 4, 5: 1, 1: 2, 2: 5, 0: 3}
>>> verifyStable(suitors, suiteds, marriage)
True
{{< /highlight >}}

We encourage the reader to check this by hand (this one only took two rounds). Even better, answer the question of whether the algorithm could ever require $n$ steps to converge for $2n$ individuals, where you get to pick the preference list to try to make this scenario happen.


## Stable Marriages with Capacity


We can extend this algorithm to work for "polygamous" marriages in which one Suited can accept multiple Suitors. In fact, the two problems are entirely the same! Just imagine duplicating a Suited with large capacity into many Suiteds with capacity of 1. This particular reduction is not very efficient, but it allows us to see that the same proof of convergence and correctness applies. We can then modify our classes and algorithm to account for it, so that (for example) instead of a Suited "holding" a single Suitor, she holds a set of Suitors. We encourage the reader to try extending our code above to the polygamous case as an exercise, and we've provided the solution in [the code repository for this post](https://github.com/j2kun/stable-marriages) on [this blog's Github page](https://github.com/j2kun).


## Ways to Make it Harder


When you study algorithmic graph problems as much as I do, you start to get disheartened. It seems like every problem is NP-hard or worse. So when we get a situation like this, a nice, efficient algorithm with very real consequences and interpretations, you start to get very excited. In between our heaves of excitement, we imagine all the other versions of this problem that we could solve and Nobel prizes we could win. Unfortunately the landscape is bleaker than that, and most extensions of stable marriage problems are NP-complete.

For example, what if we allow ties? That is, one man can be equally happy with two women. [This is NP-complete](http://arxiv.org/abs/1308.4064). However, it turns out his extension can be formulated as an integer programming problem, and standard optimization techniques can be used to approximate a solution.

What if, thinking about the problem in terms of medical students and residencies, we allow people to pick their preferences as couples? Some med students are married, after all, and prefer to be close to their spouse even if it means they have a less preferred residency. NP-hard again. See page 53 (pdf page 71) of [these notes](http://opim.wharton.upenn.edu/~sok/papers/g/B-51097%20The%20Stable%20Marriage%20Problem%20Structure%20and%20Algorithms.pdf) for a more detailed investigation. The problem is essentially that there is not always a stable matching, and so even determining whether there is one is NP-complete.

So there are a lot of ways to enrich the problem, and there's an interesting line between tractable and hard in the worst case. As a (relatively difficult) exercise, try to solve the "roommates" version of the problem, where there is no male/female distinction (anyone can be matched with anyone). It turns out to have a tractable solution, and the algorithm is similar to the one outlined in this post.

Until next time!

PS. I originally wrote this post about a year ago when I was contacted by someone in industry who agreed to provide some (anonymized) data listing the preferences of companies and interns applying to work at those companies. Not having heard from them for almost a year, I figure it's a waste to let this finished post collect dust at the risk of not having an interesting data set. But if you, dear reader, have any data you'd like to provide that fits into the framework of stable marriages, I'd love to feature your company/service on my blog (and solve the matching problem) in exchange for the data. The only caveat is that the data would have to be public, so you would have to anonymize it.
