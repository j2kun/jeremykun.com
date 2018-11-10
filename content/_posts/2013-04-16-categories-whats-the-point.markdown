---
author: jeremykun
date: 2013-04-16 23:00:09+00:00
draft: false
title: Categories, What's the Point?
type: post
url: /2013/04/16/categories-whats-the-point/
categories:
- Category Theory
- General
tags:
- categories
- mathematics
---

Perhaps primarily due to the prominence of monads [in the Haskell programming language](http://www.haskell.org/haskellwiki/Monad#Interesting_monads), programmers are often curious about category theory. Proponents of Haskell and other functional languages can put category-theoretic concepts on a pedestal or in a [mexican restaurant](http://blog.plover.com/prog/burritos.html), and their benefits can seem as mysterious as they are magical. For instance, the most common use of a monad in Haskell is to simulate the mutation of immutable data. Others include suspending and backtracking computations, and even [untying tangled rope](http://vimeo.com/6590617).




Category theory is often mocked (or praised) as the be-all and end-all of mathematical abstraction, and as such (and for [other reasons I've explored](http://jeremykun.com/2013/02/08/why-there-is-no-hitchhikers-guide-to-mathematics-for-programmers/) on this blog) many have found it difficult to digest and impossible to master. However, in truth category theory arose from a need for organizing mathematical ideas based on their shared structure. In this post, I want to give a brief overview of what purpose category theory serves within mathematics, and emphasize what direction we'll be going with it on this blog.




We should also note (writing this after the fact), that this article is meant to be a motivation to our future series on category theory. It is very difficult to explain what category theory is without going into very specific details, but we can explain by analogy what category theory achieves for us. That is the goal of this post.





## Category Theory as a Modern Language


It would be a silly question to ask why we don't program entirely in binary. It's a slow, inefficient process prone to mistakes of all sorts, and so we generally avoid it (although a well-rounded programmer can readily work in binary when it is necessary). But once upon a time there was no choice. Eventually people found that certain programmatic constructions were ubiquitous, and the developers of the next generation of languages abstracted these ideas to make types, lists, loops, if statements, and functions. The cycle continued: we found that we needed to further allow programmers to define custom data types, polymorphic operations, protected data, and others. Another iteration and we have list comprehensions, Python [decorators](http://www.artima.com/weblogs/viewpost.jsp?thread=240808), Javascript [promises](http://blog.parse.com/2013/01/29/whats-so-great-about-javascript-promises/), and a whole host of other programming paradigms that have turned into features  [1].

So it is with programming as it is in mathematics. I would digress by detailing the history of numbers as symbols, or of the [transition to set-based mathematics](http://www-groups.dcs.st-and.ac.uk/history/HistTopics/Beginnings_of_set_theory.html) in the late 1800's to early 1900's. But within the last fifty years there has been a major revolution in the discourse of modern mathematics: the integration of category theory.

I have to contextualize this immediately, because I don't want to enter a metamathematical discussion about what the proper foundation of all mathematics should be. This is a huge can of worms riddled with strong opinions and logical fallacies. I'm not saying that mathematicians have unanimously agreed that category theory is the correct basis for all logic and mathematics. I wouldn't claim _that_ just as I wouldn't claim that all programmers agree that object-oriented programming is the best model for all programs, because that would be ridiculous and myopic.

I am saying, however, that enough mathematicians have agreed category theory is useful and convenient. As a result category theory is the contemporary baseline for serious discussion in many fields of pure mathematics. In short, anyone who wants to do serious mathematics in these fields must learn the language of category theory.

One goal of this blog's category theory series is to gain fair fluency in this modern language.


## Category Theory as an Organizing Principle


As most readers will readily understand, people who study and develop programming languages think differently about language features than people who just use programming languages. For instance, a systems programmer friend of mine was pleased to discover that Python supports multiple variable assignments in a single statement (e.g. a,b = 7, False). Now a language designer might smile and think, "Well that's just syntactic sugar." But to a working programmer, this kind of feature is quite convenient and extensible (to one-line variable swapping, multiple return values, etc.). On the other hand, when a language designer claims to have invented a wonderful new paradigm, say, [continuations](http://en.wikipedia.org/wiki/Continuation-passing_style), the working programmer would think, "What good is that for? It's just an ugly way to write functions!" It's not until someone uses the feature to do amazing things like eliminate the need for a stack or [provide lightweight extensible stack inspection](http://scholar.google.com/citations?view_op=view_citation&hl=en&user=jh7JGrEAAAAJ&citation_for_view=jh7JGrEAAAAJ:Tyk-4Ss8FVUC) that the working programmer appreciates the abstraction.

Analogously, those who study category theory from a logical viewpoint see it very differently than those who use it to come up with new mathematics. Many would argue it was not until the work of [Alexander Grothendieck](http://en.wikipedia.org/wiki/Alexander_Grothendieck) (in the late 1950's and 60's) that non-category-theorists saw the true value of applying category theory to their fields. Grothendieck implemented a sweeping reform of a number of mathematical fields, his most notable stemming from the invention of [étale cohomology](http://en.wikipedia.org/wiki/%C3%89tale_cohomology). Now I'm not a number theorist or an algebraic geometer, but I know enough to understand category theory's role there.

The main benefit to using category theory is as a way to organize and synthesize information. This is particularly true of the concept of a _universal property_. We will hear more about this in due time, but as it turns out most important mathematical structures can be phrased in terms of universal properties. Moreover, a universal property jumps right to the heart of _why_ a construction is important. For example, one new to mathematics might wonder why polynomials are so ubiquitous and important. The answer is (vaguely) that they satisfy a universal property which makes them canonical extensions of certain computations.

I want to make this point very clear, because most newcomers to category theory are never told this. Category theory exists because it fills a _need_. Even if that need is a need for better organization and a refocusing of existing definitions. It was not just an attempt to build higher abstractions, but a successful adaptation of mathematics to a more complex world.

And so as category theory has spread through the mathematical world, more and more definitions are phrased in terms of various universal constructions in special categories. This is a good thing precisely because there are _only two_ universal properties. As we'll see, by stating that an object satisfies a universal property, one immediately understands how the proof will progress, and many properties like uniqueness and invariance will follow trivially. Familiar readers of this blog will remember our posts on groups (and will read future posts on rings and fields), in which we state and prove theorems about quotients and products and isomorphism theorems which are all essentially the same across the various fields. Viewing the problem abstractly in category theory allows one to prove all of these theorems simultaneously, and study the differences between the objects via the properties of the category as a whole.

To reiterate, category theory streamlines the process of making precise technical definitions and proving their well-definition. One hopes, then, that very general theorems proved within category theory can apply to a wide breadth of practical areas. [2] 


## Category as a Tool to Gain More Knowledge


When someone invents a new programming tool, the primary goal is usually to allow a programmer to do something that he couldn't do previously (or was difficult/inconvenient to do). For instance, programmers invented version control to allow for easy project collaboration and rollbacks. Before then, managing multiple versions of a file was a horrendous task.

In mathematics, we can ask the poignant question: what does category theory allow us to do that we couldn't do before? This should be read as _besides_ having a new way to think about mathematical structures and _besides_ having a more efficient language for discourse. Of course, this is a highly philosophical question. Could it be that there is some (non-categorical) theorem that can't be proved unless you resort to category-theoretical arguments? In my optimistic mind the answer must certainly be no. Moreover, it appears that most proofs that "rely" on category theory only really do so because they're so deeply embedded in the abstraction that unraveling them to find non-category-theoretical proofs would be a tiresome and fruitless process.

In programming we can ask a related question: what insights does category theory give us about programming? Can we write programs better if we resort to organizing things in terms of categories? Would it be easier to prove correctness of our programs or to discover a good algorithm to solve a task?

I think it goes without saying that we certainly can't do anything that we couldn't have done before (this would violate the notion that our usual languages are Turing complete). But these other soft questions should have positive answers. While in the previous two sections I gave concrete reasons why one might want to learn category theory, here the reason is very vague. Supposedly, learning category theory makes one a better programmer by forcing one to make connections between structures and computation. Then when a new problem comes along, it becomes easy (almost natural!) to fit it into a categorical organization of the world, and the right solution just "falls into your lap."

While I don't necessarily espouse this line of thinking (I believe any mathematics makes you better at analyzing problems), this is essentially the argument for why functional programming is a good thing to learn.


## What We'll Do With Categories


I don't necessarily have any amazing applications of category theory in mind for this blog. Instead, I want to develop a fair fluency and categorical organization (the first to sections of this article) among my readers. Along the way, we will additionally _implement_ the concepts of category theory in code. This will give us a chance to play with the ideas as we learn, and hopefully will make all of the abstract nonsense much more concrete.

So next time we'll start with the definition of a category, and give a wealth of examples. Until then!

**[1]** I'm obviously oversimplifying the history of programming languages, but the spirit is true, and the same as for all technological developments: incremental improvements based on a need for convenience and removing repetitive tasks. (back)
**[2]** One place this is particularly convenient is actually in the theory of persistent homology. Though on this blog the plan is to avoid the theory side before we investigate the algorithm from a high-level, once we get to the theory we will see an effective use of category theory in action. (back)
