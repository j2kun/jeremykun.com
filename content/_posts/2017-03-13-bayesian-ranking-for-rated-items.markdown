---
author: jeremykun
date: 2017-03-13 16:00:49+00:00
draft: false
title: Bayesian Ranking for Rated Items
type: post
url: /2017/03/13/bayesian-ranking-for-rated-items/
categories:
- Algorithms
- Probability
- Probability Theory
- Program Gallery
- Statistics
tags:
- conjugate prior
- Dirichlet distribution
- inference
- mathematics
- probability theory
- python
- ranking
- sorting
- statistics
---

**Problem:** You have a catalog of items with discrete ratings (thumbs up/thumbs down, or 5-star ratings, etc.), and you want to display them in the "right" order.

**Solution: **In Python

{{< highlight python >}}
'''
  score: [int], [int], [float] -&gt; float

  Return the expected value of the rating for an item with known
  ratings specified by `ratings`, prior belief specified by
  `rating_prior`, and a utility function specified by `rating_utility`,
  assuming the ratings are a multinomial distribution and the prior
  belief is a Dirichlet distribution.
'''
def score(self, ratings, rating_prior, rating_utility):
    ratings = [r + p for (r, p) in zip(ratings, rating_prior)]
    score = sum(r * u for (r, u) in zip(ratings, rating_utility))
    return score / sum(ratings)
{{< /highlight >}}

**Discussion: **This deceptively short solution can lead you on a long and winding path into the depths of statistics. I will do my best to give a short, clear version of the story.

As a working example I chose merely because I recently listened to a [related podcast](https://www.theallusionist.org/allusionist/covers-i), say you're selling mass-market romance novels—which, by all accounts, is a predictable genre. You have a list of books, each of which has been rated on a scale of 0-5 stars by some number of users. You want to display the top books first, so that time-constrained readers can experience the most titillating novels first, and newbies to the genre can get the best first time experience and be incentivized to buy more.

The setup required to arrive at the above code is the following, which I'll phrase as a story.

Users' feelings about a book, and subsequent votes, are independent draws from a known distribution (with unknown parameters). I will just call these distributions "discrete" distributions. So given a book and user, there is some unknown list $(p_0, p_1, p_2, p_3, p_4, p_5)$ of probabilities ($\sum_i p_i = 1$) for each possible rating a user could give for that book.

But how do users get these probabilities? In this story, the probabilities are the output of a randomized procedure that generates distributions. That modeling assumption is called a "Dirichlet prior," with _Dirichlet_ meaning it generates discrete distributions, and _prior _meaning it encodes domain-specific information (such as the fraction of 4-star ratings for a typical romance novel).

So the story is you have a book, and that book gets a Dirichlet distribution (unknown to us), and then when a user comes along they sample from the Dirichlet distribution to get a discrete distribution, which they then draw from to choose a rating. We observe the ratings, and we need to find the book's underlying Dirichlet. We start by assigning it some default Dirichlet (the prior) and update that Dirichlet as we observe new ratings. Some other assumptions:



	  1. Books are indistinguishable except in the parameters of their Dirichlet distribution.
	  2. The parameters of a book's Dirichlet distribution don't change over time, and inherently reflect the book's value.

So a Dirichlet distribution is a process that produces discrete distributions. For simplicity, in this post we will say a Dirichlet distribution is parameterized by a list of six integers $(n_0, \dots, n_5)$, one for each possible star rating. These values represent our belief in the "typical" distribution of votes for a new book. We'll discuss more about how to set the values later. Sampling a value (a book's list of probabilities) from the Dirichlet distribution is [not trivial](http://stats.stackexchange.com/questions/69210/drawing-from-dirichlet-distribution), but we don't need to do that for this program. Rather, we need to be able to interpret a fixed Dirichlet distribution, and update it given some observed votes.

The interpretation we use for a Dirichlet distribution is its expected value, which, recall, is the parameters of a discrete distribution. In particular if $n = \sum_i n_i$, then the expected value is a discrete distribution whose probabilities are


$\displaystyle \left (  \frac{n_0}{n}, \frac{n_1}{n}, \dots, \frac{n_5}{n} \right )$


So you can think of each integer in the specification of a Dirichlet as "ghost ratings," sometimes called _pseudocounts_, and we're saying the probability is proportional to the count.

This is great, because if we knew the true Dirichlet distribution for a book, we could compute its ranking without a second thought. The ranking would simply be the expected star rating:

{{< highlight python >}}
def simple_score(distribution):
   return sum(i * p for (i, p) in enumerate(distribution))
{{< /highlight >}}

Putting books with the highest score on top would maximize the expected happiness of a user visiting the site, provided that happiness matches the user's voting behavior, since the simple_score _is_ just the expected vote.

Also note that all the rating system needs to make this work is that the rating options are linearly ordered. So a thumbs up/down (heaving bosom/flaccid member?) would work, too. We don't need to know _how_ happy it makes them to see a 5-star vs 4-star book. However, because as we'll see next we have to approximate the distribution, and hence have uncertainty for scores of books with only a few ratings, it helps to incorporate numerical utility values (we'll see this at the end).

Next, to update a given Dirichlet distribution with the results of some observed ratings, we have to dig a bit deeper into Bayes rule and the formulas for sampling from a Dirichlet distribution. Rather than do that, I'll point you to this nice [writeup by Jonathan Huang](http://jonathan-huang.org/research/dirichlet/dirichlet.pdf), where the core of the derivation is in Section 2.3 (page 4), and remark that the rule for updating for a new observation is to just add it to the existing counts.

**Theorem:** Given a Dirichlet distribution with parameters $(n_1, \dots, n_k)$ and a new observation of outcome $i$, the updated Dirichlet distribution has parameters $(n_1, \dots, n_{i-1}, n_i + 1, n_{i+1}, \dots, n_k)$. That is, you just update the $i$-th entry by adding $1$ to it.

This particular arithmetic to do the update is a mathematical consequence (derived in the link above) of the _philosophical_ assumption that Bayes rule is how you should model your beliefs about uncertainty, coupled with the assumption that the Dirichlet process is how the users actually arrive at their votes.

The initial values $(n_0, \dots, n_5)$ for star ratings should be picked so that they represent the average rating distribution among all prior books, since this is used as the default voting distribution for a new, unknown book. If you have more information about whether a book is likely to be popular, you can use a different prior. For example, if JK Rowling wrote a Harry Potter Romance novel that was part of the canon, you could pretty much guarantee it would be popular, and set $n_5$ high compared to $n_0$. Of course, if it were actually popular you could just wait for the good ratings to stream in, so tinkering with these values on a per-book basis might not help much. On the other hand, most books by unknown authors are bad, and $n_5$ should be close to zero. Selecting a prior dictates how influential ratings of new items are compared to ratings of items with many votes. The more pseudocounts you add to the prior, the less new votes count.

This gets us to the following code for star ratings.

{{< highlight python >}}
def score(self, ratings, rating_prior):
    ratings = [r + p for (r, p) in zip(ratings, rating_prior)]
    score = sum(i * u for (i, u) in enumerate(ratings))
    return score / sum(ratings)
{{< /highlight >}}

The only thing missing from the solution at the beginning is the utilities. The utilities are useful for two reasons. First, because books with few ratings encode a lot of uncertainty, having an idea about how extreme a feeling is implied by a specific rating allows one to give better rankings of new books.

Second, for many services, such as taxi rides on Lyft, the default star rating tends to be a 5-star, and 4-star or lower mean something went wrong. For books, 3-4 stars is a default while 5-star means you were very happy.

The utilities parameter allows you to weight rating outcomes appropriately. So if you are in a Lyft-like scenario, you might specify utilities like [-10, -5, -3, -2, 1] to denote that a 4-star rating has the same negative impact as two 5-star ratings would positively contribute. On the other hand, for books the gap between 4-star and 5-star is much less than the gap between 3-star and 4-star. The utilities simply allow you to calibrate how the votes should be valued in comparison to each other, instead of using their literal star counts.
