---
author: jeremykun
date: 2015-05-18 14:00:00+00:00
draft: false
title: Weak Learning, Boosting, and the AdaBoost algorithm
type: post
url: /2015/05/18/boosting-census/
categories:
- Algorithms
- Learning Theory
- Probability Theory
---

When addressing the question of what it means for an algorithm to learn, one can imagine many different models, and there are quite a few. This invariably raises the question of which models are "the same" and which are "different," along with a precise description of how we're comparing models. We've seen one learning model so far, called [Probably Approximately Correct](http://jeremykun.com/2014/01/02/probably-approximately-correct-a-formal-theory-of-learning/) (PAC), which espouses the following answer to the learning question:

An algorithm can "solve" a classification task using labeled examples drawn from some distribution if it can achieve accuracy that is arbitrarily close to perfect on the distribution, and it can meet this goal with arbitrarily high probability, where its runtime and the number of examples needed scales efficiently with all the parameters (accuracy, confidence, size of an example). Moreover, the algorithm needs to succeed no matter what distribution generates the examples.

You can think of this as a game between the algorithm designer and an adversary. First, the learning problem is fixed and everyone involved knows what the task is. Then the algorithm designer has to pick an algorithm. Then the adversary, _knowing the chosen algorithm,_ chooses a nasty distribution $D$ over examples that are fed to the learning algorithm. The algorithm designer "wins" if the algorithm produces a hypothesis with low error on $D$ when given samples from $D$. And our goal is to prove that the algorithm designer can pick a single algorithm that is extremely likely to win no matter what $D$ the adversary picks.

We'll momentarily restate this with a more precise definition, because in this post we will compare it to a slightly different model, which is called the _weak PAC-learning _model. It's essentially the same as PAC, except it only requires the algorithm to have accuracy that is _slightly better than random guessing_. That is, the algorithm will output a classification function which will correctly classify a random label with probability at least $\frac{1}{2} + \eta$ for some small, but fixed, $\eta > 0$. The quantity $\eta$ (the Greek "eta") is called the _edge_ as in "the edge over random guessing." We call an algorithm that produces such a hypothesis a _weak learner_, and in contrast we'll call a successful algorithm in the usual PAC model a _strong learner_.

The amazing fact is that **strong learning and weak learning are equivalent!** Of course a weak learner is not the same thing as a strong learner. What we mean by "equivalent" is that:

A problem can be weak-learned if and only if it can be strong-learned.

So they are _computationally_ the same. One direction of this equivalence is trivial: if you have a strong learner for a classification task then it's automatically a weak learner for the same task. The reverse is much harder, and this is the crux: there is an algorithm for transforming a weak learner into a strong learner! Informally, we "boost" the weak learning algorithm by feeding it examples from carefully constructed distributions, and then take a majority vote. This "reduction" from strong to weak learning is where all the magic happens.

In this post we'll get into the depths of this boosting technique. We'll review the model of PAC-learning, define what it means to be a weak learner, "organically" come up with the AdaBoost algorithm from some intuitive principles, prove that AdaBoost reduces error on the training data, and then run it on data. It turns out that despite the origin of boosting being a purely theoretical question, boosting algorithms have had a wide impact on practical machine learning as well.

As usual, [all of the code and data](https://github.com/j2kun/boosting) used in this post is available on [this blog's Github page](https://github.com/j2kun/).

## History and multiplicative weights

Before we get into the details, here's a bit of history and context. PAC learning was introduced by Leslie Valiant in 1984, laying the foundation for a flurry of innovation. In 1988 Michael Kearns posed the question of whether one can "boost" a weak learner to a strong learner. Two years later Rob Schapire published his landmark paper "[The Strength of Weak Learnability](http://www.cs.princeton.edu/~schapire/papers/strengthofweak.pdf)" closing the theoretical question by providing the first "boosting" algorithm. Schapire and Yoav Freund worked together for the next few years to produce a simpler and more versatile algorithm called [AdaBoost](http://en.wikipedia.org/wiki/AdaBoost), and for this they won the Gödel Prize, one of the highest honors in theoretical computer science. AdaBoost is also the standard boosting algorithm used in practice, though there are enough variants to warrant [a book on the subject](http://www.amazon.com/Boosting-Foundations-Algorithms-Adaptive-Computation/dp/0262526034).

I'm going to define and prove that AdaBoost works in this post, and implement it and test it on some data. But first I want to give some high level discussion of the technique, and afterward the goal is to make that wispy intuition rigorous.

The central technique of AdaBoost has been discovered and rediscovered in computer science, and recently it was recognized abstractly in its own right. It is called the **Multiplicative Weights Update Algorithm** (MWUA), and it has applications in everything from learning theory to combinatorial optimization and game theory. The idea is to

 	  1. Maintain a nonnegative weight for the elements of some set,
 	  2. Draw a random element proportionally to the weights,
 	  3. So something with the chosen element, and based on the outcome of the "something..."
 	  4. Update the weights and repeat.

The "something" is usually a black box algorithm like "solve this simple optimization problem." The output of the "something" is interpreted as a reward or penalty, and the weights are updated according to the severity of the penalty (the details of how this is done differ depending on the goal). In this light one can interpret MWUA as minimizing regret with respect to the best alternative element one could have chosen in hindsight. In fact, this was precisely the technique we used to attack the [adversarial bandit learning problem](http://jeremykun.com/2013/11/08/adversarial-bandits-and-the-exp3-algorithm/) (the Exp3 algorithm is a multiplicative weight scheme). See this lengthy technical [survey of Arora and Kale](https://www.cs.princeton.edu/~arora/pubs/MWsurvey.pdf) for a research-level discussion of the algorithm and its applications.

Now let's remind ourselves of the formal definition of PAC. If you've read the previous post on [the PAC model](http://jeremykun.com/2014/01/02/probably-approximately-correct-a-formal-theory-of-learning/), this next section will be redundant.

## Distributions, hypotheses, and targets

In PAC-learning you are trying to give labels to data from some set $X$. There is a distribution $D$ producing data from $X$, and it's used for everything: to provide data the algorithm uses to learn, to measure your accuracy, and every other time you might get samples from $X$. You as the algorithm designer don't know what $D$ is, and a successful learning algorithm has to work _no matter what_ $D$ _is_. There's some unknown function $c$ called the _target concept,_ which assigns a $\pm 1$ label to each data point in $X$. The target is the function we're trying to "learn." When the algorithm draws an example from $D$, it's allowed to query the label $c(x)$ and use all of the labels it's seen to come up with some _hypothesis_ $h$ that is used for new examples that the algorithm may not have seen before._ _The problem is "solved" if $h$ has low error on all of $D$.

To give a concrete example let's do spam emails. Say that $X$ is the set of all emails, and $D$ is the distribution over emails that get sent to my personal inbox. A PAC-learning algorithm would take all my emails, along with my classification of which are spam and which are not spam (plus and minus 1). The algorithm would produce a hypothesis $h$ that can be used to label new emails, and if the algorithm is truly a PAC-learner, then our guarantee is that with high probability (over the randomness in which emails I receive) the algorithm will produce an $h$ that has low error on the entire distribution of emails that get sent to me (relative to my personal spam labeling function).

Of course there are practical issues with this model. I don't have a consistent function for calling things spam, the distribution of emails I get and my labeling function can change over time, and emails don't come according to a distribution with independent random draws. But that's the theoretical model, and we can hope that algorithms we devise for this model happen to work well in practice.

Here's the formal definition of the error of a hypothesis $h(x)$ produced by the learning algorithm:

$\textup{err}_{c,D}(h) = P_{x \sim D}(h(x) \neq c(x))$

It's read "The error of $h$ with respect to the concept $c$ we're trying to learn and the distribution $D$ is the probability over $x$ drawn from $D$ that the hypothesis produces the wrong label." We can now define PAC-learning formally, introducing the parameters $\delta$ for "probably" and $\varepsilon$ for "approximately." Let me say it informally first:

An algorithm PAC-learns if, for any $\varepsilon, \delta > 0$ and any distribution $D$, with probability at least $1-\delta$ the hypothesis $h$ produced by the algorithm has error at most $\varepsilon$.

To flush out the other things hiding, here's the full definition.

**Definition (PAC): **An algorithm $A(\varepsilon, \delta)$ is said to PAC-learn the concept class $H$ over the set $X$ if, for any distribution $D$ over $X$ and for any $0 < \varepsilon, \delta < 1/2$ and for any target concept $c \in H$, the probability that $A$ produces a hypothesis $h$ of error at most $\varepsilon$ is at least $1-\delta$. In symbols, $\Pr_D(\textup{err}_{c,D}(h) \leq \varepsilon) > 1 - \delta$. Moreover, $A$ must run in time polynomial in $1/\varepsilon, 1/\delta$ and $n$, where $n$ is the size of an element $x \in X$.

The reason we need a class of concepts (instead of just one target concept) is that otherwise we could just have a constant algorithm that outputs the correct labeling function. Indeed, when we get a problem we ask whether there _exists_ an algorithm that can solve it. I.e., a problem is "PAC-learnable" if there is some algorithm that learns it as described above. With just one target concept there can exist an algorithm to solve the problem by hard-coding a description of the concept in the source code. So we need to have some "class of possible answers" that the algorithm is searching through so that the algorithm actually has a job to do.

We call an algorithm that gets this guarantee a _strong learner. _A _weak learner _has the same definition, except that we replace $\textup{err}_{c,D}(h) \leq \varepsilon$ by the weak error bound: for _some fixed_ $0 < \eta < 1/2$_._ the error $\textup{err}_{c,D}(h) \leq 1/2 - \eta$. So we don't require the algorithm to achieve _any _desired accuracy, it just has to get some accuracy slightly better than random guessing, which we don't get to choose. As we will see, the value of $\eta$ influences the convergence of the boosting algorithm. One important thing to note is that $\eta$ is a constant independent of $n$, the size of an example, and $m$, the number of examples. In particular, we need to avoid the "degenerate" possibility that $\eta(n) = 2^{-n}$ so that as our learning problem scales the quality of the weak learner degrades toward 1/2. We want it to be _bounded _away from 1/2.

So just to clarify all the parameters floating around, $\delta$ will always be the "probably" part of PAC, $\varepsilon$ is the error bound (the "approximately" part) for strong learners, and $\eta$ is the error bound for weak learners.

## What could a weak learner be?

Now before we prove that you can "boost" a weak learner to a strong learner, we should have some idea of what a weak learner is. Informally, it's just a 'rule of thumb' that you can somehow guarantee does a little bit better than random guessing.

In practice, however, people sort of just make things up and they work. It's kind of funny, but [until recently](http://www.levreyzin.com/papers/Reyzin14_aaai.pdf) nobody has really studied what makes a "good weak learner." They just use an example like the one we're about to show, and as long as they get a good error rate they don't care if it has any mathematical guarantees. Likewise, they don't expect the final "boosted" algorithm to do arbitrarily well, they just want low error rates.

The weak learner we'll use in this post produces "decision stumps." If you know what a [decision tree](http://jeremykun.com/2012/10/08/decision-trees-and-political-party-classification/) is, then a decision stump is trivial: it's a decision tree where the whole tree is just one node. If you don't know what a decision tree is, a decision stump is a classification rule of the form:

Pick some feature $i$ and some value of that feature $v$, and output label $+1$ if the input example has value $v$ for feature $i$, and output label $-1$ otherwise.

Concretely, a decision stump might mark an email spam if it contains the word "viagra." Or it might deny a loan applicant a loan if their credit score is less than some number.

Our weak learner produces a decision stump by simply looking through all the features and all the values of the features until it finds a decision stump that has the best error rate. It's brute force, baby! Actually we'll do something a little bit different. We'll make our data numeric and look for a threshold of the feature value to split positive labels from negative labels. Here's the Python code we'll use in this post for boosting. This code was part of a collaboration with my two colleagues [Adam Lelkes](http://homepages.math.uic.edu/~alelkes/) and [Ben Fish](http://homepages.math.uic.edu/~bfish3/). As usual, all of the code used in this post is [available on Github](https://github.com/j2kun/boosting).

First we make a class for a decision stump. The attributes represent a feature, a threshold value for that feature, and a choice of labels for the two cases. The classify function shows how simple the hypothesis is.

{{< highlight python >}}
class Stump:
   def __init__(self):
      self.gtLabel = None
      self.ltLabel = None
      self.splitThreshold = None
      self.splitFeature = None

   def classify(self, point):
      if point[self.splitFeature] >= self.splitThreshold:
         return self.gtLabel
      else:
         return self.ltLabel

   def __call__(self, point):
      return self.classify(point)
{{< /highlight >}}

Then for a fixed feature index we'll define a function that computes the best threshold value for that index.

{{< highlight python >}}
def minLabelErrorOfHypothesisAndNegation(data, h):
   posData, negData = ([(x, y) for (x, y) in data if h(x) == 1],
                       [(x, y) for (x, y) in data if h(x) == -1])

   posError = sum(y == -1 for (x, y) in posData) + sum(y == 1 for (x, y) in negData)
   negError = sum(y == 1 for (x, y) in posData) + sum(y == -1 for (x, y) in negData)
   return min(posError, negError) / len(data)

def bestThreshold(data, index, errorFunction):
   '''Compute best threshold for a given feature. Returns (threshold, error)'''

   thresholds = [point[index] for (point, label) in data]
   def makeThreshold(t):
      return lambda x: 1 if x[index] >= t else -1
   errors = [(threshold, errorFunction(data, makeThreshold(threshold))) for threshold in thresholds]
   return min(errors, key=lambda p: p[1])
{{< /highlight >}}

Here we allow the user to provide a generic error function that the weak learner tries to minimize, but in our case it will just be `minLabelErrorOfHypothesisAndNegation`. In words, our threshold function will label an example as $+1$ if feature $i$ has value greater than the threshold and $-1$ otherwise. But we might want to do the opposite, labeling $-1$ above the threshold and $+1$ below. The `bestThreshold` function doesn't care, it just wants to know which threshold value is the best. Then we compute what the right hypothesis is in the next function.

{{< highlight python >}}
def buildDecisionStump(drawExample, errorFunction=defaultError):
   # find the index of the best feature to split on, and the best threshold for
   # that index. A labeled example is a pair (example, label) and drawExample() 
   # accepts no arguments and returns a labeled example. 

   data = [drawExample() for _ in range(500)]

   bestThresholds = [(i,) + bestThreshold(data, i, errorFunction) for i in range(len(data[0][0]))]
   feature, thresh, _ = min(bestThresholds, key = lambda p: p[2])

   stump = Stump()
   stump.splitFeature = feature
   stump.splitThreshold = thresh
   stump.gtLabel = majorityVote([x for x in data if x[0][feature] >= thresh])
   stump.ltLabel = majorityVote([x for x in data if x[0][feature] < thresh])

   return stump
{{< /highlight >}}

It's a little bit inefficient but no matter. To illustrate the PAC framework we emphasize that the weak learner needs nothing except the ability to draw from a distribution. It does so, and then it computes the best threshold and creates a new stump reflecting that. The `majorityVote` function just picks the most common label of examples in the list. Note that drawing 500 samples is arbitrary, and in general we might increase it to increase the success probability of finding a good hypothesis. In fact, when proving PAC-learning theorems the number of samples drawn often depends on the accuracy and confidence parameters $\varepsilon, \delta$. We omit them here for simplicity.

## Strong learners from weak learners

So suppose we have a weak learner $A$ for a concept class $H$, and for any concept $c$ from $H$ it can produce with probability at least $1 - \delta$ a hypothesis $h$ with error bound $1/2 - \eta$. How can we modify this algorithm to get a strong learner? Here is an idea: we can maintain a large number of separate instances of the weak learner $A$, run them on our dataset, and then combine their hypotheses with a majority vote. In code this might look like the following python snippet. For now examples are binary vectors and the labels are $\pm 1$, so the sign of a real number will be its label.

{{< highlight python >}}
def boost(learner, data, rounds=100):
   m = len(data)
   learners = [learner(random.choice(data, m/rounds)) for _ in range(rounds)]
   
   def hypothesis(example):
      return sign(sum(1/rounds * h(example) for h in learners))

   return hypothesis
{{< /highlight >}}

This is a bit too simplistic: what if the majority of the weak learners are wrong? In fact, with an overly naive mindset one might imagine a scenario in which the different instances of $A$ have high disagreement, so is the prediction going to depend on which random subset the learner happens to get? We can do better: instead of taking a majority vote we can take a _weighted _majority vote. That is, give the weak learner a random subset of your data, and then test its hypothesis on the data to get a good estimate of its error. Then you can use this error to say whether the hypothesis is any good, and give good hypotheses high weight and bad hypotheses low weight (proportionally to the error). Then the "boosted" hypothesis would take a _weighted_ majority vote of all your hypotheses on an example. This might look like the following.

{{< highlight python >}}
# data is a list of (example, label) pairs
def error(hypothesis, data):
   return sum(1 for x,y in data if hypothesis(x) != y) / len(data)

def boost(learner, data, rounds=100):
   m = len(data)
   weights = [0] * rounds
   learners = [None] * rounds

   for t in range(rounds):
      learners[t] = learner(random.choice(data, m/rounds))
      weights[t] = 1 - error(learners[t], data)
   
   def hypothesis(example):
      return sign(sum(weight * h(example) for (h, weight) in zip(learners, weights)))

   return hypothesis
{{< /highlight >}}

This might be better, but we can do something even cleverer. Rather than use the estimated error just to say something about the hypothesis, we can identify the mislabeled examples in a round and somehow _encourage_ $A$ to do better at classifying those examples in later rounds. This turns out to be the key insight, and it's why the algorithm is called AdaBoost (Ada stands for "adaptive"). We're adaptively modifying the distribution over the training data we feed to $A$ based on which data $A$ learns "easily" and which it does not. So as the boosting algorithm runs, the distribution given to $A$ has more and more probability weight on the examples that $A$ misclassified. And, this is the key, $A$ has the guarantee that it will weak learn _no matter what the distribution over the data is_. Of course, it's error is also measured relative to the adaptively chosen distribution, and the crux of the argument will be relating this error to the error on the original distribution we're trying to strong learn.

To implement this idea in mathematics, we will start with a fixed sample $X = \{x_1, \dots, x_m\}$ drawn from $D$ and assign a weight $0 \leq \mu_i \leq 1$ to each $x_i$. Call $c(x)$ the true label of an example. Initially, set $\mu_i$ to be 1. Since our dataset can have repetitions, normalizing the $\mu_i$ to a probability distribution gives an estimate of $D$. Now we'll pick some "update" parameter $\zeta > 1$ (this is intentionally vague). Then we'll repeat the following procedure for some number of rounds $t = 1, \dots, T$.

 	  1. Renormalize the $\mu_i$ to a probability distribution.
 	  2. Train the weak learner $A$, and provide it with a simulated distribution $D'$ that draws examples $x_i$ according to their weights $\mu_i$. The weak learner outputs a hypothesis $h_t$.
 	  3. For every example $x_i$ mislabeled by $h_t$, update $\mu_i$ by replacing it with $\mu_i \zeta$.
 	  4. For every correctly labeled example replace $\mu_i$ with $\mu_i / \zeta$.

At the end our final hypothesis will be a weighted majority vote of all the $h_t$, where the weights depend on the amount of error in each round. Note that when the weak learner misclassifies an example we _increase _the weight of that example, which means we're increasing the likelihood it will be drawn in future rounds. In particular, in order to maintain good accuracy the weak learner will eventually have to produce a hypothesis that fixes its mistakes in previous rounds. Likewise, when examples are correctly classified, we reduce their weights. So examples that are "easy" to learn are given lower emphasis. And that's it. That's the prize-winning idea. It's elegant, powerful, and easy to understand. The rest is working out the values of all the parameters and proving it does what it's supposed to.

## The details and a proof

Let's jump straight into a Python program that performs boosting.

First we pick a data representation. Examples are pairs $(x,c(x))$ whose type is the tuple `(object, int)`. Our labels will be $\pm 1$ valued. Since our algorithm is entirely black-box, we don't need to assume anything about how the examples $X$ are represented. Our dataset is just a list of labeled examples, and the weights are floats. So our boosting function prototype looks like this

{{< highlight python >}}
# boost: [(object, int)], learner, int -> (object -> int)
# boost the given weak learner into a strong learner
def boost(examples, weakLearner, rounds):
   ...
{{< /highlight >}}

And a weak learner, as we saw for decision stumps, has the following function prototype.

{{< highlight python >}}
# weakLearner: (() -> (list, label)) -> (list -> label)
# accept as input a function that draws labeled examples from a distribution,
# and output a hypothesis list -> label
def weakLearner(draw):
   ...
   return hypothesis
{{< /highlight >}}

Assuming we have a weak learner, we can fill in the rest of the boosting algorithm with some mysterious details. First, a helper function to compute the weighted error of a hypothesis on some exmaples. It also returns the correctness of the hypothesis on each example which we'll use later.

{{< highlight python >}}
# compute the weighted error of a given hypothesis on a distribution
# return all of the hypothesis results and the error
def weightedLabelError(h, examples, weights):
   hypothesisResults = [h(x)*y for (x,y) in examples] # +1 if correct, else -1
   return hypothesisResults, sum(w for (z,w) in zip(hypothesisResults, weights) if z < 0)
{{< /highlight >}}

Next we have the main boosting algorithm. Here `draw` is a function that accepts as input a list of floats that sum to 1 and picks an index proportional to the weight of the entry at that index.

{{< highlight python >}} 
def boost(examples, weakLearner, rounds):
   distr = normalize([1.] * len(examples))
   hypotheses = [None] * rounds
   alpha = [0] * rounds

   for t in range(rounds):
      def drawExample():
         return examples[draw(distr)]

      hypotheses[t] = weakLearner(drawExample)
      hypothesisResults, error = computeError(hypotheses[t], examples, distr)

      alpha[t] = 0.5 * math.log((1 - error) / (.0001 + error))
      distr = normalize([d * math.exp(-alpha[t] * h)
                         for (d,h) in zip(distr, hypothesisResults)])
      print("Round %d, error %.3f" % (t, error))

   def finalHypothesis(x):
      return sign(sum(a * h(x) for (a, h) in zip(alpha, hypotheses)))

   return finalHypothesis
{{< /highlight >}}

The code is almost clear. For each round we run the weak learner on our hand-crafted distribution. We compute the error of the resulting hypothesis on that distribution, and then we update the distribution in this mysterious way depending on some alphas and logs and exponentials. In particular, we use the expression $c(x) h(x)$, the product of the true label and predicted label, as computed in `weightedLabelError`. As the comment says, this will either be $+1$ or $-1$ depending on whether the predicted label is correct or incorrect, respectively. The choice of those strange logarithms and exponentials are the result of some optimization: they allow us to minimize training error as quickly as possible (we'll see this in the proof to follow). The rest of this section will prove that this works when the weak learner is correct. One small caveat: in the proof we will assume the error of the hypothesis is not zero (because a weak learner is not supposed to return a perfect hypothesis!), but in practice we want to avoid dividing by zero so we add the small 0.0001 to avoid that. As a quick self-check: why wouldn't we just stop in the middle and output that "perfect" hypothesis? (What distribution is it "perfect" over? It might not be the original distribution!)

If we wanted to define the algorithm in pseudocode (which helps for the proof) we would write it this way. Given $T$ rounds, start with $D_1$ being the uniform distribution over labeled input examples $X$, where $x$ has label $c(x)$. Say there are $m$ input examples.

 	  1. For each $t=1, \dots T$:

 	    1. Let $h_t$ be the weak learning algorithm run on $D_t$.
 	    2. Let $\varepsilon_t$ be the error of $h_t$ on $D_t$.
 	    3. Let $\alpha_t = \frac{1}{2} \log ((1- \varepsilon) / \varepsilon)$.
 	    4. Update each entry of $D_{t+1}$ by the rule $D_{t+1}(x) = \frac{D_t(x)}{Z_t} e^{- h_t(x) c(x) \alpha_t}$, where $Z_t$ is chosen to normalize $D_{t+1}$ to a distribution.

 	  2. Output as the final hypothesis the sign of $h(x) = \sum_{t=1}^T \alpha_t h_t(x)$, i.e. $h'(x) = \textup{sign}(h(x))$.

Now let's prove this works. That is, we'll prove the error on the input dataset (the training set) decreases exponentially quickly in the number of rounds. Then we'll run it on an example and save generalization error for the next post. Over many years this algorithm and tweaked so that the proof is very straightforward.

**Theorem:** If AdaBoost is given a weak learner and stopped on round $t$, and the edge $\eta_t$ over random choice satisfies $\varepsilon_t = 1/2 - \eta_t$, then the training error of the AdaBoost is at most $e^{-2 \sum_t \eta_t^2}$.

_Proof. _ Let $m$ be the number of examples given to the boosting algorithm. First, we derive a closed-form expression for $D_{t}$ in terms of the normalization constants $Z_t$. Expanding the recurrence relation gives

$\displaystyle D_{t}(x) = D_1(x)\frac{e^{-\alpha_1 c(x) h_1(x)}}{Z_1} \dots \frac{e^{- \alpha_t c(x) h_t(x)}}{Z_t}$

Because the starting distribution is uniform, and combining the products into a sum of the exponents, this simplifies to

$\displaystyle \frac{1}{m} \frac{e^{-c(x) \sum_{s=1}^t \alpha_s h_t(x)}}{\prod_{s=1}^t Z_s} = \frac{1}{m}\frac{e^{-c(x) h(x)}}{\prod_s Z_s}$

Next, we show that the training error is bounded by the product of the normalization terms $\prod_{s=1}^t Z_s$. This part has always seemed strange to me, that the training error of boosting depends on the factors you need to normalize a distribution. But it's just a different perspective on the multiplicative weights scheme. If we didn't explicitly normalize the distribution at each step, we'd get nonnegative weights (which we could convert to a distribution just for the sampling step) and the training error would depend on the product of the weight updates in each step. Anyway let's prove it.

The training error is defined to be $\frac{1}{m} (\textup{\# incorrect predictions by } h)$. This can be written with an indicator function as follows:

$\displaystyle \frac{1}{m} \sum_{x \in X} 1_{c(x) h(x) \leq 0}$

Because the sign of $h(x)$ determines its prediction, the product is negative when $h$ is incorrect. Now we can do a strange thing, we're going to upper bound the indicator function (which is either zero or one) by $e^{-c(x)h(x)}$. This works because if $h$ predicts correctly then the indicator function is zero while the exponential is greater than zero. On the other hand if $h$ is incorrect the exponential is greater than one because $e^z \geq 1$ when $z \geq 0$. So we get

$\displaystyle \leq \sum_i \frac{1}{m} e^{-c(x)h(x)}$

and rearranging the formula for $D_t$ from the first part gives

$\displaystyle \sum_{x \in X} D_T(x) \prod_{t=1}^T Z_t$

Since the $D_T$ forms a distribution, it sums to 1 and we can factor the $Z_t$ out. So the training error is just bounded by the $\prod_{t=1}^T Z_t$.

The last step is to bound the product of the normalization factors. It's enough to show that $Z_t \leq e^{-2 \eta_t^2}$. The normalization constant is just defined as the sum of the numerator of the terms in step D. i.e.

$\displaystyle Z_t = \sum_i D_t(i) e^{-\alpha_t c(x) h_t(x)}$

We can split this up into the correct and incorrect terms (that contribute to $+1$ or $-1$ in the exponent) to get

$\displaystyle Z_t = e^{-\alpha_t} \sum_{\textup{correct } x} D_t(x) + e^{\alpha_t} \sum_{\textup{incorrect } x} D_t(x)$

But by definition the sum of the incorrect part of $D$ is $\varepsilon_t$ and $1-\varepsilon_t$ for the correct part. So we get

$\displaystyle e^{-\alpha_t}(1-\varepsilon_t) + e^{\alpha_t} \varepsilon_t$

Finally, since this is an upper bound we want to pick $\alpha_t$ so as to minimize this expression. With a little calculus you can see the $\alpha_t$ we chose in the algorithm pseudocode achieves the minimum, and this simplifies to $2 \sqrt{\varepsilon_t (1-\varepsilon_t)}$. Plug in $\varepsilon_t = 1/2 - \eta_t$ to get $\sqrt{1 - 4 \eta_t^2}$ and use the calculus fact that $1 - z \leq e^{-z}$ to get $e^{-2\eta_t^2}$ as desired.

$\square$

This is fine and dandy, it says that if you have a true weak learner then the training error of AdaBoost vanishes exponentially fast in the number of boosting rounds. But what about generalization error? What we really care about is whether the hypothesis produced by boosting has low error on the original distribution $D$ as a whole, not just the training sample we started with.

One might expect that if you run boosting for more and more rounds, then it will eventually overfit the training data and its generalization accuracy will degrade. However, in practice this is not the case! The longer you boost, even if you get down to zero training error, the _better _generalization tends to be. For a long time this was sort of a mystery, and we'll resolve the mystery in the sequel to this post. For now, we'll close by showing a run of AdaBoost on some real world data.

## The "adult" census dataset

[The "adult" dataset](https://archive.ics.uci.edu/ml/datasets/Adult) is a standard dataset taken from the 1994 US census. It tracks a number of demographic and employment features (including gender, age, employment sector, etc.) and the goal is to predict whether an individual makes over $50k per year. Here are the first few lines from the training set.

    
    39, State-gov, 77516, Bachelors, 13, Never-married, Adm-clerical, Not-in-family, White, Male, 2174, 0, 40, United-States, <=50K
    50, Self-emp-not-inc, 83311, Bachelors, 13, Married-civ-spouse, Exec-managerial, Husband, White, Male, 0, 0, 13, United-States, <=50K
    38, Private, 215646, HS-grad, 9, Divorced, Handlers-cleaners, Not-in-family, White, Male, 0, 0, 40, United-States, <=50K
    53, Private, 234721, 11th, 7, Married-civ-spouse, Handlers-cleaners, Husband, Black, Male, 0, 0, 40, United-States, <=50K
    28, Private, 338409, Bachelors, 13, Married-civ-spouse, Prof-specialty, Wife, Black, Female, 0, 0, 40, Cuba, <=50K
    37, Private, 284582, Masters, 14, Married-civ-spouse, Exec-managerial, Wife, White, Female, 0, 0, 40, United-States, <=50K

We perform some preprocessing of the data, so that the categorical examples turn into binary features. You can see the full details in the [github repository for this post](https://github.com/j2kun/boosting); here are the first few post-processed lines (my newlines added).

{{< highlight python >}}
>>> from data import adult
>>> train, test = adult.load()
>>> train[:3]
[((39, 1, 0, 0, 0, 0, 0, 1, 0, 0, 13, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 2174, 0, 40, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0), -1), 

((50, 1, 0, 1, 0, 0, 0, 0, 0, 0, 13, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 13, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0), -1), 

((38, 1, 1, 0, 0, 0, 0, 0, 0, 0, 9, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 40, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0), -1)]
{{< /highlight >}}

Now we can run boosting on the training data, and compute its error on the test data.

{{< highlight python >}}
>>> from boosting import boost
>>> from data import adult
>>> from decisionstump import buildDecisionStump
>>> train, test = adult.load()
>>> weakLearner = buildDecisionStump
>>> rounds = 20
>>> h = boost(train, weakLearner, rounds)
Round 0, error 0.199
Round 1, error 0.231
Round 2, error 0.308
Round 3, error 0.380
Round 4, error 0.392
Round 5, error 0.451
Round 6, error 0.436
Round 7, error 0.459
Round 8, error 0.452
Round 9, error 0.432
Round 10, error 0.444
Round 11, error 0.447
Round 12, error 0.450
Round 13, error 0.454
Round 14, error 0.505
Round 15, error 0.476
Round 16, error 0.484
Round 17, error 0.500
Round 18, error 0.493
Round 19, error 0.473
>>> error(h, train)
0.153343
>>> error(h, test)
0.151711
{{< /highlight >}}

This isn't too shabby. I've tried running boosting for more rounds (a hundred) and the error doesn't seem to improve by much. This implies that finding the best decision stump is not a weak learner (or at least it fails for this dataset), and we can see that indeed the training errors across rounds roughly tend to 1/2.

Though we have not compared our results above to any baseline, AdaBoost seems to work pretty well. This is kind of a meta point about theoretical computer science research. One spends years trying to devise algorithms that work in theory (and finding conditions under which we can get good algorithms in theory), but when it comes to practice we can't do anything but hope the algorithms will work well. It's kind of amazing that something like Boosting works in practice. It's not clear to me that weak learners should exist at all, even for a given real world problem. But the results speak for themselves.

## Next time

Next time we'll get a bit deeper into the theory of boosting. We'll derive the notion of a "margin" that quantifies the confidence of boosting in its prediction. Then we'll describe (and maybe prove) a theorem that says if the "minimum margin" of AdaBoost on the training data is large, then the generalization error of AdaBoost on the entire distribution is small. The notion of a margin is actually quite a deep one, and it shows up in another famous machine learning technique called the Support Vector Machine. In fact, it's part of some recent research I've been working on as well. More on that in the future.

If you're dying to learn more about Boosting, but don't want to wait for me, check out the book [Boosting: Foundations and Algorithms](http://www.amazon.com/gp/product/B00946TOVW/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B00946TOVW&linkCode=as2&tag=mathinterprog-20&linkId=Q7NPJFXCBENWLUBE), by Freund and Schapire.

Until next time!
