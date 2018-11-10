---
author: jeremykun
date: 2011-06-13 04:09:29+00:00
draft: false
title: Google's PageRank - Introduction
type: post
url: /2011/06/12/googles-pagerank-introduction/
categories:
- Algorithms
- Graph Theory
- Linear Algebra
- Probability Theory
tags:
- crawler
- google
- history
- indexer
- page rank
- query engine
- search engine
---

## Importance on the Web

As a society living in the "Information Age," it comes as no surprise that we are faced with the task of sorting through vast oceans of content. With the admission that most content is actually junk, we must wisely choose the objects of our analysis. The appropriately named site UselessJunk.com certainly doesn't deserve the same attention as the BBC World News page, and yet within the monstrous heart of the internet, it requires the maturity of the human psyche to discriminate their relative worth.

However, as with many real-world systems, there is a method to the madness. We have the following two important observations to inspire our quest:

	  * The internet is a human construction, and hence
	  * The internet intrinsically reflects some level of human interest in its content.

If the second statement is true, that the internet somehow reflects what information people want to absorb (or as is often these days, games they want to play, videos they want to watch, restaurants they want to find), then all we need to do is extract this information without human aid. In other words, by first picking out information that is generally desirable, we can reduce the black hole of available (and mostly useless) information to a manageable size for human consumption.

## Search Engines

From a much sharper perspective, information selection is precisely what Google does for us every day. If there's something we'd like to know more about, we type in the relevant search keywords, and out comes a list of pages sorted (more or less) in order by relevance. Of course, "relevance" is not the correct term, but rather "popularity," and hence "authority," but we will explain why this characterization makes more sense later. For now, we'll provide an overview of what a search engine does:

A search engine has four main parts:

	  * A crawler
	  * An indexer
	  * A ranking algorithm, and
	  * A query engine

A web _crawler_ methodically copies pages from the web into a database, keeping track of hyperlinks between pages. An _indexer_ then revisits these copies, determining relevant keywords to optimize their later retrieval (leaning on immense amounts of work in cognitive psychology, linguistics, and mathematics). The pages are then ranked according to a particular _ranking algorithm_. And finally the user is provided with a query engine (the search bar) to access these records, which are displayed in order according to the ranking algorithm.

While each part above is a fascinating problem in itself, we will focus primarily on the third: the ranking algorithm. In its infancy, Google's novel approach rested in its ranking algorithm, affectionately named PageRank after co-founder [Larry Page](http://en.wikipedia.org/wiki/Larry_Page) (other co-founder [Sergey Brin](http://en.wikipedia.org/wiki/Sergey_Brin)). Though it is not presented here in a readable way, this is (a condensed version of) [the original paper presenting the Google search engine](http://infolab.stanford.edu/~backrub/google.html). Of course, Larry and Sergey needed much more elbow grease to make Google as slick as it is today, and likewise the paper delves into details on local data storage, parsing, chunking, and all sorts of error-handling mechanisms that are beyond the scope of this series. We will stick to investigating and proving the validity of the mathematical model underlying PageRank itself.

And so, the predominant questions throughout this series will be:

	  * Which websites on the internet are worth my time? and, more importantly,
	  * How can we extract this from the structure of the internet?

The answer to the second question lies in a jungle of fantastically interconnected maths. First, we'll represent the structure of the web as a directed graph. Then, we'll compute importance of every web page simultaneously by solving a (very large) system of linear equations. While this sounds straightforward enough, there will be a number of bumps along the way to a satisfactory solution, and we will derive each twist and turn to bask in the elegance of the process.

For those of you who are unfamiliar with graph theory and linear algebra, we plan to provide additional (terse) primers for the necessary definitions and basic notions. Otherwise, look forward to the next part in this series, where we'll construct PageRank for an internet with some strong hypotheses restricting its form. Until then!

Page Rank Series
[An Introduction](http://jeremykun.wordpress.com/2011/06/12/googles-pagerank-introduction/)
[A First Attempt](http://jeremykun.wordpress.com/2011/06/18/googles-pagerank-a-first-attempt/)
[The Final Product](http://jeremykun.wordpress.com/2011/06/20/googles-page-rank-the-final-product/)
[Why It Doesn't Work Anymore](http://jeremykun.wordpress.com/2011/06/21/googles-page-rank-why-it-doesnt-work-anymore/)
