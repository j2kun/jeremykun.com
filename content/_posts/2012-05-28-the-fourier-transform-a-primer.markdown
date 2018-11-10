---
author: jeremykun
date: 2012-05-28 00:00:15+00:00
draft: false
title: The Fourier Transform — A Primer
type: post
url: /2012/05/27/the-fourier-transform-a-primer/
categories:
- Analysis
- Primers
tags:
- convolution
- duality
- fourier analysis
- fourier transform
- mathematics
- primer
---

[![](http://imgs.xkcd.com/comics/fourier.jpg)
](http://xkcd.com/26)

In our [last primer](http://jeremykun.wordpress.com/2012/04/25/the-fourier-series/) we saw the Fourier series, which flushed out the notion that a periodic function can be represented as an infinite series of sines and cosines. While this is fine and dandy, and quite a powerful tool, it does not suffice for the real world. In the real world, very little is truly periodic, especially since human measurements can only record a finite period of time. Even things we wish to explore on this blog are hardly periodic (for instance, image analysis). To compensate, we'll develop the Fourier transform, which can be thought of as a limiting case of the Fourier series.

We will approach the Fourier transform from two different angles. First, we will take the "limiting case of the Fourier series" notion as far as it will take us (this will be quite far) to motivate the appropriate definitions. In this naive world, we will perform a few interesting computations, and establish the most useful properties of the Fourier transform as an operation. On the other hand, this naive world will be fraught with hand-waving and mathematical laxity. We will make statements that analysts (and people who know about the issues of convergence) would find uncouth.

And so we will redevelop the bulk of the theory from the ground up, and define the Fourier transform on a larger class of things called _distributions_. In doing so, we will circumvent (or rather, properly handle) all of the issues of convergence.


## Fourier and Naivete


The Fourier transform is best thought of as an operation on functions which has some nice properties. One such property is linearity, and a more complex one is its effect on the convolution operation. But if one wants to know where the transform comes from, and this is an important thing to know, then we could interpret it as a generalization of the Fourier series coefficient. Similarly, its inverse can be thought of as a generalization of the Fourier series representation (or, the map taking a function to its Fourier series representation). The generalization we speak of, and the "limiting case" we mentioned earlier, is in the size of the period. In rough terms,


_The Fourier transform is the limit of the Fourier coefficient as the period of the function tends to infinity._




This is how we will develop the definition of the Fourier transform, and the reader should understand why this is a sensible place to start: a function which has no period is simply a function which has an infinitely large period. Colloquially, one can "spot" periodicity much easier if the period is shorter, and as the period increases, functions start to "look" less and less periodic. So in the limiting case, there is no period.




In order to do this correctly, we should alter some of the definitions we made in our post on Fourier series. Specifically, we want to have an arbitrary period $T$. So instead of making the 1-periodic complex exponential $e^{2\pi i k t}$ our basic building block, we choose $e^{2 \pi i t k/T}$. The reader will check that as $k$ varies over all integers, these new complex exponentials still form an orthonormal basis of $L^2$ (well not quite, we have to modify the inner product slightly; see below). Then, using the notation we used last time for the Fourier coefficients $c_k$, the series is calculated as




$\displaystyle \sum_{k = -\infty}^{\infty} c_k e^{\frac{2 \pi i k t}{T}}$




where the $c_k$ are computed via the new inner product:




$\displaystyle c_k = \frac{1}{T}\int_{0}^{T}e^{\frac{-2 \pi i k t}{T}} f(t)dt$




We make another slight alteration in the limits of integration:




$\displaystyle c_k = \frac{1}{T} \int_{-T/2}^{T/2} e^{\frac{-2 \pi i k t}{T}} f(t)dt$




This doesn't change the integral, since a  $T$-periodic function has the same integral on any interval of length $T$.




Before we continue, we should show an intuitive aspect of what happens when $T \to \infty$. We can think of the usual Fourier series representation of a 1-periodic function $f$ as a function on the integers whose values are the Fourier coefficients $k \mapsto c_k$, since the coefficients completely determine the representation of $f$.  The interval between the inputs to this mapping is 1, because the function is 1-periodic. If we generalize this to an arbitrary period $T$, then we have functions whose inputs are multiples of $1/T$. So the intervals between adjacent inputs shrink to $1/T$. As $T$ grows, the inputs are moving closer and closer together. In other words, the Fourier series representation is becoming a _continuous_ mapping of the frequency! This viewpoint will motivate our seemingly magical choices to follow, and it partially justifies the common notion that the Fourier transform takes a function "in the time domain" and represents it "in the frequency domain." It's a stupid notion for mathematicians, but everyone says it anyway.




So if we try to take the limit immediately, that is, if we use the exact formula above for $c_k$ and try to evaluate $\lim_{T \to \infty} c_k$, we have issues. The problem rears it's ugly head when we let $f$ be a function with bounded support (that is, $f(x)$ is zero everywhere except possibly on a finite interval). If $f$ is zero outside of $[a,b]$ and $\int_a^b |f(x)|dx \leq M$ is finite, then for some large $T$, we have that all of the Fourier coefficients go to zero as $T \to \infty$. The details:




$\displaystyle |c_k| = \left | \frac{1}{T}\int_{-T/2}^{T/2} e^{\frac{-2 \pi i kt}{T}} f(t)dt \right | \leq \frac{1}{T} \int_{-T/2}^{T/2} \left | e^{\frac{-2 \pi i k t}{T}} \right | |f(t)| dt$




But as the absolute value of the complex exponential is 1, we can bound this by




$\displaystyle \frac{1}{T} \int_{-T/2}^{T/2} |f(t)|dt \leq \frac{M}{T}$,




and as $T \to \infty$, we see that the whole thing goes to 0.




The solution is (magic!) to scale linearly by $T$, and pull the balancing factor of $1/T$ outside of the coefficients $c_k$, and into the Fourier series itself. In other words, our new Fourier series is (written with the terms rearranged for good reason)




$\displaystyle \sum_{k = -\infty}^{\infty} e^{\frac{-2 \pi i k t}{T}} c_k (1/T) \frac{1}{T}$




where the coefficients $c_k(1/T)$ are




$\displaystyle c_k(1/T) = \int_{-T/2}^{T/2}e^{\frac{-2 \pi i k t}{T}} f(t)dt$




Now we suddenly (magically!) realize that the first equation is just the usual Riemann sum from calculus for the estimate of an integral. If we think of $x$ as our variable, then we'd be integrating $e^{-2 \pi i t x} c_k(x)$. And in particular, when the interval between the $x$ values goes to 0, the discrete sum converges to an integral by definition. Let us denote the infinitesimal variable $s$ to represent this "limit of $1/T$." Then we redefine the two above equations with glorious new names:




**Definition**: The _Fourier transform_ of a function $f: \mathbb{R} \to \mathbb{C}$ is the integral




$\displaystyle \mathscr{F}f(s) = \int_{-\infty}^{\infty}e^{-2 \pi i s t} f(t)dt$




whenever such an integral converges.




The _inverse Fourier transform_ of $g$ is the integral




$\displaystyle \mathscr{F}^{-1}g(t) = \int_{-\infty}^{\infty} e^{2\pi i s t}g(s)ds$




whenever such an integral converges.




And so, the Fourier transform above generalizes the Fourier coefficient $c_k$ (the limits of integration go to infinity), while the inverse transform generalizes the Fourier series reconstruction, by our conversion from a discrete sum to an integral.




We should note a few things about this definition, because it is quite a mouthful. First, $\mathscr{F}$ and $\mathscr{F}^{-1}$ _operate on functions_. In other words, they accept a function as input, and their values are functions. Still in other words, the parentheses are like $(\mathscr{F}f)(s)$, and not like $\mathscr{F}(f(s))$. We will often omit the parentheses with this implicitly understood precedence. This is also part of why we choose different variables. $f(t)$ will often use a different variable than its transform $\mathscr{F}f(s)$.




Second, returning to our remark about stupid notions, the function $f(t)$ can be thought of as being in the "time domain," where the inputs are instances of time, while the transformed function $\mathscr{F}f$ is in the "frequency domain." That is, for a given input $s$, the Fourier transform $\mathscr{F}f(s)$ describes how the complex exponential with frequency $s$ contributes to the overall function $f$. The set of values of the Fourier transform of $f$ is called the _spectrum_ of $f$. One can visualize the spectrum, but only indirectly. A complex-valued function is always hard to visualize, so instead one graphs $|\mathscr{F}f(s)|$ as a function on the real numbers. We then get pretty pictures like this one giving the spectrum of some human-spoken words:




[![](http://upload.wikimedia.org/wikipedia/commons/f/f1/Voice_waveform_and_spectrum.png)
](http://upload.wikimedia.org/wikipedia/commons/f/f1/Voice_waveform_and_spectrum.png)




This also explains the humorous comic at the beginning of this post: the thing saying "meow" is the spectrum of a cat, complete with whiskers. The comic also reinforces the idea that $\mathscr{F}$ is simply an operation on functions. One does not _need_ to restrict $\mathscr{F}$ to operate on functions whose domain is time (indeed, a cat is not a function of time). It's just an instance in which one can concretely interpret the transform of a function. For example, if one wanted to (and we will shortly), one could wonder about $\mathscr{FF}f$, or even apply $\mathscr{F}$ arbitrarily many times and see what happens under the limit. The same thing goes for the inverse Fourier transform.




The last big issue we have with the above definition is that it only makes sense when the integral actually converges. We will run into a few examples where this becomes a big problem, but we will sweep these issues under the rug for now (remember, this is still the land of naivete).




Nevertheless, we can do some wonderful computations with this mentality and this new definition. It will benefit us in the long run, because we'll discover the useful properties of the Fourier transform now, and use those properties to steer the more rigorous formalities later.





## Elementary Transforms and Elementary Properties


Armed with the mighty definition of the Fourier transform, we can take two paths. We can compute the transforms of various elementary functions, or we can develop tools to construct transforms of combinations of functions by computing the transforms of their constituent parts. This is largely the same approach one takes in studying derivatives and integrals in classical calculus: one learns to compute the derivatives of polynomials, logarithms, and exponentials; and then one learns to compute derivatives of products, sums, and compositions of functions. We will operate with the same philosophy for now.

**Example: **Let $f = \chi_{[-1/2, 1/2]}$ be the characteristic function of the interval from -1/2 to 1/2. That is, it is the function which is 1 on that interval and zero everywhere else. We will show $\mathscr{F}f = \frac{\sin(\pi s)}{\pi s}$ by appealing directly to the definition of the Fourier transform.


$\displaystyle \mathscr{F}f(s) = \int_{-\infty}^{\infty} e^{-2 \pi i s t} \chi_{[-1/2, 1/2]}(t) dt$




Since $f$ is zero outside of the chosen interval, and one inside, we can simplify the integral by adjusting the limits to -1/2 and 1/2, and inside simply using $f(t) = 1$:




$\displaystyle \mathscr{F}f(s) = \int_{-1/2}^{1/2}e^{-2 \pi ist} dt$




And this is quite tractable. Integrating the complex exponential as usual, we have:




$\displaystyle \mathscr{F}f(s) = \left ( \frac{1}{-2 \pi is} e^{-2 \pi ist} \right ) \Big |_{-1/2}^{1/2} = \frac{e^{- \pi ist} - e^{\pi ist}}{-2 \pi is} = \frac{\sin(\pi s)}{\pi s}$




Where the last equality follows from the classic identity $e^{ix} = \cos(x) + i\sin(x)$. The result of this Fourier transform is so pervasive that it has it's own name: $\textup{sinc}(s) = \frac{\sin(\pi s)}{\pi s}$.




**Exercise: **Let $\Lambda(t)$ be the piecewise function defined as $1 - |t|$ if $|t| < 1$, and zero otherwise. Prove that $\mathscr{F}\Lambda(s) = \textup{sinc}^2(s) = \frac{\sin^2(\pi s)}{(\pi s)^2}$.




Again, this one follows straight from the definition, which must be computed piecewise to handle the absolute value.




**Example**: Let $f$ be the Gaussian $f(t) = e^{- \pi t^2}$. Then $\mathscr{F}f(s) = f(s)$. That is, the Gaussian is fixed by the Fourier transform.




This is a very special property of the Gaussian, hinting at the special relationship between Fourier transforms and smoothness of curves. In order to prove it we need to borrow a fact from complex analysis, that $\int_{-\infty}^{\infty} e^{- \pi t^2} = 1$. Note that here the indefinite integral of $f$ cannot be expressed in elementary terms, so basic calculus tools are insufficient to prove this fact. A proof is most easily accessible using complex integration and residue theory, and [Wikipedia provides a proof](http://en.wikipedia.org/wiki/Gaussian_integral#Careful_proof) that does the same thing using a real parameterization to make it seem more elementary.




To find the Fourier transform, we again appeal to the definition, except this time we use some tricks. First, we differentiate the definition with respect to $s$, and then integrate the result by parts to arrive at an ordinary differential equation, which we know how to solve. Set $F(s) = \mathscr{F}f(s)$ for ease of notation.




$\displaystyle F(s) = \int_{-\infty}^{\infty} e^{-2 \pi ist} e^{-\pi t^2}dt$




Differentiating with respect to $s$, we have




$\displaystyle F'(s) = \frac{d}{ds}\int_{-\infty}^{\infty} e^{-2 \pi ist}e^{-\pi t^2}dt = \int_{-\infty}^{\infty} \frac{d}{ds}(e^{-2 \pi ist}) e^{-\pi t^2} dt$




Performing the differentiation and regrouping terms we have




$\displaystyle F'(s) = i \int_{-\infty}^{\infty}e^{-2\pi ist}(-2\pi t e^{-\pi t^2}) dt$




Now integrating by parts with respect to $t$, and recognizing that the term $e^{-2 \pi ist} e^{-\pi t^2}$ tends to zero both as $t \to \pm \infty$, we get




$\displaystyle F'(s) = -i \int_{-\infty}^{\infty} e^{-\pi t^2}(-2\pi is)e^{-2 \pi ist} dt = -2\pi s F(s)$




As we claimed earlier, this is a simple ordinary differential equation, which has solution




$\displaystyle F(s) = F(0)e^{-\pi s^2} = F(0)f(s)$




And here $F(0) = \int_{-\infty}^{\infty} e^{-2 \pi i t 0}e^{-\pi t^2} dt = 1$, as we claimed from the beginning. This completes the proof, as $F(s) = f(s)$.




Next, we will focus on the rules for taking Fourier transforms of functions combined in various ways. First, we note that the Fourier transform is linear, in the very same sense as linear maps between vector spaces in elementary linear algebra. In particular, the linearity of the integral gives




$\displaystyle \mathscr{F}(af + bg)(s) = a \mathscr{F}f(s) + b\mathscr{F}g(s)$




Other easy properties arise from modifying the input of $f$, and using multiplicative properties of the complex exponential. For instance, if we let $f_a(t) = f(t - a)$, we see that $\mathscr{F}f_a(s) = e^{-2 \pi ias}\mathscr{F}f(s)$. This follows by a simple change of variables in the integral. Letting $u = t-a$,




$\displaystyle \mathscr{F}f_a(s) = \int_{-\infty}^{\infty} e^{-2\pi is(u+a)}f(u)du$




And we can trivially factor out the needed complex exponential coefficient, and work with $u$ as usual. One convenient interpretation of this formula is that a shift in time corresponds to a phase shift in frequency. Once again, we caution that these interpretations are a tool; they can massively confuse the issue when, say, the domain of $f$ is frequency to begin with.




Similar considerations give us a formula for the scaled function $f(at)$ whose transform is $\frac{1}{|a|} \mathscr{F}f(\frac{s}{a})$. We leave this as an exercise to the reader (hint: break it into two cases for when $a<0, a>0$).




Next, we note that the Fourier transform turns derivatives of some functions into a very manageable product. Rigorously, if $\lim_{t \to \pm \infty} f(t) = 0$ then




$\displaystyle \mathscr{F}\frac{d^nf}{dt^n}(s) = (2\pi i s)^n \mathscr{F}f(s)$




We can prove this by induction. We'll just prove the base case:




$\displaystyle \mathscr{F}f'(s) = \int_{-\infty}^{\infty} e^{-2 \pi ist}f'(t)dt$




Integrating by parts, we get




$\displaystyle \mathscr{F}f'(s) = e^{-2\pi ist}f(t) - \int_{-\infty}^{\infty} (-2\pi is)e^{-2\pi ist}f(t)dt$




And by our boundedness property and the fact that the complex exponential has a constant norm, the first term (evaluated from $-\infty$ to $\infty$) tends to zero, leaving our desired product. The inductive step follows with the ease of iterated integration by parts. Note that although this example only holds for functions which tend to zero at $\pm \infty$, next time we will rectify the situation by restricting our theory to functions which are "the best candidates" for the theory of Fourier analysis and eliminate the need for such hypotheses.





## The More Interesting Properties




The final two properties of the Fourier transform that we will inspect are in a sense deeper and more substantial than those above. In particular, we will establish the duality of the Fourier transform, and the effect of Fourier transforms on convolution.




First, the Fourier transform has a few notions of duality. Let $f^-(t)$ denote $f(-t)$. One such duality notion is the following, which is a trivial consequence of the definitions of the transform and its inverse:




$\displaystyle (\mathscr{F}f)^- = \mathscr{F}^{-1}f$




Similarly, a minor change of variables shows that $\mathscr{F}(f^-) = \mathscr{F}^{-1}f$. Chaining these together, we have the nice identity




$\displaystyle \mathscr{F}(f^-) = (\mathscr{F}f)^-$




A simple corollary is that $\mathscr{FF}f = f^-$. This allows us to compute the Fourier transforms of some potentially unmanageable functions. For instance, let us return to our friend the sinc function.




$\displaystyle \mathscr{F}\textup{sinc}(s) = \mathscr{FF}(\chi_{[-1/2,1/2]}) = \chi^-_{[-1/2, 1/2]} = \chi_{[-1/2, 1/2]}$




by the symmetry of the characteristic function. On the other hand, it's ridiculously counterintuitive that the following integral is actually the characteristic function of a finite interval:




$\displaystyle \int_{-\infty}^{\infty} e^{-2 \pi ist} \frac{\sin(\pi t)}{\pi t} dt$




In fact, even though we just "proved" that the sinc function has a nice transform, it is hardly clear how to integrate it. In fact, the sinc function is not even (Lebesgue) integrable! Without further qualifications, the above expression is complete nonsense.




Historically, this is the point at which the physicists contact the mathematicians and say, "We dun broked it!" Because the physicists went ahead and used these naively impossible transforms to do amazing things and discover elegant identities, the mathematicians are left to design a sensible theory to support their findings. The field is rife with such inconsistencies, and this is not the last one we will see before consolidating the theory. Perhaps this is in part because successful applications in engineering outpace mathematical rigor. Glibly, they're racing for profit while the mathematicians want to architect a flawless foundation in which deep theorems are manifestly obvious.




Getting back to the properties of Fourier transforms, we have saved perhaps the most useful one for last. In short, Fourier transforms turn _convolution_ into multiplication. Convolutions, both continuous and discrete, make cameo appearances all over applied mathematics, from signal processing and image analysis to quantum mechanics and mathematical finance. In our applications, we will use the following properties of convolution to modify the spectrum of a signal, for such purposes as removing noise, or filtering out low/high/mid frequency regions. Without further ado, the definition:




**Definition:** The _convolution_ of $f$ and $g$, denoted $f \ast g$, is the integral




$\displaystyle (f \ast g)(x) = \int_{-\infty}^{\infty} g(x-y)f(y)dy,$




should such an integral converge. Otherwise the convolution is undefined.




Often convolution is interpreted as some sort of stretch+translation of a function by another, but we find such meager interpretations mathematically flaccid. Convolution is simply an operation that combines functions in an interesting way (perhaps its definition is motivated by the question below). Nevertheless, Wikipedia provides a number of [relevant animations showing convolution in action](http://en.wikipedia.org/wiki/Convolution).




So the leading question here is, what happens when one takes the product of $(\mathscr{F}f)(\mathscr{F}g)$? From the definition, this is




$\displaystyle \left ( \int_{-\infty}^{\infty}e^{-2\pi isx}f(x)dx \right ) \left ( \int_{-\infty}^{\infty} e^{-2 \pi ist} g(t) dt \right )$




We may combine the integrals into a double integral, and further combine the complex exponentials, getting




$\displaystyle \int_{-\infty}^{\infty} \left ( \int_{-\infty}^{\infty} e^{-2 \pi is (t+x)}g(t) dt \right ) f(x) dx$




Substituting $u = t+x$, we have




$\displaystyle \int_{-\infty}^{\infty} \left ( \int_{-\infty}^{\infty} e^{-2\pi isu} g(u-x)du \right ) f(x) dx$




And swapping the order of integration,




$\displaystyle \int_{-\infty}^{\infty} \left ( \int_{-\infty}^{\infty} g(u-x)f(x)dx \right ) e^{-2\pi isu} du = \mathscr{F}(g \ast f)$




(The parenthetical quantity drove our definition of the convolution to begin with.) And so we have the beautiful identity:




$\mathscr{F}(f \ast g)(s) = \mathscr{F}f(s) \mathscr{F}g(s)$




We will use this as follows: multiply the Fourier transform of a signal by an appropriate characteristic function (the characteristic function of the set of "good" frequencies of, say, a sound clip) and then take the inverse transform of the product, getting as a result a modified signal with certain frequencies removed.




There are a few hurdles between here and there (at least, as far as this blog goes). First, we must compensate for our convergence naivete with mathematical rigor. Next time, we will define the class of Schwartz functions, from which we will derive a class of "generalized functions," intuitively constituting the class of "transformable" functions. After that, we must needs find a suitable discrete approximation of the Fourier transform. In real life, all signals are _sampled_ sequences of numbers. As such, we cannot take their integrals, and must convert these continuous notions to operations on sequences. Finally, we need to investigate an algorithm to efficiently compute such a discrete Fourier transform. Then, and only then, may we proceed with writing programs to do great things.




So look forward to all of the above in the coming weeks. Until next time!
