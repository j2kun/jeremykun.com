---
author: jeremykun
date: 2013-08-18 22:43:20+00:00
draft: false
title: Linear Regression
type: post
url: /2013/08/18/linear-regression/
categories:
- Analysis
- Linear Algebra
- Optimization
- Statistics
tags:
- conditional probability
- covariance
- expectation
- linear regression
- python
- statistics
- variance
---

Machine learning is broadly split into two camps, statistical learning and non-statistical learning. The latter we've started to get a good picture of on this blog; we approached [Perceptrons](http://jeremykun.com/2011/08/11/the-perceptron-and-all-the-things-it-cant-perceive/), [decision trees](http://jeremykun.com/2012/10/08/decision-trees-and-political-party-classification/), and [neural networks](http://jeremykun.com/2012/12/09/neural-networks-and-backpropagation/) from a non-statistical perspective. And generally "statistical" learning is just that, a perspective. Data is phrased in terms of independent and dependent variables, and statistical techniques are leveraged against the data. In this post we'll focus on the simplest example of this, linear regression, and in the sequel see it applied to various learning problems.

As usual, [all of the code](https://github.com/j2kun/linear-regression) presented in this post is available on [this blog's Github page](https://github.com/j2kun?tab=repositories).


## The Linear Model, in Two Variables


And so given a data set we start by splitting it into independent variables and dependent variables. For this section, we'll focus on the case of two variables, $X, Y$. Here, if we want to be completely formal, $X,Y$ are real-valued random variables on the same probability space (see our [primer on probability theory](http://jeremykun.com/2013/01/04/probability-theory-a-primer/) to keep up with this sort of terminology, but we won't rely on it heavily in this post), and we choose one of them, say $X$, to be the _independent variable_ and the other, say $Y$, to be the _dependent variable_. All that means in is that we are assuming there is a relationship between $X$ and $Y$, and that we intend to use the value of $X$ to predict the value of $Y$. Perhaps a more computer-sciencey terminology would be to call the variables _features_ and have _input features _and_ output features, _but we will try to stick to the statistical terminology.

As a quick example, our sample space might be the set of all people, $X$ could be age, and $Y$ could be height. Then by calling age "independent," we're asserting that we're trying to use age to predict height.

One of the strongest mainstays of statistics is the linear model. That is, when there aren't any known relationships among the observed data, the simplest possible relationship one could discover is a linear one. A change in $X$ corresponds to a proportional change in $Y$, and so one could hope there exist constants $a,b$ so that (as random variables) $Y = aX + b$.  If this were the case then we could just draw many pairs of sample values of $X$ and $Y$, and try to estimate the value of $a$ and $b$.

If the data actually lies on a line, then two sample points will be enough to get a perfect prediction. Of course, nothing is exact outside of mathematics. And so if we were to use data coming from the real world, and even if we were to somehow produce some constants $a, b$, our "predictor" would almost always be off by a bit. In the diagram below, where it's clear that the relationship between the variables is linear, only a small fraction of the data points appear to lie on the line itself.

[caption id="" align="aligncenter" width="400"]![](http://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Linear_regression.svg/400px-Linear_regression.svg.png)
An example of a linear model for a set of points (credit Wikipedia).[/caption]

In such scenarios it would be hopelessly foolish to wish for a perfect predictor, and so instead we wish to summarize the trends in the data using a simple description mechanism. In this case, that mechanism is a line. Now the computation required to find the "best" coefficients of the line is quite straightforward once we pick a suitable notion of what "best" means.

Now suppose that we call our (presently unknown) prediction function $\hat{f}$. We often call the function we're producing as a result of our learning algorithm the _hypothesis_, but in this case we'll stick to calling it a prediction function. If we're given a data point $(x,y)$ where $x$ is a value of $X$ and $y$ of $Y$, then the _error_ of our predictor on this example is $|y - \hat{f}(x)|$. Geometrically this is the vertical distance from the actual $y$ value to our prediction for the same $x$, and so we'd like to minimize this error. Indeed, we'd like to minimize the sum of all the errors of our linear predictor over all data points we see. We'll describe this in more detail momentarily.

The word "minimize" might evoke long suppressed memories of torturous Calculus lessons, and indeed we will use elementary Calculus to find the optimal linear predictor. But one small catch is that our error function, being an absolute value, is not differentiable! To mend this we observe that minimizing the absolute value of a number is the same as minimizing the square of a number. In fact, $|x| = \sqrt(x^2)$, and the square root function and its inverse are both increasing functions; they preserve minima of sets of nonnegative numbers.  So we can describe our error as $(y - \hat{f}(x))^2$, and use calculus to our heart's content.

To explicitly formalize the problem, given a set of data points $(x_i, y_i)_{i=1}^n$ and a potential prediction line $\hat{f}(x) = ax + b$, we define the error of $\hat{f}$ on the examples to be


$\displaystyle S(a,b) = \sum_{i=1}^n (y_i - \hat{f}(x_i))^2$




Which can also be written as




$\displaystyle S(a,b) = \sum_{i=1}^n (y_i - ax_i - b)^2$




Note that since we're fixing our data sample, the function $S$ is purely a function of the variables $a,b$. Now we want to minimize this quantity with respect to $a,b$, so we can take a gradient,




$\displaystyle \frac{\partial S}{\partial a} = -2 \sum_{i=1}^n (y_i - ax_i - b) x_i$




$\displaystyle \frac{\partial S}{\partial b} = -2 \sum_{i=1}^n (y_i -ax_i - b)$




and set them simultaneously equal to zero. In the first we solve for $b$:




$\displaystyle 0 = -2 \sum_{i=1}^n y_i - ax_i - b = -2 \left (-nb + \sum_{i=1}^n y_i - ax_i \right )$




$\displaystyle b = \frac{1}{n} \sum_{i=1}^n y_i - ax_i$




If we denote by $x_{\textup{avg}} = \frac{1}{n} \sum_i x_i$ this is just $b = y_{\textup{avg}} - ax_{\textup{avg}}$. Substituting $b$ into the other equation we get




$\displaystyle -2 \sum_{i=1}^n (y_ix_i - ax_i^2 - y_{\textup{avg}}x_i - ax_{\textup{avg}}x_i ) = 0$




Which, by factoring out $a$, further simplifies to




$\displaystyle 0 = \sum_{i=1}^n y_ix_i - y_{\textup{avg}}x_i - a \sum_{i=1}^n (x_i^2 - x_{\textup{avg}}x_i)$




And so




$\displaystyle a = \frac{\sum_{i=1}^n (y_i - y_{\textup{avg}})x_i }{\sum_{i=1}^n(x_i - x_{\textup{avg}})x_i}$




And it's not hard to see (by taking second partials, if you wish) that this corresponds to a minimum of the error function. This closed form gives us an immediate algorithm to compute the optimal linear estimator. In Python,




{{< highlight python >}}avg = lambda L: 1.0* sum(L)/len(L)

def bestLinearEstimator(points):
   xAvg, yAvg = map(avg, zip(*points))

   aNum = 0
   aDenom = 0
   for (x,y) in points:
      aNum += (y - yAvg) * x
      aDenom += (x - xAvg) * x

   a = float(aNum) / aDenom
   b = yAvg - a * xAvg
   return (a, b), lambda x: a*x + b
{{< /highlight >}}

and a quick example of its use on synthetic data points:

    
    >>> import random
    >>> a = 0.5
    >>> b = 7.0
    >>> points = [(x, a*x + b + (random.random() * 0.4 - 0.2)) for x in [random.random() * 10 for _ in range(100)]]
    >>> bestLinearEstimator(points)[0]
    (0.49649543577814137, 6.993035962110321)




## Many Variables and Matrix Form


If we take those two variables $x,y$ and tinker with them a bit, we can represent the solution to our regression problem in a different (a priori strange) way in terms of matrix multiplication.

First, we'll transform the prediction function into matrixy style. We add in an extra variable $x_0$ which we force to be 1, and then we can write our prediction line in a _vector form_ as $\mathbf{w} = (a,b)$. What is the benefit of such an awkward maneuver? It allows us to write the _evaluation_ of our prediction function as a dot product


$\displaystyle \hat{f}(x_0, x) = \left \langle (x_0, x), (b, a) \right \rangle = x_0b + ax = ax + b$




Now the notation is starting to get quite ugly, so let's rename the coefficients of our line $\mathbf{w} = (w_0, w_1)$, and the coefficients of the input data $\mathbf{x} = (x_0, x_1)$. The output is still $y$. Here we understand implicitly that the indices line up: if $w_0$ is the constant term, then that makes $x_0 = 1$ our extra variable (often called a _bias_ variable by statistically minded folks), and $x_1$ is the linear term with coefficient $w_1$. Now we can just write the prediction function as




$\hat{f}(\mathbf{x}) = \left \langle \mathbf{w}, \mathbf{x} \right \rangle$




We still haven't really seen the benefit of this vector notation (and we won't see it's true power until we extend this to kernel ridge regression in the next post), but we do have at least one additional notational convenience: we can add arbitrarily many input variables without changing our notation.




If we expand our horizons to think of the random variable $Y$ depending on the $n$ random variables $X_1, \dots, X_n$, then our data will come in tuples of the form $(\mathbf{x}, y) = ((x_0, x_1, \dots, x_n), y)$, where again the $x_0$ is fixed to 1. Then expanding our line $\mathbf{w} = (w_0 , \dots, w_n)$, our evaluation function is still $\hat{f}(\mathbf{x}) = \left \langle \mathbf{w}, \mathbf{x} \right \rangle$. Excellent.




Now we can write our error function using the same style of compact notation. In this case, we will store all of our input data points $\mathbf{x}_j$ as rows of a matrix $X$ and the output values $y_j$ as entries of a vector $\mathbf{y}$. Forgetting the boldface notation and just understanding everything as a vector or matrix, we can write the deviation of the predictor (on all the data points) from the true values as




$y - Xw$




Indeed, each entry of the vector $Xw$ is a dot product of a row of $X$ (an input data point) with the coefficients of the line $w$. It's just $\hat{f}$ applied to all the input data and stored as the entries of a vector. We still have the sign issue we did before, and so we can just take the square norm of the result and get the same effect as before:




$\displaystyle S(w) = \| y - Xw \|^2$




This is just taking a dot product of $y-Xw$ with itself. This form is awkward to differentiate because the variable $w$ is nested in the norm. Luckily, we can get the same result by viewing $y - Xw$ as a 1-by-$n$ matrix, transposing it, and multiplying by $y-Xw$.




$\displaystyle S(w) = (y - Xw)^{\textup{T}}(y-Xw) = y^{\textup{T}}y -2w^{\textup{T}}X^{\textup{T}}y + w^{\textup{T}}X^{\textup{T}}Xw$




This notation is widely used, in particular because we have [nice formulas for calculus on such forms](http://orion.uwaterloo.ca/~hwolkowi/matrixcookbook.pdf). And so we can compute a gradient of $S$ with respect to each of the $w_i$ variables in $w$ at the same time, and express the result as a vector. This is what taking a "partial derivative" with respect to a vector means: we just represent the system of partial derivates with respect to each entry as a vector. In this case, and using formula 61 from page 9 and formula 120 on page 13 of [The Matrix Cookbook](http://orion.uwaterloo.ca/~hwolkowi/matrixcookbook.pdf), we get




$\displaystyle \frac{\partial S}{\partial w} = -2X^{\textup{T}}y + 2X^{\textup{T}}Xw$




Indeed, it's quite trivial to prove the latter formula, that for any vector $x$, the partial $\frac{\partial x^{\textup{T}}x}{\partial x} = 2x$. If the reader feels uncomfortable with this, we suggest taking the time to unpack the notation (which we admittedly just spent so long packing) and take a classical derivative entry-by-entry.




Solving the above quantity for $w$ gives $w = (X^{\textup{T}}X)^{-1}X^{\textup{T}}y$, assuming the inverse of $X^{\textup{T}}X$ exists. Again, we'll spare the details proving that this is a minimum of the error function, but inspecting second derivatives provides this.




Now we can have a slightly more complicated program to compute the linear estimator for one input variable and many output variables. It's "more complicated" in that much more mathematics is happening behind the code, but just admire the brevity!




{{< highlight python >}}from numpy import array, dot, transpose
from numpy.linalg import inv

def bestLinearEstimatorMV(points):
   # input points are n+1 tuples of n inputs and 1 output
   X = array([[1] + list(p[:-1]) for p in points]) # add bias as x_0
   y = array([p[-1] for p in points])

   Xt = transpose(X)
   theInverse = inv(dot(Xt, X))
   w = dot(dot(theInverse, Xt), y)
   return w, lambda x: dot(w, x)
{{< /highlight >}}



Here are some examples of its use. First we check consistency by verifying that it agrees with the test used in the two-variable case (note the reordering of the variables):




    
    >>> print(bestLinearEstimatorMV(points)[0])
    [ 6.97687136  0.50284939]


And a more complicated example:

    
    >>> trueW = array([-3,1,2,3,4,5])
    >>> bias, linearTerms = trueW[0], trueW[1:]
    >>> points = [tuple(v) + (dot(linearTerms, v) + bias + noise(),) for v in [numpy.random.random(5) for _ in range(100)]]
    >>> print(bestLinearEstimatorMV(points)[0])
    [-3.02698484  1.03984389  2.01999929  3.0046756   4.01240348  4.99515123]


As a quick reminder, [all of the code used in this post](https://github.com/j2kun/linear-regression) is available on [this blog's Github page](https://github.com/j2kun?tab=repositories).


## Bias and Variance


There is a deeper explanation of the linear model we've been studying. In particular, there is a general technique in statistics called [maximum likelihood estimation](http://en.wikipedia.org/wiki/Maximum_likelihood). And, to be as concise as possible, the linear regression formulas we've derived above provide the maximum likelihood estimator for a line with symmetric "Gaussian noise." Rather than go into maximum likelihood estimation in general, we'll just describe what it means to be a "line with Gaussian noise," and measure the linear model's bias and variance with respect to such a model. We saw this very briefly in the test cases for the code in the past two sections. Just a quick warning: the proofs we present in this section will use the notation and propositions of basic probability theory [we've discussed on this blog before](http://jeremykun.com/2013/01/04/probability-theory-a-primer/).

So what we've done so far in this post is describe a computational process that accepts as input some points and produces as output a line. We have said nothing about the quality of the line, and indeed we cannot say anything about its quality without some assumptions on how the data was generated.  In usual statistical fashion, we will assume that the true data is being generated by an actual line, but with some added noise.

Specifically, let's return to the case of two random variables $X,Y$. If we assume that $Y$ is perfectly determined by $X$ via some linear equation $Y = aX + b$, then as we already mentioned we can produce a perfect estimator using a mere two examples. On the other hand, what if every time we take a new $x$ example, its corresponding $y$ value is perturbed by some random coin flip (flipped at the time the example is produced)? Then the value of $y_i$ would be $y_i = ax_i + b + \eta_i$, and we say all the $\eta_i$ are drawn independently and uniformly at random from the set $\left \{ -1,1 \right \}$. In other words, with probability 1/2 we get -1, and otherwise 1, and none of the $\eta_i$ depend on each other. In fact, we just want to make the blanket assumption that the noise doesn't depend on _anything_ (not the data drawn, the method we're using to solve the problem, what our favorite color is...). In the notation of random variables, we'd call $H$ the random variable producing the noise (in Greek $H$ is the capital letter for $\eta$), and write $Y = aX + b + H$.

More realistically, the noise isn't chosen uniformly from $\pm 1$, but is rather chosen to be Gaussian with mean $0$ and some variance $\sigma$. We'd denote this by $\eta_i \sim N(\mu, \sigma)$, and say the $\eta_i$ are drawn independently from this normal distribution. If the reader is uncomfortable with Gaussian noise (it's certainly a nontrivial problem to generate it computationally), just stick to the noise we defined in the previous paragraph. For the purpose of this post, any symmetric noise will result in the same analysis (and the code samples above use uniform noise over an interval anyway).

Moving back to the case of many variables, we assume our data points $y$ are given by $y = Xw + H$ where $X$ is the observed data and $H$ is Gaussian noise with mean zero and some (unknown) standard deviation $\sigma$. Then if we call $\hat{w}$ our predicted linear coefficients (randomly depending on which samples are drawn), then its expected value conditioned on the data is


$\displaystyle \textup{E}(\hat{w} | X) = \textup{E}((X^{\textup{T}}X)^{-1}X^{\textup{T}}y | X)$




Replacing $y$ by $Xw + H$,




$\displaystyle \begin{array} {lcl} \textup{E}(\hat{w} | X) & = & \textup{E}((X^{\textup{T}}X)^{-1}X^{\textup{T}}(Xw + H) | X) \\ & = & \textup{E}((X^{\textup{T}}X)^{-1}X^{\textup{T}}Xw + (X^{\textup{T}}X)^{-1}X^{\textup{T}}H | X) \end{array}$




Notice that the first term is a fat matrix ($X^{\textup{T}}X$) multiplied by its own inverse, so that cancels to 1. By linearity of expectation, we can split the resulting expression up as




$\textup{E}(w | X) + (X^{\textup{T}}X)^{-1}X^{\textup{T}}\textup{E}(H | X)$




but $w$ is constant (so its expected value is just itself) and $\textup{E}(H | X) = 0$ by assumption that the noise is symmetric. So then the expected value of $\hat{w}$ is just $w$. Because this is true for all choices of data $X$, the bias of our estimator is zero.




The question of variance is a bit trickier, because the variance of the entries of $\hat{w}$ actually do depend on which samples are drawn. Briefly, to compute the covariance matrix of the $w_i$ as variables depending on $X$, we apply the definition:




$\textup{Var}(\hat{w} | X) = \textup{E}(\| w - \textup{E}(w) \|^2 | X)$




And after some tedious expanding and rewriting and recalling that the covariance matrix of $H$ is just the diagonal matrix $\sigma^2 I_n$, we get that




$\textup{Var}(\hat{w} | X) = \sigma^2 (X^{\textup{T}}X)^{-1}$




This means that if we get unlucky and draw some sample which makes some entries of $(X^{\textup{T}}X)^{-1}$ big, then our estimator will vary a lot from the truth. This can happen for a variety of reasons, one of which is including irrelevant input variables in the computation. Unfortunately a deeper discussion of the statistical issues that arise when trying to make hypotheses in such situations. However, the concept of a bias-variance tradeoff is quite relevant. As we'll see next time, a technique called _ridge-regression_ sacrifices some bias in this standard linear regression model in order to dampen the variance. Moreover, a "kernel trick" allows us to make non-linear predictions, turning this simple model for linear estimation into a very powerful learning tool.




Until then!
