---
author: jeremykun
date: 2011-10-03 03:42:57+00:00
draft: false
title: A Taste of Racket
type: post
url: /2011/10/02/a-taste-of-racket/
categories:
- Algorithms
- Primers
- Programming Languages
tags:
- functional programming
- racket
---

## or, How I Learned to Love Functional Programming

We recognize that not every reader has an appreciation for functional programming. Yet here on this blog, we've done most of our work in languages teeming with functional paradigms. It's time for us to take a stand and shout from the digital mountaintops, "I love functional programming!" In fact, functional programming was part of this author's inspiration for Math ∩ Programming.

And so, to help the reader discover the joys of functional programming, we present an introduction to programming in [Racket](http://racket-lang.org/), with a focus on why functional programming is amazing, and a functional solution to a problem on [Project Euler](http://projecteuler.net). As usual, [the entire source code](https://github.com/j2kun/a-taste-of-racket) for the examples in this post is available on [this blog's Github page](https://github.com/j2kun).

![](http://racket-lang.org/logo.png)

## Lists

Lists are the datatype of choice for functional programmers. In particular, a list is either the empty list or a pair of objects:

    
    list = empty
         | (x list)

Here () denotes a pair, the first thing in the pair, "x", is any object, and the second thing is another list. In Racket, all lists have this form, and they are constructed with a special function called "cons". For instance, the following program outputs the list containing 7 and 8, in that order.

    
    (cons 7 (cons 8 empty))

The reader will soon get used to the syntax: every function application looks like (function arguments...), including the arithmetic operators.

This paradigm is familiar; in imperative ("normal") programming, this is called a _linked list_, and is generally perceived as slower than lists based on array structures. We will see why shortly, but in general this is only true for some uncommon operations.

Of course, Racket has a shorthand for constructing lists, which doesn't require one to write "cons" a hundred times:

    
    (list 7 9)

gives us the same list as before, without the nested parentheses. Now, if we wanted to _add_ a single element to the front of this list, "cons" is still the best tool for the job. If the variable "my-list" is bound to a list, we would call

    
    (cons 6 my-list)

to add the new element. For lists of things which are just numbers, symbols, or strings , there is an additional shorthand, using the "quote" macro:

    
    '(1 2 3 4 "hello" my-symbol!)

Note that Racket does not require such lists are homogeneous, and it automatically converts the proper types for us.

To access the elements of a list, we only need two functions: first and rest. The "first" function accepts a list and returns the first element in it, while "rest" returns the tail of the list excluding the first element. This naturally fits with the "cons" structure of a list. For instance, if "my-list" is a variable containing (cons 8 (cons 9 empty)), then first and rest act as follows:

    
    > (first my-list)
    8
    > (rest my-list)
    '(9) 
    > (first (rest my-list))
    9

In particular, we can access any element of a list with sufficiently many calls to first and rest. But for most problems this is unnecessary. We are about to discover far more elegant methods for working with lists. This is where functional programming truly shines.

## Double-List, Triple-List, and Sub-List

Suppose we want to take a list of numbers and double each number. If we just have what we know now about lists, we can write a function to do this. The general function definition looks like:

{{< highlight python >}}(define (function-name arg1 arg2 ...)
body-expression){{< /highlight >}}

To be completely clear, the return value of a Racket function is whatever the body expression evaluates to, and we are allowed to recursively call the function. Indeed, this is the only way we will ever loop in Racket (although it has some looping constructs, we frown upon their use).

And so the definition for doubling a list is naturally:

{{< highlight python >}}(define (double-list my-list)
  (if (empty? my-list) empty
      (cons (* 2 (first my-list))
            (double-list (rest my-list))))){{< /highlight >}}

In words, we have two cases: if my-list is empty, then there is nothing to double, so we return a new empty list (well, all empty lists are equal, so it's the same empty list). This is often referred to as the "base case." If my-list is nonempty, we construct a new list by doubling the first element, and then recursively  doubling the remaining list. Eventually this algorithm will hit the end of the list, and ultimately it will return a new list with each element of my-list doubled.

Of course, the mathematicians will immediately recognize _induction_ at work. If the program handles the base case and the induction step correctly, then it will correctly operate on a list of any length!

Indeed, we may test double-list:

    
    > (double-list empty)
    '()
    > (double-list '(1 2 3 5))
    '(2 4 6 10)

And we are confident that it works. Now say we wanted to instead triple the elements of the list. We could rewrite this function with but a single change:

{{< highlight python >}}(define (triple-list my-list)
  (if (empty? my-list) empty
      (cons (* 3 (first my-list))
            (triple-list (rest my-list))))){{< /highlight >}}

It's painfully obvious that coding up two such functions is a waste of time. In fact, at 136 characters, I'm repeating more than 93% of the code (eight characters changing "doub" to "trip" and one character changing 2 to 3). What a waste! We should instead refactor this code to accept a new argument: the number we want to multiply by.

{{< highlight python >}}(define (multiply-list my-list n)
  (if (empty? my-list) empty
      (cons (* n (first my-list))
            (multiply-list (rest my-list) n)))){{< /highlight >}}

This is much better, but now instead of multiplying the elements of our list by some fixed number, we want to subtract 7 from each element (arbitrary, I know, but we're going somewhere). Now I have to write a whole _new_ function to subtract things!

{{< highlight python >}}(define (sub-list my-list n)
  (if (empty? my-list) empty
      (cons (- (first my-list) n)
            (sub-list (rest my-list) n)))){{< /highlight >}}

Of course, we have the insight to make it generic and accept any subtraction argument, but this is the problem we tried to avoid by writing multiply-list! We obviously need to step things up a notch.

## Map

In all of this work above, we've only been changing one thing: the operation applied to each element of the list. Let's create a new function, which accepts as input a list and _a function_ which operates on each element of the list. This special operation is called _map_, and it is only possible to make because Racket treats functions like any other kind of value (they can be passed as arguments to functions, and returned as values; functions are _first class objects_).

The implementation of map should look very familiar by now:

{{< highlight python >}}(define (map f my-list)
  (if (empty? my-list) empty
      (cons (f (first my-list))
            (map f (rest my-list))))){{< /highlight >}}

In particular, we may now define all of our old functions in terms of map! For instance,

{{< highlight python >}}(define (double x) (* 2 x))
(define (double-list2 my-list) (map double my-list)){{< /highlight >}}

Or, even better, we may take advantage of Racket's _anonymous functions_, which are also called "lambda expressions," to implement the body of double-list in a single line:

{{< highlight python >}}(map (λ (x) (* 2 x)) my-list){{< /highlight >}}

Here the λ character has special binding in the Dr. Racket programming environment (Alt-\), and one can alternatively write the string "lambda" in its place.

With map we have opened quite a large door. Given any function at all, we may _extend_ that function to operate on a list of values using map. Consider the imperative equivalent:

    
    for (i = 0; i < list.length; i++):
       list.set(i, f(list.get(i)))

Every time we want to loop over a list, we have to deal with all of this indexing nonsense (not to mention the extra code needed to make a new list if we don't want to mutate the existing list, and that iterator shortcuts prohibit mutation). And the Racket haters will have to concede, the imperative method has just as many parentheses :)

Of course, we must note that map _always_ creates a new list. In fact, in languages that are so-called "purely" functional, it is impossible to change the value of a variable (i.e., there is no such thing as mutation). The advantages and disadvantages of this approach are beyond the scope of this post, but we will likely cover them in the future.

## Fold and Filter

Of course, map is just one kind of loop we might want. For instance, what if we wanted to sum up all of the numbers in a list, or pick out the positive ones? This is where fold and filter come into play.

_Fold_ is a function which reduces a list to a single value. To do this, it accepts a list, an initial value, and a function which accepts precisely two arguments and outputs a single value. It then uses this to combine the elements of a list. It's implementation is not that different from map:

{{< highlight python >}}(define (fold f val my-list)
  (if (empty? my-list) val
      (fold f
            (f val (first my-list))
            (rest my-list)))){{< /highlight >}}

Here the base case is to simply return "val", while the induction step is to combine "val" with the first element of the list using "f", and then recursively apply fold to the remainder of the list. Now we may implement our desired summing function as

    
    (define (sum my-list) (fold + 0 my-list))

And similarly, make a multiplying function:

    
    (define (prod my-list) (fold * 1 my-list))

Notice now that we've extracted the essential pieces of the problem: what operation to apply, and what the base value is. In fact, this is the only relevant information to the summing and multiplying functions. In other words, we couldn't possibly make our code any simpler!

Finally, _filter_ is a function which selects specific values from a list. It accepts a selection function, which accepts one argument and returns true or false, and the list to select from. It's implementation is again straightforward induction:

{{< highlight python >}}(define (filter select? my-list)
  (if (empty? my-list) empty
      (let ([elt (first my-list)]
            [the-rest (rest my-list)])
        (if (select? elt)
            (cons elt (filter select? the-rest))
            (filter select? the-rest))))){{< /highlight >}}

To avoid superfluous calls to "first" and "rest", we use Racket's "let" form to bind some variables. Logically, the base case is again to return an empty list, while the inductive step depends on the result of applying "select?" to the first element in our list. If the result is true, we include it in the resulting list, recursively calling filter to look for other elements. If the result is false, we simply skip it, recursively calling filter to continue our search.

Now, to find the positive numbers in a list, we may simply use filter:

{{< highlight python >}}(filter (λ (x) (> x 0)) my-list){{< /highlight >}}

Again, the only relevant pieces of this algorithm are the selection function and the list to search through.

There is one important variant of fold, in particular, the function we're using to fold may depend on the order in which it's applied to elements of the list. We might require that folding begin at the _end_ of a list instead of the beginning. Fold functions are usually distinguished as left- or right-folds. Of course, Racket has map, fold, and filter built in, but the fold functions are renamed "foldl" and "foldr". We have implemented foldl, and we leave foldr as an exercise to the reader.

## A Brighter, More Productive World

Any loop we ever want to implement can be done with the appropriate calls to map, fold, and filter. We will illustrate this by solving a [Project Euler](http://projecteuler.net/) problem, specifically [problem 67](http://projecteuler.net/problem=67). For those too lazy to click a link, the problem is to find the maximal sum of paths from the apex to the base of a triangular grid of numbers. For example, consider the following triangle:

    
       3
      7 4
     2 4 6
    8 5 9 3

Here the maximal path is 3,7,4,9, whose sum is 23. In the problem, we are provided with a file containing a triangle with 100 rows ($2^{99}$ paths!) and are asked to find the maximal path.

First, we recognize a trick. Suppose that by travelling the optimal route in the triangle above, we arrived in the second to last row at the number 2. Then we would know precisely how to continue: simply choose the larger of the two next values. We may reduce this triangle to the following:

    
          3
       7     4
     10   13   15

where we replace the second-to-last row with the sum of the entries and the larger of the two possible subsequent steps. Now, performing the reduction again on this reduced triangle, we get

    
       3
    20   19

And performing the reduction one last time, we arrive at our final, maximal answer of 23.

All we need to do now is translate this into a sequence of maps, folds, and filters.

First, we need to be able to select the "maximum of pairs" of a given row. To do this, we convert a row into a list of successive pairs. Considering the intended audience, this is a rather complicated fold operation, and certainly the hardest part of the whole problem. We will let the reader investigate the code to understand it.

{{< highlight python >}};; row->pairs: list of numbers -> list of successive pairs of numbers
(define (row->pairs row)
  (if (equal? (length row) 1)
      (list row)
      (let ([first-pair (list (list (first row) (second row)))]
            [remaining-row (rest (rest row))]
            [fold-function (λ (so-far next)
                             (let ([prev-pair (first so-far)])
                               (cons (list (second prev-pair) next) so-far)))])
        (reverse (fold fold-function first-pair remaining-row))))){{< /highlight >}}

All we will say is that we need to change the base case so that it is the first pair we want, and then apply the fold to the remaining elements of the row. This turns a list like '(1 2 3 4) into '((1 2) (2 3) (3 4)).

Next, we need to be able to determine which of these pairs in a given row are maximal. This is a simple map, which we extend to work not just with pairs, but with lists of any size:

{{< highlight python >}};; maxes: list of lists of numbers -> list of maxes of each list
(define (maxes pairs)
  (map (λ (lst) (apply max lst)) pairs)){{< /highlight >}}

Next, we combine the two operations into a "reduce" function:

{{< highlight python >}};; reduce: combine maxes with row->pairs
(define (reduce row) (maxes (row->pairs row))){{< /highlight >}}

Finally, we have the bulk of the algorithm. We need a helper "zip" function:

{{< highlight python >}};; zip: list of lists -> list
;; turn something like '((1 2 3) (5 6 7)) into '((1 5) (2 6) (3 7))
(define (zip lists)
  (if (empty? (first lists)) empty
      (cons (map first lists)
            (zip (map rest lists))))) {{< /highlight >}}

and the function which computes the maximal path, which is just a nice fold. The main bit of logic is highlighted.

{{< highlight python >}};; max-path: list of rows -> number
;; takes the upside-down triangle and returns the max path
(define (max-path triangle)
  (fold (λ (cumulative-maxes new-row)
          (reduce (map sum (zip (list new-row cumulative-maxes)))))
        (make-list (length (first triangle)) 0)
        triangle)){{< /highlight >}}

In particular, given the previously computed maxima, and a new row, we combine the two rows by adding the two lists together element-wise (mapping sum over a zipped list), and then we reduce the result. The initial value provided to fold is an appropriately-sized list of zeros, and the rest falls through.

With an extra bit of code to read in the big input file, we compute the answer to be 7273, and eat a cookie.

Of course, we split this problem up into much smaller pieces just to show how map and fold are used. Functions like zip are usually built in to languages (though I haven't found an analogue in Racket through the docs), and the maxes function would likely not be separated from the rest. The point is: the code is short without sacrificing modularity, readability, or extensibility. In fact, most of the algorithm we came up with translates directly to code! If we were to try the same thing in an imperative language, we would likely store everything in an array with pointers floating around, and our heads would spin with index shenanigans. Yet none of that has anything to do with the actual algorithm!

And that is why functional programming is beautiful.

As usual, [the entire source code](https://github.com/j2kun/racket-tutorial) for the examples in this post is available on [this blog's Github page](https://github.com/j2kun).

Until next time!

Addendum: Consider, if you will, the following solutions from others who solved the same problem on Project Euler:

C/C++:

{{< highlight python >}}#define numlines 100

int main()
{

  	int** lines = new int*[numlines];
  	int linelen[numlines];

  	for(int i=0; i<numlines; i++) linelen[i] = i+1;

   	ifstream in_triangle("triangle.txt");

   	// read in the textfile
   	for (int i=0;i<numlines;i++)
   	{
   		lines[i] = new int[i+1];
   		linelen[i] = i+1;
   		for (int j=0; j<i+1; j++)
   		{
       		in_triangle>>lines[i][j];
       	}
       	in_triangle.ignore(1,'\n');
   	}

   	int routes1[numlines];
   	int routes2[numlines];

   	for (int i=0;i<numlines;i++) routes1[i] = lines[numlines-1][i];

   	//find the best way
   	for (int i=numlines-2;i>=0;i--)
   	{
     	for(int j=0;j<i+1;j++)
   		{
   			if(routes1[j] > routes1[j+1])
   			{
      			routes2[j] = routes1[j] + lines[i][j];
            } else
            {
            	routes2[j] = routes1[j+1] + lines[i][j];
            }
     	}
     	for (int i=0;i<numlines;i++) routes1[i] = routes2[i];
   	}
   	cout<<"the sum is: "<<routes1[0]<<endl;
}{{< /highlight >}}

PHP:

{{< highlight python >}}<?php
 $cont = file_get_contents("triangle.txt");
 $lines = explode("\n",$cont);
 $bRow = explode(" ",$lines[count($lines)-1]);
 for($i=count($lines)-1; $i>0; $i--)
 {
   $tRow = explode(" ",$lines[$i-1]);
   for($j=0; $j<count($tRow); $j++)
   {
      if($bRow[$j] > $bRow[$j+1])
         $tRow[$j] += $bRow[$j];
      else
         $tRow[$j] += $bRow[$j+1];
   }
   if($i==1)
    echo $tRow[0];
   $bRow = $tRow;
 }
?>{{< /highlight >}}

J (We admit to have no idea what is going in programs written in J):

{{< highlight python >}})/ m{{< /highlight >}}

Python:

{{< highlight python >}}import sys

l = [[0] + [int(x) for x in line.split()] + [0] for line in sys.stdin]

for i in range(1, len(l)):
    for j in range(1, i+2):
        l[i][j] += max(l[i-1][j-1], l[i-1][j])
print max(l[-1]){{< /highlight >}}

Haskell:

{{< highlight python >}} module Main where
import IO

main = do
  triangle <- openFile "triangle.txt" ReadMode
              >>= hGetContents
  print . foldr1 reduce .
      map ((map read) . words) . lines $ triangle
    where reduce a b = zipWith (+) a (zipWith max b (tail b)) {{< /highlight >}}

Ah, foldr! map! zip! Haskell is clearly functional :) Now there is a lot more going on here (currying, function composition, IO monads) that is far beyond the scope of this post, and admittedly it could be written more clearly, but the algorithm is essentially the same as what we have.
