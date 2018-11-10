---
author: jeremykun
date: 2015-07-13 14:00:00+00:00
draft: false
title: What does it mean for an algorithm to be fair?
type: post
url: /2015/07/13/what-does-it-mean-for-an-algorithm-to-be-fair/
categories:
- Algorithms
- Computing Theory
- Learning Theory
- Models
tags:
- accountability
- data mining
- deep learning
- disparate impact
- fairness
- law
- machine learning
- mathematics
- neural networks
- transparency
---

In 2014 the White House commissioned a 90-day study that culminated in a [report](https://www.whitehouse.gov/sites/default/files/docs/big_data_privacy_report_may_1_2014.pdf) (pdf) on the state of "big data" and related technologies. The authors give many recommendations, including this central warning.

**Warning: algorithms can facilitate illegal discrimination!**

Here's a not-so-imaginary example of the problem. A bank wants people to take loans with high interest rates, and it also serves ads for these loans. A modern idea is to use an algorithm to decide, based on the sliver of known information about a user visiting a website, which advertisement to present that gives the largest chance of the user clicking on it. There's one problem: these algorithms are trained on historical data, and poor uneducated people (often racial minorities) have a [historical trend](http://www.pewtrusts.org/~/media/legacy/uploadedfiles/pcs_assets/2012/PewPaydayLendingReportpdf.pdf) of being more likely to succumb to predatory loan advertisements than the general population. So an algorithm that is "just" trying to maximize clickthrough may also be targeting black people, de facto denying them opportunities for fair loans. Such behavior is [illegal](https://en.wikipedia.org/wiki/Mortgage_discrimination#Equal_Credit_Opportunity_Act).

[![Payday-Loans](https://jeremykun.files.wordpress.com/2015/06/payday-loans.jpg?w=660)
](https://jeremykun.files.wordpress.com/2015/06/payday-loans.jpg)

On the other hand, even if algorithms are not making illegal decisions, by training algorithms on data produced by humans, we naturally reinforce prejudices of the majority. This can have negative effects, like Google's autocomplete finishing "Are transgenders" with "going to hell?" Even if this is the most common question being asked on Google, and _even_ if the majority think it's morally acceptable to display this to users, this shows that algorithms do in fact encode our prejudices. People are slowly coming to realize this, to the point where [it was recently covered](http://www.nytimes.com/2015/07/10/upshot/when-algorithms-discriminate.html?abt=0002&abg=1) in the _New York Times_.

There are many facets to the algorithm fairness problem one that has not even been widely acknowledged as a problem, despite the _Times_ article. The message has been [echoed by machine learning researchers](https://medium.com/@mrtz/how-big-data-is-unfair-9aa544d739de) but mostly [ignored by practitioners](http://www.theverge.com/2014/2/19/5419854/the-minority-report-this-computer-predicts-crime-but-is-it-racist). In particular, "experts" continually make ignorant claims such as, "[equations can't be racist,](http://mathbabe.org/2014/08/25/gilian-tett-gets-it-very-wrong-on-racial-profiling/)" and the following quote from the above linked article about how the Chicago Police Department has been using algorithms to do predictive policing.

<blockquote>

> 
> Wernick denies that [the predictive policing] algorithm uses "any racial, neighborhood, or other such information" to assist in compiling the heat list [of potential repeat offenders].
> 
> 
</blockquote>

Why is this ignorant? Because of the well-known fact that removing explicit racial features from data does not eliminate an algorithm's ability to learn race. If racial features disproportionately correlate with crime (as they do in the US), then an algorithm which learns race is actually doing exactly what it is designed to do! One needs to be very thorough to say that an algorithm does not "use race" in its computations. Algorithms are not designed in a vacuum, but rather in conjunction with the designer's analysis of their data. There are two points of failure here: the designer can unwittingly encode biases into the algorithm based on a biased exploration of the data, and the data itself can encode biases due to human decisions made to create it. Because of this, the burden of proof is (or should be!) on the practitioner to guarantee they are not violating discrimination law. Wernick should instead prove mathematically that the policing algorithm does not discriminate.

While that viewpoint is idealistic, it's a bit naive because there is no accepted definition of what it _means_ for an algorithm to be fair. In fact, from a precise mathematical standpoint, there isn't even a precise _legal _definition of what it means for any practice to be fair. In the US the existing legal theory is called [disparate impact](https://en.wikipedia.org/wiki/Disparate_impact), which states that a practice can be considered illegal discrimination if it has a "disproportionately adverse" effect on members of a protected group. Here "disproportionate" is precisely defined by the [80% rule](https://en.wikipedia.org/wiki/Disparate_impact#The_80.25_rule), but this is somehow not enforced as stated. As with many legal issues, laws are broad assertions that are challenged on a case-by-case basis. In the case of fairness, the legal decision usually hinges on whether an _individual_ was treated unfairly, because the individual is the one who files the lawsuit. Our understanding of the law is cobbled together, essentially through anecdotes slanted by political agendas. A mathematician can't make progress with that. We want the mathematical essence of fairness, not something that can be interpreted depending on the court majority.

The problem is exacerbated for data mining because the practitioners often demonstrate a poor understanding of statistics, the management doesn't understand algorithms, and almost everyone is lulled into a false sense of security via abstraction (remember, "equations can't be racist"). Experts in discrimination law aren't trained to audit algorithms, and engineers aren't trained in social science or law. The speed with which research becomes practice far outpaces the speed at which anyone can keep up. This is especially true at places like Google and Facebook, where teams of in-house mathematicians and algorithm designers bypass the delay between academia and industry.

And perhaps the worst part is that even the world's best mathematicians and computer scientists don't know how to interpret the output of many popular learning algorithms. This isn't just a problem that stupid people aren't listening to smart people, it's that everyone is "stupid." A more politically correct way to say it: transparency in machine learning is a wide open problem. Take, for example, deep learning. A far-removed adaptation of neuroscience to data mining, deep learning has become the flagship technique spearheading modern advances in image tagging, speech recognition, and other classification problems.

[caption id="attachment_5878" align="aligncenter" width="615"][![A typical example of how a deep neural network learns to tag images. Image source: http://engineering.flipboard.com/2015/05/scaling-convnets/](https://jeremykun.files.wordpress.com/2015/06/yann_filters.png)
](https://jeremykun.files.wordpress.com/2015/06/yann_filters.png) A typical example of how a deep neural network learns to tag images. Image source: http://engineering.flipboard.com/2015/05/scaling-convnets/[/caption]

The picture above shows how low level "features" (which essentially boil down to simple numerical combinations of pixel values) are combined in a "neural network" to more complicated image-like structures. The claim that these features represent natural concepts like "cat" and "horse" have fueled the public attention on deep learning for years. But looking at the above, is there any reasonable way to say whether these are encoding "discriminatory information"? Not only is this an open question, but we don't even know _what kinds of problems_ deep learning can solve! How can we understand to what extent neural networks can encode discrimination if we don't have a deep understanding of why a neural network is good at what it does?

What makes this worse is that there are only about ten people in the world who understand the practical aspects of deep learning well enough to achieve record results for deep learning. This means they spent a ton of time tinkering the model to make it domain-specific, and nobody really knows whether the subtle differences between the top models correspond to genuine advances or slight overfitting or luck. Who is to say whether the fiasco with Google [tagging images of black people as apes](http://edition.cnn.com/2015/07/02/tech/google-image-recognition-gorillas-tag/) was caused by the data or the deep learning algorithm or by some obscure tweak made by the designer? I doubt even the designer could tell you with any certainty.

Opacity and a lack of interpretability is the rule more than the exception in machine learning. Celebrated techniques like Support Vector Machines, [Boosting](http://jeremykun.com/2015/05/18/boosting-census/), and recent popular "tensor methods" are all highly opaque. This means that even if we knew what fairness meant, it is still a challenge (though one we'd be suited for) to modify existing algorithms to become fair. But with recent success stories in theoretical computer science [connecting security, trust, and privacy](https://en.wikipedia.org/wiki/Differential_privacy), computer scientists have started to take up the call of nailing down what fairness means, and how to measure and enforce fairness in algorithms. There is now a yearly workshop called [Fairness, Accountability, and Transparency in Machine Learning](http://fatml.org/) (FAT-ML, an awesome acronym), and some famous theory researchers are starting to get involved, as are social scientists and legal experts. Full disclosure, two days ago I gave a talk as part of this workshop on [modifications to AdaBoost](http://jeremykun.com/2015/05/18/boosting-census/) that seem to make it more fair. More on that in a future post.

From our perspective, we the computer scientists and mathematicians, the central obstacle is still that we don't have a good definition of fairness.

In the next post I want to get a bit more technical. I'll describe the parts of the fairness literature I like (which will be biased), I'll hypothesize about the tension between statistical fairness and individual fairness, and I'll entertain ideas on how someone designing a controversial algorithm (such as a predictive policing algorithm) could maintain transparency and accountability over its discriminatory impact. In subsequent posts I want to explain in more detail why it seems so difficult to come up with a useful definition of fairness, and to describe some of the ideas I and my coauthors have worked on.

Until then!

## 

## 
