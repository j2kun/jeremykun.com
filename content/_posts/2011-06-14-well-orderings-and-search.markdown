---
author: jeremykun
date: 2011-06-14 18:18:04+00:00
draft: false
title: Well Orderings and Search
type: post
url: /2011/06/14/well-orderings-and-search/
categories:
- Algorithms
- Set Theory
tags:
- axiom of choice
- binary search
- mathematica
- mathematics
- pseudocode
- sorting
- well-ordering
---

## Binary Search


Binary search is perhaps the first and most basic nontrivial algorithm a student learns. For the mathematicians out there, binary search is a fast procedure to determine whether a sorted list contains a particular element. Here is a pseudocode implementation:

{{< highlight python >}}
# Binary Search:
# Given a list L, sorted via the total order <, and a sought
# element x, return true iff L contains x.

function binarySearch(L, x, <):
   # base case
   if(length(L) == 1):
      return L[0] == x
   middleIndex = floor(length(L) / 2)
   if (L[middleIndex] == x):
      return true

   # inductive step, with ellipsis notation meaning slices of L
   # from the beginning and to the end, respectively
   if (x < L[middleIndex]):
      return binarySort(L[...middleIndex-1], x, <)
   else:
      return binarySort(L[middleIndex+1...], x, <){{< /highlight >}}

Colloquially, this is the optimal strategy in a game of "guess the number," where the guesser is told if her guess is correct, too high, or too low. Try the middle number in the range of possible numbers. If the guess is too high, try the number which is 1/4th in the ordering, otherwise try 3/4ths, continuing this process until the number is guessed. This algorithm is obviously made for recursion (and for those advanced programmers, we resign to hope our working language supports tail-call optimization).

Binary search's runtime is rather easy to analyze. At each step of the algorithm, we either finish, or cut the problem size in half. By no stretch of the imagination, binary search runs in $O(\log n)$ where $n$ is the length of the input list. In other words, in at worst $\log_2 n$ steps, we will reduce the input list to have size 1, and can definitively say whether the list as a whole contains the sought element.

Notice that the success of the algorithm depends on the fact that the list is sorted, but the specific total order $<$ is irrelevant. We will investigate this idea further, but first we need some deeper maths.


## Well and Total Orders


For those of us who aren't set theorists, it isn't fair to talk about total orders and well orders without defining them. So here comes a definition:

**Definition:** A _strict total order_ $<$ is a relation on a set $S$ with the following statements holding for all $a, b, c \in S$:



	  * It is never the case that $a < a$. (anti-reflexivity)
	  * Exactly one of the following are true: $a < b, b < a,$ or $a = b$. (trichotomy)
	  * If $a < b$ and $b < c$, then $a < c$. (transitivity)

These conditions create an environment in which sorting is possible: we need to be able to compare any two elements (trichotomy), we need to be able to inspect two elements at a time and know that our analysis generalizes to the whole list (transitivity), and we can't break the world of strictness (anti-reflexivity).

_Aside: _The use of a strict total order as opposed to a non-strict total order is irrelevant, because each strict total order [corresponds bijectively to a non-strict total order](http://en.wikipedia.org/wiki/Total_order#Strict_total_order). Hence, there are two equivalent formulations of sorting with respect to strict and non-strict total orders, and we may choose one arbitrarily.

Now, we may elevate a total order $<$ to a _well order_ if every non-empty subset $R \subset S$ has a least element with respect to $<$. We computer scientists only sort finite lists, so every total order is automatically a well order. However, the reader may be interested in the mathematical need for such a distinction, so here it is:

Consider the integers $\mathbb{Z}$ with the standard ordering $<$. While $\mathbb{Z}$ itself has no smallest element, neither does any subset which has infinitely many negative numbers, such as the evens or odds. More generally, any open interval in the real numbers $\mathbb{R}$ obviously doesn't have a least element with respect to the natural order. In contrast, we rely on the crucial fact that the set of natural numbers $\mathbb{N}$ is well-ordered to apply mathematical induction.

Interestingly enough, a theorem [due to Ernst Zermelo](http://en.wikipedia.org/wiki/Well-ordering_theorem) states that every set can be well ordered, and it is equivalent to the Axiom of Choice. While many people have a hard time visualizing a well-ordering of the real numbers $\mathbb{R}$, we simply resign (as mystical as it is) to admit there is one out there somewhere, though we may never know what it is.

As another aside, it turns out that we only need one of the inequalities in $(<, \leq, >, \geq)$ and the standard logical operations _and_ (infix &&), _or _(infix ||), and _not_ (prefix !) in order to define the other three (and indeed, to define $=, \neq$ as well). This is a computer science trick that comes in handy, as we'll see later, so here is the described equivalence. Given $<$, we define the remaining operations as follows:



	  * $x > y$ is equivalent to $y < x$
	  * $x \geq y$ is equivalent to $!(x < y)$
	  * $x \leq y$ is equivalent to $!(y < x)$
	  * $x = y$ is equivalent to $!(x < y) \textup{ and } !(y < x)$
	  * $x \neq y$ is equivalent to $x < y \textup{ or } y < x$

So if we are interested in sorting a set via some procedure, all we need from the user is the $<$ operation, and then we may compare any way our heart desires.


## Defining a New Well Order


Consider a deck of cards which is initially sorted (with some arbitrary ordering on the suits), and then is "cut" at some arbitrary point and the bottom part is placed on top of the deck. We may simplify this "cut" operation to a list of numbers, say ten, and provide the following example of a cut:

    
    (5,6,9,10,11,13,1,3,3,4)


To pick a standard working language, we say the "cut point" of this list is 5, not 4.

We have a few (naive) options to search through cut data: we may sort it with respect to the natural total order on $\mathbb{N}$, and then search through it; we may stick the elements of the list into a [hash set](http://en.wikipedia.org/wiki/Hash_table) (a constant-time lookup table), and then query existence that way; or we may traverse the list element-by element looking for a particular value.

The problem with the first two methods, though they determine existence, is that they don't allow us to know _where_ the value is in the list. If this it not important, and we are searching many times (compared to the size of the list) on many different values, then a has table would be the correct choice. However, if we are searching only a few times, and need to know where the value is hidden, all three of the above approaches are slow and inelegant.

Enter well orders. You may have noticed that a cut list of numbers has a very simple well ordering in terms of the natural order on $\mathbb{N}$. Verbally, if the two numbers are separated across the cut point, then the larger number is in fact the smaller number. Otherwise, we may appeal to the regular ordering. Here it is in pseudocode:

{{< highlight python >}}function lessThan(x, y):
   if (y < cutPoint <= x):
      return true
   else if (x < cutPoint <= y):
      return false
   else:
      return x < y{{< /highlight >}}

And we may compress these if statements into a single condition:

{{< highlight python >}}function lessThan(cutPoint, x, y): 
   y < cutPoint <= x || (!(x < cutPoint <= y) && x < y)

function makeCutOrdering(cutPoint): 
   lambda x,y: lessThan(cutPoint, x, y){{< /highlight >}}

So we have found that a cut list of numbers is in fact well ordered with respect to this new relation. Forget about preprocessing the data, we can just do a binary search using this new ordering! Here's a Mathematica script that does just that. Here we assume constant-time list length calculations, and fast slicing (which Mathematica has). Note that list indexing and slicing has double square bracket [ [ ] ] syntax, while function application is single square brackets [ ]. It should look very similar to the earlier pseudocode for binary search.

{{< highlight python >}};

(* base case *)
BinarySearch[{oneElt_}, sought_, lt_] := eq[oneElt, sought, lt];

(* inductive step *)
BinarySearch[lst_List, sought_, lt_] :=
   Module[{size = Length[lst], midVal, midNdx},
      midNdx = Floor[size/2];
      midVal = lst[[midNdx]];
      If[eq[midVal, sought, lt],
         True,
         If[lt[sought, midVal],
            BinarySearch[lst[[ ;; midNdx - 1]], sought, lt]
            BinarySearch[lst[[midNdx + 1 ;; ]], sought, lt]
         ]
      ]
   ];{{< /highlight >}}

Notice that if we use the standard $<$ (in Mathematica, the function Less), then the BinarySearch function reverts to a standard binary search. Marvelous! Now we have a reusable piece of code that searches through any well-ordered set, provided we provide the correct well order.

The lesson to take from this is know your data! If your input list is not sorted, but still structured in some way, then there's a good chance it is sorted with respect to a non-natural total order. For example, many operating systems order filenames which end in numbers oddly (e.g. "file1", "file11", "file12", "file2"), and in certain places in the world, financial calendars are ordered differently (In Australia, the fiscal year starts in July). So take advantage of that, and you'll never need to write binary search again.
