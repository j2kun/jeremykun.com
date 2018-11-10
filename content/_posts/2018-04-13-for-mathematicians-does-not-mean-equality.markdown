---
author: jeremykun
date: 2018-04-13 15:00:05+00:00
draft: false
title: For mathematicians, = does not mean equality
type: post
url: /2018/04/13/for-mathematicians-does-not-mean-equality/
categories:
- General
---

Every now and then I hear some ridiculous things about the equals symbol. Some large subset of programmers—perhaps related to functional programmers, perhaps not—seem to think that = should only and ever mean "equality in the mathematical sense." The argument usually goes,

_Functional programming gives us back that inalienable right to analyze things by using mathematics. Never again need we bear the burden of that foul mutant x = x+1! No novice programmer—nay, not even a mathematician!—could comprehend such flabbergastery. Tis a pinnacle of confusion!_

It's ironic that so much of the merits or detriment of the use of = is based on a veiled appeal to the purity of mathematics. Just as often software engineers turn the tables, and any similarity to mathematics is decried as elitist jibber jabber (_Such an archaic and abstruse use of symbols! Oh no, big-O!_).

In fact, equality is more rigorously defined in a programming language than it will ever be in mathematics. Even in the hottest pits of software hell, where there's = and == and ===, throwing in ==== just to rub salt in the wound, each operator gets its own coherent definition and documentation. Learn it once and you'll never go astray.

Not so in mathematics—oh yes, hide your children from the terrors that lurk. In mathematics equality is little more than a stand-in for the word "is," oftentimes entirely dependent on context. Now gather round and listen to the tale of the true identities of the masquerader known as =.

Let's start with some low-hanging fruit, the superficial concerns.

$\displaystyle \sum_{i=1}^n i^2 + 3$

If = were interpreted literally, $i$ would be "equal" to 1, and "equal" to 2, and I'd facetiously demand $1 = 2$. Aha! Where is your Gauss now?! But seriously, this bit of notation shows that mathematics has both expressions with scope and variables that change their value over time. And the $\sum$ use for notation was established by _Euler_, long before algorithms jumped from logic to computers to billionaire Senate testimonies.

Likewise, set-builder notation often uses the same kind of equals-as-iterate.

$\displaystyle A = \{ n^2 : n = 1, 2, \dots, 100 \}$

In Python, or interpreting the expression literally, the value of $n$ would be a tuple, producing a type error. ([In Javascript, it produces 2](https://jsconsole.com/?console.log%28%5B1%2C2%2C3%2C4%2C5%2C6%2C7%5D%20%5E%202%29%3B). How could it be Javascript if it didn't?)

Next up we have the sloppiness of functions. Let $f(x) = 2x + 3$. This is a function, and $x$ is a variable. Rather than precisely say, $f(2) = 7$, we say that for $x=2, f(x) = 7$. So $x$ is simultaneously an indeterminate input and a concrete value. The same scoping for programming functions bypass the naive expectation that equality means "now and forever." Couple that with the question-as-equation $f(x) = 7$, in which one asks what values of $x$ produce this result, if any, and you begin to see how deep the rabbit hole goes. To understand what someone means when they say $f(x) = 7$, you need to know the context.

But this is just the tip of the iceberg, and we're drilling deep. The point is that = carries with it all _kinds_ of baggage, not just the scope of a particular binding of a variable.

Continuing with functions, we have rational expressions like $f(x) = \frac{(x+1)x}{x}$. One often starts by saying "let's let $f$ be this function." Then we want to analyze it, and in-so-doing we simplify to $f(x) = x+1$. To keep ourselves safe, we modify the domain of $f$ to exclude $x=0$ post-hoc. But the flow of the argument is the same: we defer the exclusion of $x=0$ until we need it, meaning the equality at the beginning is a different equality than at the end. In effect, we have an infinitude of different kinds of equality for functions, one for each choice of what to exclude from the domain. And a mathematical proof might switch between them as needed.

"Why not just define a new function $g$ with a different domain," you ask? You can, but mathematicians don't. And if you're arguing in favor or against a particular notation, and using "mathematics" as your impenetrable shield, you've got to remember the famous definition of Reuben Hersh, that "mathematics is what mathematicians do." For us, that means you can't claim superiority based on an idea of mathematics that disagrees with mathematical practice. And mathematics, dear reader, is messier than programmers and philosophers would have one believe.

And now we turn to the Great Equality Contextualizer, the **isomorphism. **

You see, all over mathematics there are objects which are not equal, but we want them to be. When you study symmetry, say, you learn that there is an algebraic structure to symmetry called a [group](http://jeremykun.com/2012/12/08/groups-a-primer/). And the same structure—that is, the same true underlying relationships between the symmetries of a thing—can show up in many different guises. As a set, as a picture, as a class of functions, in polynomials and compass constructions and wallpapers, oh my! In each of these things we want to say that two symmetry structures are the same even if they look different. We want to overload equality when four-fold rotational symmetry applies to my table as well as a four-pointed star.

The tool we use for that is called an isomorphism. In brief terms, it's a function between two objects, with an inverse, that preserves the structure you care about both ways. In fact, there _is_ a special symbol for when two things are isomorphic, and it's often $\cong$. But $\cong$ is annoying to write, and it really just means "is the same as" the same way equality does. So mathematicians often drop the squiggle and use =.

Plus, there are a million kinds of isomorphism. Groups, graphs, vector spaces, rings, fields, modules, algebras, rational functions, varieties, Lie groups, *breathe* topological spaces, manifolds of all stripes, sheaves, schemes, lattices, knots, the list just keeps going on and on and on! No way are we making up a symbol for each one of these and the hundreds of variations we might come up with. And moreover, when you say two things are isomorphic, that gives you absolutely no indication of _how_ they are isomorphic. It fact, it can be extremely tedious to compute isomorphisms between things, and it's even known to be [uncomputable](https://en.wikipedia.org/wiki/Group_isomorphism_problem) in extreme cases! What good is equality if you can't even check it?

_But wait!_ You might ask, having read this blog for a while and knowing better than to not question a claim. _All of these uses of equality are still equivalence relations, and x = x + 1 is not an equivalence relation!_

Well, you got me there. Mathematicians love to keep equality as an equivalence relation. When mathematicians need to define an algorithm where the value of $x$ changes in a nontrivial way, it's usually done by setting $x_0$ equal to some starting value and letting $x_{n}$ be defined as some function of $x_{n-1}$ and smaller terms, like the good ol' Fibonacci sequence $x_0 = x_1 = 1$ and $x_n = x_{n-1} + x_{n-2}$.

_If mutation is so great, why do mathematicians use recursion so much? Huh? Huh?_

Well, I've got two counterpoints. The first is that the goal here is to _reason_ about the sequence, not to describe it in a way that can be efficiently carried out by a computer. When you say x = x + 1, you're telling the computer that the old value of x need not linger, and you can do away with the space occupied by the previous value of x. To achieve the same result with recursion requires a whole other can of worms: memoization and tail recursive style and compiler optimizations to shed stack frames. It's a lot more work to understand all that (to get to an equivalent solution) than it is to understand mutation! Simply stated, the goals of mathematics and programming are quite differently aligned. The former is about understanding a thing, and the latter is more often about describing a concrete process under threat of limited resources.

My second point is that mathematical notation is so flexible and adaptable that it doesn't _need_ mutation the same way programming languages need it. In mathematics we have no stack overflows, no register limits or page swaps, no limitations on variable names or memory allocation, our brains do the continuation passing for us, and we can rewrite history ad hoc and pile on abstractions as needed to achieve a particular goal. Even when you're describing an algorithm in mathematics, you get the benefits of mathematical abstractions. A mathematician could easily introduce = as mutation in their work. Nothing stops them from doing so! It's just that they rarely have a genuine need for it.

But of course, none of this changes that languages could use := or "let" instead of = for assignment. If a strict adherence to asymmetry for asymmetric operations helps you sleep at night, so be it. My point is that the case when = means assignment is an extremely simple bit of context. Much simpler than the albatrossian mental burden required to understand what mathematicians really mean when they write $A = B$.

_Postscript: I hope everyone reading this realizes I'm embellishing a bit for the sake of entertainment. If you want to fight me, tell me the best tree isn't aspen. I dare you.

Postpostscript: embarrassingly, I completely forgot about Big-O notation and friends (despite mentioning it in the article!) as a case where = does not mean equality! f(n) = O(log n) is a statement about upper bounds, not equality! Thanks to [@lreyzin](https://twitter.com/lreyzin) for keeping me honest._
