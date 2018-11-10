---
author: jeremykun
date: 2015-10-19 14:00:00+00:00
draft: false
title: 'One definition of algorithmic fairness: statistical parity'
type: post
url: /2015/10/19/one-definition-of-algorithmic-fairness-statistical-parity/
categories:
- Algorithms
- Data mining
- Fairness
- Probability
- Statistics
tags:
- algorithms
- bias
- conditional probability
- discrimination
- fairness
- machine learning
- mathematics
- programming
- python
- research
- reverse tokenism
- self-fulfilling prophecy
- statistics
---

If you haven't read the [first post on fairness](http://jeremykun.com/2015/07/13/what-does-it-mean-for-an-algorithm-to-be-fair/), I suggest you go back and read it because it motivates why we're talking about fairness for algorithms in the first place. In this post I'll describe one of the existing mathematical definitions of "fairness," its origin, and discuss its strengths and shortcomings.




Before jumping in I should remark that nobody has found a definition which is widely agreed as a good definition of fairness in the same way we have for, say, the security of a [random number generator](https://en.wikipedia.org/wiki/Cryptographically_secure_pseudorandom_number_generator). So this post is intended to be exploratory rather than dictating The Facts. Rather, it's an idea with some good intuitive roots which may or may not stand up to full mathematical scrutiny.





## Statistical parity


Here is one way to define fairness.

Your population is a set $X$ and there is some known subset $S \subset X$ that is a "protected" subset of the population. For discussion we'll say $X$ is people and $S$ is people who dye their hair [teal](http://www.toroidalsnark.net/fmwth.html). We are afraid that banks give fewer loans to the teals because of hair-colorism, despite teal-haired people being just as creditworthy as the general population on average.

Now we assume that there is some distribution $D$ over $X$ which represents the probability that any individual will be drawn for evaluation. In other words, some people will just have no reason to apply for a loan (maybe they're filthy rich, or don't like homes, cars, or expensive colleges), and so $D$ takes that into account. Generally we impose no restrictions on $D$, and the definition of fairness will have to work no matter what $D$ is.

Now suppose we have a (possibly randomized) classifier $h:X \to \{-1,1\}$ giving labels to $X$. When given a person $x$ as input $h(x)=1$ if $x$ gets a loan and $-1$ otherwise. The _bias_, or _statistical imparity,_ of $h$ on $S$ with respect to $X,D$ is the following quantity. In words, it is the difference between the probability that a random individual drawn from $S$ is labeled 1 and the probability that a random individual from the complement $S^C$ is labeled 1.


$\textup{bias}_h(X,S,D) = \Pr[h(x) = 1 | x \in S^{C}] - \Pr[h(x) = 1 | x \in S]$


The probability is taken both over the distribution $D$ and the random choices made by the algorithm. This is the statistical equivalent of the legal doctrine of [adverse impact](https://en.wikipedia.org/wiki/Disparate_impact). It measures the difference that the majority and protected classes get a particular outcome. When that difference is small, the classifier is said to have "statistical parity," i.e. to conform to this notion of fairness.

**Definition: **A hypothesis $h:X \to \{-1,1\}$ is said to have _statistical parity_ on $D$ with respect to $S$ up to bias $\varepsilon$ if $|\textup{bias}_h(X,S,D)| < \varepsilon$.

So if a hypothesis achieves statistical parity, then it treats the general population statistically similarly to the protected class. So if 30% of normal-hair-colored people get loans, statistical parity requires roughly 30% of teals to also get loans.

It's pretty simple to write a program to compute the bias. First we'll write a function that computes the bias of a given set of labels. We'll determine whether a data point $x \in X$ is in the protected class by specifying a specific value of a specific index. I.e., we're assuming the feature selection has already happened by this point.

{{< highlight python >}}
# labelBias: [[float]], [int], int, obj -> float
# compute the signed bias of a set of labels on a given dataset
def labelBias(data, labels, protectedIndex, protectedValue):   
   protectedClass = [(x,l) for (x,l) in zip(data, labels) 
      if x[protectedIndex] == protectedValue]   
   elseClass = [(x,l) for (x,l) in zip(data, labels) 
      if x[protectedIndex] != protectedValue]

   if len(protectedClass) == 0 or len(elseClass) == 0:
      raise Exception("One of the classes is empty!")
   else:
      protectedProb = sum(1 for (x,l) in protectedClass if l == 1) / len(protectedClass)
      elseProb = sum(1 for (x,l) in elseClass  if l == 1) / len(elseClass)

   return elseProb - protectedProb
{{< /highlight >}}

Then generalizing this to an input hypothesis is a one-liner.

{{< highlight python >}}
# signedBias: [[float]], int, obj, h -> float
# compute the signed bias of a hypothesis on a given dataset
def signedBias(data, h, protectedIndex, protectedValue):
   return labelBias(pts, [h(x) for x in pts], protectedIndex, protectedValue)
{{< /highlight >}}

Now we can load the [census data from the UCI machine learning repository](https://archive.ics.uci.edu/ml/datasets/Adult) and compute some biases in the labels. The data points in this dataset correspond to demographic features of people from a census survey, and the labels are +1 if the individual's salary is at least 50k, and -1 otherwise. I wrote some helpers to load the data from a file (which you can see in [this post's Github repo](https://github.com/j2kun/statistical-parity)).

{{< highlight python >}}
if __name__ == "__main__":
   from data import adult
   train, test = adult.load(separatePointsAndLabels=True)

   # [(test name, (index, value))]
   tests = [('gender', (1,0)), 
            ('private employment', (2,1)), 
            ('asian race', (33,1)),
            ('divorced', (12, 1))]

   for (name, (index, value)) in tests:
      print("'%s' bias in training data: %.4f" %
         (name, labelBias(train[0], train[1], index, value)))
{{< /highlight >}}

(I chose 'asian race' instead of just 'asian' because there are various 'country of origin' features that are for countries in Asia.)

Running this gives the following.

{{< highlight python >}}
anti-'female' bias in training data: 0.1963
anti-'private employment' bias in training data: 0.0731
anti-'asian race' bias in training data: -0.0256
anti-'divorced' bias in training data: 0.1582
{{< /highlight >}}

Here a positive value means it's biased against the quoted thing, a negative value means it's biased in favor of the quoted thing.

Now let me define a stupidly trivial classifier that predicts 1 if the country of origin is India and zero otherwise. If I do this and compute the gender bias of this classifier on the training data I get the following.

{{< highlight python >}}
>>> indian = lambda x: x[47] == 1
>>> len([x for x in train[0] if indian(x)]) / len(train[0]) # fraction of Indians
0.0030711587481956942
>>> signedBias(train[0], indian, 1, 0)
0.0030631816119030884
{{< /highlight >}}

So this says that predicting based on being of Indian origin (which probably has very low accuracy, since many non-Indians make at least $50k) does not bias significantly with respect to gender.

We can generalize statistical parity in various ways, such as using some other specified set $T$ in place of $S^C$, or looking at discrepancies among $k$ different sub-populations or with $m$ different outcome labels. In fact, the mathematical name for this measurement (which is a measurement of a set of distributions) is called the _total variation distance_. The form we sketched here is a simple case that just works for the binary-label two-class scenario.

Now it is important to note that statistical parity says nothing about the _truth _about the protected class $S$. I mean two things by this. First, you could have some historical data you want to train a classifier $h$ on, and usually you'll be given training labels for the data that tell you whether $h(x)$ should be $1$ or $-1$. In the absence of discrimination, getting high accuracy with respect to the training data is enough. But if there is some historical discrimination against $S$ then the training labels are not trustworthy. As a consequence, achieving statistical parity for $S$ _necessarily _reduces the accuracy of $h$. In other words, when there is bias in the data accuracy is measured in favor of encoding the bias. Studying fairness from this perspective means you study the tradeoff between high accuracy and low statistical disparity. However, and this is why statistical parity says nothing about whether the individuals $h$ behaves differently on (differently compared to the training labels) were the correct individuals to behave differently on. If the labels alone are all we have to work with, and we don't know the true labels, then we'd need to apply domain-specific knowledge, which is suddenly out of scope of machine learning.

Second, nothing says optimizing for statistical parity is the _correct_ thing to do. In other words, it may be that teal-haired people are truly less creditworthy (jokingly, maybe there is a hidden innate characteristic causing both uncreditworthiness and a desire to dye your hair!) and by enforcing statistical parity you are going against a fact of Nature. Though there are serious repercussions [for suggesting such things](http://www.theguardian.com/science/2005/jan/18/educationsgendergap.genderissues) in real life, my point is that statistical parity does not address anything outside the desire for an algorithm to exhibit a certain behavior. The obvious counterargument is that if, as a society, we have decided that teal-hairedness should be protected by law regardless of Nature, then we're defining statistical parity to be correct. We're changing our optimization criterion and as algorithm designers we don't care_ _about anything else. We care about what guarantees we can prove about algorithms, and the utility of the results.

The third side of the coin is that if all we care about is statistical parity, then we'll have a narrow criterion for success that can be gamed by an _actively biased_ adversary.


## Statistical parity versus targeted bias


Statistical parity has some known pitfalls. In their paper "[Fairness Through Awareness](http://arxiv.org/abs/1104.3913)" (Section 3.1 and Appendix A), Dwork, et al. argue convincingly that these are primarily issues of _individual fairness _and targeted discrimination. They give six examples of "evils" including a few that maintain statistical parity while not being fair from the perspective of an individual. Here are my two favorite ones to think about (using teal-haired people and loans again):



	  1. **Self-fulfilling prophecy: **The bank intentionally gives a few loans to teal-haired people who are (for unrelated reasons) obviously uncreditworthy, so that in the future they can point to these examples to justify discriminating against teals. This can appear even if the teals are chosen uniformly at random, since the average creditworthiness of a random teal-haired person is lower than a carefully chosen normal-haired person.
	  2. **Reverse tokenism:** The bank intentionally does _not_ give loans to some highly creditworthy normal-haired people, let's call one Martha, so that when a teal complains that they are denied a loan, the bank can point to Martha and say, "Look how qualified she is, and we didn't even give her a loan! You're much less qualified." Here Martha is the "token" example used to justify discrimination against teals.

I like these two examples for two reasons. First, they illustrate how hard coming up with a good definition is: it's not clear how to encapsulate both statistical parity and resistance to this kind of targeted discrimination. Second, they highlight that discrimination can both be unintentional and intentional. Since computer scientists tend to work with worst-case guarantees, this makes we think the right definition will be resilient to some level of adversarial discrimination. But again, these two examples are not formalized, and it's not even clear to what extent existing algorithms suffer from manipulations of these kinds. For instance, many learning algorithms are relatively resilient to changing the desired label of a single point.

In any case, the thing to take away from this discussion is that there is not yet an accepted definition of "fairness," and there seems to be a disconnect between what it means to be fair for an individual versus a population. There are some other proposals in the literature, and I'll just mention one: Dwork et al. propose that individual fairness mean that "similar individuals are treated similarly." I will cover this notion (and what's know about it) in a future post.

Until then!
