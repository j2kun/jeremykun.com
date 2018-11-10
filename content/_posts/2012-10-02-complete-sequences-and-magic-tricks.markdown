---
author: jeremykun
date: 2012-10-02 16:28:16+00:00
draft: false
title: Complete Sequences and Magic Tricks
type: post
url: /2012/10/02/complete-sequences-and-magic-tricks/
categories:
- Algorithms
- Number Theory
tags:
- greedy algorithm
- javascript
- numberphile
- primes
- programming
---

Numberphile posted a video today describing a neat trick based on complete sequences:

[youtube=http://www.youtube.com/watch?v=kQZmZRE0cQY]

The mathematics here is pretty simple, but I noticed at the end of the video that Dr. Grime was constructing the cards by hand, when really this is a job for a computer program. I thought it would be a nice warmup exercise (and a treat to all of the Numberphile viewers) to write a program to construct the cards for any complete sequence.

For the sake of bringing some definitions into it, let's review the idea of the card trick.

**Definition:** A sequence of integers $a_n$ is _complete_ if every natural number $k$ can be represented as a sum of numbers in $a_n$.

The examples used in the video are the binary numbers and the fibonacci numbers. The latter is a famous theorem [Zeckendorf's Theorem](http://en.wikipedia.org/wiki/Zeckendorf%27s_theorem). Other famous complete sequences include the prime numbers (if you add 1) and the [lazy caterer's sequence](http://en.wikipedia.org/wiki/Lazy_caterer's_sequence).

Now the question is, given a complete sequence, how do we generate the cards from the video? One might recall our post on dynamic programming, in which we wrote a program to compute the optimal coin change for a given amount of money. Indeed, this method works, but we have some added structure in this problem: we know that any number can only be used once. In that case, it is easy to see that there is no need for dynamic programming. Instead, we just use a greedy algorithm.

That is, we can determine which card contains a number $k$ (which number in the sequence occurs in the representation of $k$) as follows. Start with the largest card smaller than $k$, call it $n$, and we know that $n$ shows up in the representation of $k$. To find the next number in the representation, simply repeat the process with the difference $k-n$. The next number to appear in the representation of $k$ is hence the largest card less than $k-n$. We can repeat this process until we run out of cards or the difference becomes zero.

One interesting fact about this algorithm is that it will _always_ produce the smallest representation. That is, in performing the card trick, one is guaranteed the least amount of work in remembering which cards contained the hidden number, and the least amount of work in adding those numbers up.

To implement this algorithm in code, we used Javascript. We chose Javascript so that the reader can [run the program](http://homepages.math.uic.edu/~jkun2/other/complete-sequences/make-cards.html) and view its source. But we extract the most important bit of the code here:

    
    // compute each card
    var j;
    for (i = 1; i <= usersMax; i++) {
       var remainder = i;
       for (j = numbers.length-1; j >= 0; j--) {
          if (numbers[j] <= remainder) {
             cards[j].push(i);
             remainder -= numbers[j];
          }
       }
    }


In words, the "numbers" array contains the complete sequence in question, the cards array is an array of arrays, where each element in the array represents one card. We then loop over all numbers (the $i$ variable), and for each number we check the sequence in decreasing order to look for membership of $i$ on a card.

For the sake of brevity, we omit all of the code to deal with input and output, which comprises all of the remaining code in this program.

So to use the program, for example with prime numbers as the complete sequence, one would type "1,2,3,5,7,13,17" into the first text box, and whatever the maximum allowable guess is in the second box, and click the "Generate cards" button.

Enjoy!
