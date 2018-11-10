---
author: jeremykun
date: 2012-08-05 00:59:42+00:00
draft: false
title: Machine Learning — Introduction
type: post
url: /2012/08/04/machine-learning-introduction/
categories:
- General
---

## A Series on Machine Learning


These days an absolutely staggering amount of research and development work goes into the very coarsely defined field of "machine learning." Part of the reason why it's so coarsely defined is because it borrows techniques from so many different fields. Many problems in machine learning can be phrased in different but equivalent ways. While they are often purely optimization problems, such techniques can be expressed in terms of statistical inference, have biological interpretations, or have a distinctly geometric and topological flavor. As a result, machine learning has come to be understood as a toolbox of techniques as opposed to a unified theory.

It is unsurprising, then, that such a multitude of mathematics supports this diversified discipline. Practitioners (that is, algorithm designers) rely on statistical inference, linear algebra, convex optimization, and dabble in graph theory, functional analysis, and topology. Of course, above all else machine learning focuses on _algorithms_ and _data._

The general pattern, which we'll see over and over again as we derive and implement various techniques, is to develop an algorithm or mathematical model, test it on datasets, and refine the model based on specific domain knowledge. The first step usually involves a leap of faith based on some mathematical intuition. The second step commonly involves a handful of established and well understood datasets (often taken from the [University of California at Irvine's machine learning database](http://archive.ics.uci.edu/ml/), and there is some controversy over how ubiquitous this practice is). The third step often seems to require some voodoo magic to tweak the algorithm and the dataset to complement one another.

It is this author's personal belief that the most important part of machine learning is the mathematical foundation, followed closely by efficiency in implementation details. The thesis is that natural data has inherent structure, and that the goal of machine learning is to represent this and utilize it. To make true progress, one must represent and analyze structure abstractly. And so this blog will focus predominantly on mathematical underpinnings of the algorithms and the mathematical structure of data.


## General Plans


While we do intend to cover the classical topics of machine learning, such as neural networks and decision trees, we would like to quickly approach more sophisticated modern techniques such as support vector machines and methods based on [Kolmogorov complexity](http://jeremykun.wordpress.com/2012/04/21/kolmogorov-complexity-a-primer/). And so we put forth the ambitious list of topics (in no particular order). **[update: it's been a while since this initial post, and we've covered some of the topics listed below, as indicated by the links]**



	  * [K nearest neighbors](http://jeremykun.com/2012/08/26/k-nearest-neighbors-and-handwritten-digit-classification/)
	  * [Decision trees](http://jeremykun.com/2012/10/08/decision-trees-and-political-party-classification/)
	  * [Centroid-based](http://jeremykun.com/2013/02/04/k-means-clustering-and-birth-rates/) and density-based clustering
	  * [Neural networks](http://jeremykun.com/2012/12/09/neural-networks-and-backpropagation/)
	  * Support vector machines
	  * [Regression
](http://jeremykun.com/2013/08/18/linear-regression/)
	  * [Bandit learning](http://jeremykun.com/2013/12/09/bandits-and-stocks/) ([UCB1](http://jeremykun.com/2013/10/28/optimism-in-the-face-of-uncertainty-the-ucb1-algorithm/), [Exp3](http://jeremykun.com/2013/11/08/adversarial-bandits-and-the-exp3-algorithm/))
	  * Bayesian inference and networks
	  * Methods based on [Kolmogorov complexity](http://jeremykun.com/2012/04/21/kolmogorov-complexity-a-primer/)
	  * Manifold learning and persistence homology

This long and circuitous journey will inevitably require arbitrarily large but finite detours to cover the mathematical background. We'll cover metric spaces, functional analysis, mathematical statistics and probability theory, abstract algebra, topology, and even some category theory. Note that some of the more esoteric (i.e., advanced) topics will have their own series as well (for instance, we've had an itch to do computational category theory but having covered none of the typical concrete applications of category theory, the jump into extreme abstraction would come off as pointlessly complicated).

Of course, [as we've mentioned before](http://jeremykun.wordpress.com/2012/06/12/thoughts-after-a-year-of-math-programming/), while the mathematics is motivated by our desire to connect ideas, programming is motivated by what we can _do_. And so we're interested in using machine learning methods to perform cool tasks. Some ideas we plan to implement on this blog include social network analysis, machine vision and optical character recognition, spam classification, natural language processing, speech recognition, and content classification and recommendation.

Finally, we are interested in the theoretical boundaries on what is possible for a computer to learn. Aside from its practical use, this area of study would require us to rigorously define what it means for a machine to "learn." This field is known as computational learning theory, and a good deal of it is devoted to the typical complexity-theory-type questions such as "can this class of classification functions be learned in polynomial time?" In addition, this includes learning theories of a more statistical flavor, such as the "Probably Approximately Correct" model. We plan to investigate each of these models in turn as they come up in our explorations.

If any readers have suggestions for additional machine learning topics (to add to this already gargantuan list), feel free to pipe in with a comment! We'll begin with an exploration of the simplest algorithm on the above list, k nearest neighbors, and a more rigorous exploration of metric spaces.

Until then!
