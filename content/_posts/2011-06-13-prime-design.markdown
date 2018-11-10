---
author: jeremykun
date: 2011-06-13 21:26:39+00:00
draft: false
title: Prime Design
type: post
url: /2011/06/13/prime-design/
categories:
- Design
- Number Theory
tags:
- bash
- css
- graphics
- html
- mathematics
- patterns
- primes
- programming
---

The goal of this post is to use prime numbers to make interesting and asymmetric graphics, and to do so in the context of the web design language CSS.





## Number Patterns


For the longest time numbers have fascinated mathematicians and laymen alike. Patterns in numbers are decidedly simple to recognize, and the proofs of these patterns range from trivially elegant to Fields Medal worthy. Here's an example of a simple one that computer science geeks will love:

**Theorem**: $\sum \limits_{i=0}^{n} 2^i = 2^{n+1}-1$ for all natural numbers $n$.

If you're a mathematician, you might be tempted to use induction, but if you're a computer scientist, you might think of using neat representations for powers of 2...

_Proof_: Consider the base 2 representation of $2^i$, which is a 1 in the $i$th place and zeros everywhere else. Then we may write the summation as


$\begin{matrix} & 100 & \dots & 0 \\ & 010 & \dots & 0 \\ & 001 & \dots & 0 \\ & & \vdots & \\ + & 000 & \dots & 1 \\ = & 111 & \dots & 1 \end{matrix}$




And clearly adding one to this sum gives the next largest power of 2. $\square$




This proof extends quite naturally to all $k$ powers, giving the following identity. Try to prove it yourself using base $k$ number representations!




$\sum \limits_{i=0}^{n} k^i = \dfrac{k^{n+1}-1}{k-1}$




The only other straightforward proof of this fact would require induction on $n$, and as a reader points out in the comments (and I repeat in the [proof gallery](http://jeremykun.wordpress.com/2011/07/01/sums-of-k-powers/)), it's not so bad. But it was refreshing to discover this little piece of art on my own (and it dispelled my boredom during a number theory class). Number theory is full of such treasures.





## Primes




Though there are many exciting ways in which number patterns overlap, there seems to be one grand, overarching undiscovered territory that drives research and popular culture's fascination with numbers: the primes.




The first few prime numbers are $2,3,5,7,11,13,17,19,23, \dots $. Many elementary attempts to characterize the prime numbers admit results implying intractability. Here are a few:






	  * There are infinitely many primes.
	  * For any natural number $n$, there exist two primes $p_1, p_2$ with no primes between them and $|p_1 - p_2| \geq n$. (there are arbitrarily large gaps between primes)
	  * [It is conjectured](http://en.wikipedia.org/wiki/Twin_prime) that for any natural number $n$, there exist two primes $p_1, p_2$ larger than $n$ with $|p_1 - p_2| = 2$. (no matter how far out you go, there are still primes that are as close together as they can possibly be)

Certainly then, these mysterious primes must be impossible to precisely characterize with some sort of formula. Indeed, it is simple to prove that there exists no polynomial formula with rational coefficients that always yields primes*, so the problem of generating primes via some formula is very hard. Even then, much interest has gone into finding polynomials which generate many primes (the first significant such example was $n^2 +n +41$, due to Euler, which yields primes for $n < 40$), and this was one of the driving forces behind algebraic number theory, the study of special number rings called integral domains.

_*Aside_: considering the amazing way that the closed formula for the Fibonacci numbers uses irrational numbers to arrive at integers, I cannot immediately conclude whether the same holds for polynomials with arbitrary coefficients, or elementary/smooth functions in general. This question could be closely related to the Riemann hypothesis, and I'd expect a proof either way to be difficult. If any readers are more knowledgeable about this, please feel free to drop a comment.

However, the work of many great mathematicians over thousands of years is certainly not in vain. Despite their seeming randomness, the pattern in primes lies in their distribution, not in their values.

**Theorem:** Let $\pi(n)$ be the number of primes less than or equal to $n$ (called the _prime counting function_). Then


$\lim \limits_{n \rightarrow \infty} \dfrac{\pi(n)}{n / \log(n)} = 1$







Intuitively, this means that $\pi(n)$ is about $n / \log(n)$ for large $n$, or more specifically that if one picks a random number near $n$, the chance of it being prime is about $1/ \log(n)$. Much of the work on prime numbers (including equivalent statements to the Riemann hypothesis) deals with these prime counting functions and their growth rates. But stepping back, this is a fascinatingly counterintuitive result: we can say with confidence how many primes there are in any given range, but determining what they are is exponentially harder!

And what's more, many interesting features of the prime numbers have been just stumbled upon by accident. Unsurprisingly, these results are among the most confounding. Take, for instance, the following construction. Draw a square spiral starting with 1 in the center, and going counter-clockwise as below:


[![Number Spiral](http://jeremykun.files.wordpress.com/2011/06/number-spiral.png)
](http://jeremykun.files.wordpress.com/2011/06/number-spiral.png)


If you circle all the prime numbers you'll notice many of them spectacularly lie on common diagonals! If you [continue this process for a long time](http://upload.wikimedia.org/wikipedia/commons/8/81/Ulam4004001.png), you'll see that the primes continue to lie on diagonals, producing a puzzling pattern of dashed cross-hatches. This _Ulam Spiral_ was named after its discoverer, Stanislaw Ulam, and the reasons for its appearance are still unknown (though conjectured).

All of this wonderful mathematics aside, our interest in the primes is in its apparent lack of patterns.


## **Primes in Design**




One very simple but useful property of primes is in least common denominators. The product of two numbers is well known to equal the product of their least common multiple and greatest common divisor. In symbols:




$\textup{gcd}(p,q) \textup{lcm}(p,q) = pq$


We are particularly interested in the case when $p$ and $q$ are prime, because then their greatest (and only) common divisor is 1, making this equation


$\textup{lcm}(p,q) = pq$




The least common multiple manifests itself concretely in patterns. Using the numbers six and eight, draw two rows of 0's and 1's with a 1 every sixth character in the first row and every 8th character in the second. You'll quickly notice that the ones line up every twenty-fourth character, the lcm of six and eight:




000001000001000001000001000001000001000001000001
000000010000000100000001000000010000000100000001


Using two numbers $p,q$ which are coprime (their greatest common divisor is 1, but they are not necessarily prime; say, 9 and 16), then the 1's in their two rows would line up every $pq$ characters. Now for pretty numbers like six and eight, there still appears to be a mirror symmetry in the distribution of 1's and 0's above. However, if the two numbers _are_ prime, this symmetry is much harder to see. Try 5 and 7:


0000100001000010000100001000010000100001000010000100001000010000100001
0000001000000100000010000001000000100000010000001000000100000010000001


There is much less obvious symmetry, and with larger primes it  becomes even harder to tell that the choice of match up isn't random.

This trivial observation allows us to create marvelous, seemingly non-repeating patterns, provided we use large enough primes. However, patterns in strings of 1's and 0's are not quite visually appealing enough, so we will resort to overlaying multiple backgrounds in CSS. Consider the following three images, which have widths 23, 41, and 61 pixels, respectively.

[caption id="attachment_89" align="alignleft" width="23" caption="23"][![](http://jeremykun.files.wordpress.com/2011/06/23.png)
](http://jeremykun.files.wordpress.com/2011/06/23.png)[/caption]

[caption id="attachment_90" align="alignleft" width="41" caption="41"][![](http://jeremykun.files.wordpress.com/2011/06/41.png)
](http://jeremykun.files.wordpress.com/2011/06/41.png)[/caption]

[caption id="attachment_88" align="alignleft" width="61" caption="61"][![](http://jeremykun.files.wordpress.com/2011/06/61.png)
](http://jeremykun.files.wordpress.com/2011/06/61.png)[/caption]

Each has a prime width, semi-transparent color, and a portion of the image is deleted to achieve stripes when the image is x-repeated. Applying our reasoning from the 1's and 0's, this pattern will only repeat once every $\textup{lcm}(23,41,61) = 23*41*61 = 57523$ pixels! As designers, this gives us a naturally non-repeating pattern of stripes, and we can control the frequency of repetition in our choice of numbers.

Here is the CSS code to achieve the result:

{{< highlight python >}}html {
   background-image: url(23.png), url(41.png), url(61.png);
}{{< /highlight >}}

I'm using Google Chrome, so this is all the CSS that's needed. With other browsers you may need a few additional lines like "height: 100%" or "margin: 0", but I'm not going to worry too much about that because any browser which supports multiple background images should get the rest right. Here's the result of applying the CSS to a blank HTML webpage:

[![](http://jeremykun.files.wordpress.com/2011/06/nopattern.png?w=150)
](http://jeremykun.files.wordpress.com/2011/06/nopattern.png)Now I'm no graphic designer by any stretch of my imagination. So as a warning to the reader, using these three particular colors may result in an eyesore more devastating than an 80's preteen bedroom, but it illustrates the point of the primes, that on my mere 1440x900 display, the pattern never repeats itself. So brace yourself, and click the thumbnail to see the full image.

Now, to try something at least a little more visually appealing, we do the same process with circles of various sizes on square canvases with prime length sides ranging from 157x157 pixels to 419x419. Further, I included a little bash script to generate a css file with randomized background image coordinates. Here is the CSS file I settled on:

{{< highlight python >}}html {
   background-image: url(443.png), url(419.png), url(359.png),
      url(347.png), url(157.png), url(193.png), url(257.png),
      url(283.png);
   background-position: 29224 10426, 25224 24938, 8631 32461,
      22271 15929, 13201 7320, 30772 13876, 11482 15854,
      31716, 21968;
}{{< /highlight >}}

With the associated bash script generating it:

{{< highlight python >}}#! /bin/bash

echo "html {"
echo -n "   background-image: url(443.png), url(419.png), "
echo -n "url(359.png), url(347.png), url(157.png), url(193.png), "
echo -n "url(257.png), url(283.png);"
echo -n "   background-position: "

for i in {1..7}
do
	echo -n "$RANDOM $RANDOM, "
done

echo "$RANDOM, $RANDOM;"
echo "}" {{< /highlight >}}

[caption id="attachment_98" align="alignleft" width="150" caption="Prime Circles"][![](http://jeremykun.files.wordpress.com/2011/06/circles1.png?w=150)
](http://jeremykun.files.wordpress.com/2011/06/circles1.png)[/caption]

And here is the result. Again, this is not a serious attempt at a work of art. But while you might not call it visually beautiful, nobody can deny that its simplicity and its elegant mathematical undercurrent carry their own aesthetic beauty. This method, sometimes called _the cicada principle_, has recently attracted a following, and the Design Festival blog has a [gallery](http://designfestival.com/cicada/) of images, and [a few that stood out](http://designfestival.com/the-cicada-project-and-the-winner-is/). These submissions are the true works of art, though upon closer inspection many of them seem to use such large image sizes that there is only one tile on a small display, which means the interesting part (the patterns) can't be seen without a ridiculously large screen or contrived html page widths.

So there you have it. Prime numbers contribute to interesting, unique designs that in their simplest form require very little planning. Designs become organic; they grow from just a few prime seedlings to a lush, screen-filling ecosystem. Of course, for those graphical savants out there, the possibilities are endless. But for the rest of us, we can use these principles to quickly build large-scale, visually appealing designs, leaving math-phobic designers in the dust.

It would make me extremely happy if any readers who play around and come up with a cool design submit them. Just send a link to a place where your design is posted, and if I get enough submissions I can create a gallery of my own :)

Until next time!


