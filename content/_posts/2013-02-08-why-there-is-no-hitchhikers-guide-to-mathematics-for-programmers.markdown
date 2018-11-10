---
author: jeremykun
date: 2013-02-08 17:24:53+00:00
draft: false
title: Why there is no Hitchhiker's Guide to Mathematics for Programmers
type: post
url: /2013/02/08/why-there-is-no-hitchhikers-guide-to-mathematics-for-programmers/
categories:
- General
- Logic
- Set Theory
- Teaching
---

_For those who aren't regular readers: as a followup to this post, there are four posts detailing the basic four methods of proof, with intentions to detail some more advanced proof techniques in the future. You can find them on this blog's [primers page](http://jeremykun.com/primers/)._

## Do you really want to get better at mathematics?

Remember when you first learned how to program? I do. I spent two years [experimenting with Java programs on my own in high school](http://jeremykun.com/2012/03/15/learning-programming-zombies/). Those two years collectively contain the worst and most embarrassing code I have ever written. My programs [absolutely reeked of programming no-nos](http://www.codinghorror.com/blog/2006/05/code-smells.html). Hundred-line functions and even thousand-line classes, magic numbers, unreachable blocks of code, ridiculous code comments, a complete disregard for sensible object orientation, negligence of nearly all logic, and type-coercion that would make your skin crawl. I committed every naive mistake in the book, and for all my obvious shortcomings I considered myself a hot-shot programmer! At least I was learning a lot, and I was a hot-shot programmer in a crowd of high-school students interested in game programming.

Even after my first exposure and my commitment to get a programming degree in college, it was another year before I knew what a stack frame or a register was, two before I was anywhere near competent with a terminal, three before I learned to appreciate functional programming, and to this day I _still _have an irrational fear of networking and systems programming (the first time I manually edited the call stack I couldn't stop shivering with apprehension and disgust at what I was doing).

[caption id="attachment_2930" align="aligncenter" width="584"][![I just made it so this function returns to a *different* place than where it was called from.](http://jeremykun.files.wordpress.com/2013/01/wat.jpg)
](http://jeremykun.files.wordpress.com/2013/01/wat.jpg) I just made this function call return to a *different* place than where it was called from.[/caption]

In a class on C++ programming I was programming a Checkers game, and my task at the moment was to generate a list of all possible jump-moves that could be made on a given board. This naturally involved a depth-first search and a couple of recursive function calls, and once I had something I was pleased with, I compiled it and ran it on my first non-trivial example. Low and behold (even having followed test-driven development!), I was [hit hard in the face](http://xkcd.com/371/) by a segmentation fault. It took hundreds of test cases and more than twenty hours of confusion before I found the error: I was passing a reference when I should have been passing a pointer. This was not a bug in syntax or semantics (I understood pointers and references well enough) but a _design_ error. And the aggravating part, as most programmers know, was that the fix required the change of about 4 characters. Twenty hours of work for four characters! Once I begrudgingly verified it worked (of course it worked, it was so obvious in hindsight), I promptly took the rest of the day off to play Starcraft.

Of course, as every code-savvy reader will agree, all of this drama is part of the process of becoming and strong programmer. One must study the topics incrementally, make plentiful mistakes and learn from them, and spend uncountably many hours in a state of stuporous befuddlement before one can be considered an experienced coder. This gives rise to all sorts of programmer culture, [unix jokes](http://xkcd.com/149/), and [reverence for the masters of C](http://en.wikipedia.org/wiki/The_C_Programming_Language) that make the programming community so lovely to be a part of. It's like a secret club where you know all the handshakes. And should you forget one, a crafty use of awk and sed will suffice.

[caption id="attachment_2970" align="aligncenter" width="566"][!["Semicolons of Fury" was the name of my programming team in the ACM collegiate programming contest. We placed Cal Poly third in the Southern California Regionals.](http://jeremykun.files.wordpress.com/2013/02/furries.jpg)
](http://jeremykun.files.wordpress.com/2013/02/furries.jpg) "Semicolons of Fury" was the name of my programming team in the ACM collegiate programming contest. We placed Cal Poly third in the Southern California Regionals, and in my opinion our success was due in large part to the dynamics of our team. I (center, in blue) have since gotten a more stylish haircut.[/caption]

Now imagine someone comes along and says,

<blockquote>"I'm really interested in learning to code, but I don't plan to write any programs and I absolutely _abhor_ tracing program execution. I just want to use applications that others have written, like Chrome and iTunes."</blockquote>

You would laugh at them! And the first thing that would pass through your mind is either, "This person would give up programming after the first twenty minutes," or "I would be doing the world a favor by preventing this person from ever writing a program. This person belongs in some other profession." This lies in stark opposition to the common chorus that [everyone should learn programming](http://business.time.com/2012/06/08/codecademy-founder-why-everyone-should-learn-programming/). After all, it's a constructive way to think about problem solving and a highly employable skill. In today's increasingly technological world, it literally pays to know your computer better than a web browser. (Ironically, I'm writing this on my [Chromebook](http://jeremykun.files.wordpress.com/2013/02/jeremy-on-a-chromebook.jpg), but in my defense it has a terminal with ssh. Perhaps more ironically, all of my _real_ work is done with paper and pencil.)

Unfortunately this sentiment is mirrored among most programmers who claim to be interested in mathematics. Mathematics is fascinating and useful and doing it makes you smarter and better at problem solving. But a lot of programmers think they want to do mathematics, and they either don't know what "doing mathematics" means, or they don't really mean they want to do mathematics. The appropriate translation of the above quote for mathematics is:

<blockquote>"Mathematics is useful and I want to be better at it, but I won't write any original proofs and I absolutely _abhor_ reading other people's proofs. I just want to use the theorems others have proved, like Fermat's Last Theorem and the undecidability of the Halting Problem."</blockquote>

Of course no non-mathematician is really going to understand the current proof of Fermat's Last Theorem, just as no fledgling programmer is going to attempt to write a (quality) web browser. The point is that the sentiment is in the wrong place. Mathematics is cousin to programming in terms of the learning curve, obscure culture, and the amount of time one spends confused. And mathematics is as much about writing proofs as software development is about writing programs (it's not _everything_, but without it you can't do anything). Honestly, it sounds ridiculously obvious to say it directly like this, but the fact remains that people feel like they can understand the content of mathematics without being able to write or read proofs.

I want to devote the rest of this post to exploring some of the reasons why this misconception exists. My main argument is that the reasons have to do more with the culture of mathematics than the actual difficulty of the subject. Unfortunately as of the time of this writing I don't have a proposed "solution." And all I can claim is a problem is that programmers can have mistaken views of what mathematics involves. I don't propose a way to make mathematics easier for programmers, although I do try to make the content on my blog as clear as possible (within reason). I honestly do believe that the struggle and confusion builds mathematical character, just as the arduous bug-hunt builds programming character. If you want to be good at mathematics, there is no other way.

All I want to do with this article is to detail _why_ mathematics can be so hard for beginners, to explain a few of the secret handshakes, and hopefully to bring an outsider a step closer to becoming an insider. And I want to stress that this is not a call for all programmers to learn mathematics. Far from it! I just happen to notice that, for good reason, the proportion of programmers who are interested in mathematics is larger than in most professions. And as a member of both communities, I want to shed light on why mathematics can be difficult for an otherwise smart and motivated software engineer.

So read on, and welcome to the community.

## Travelling far and wide

Perhaps one of the most prominent objections to devoting a lot of time to mathematics is that it can be years before you ever apply mathematics to writing programs. On one hand, this is an extremely valid concern. If you love writing programs and designing software, then mathematics is nothing more than a tool to help you write better programs.

But on the other hand, the very _nature_ of mathematics is what makes it so applicable, and the only way to experience nature is to ditch the city entirely. Indeed, I provide an extended example of this in my journalesque post on [introducing graph theory to high school students](http://jeremykun.com/2011/06/26/teaching-mathematics-graph-theory/): the point of the whole exercise is to filter out the worldly details and distill the problem into a pristine mathematical form. Only then can we see its beauty and wide applicability.

Here is a more concrete example. Suppose you were trying to encrypt the contents of a message so that nobody could read it even if they intercepted the message in transit. Your first ideas would doubtlessly be the same as those of our civilization's past: [substitution ciphers](http://jeremykun.com/2012/02/03/cryptanalysis-with-n-grams/), [Vigenere ciphers](http://en.wikipedia.org/wiki/Vigen%C3%A8re_cipher), the [Enigma machine](http://www.youtube.com/watch?v=G2_Q9FoD-oQ), etc. Regardless of what method you come up with, your first thought would most certainly _not_ be, "prime numbers so big they'll make your pants fall down." Of course, the majority of [encryption methods today](http://jeremykun.com/2011/07/29/encryption-rsa/) rely on very deep facts (or rather, conjectures) about prime numbers, elliptic curves, and other mathematical objects ("[group presentations so complicated they'll orient your Mobius band](http://en.wikipedia.org/wiki/Word_problem_for_groups#Examples)," anyone?). But it took hundreds of years of number theory to get there, and countless deviations into other fields and dead-ends. It's not that the methods themselves are particularly complicated, but the way they're often presented (and this is unavoidable if you're interested in _new_ mathematical breakthroughs) is in the form of classical mathematical literature.

Of course there are other examples much closer to contemporary fashionable programming techniques. One such example is [boosting](http://en.wikipedia.org/wiki/Boosting_(machine_learning)). While we have yet to investigate boosting on this blog [update: [yes we have](http://jeremykun.com/2015/05/18/boosting-census/)], the basic idea is that one can combine a bunch of algorithms which perform just barely better than 50% accuracy, and collectively they will be arbitrarily close to perfect. In a field dominated by practical applications, this result is purely the product of mathematical analysis.

And of course boosting in turn relies on the mathematics of probability theory, which in turn relies on set theory and measure theory, which in turn relies on real analysis, and so on. One could get lost for a lifetime in this mathematical landscape! And indeed, the best way to get a good view of it all is to start at the bottom. To learn mathematics from scratch. The working programmer simply doesn't have time for that.

## What is it really, that people have such a hard time learning?

Most of the complaints about mathematics come understandably from notation and abstraction. And while I'll have more to say on that below, I'm fairly certain that the main obstacle is a familiarity with the basic methods of proof.

While methods of proof are semantical by nature, in practice they form a scaffolding for all of mathematics, and as such one could better characterize them as syntactical. I'm talking, of course, about the four basics: direct implication, proof by contradiction, contrapositive, and induction. These are the loops, if statements, pointers, and structs of rigorous argument, and there is simply no way to understand the mathematics without a native fluency in this language.

[caption id="" align="aligncenter" width="300"][![](http://i.qkme.me/3p0owh.jpg)
](http://i.qkme.me/3p0owh.jpg) The "Math Major Sloth" is fluent. Why aren't you?[/caption]

So much of mathematics is built up by chaining together a multitude of absolutely trivial statements which are amendable to proof by the basic four. I'm not kidding when I say they are absolutely trivial. A professor of mine once said,

<blockquote>If it's not completely trivial, then it's probably not true.</blockquote>

I can't agree more with this statement. Of course, there are many sophisticated proofs in mathematics, but an overwhelming majority of (very important) facts fall in the trivial category. That being said, trivial can be sometimes relative to one's familiarity with a subject, but that doesn't make the sentiment any less right. Drawing up a shopping list is trivial once you're comfortable with a pencil and paper and you know how to write (and you know what the words mean). There are certainly works of writing that require a lot more than what it takes to write a shopping list. Likewise, when we say something is trivial in mathematics, it's because there's no content to the proof outside of using definitions and a typical application of the basic four methods of proof. This is the "holding a pencil" part of writing a shopping list.

And as you probably know, there are many many more methods of proof than just the basic four. Proof by construction, by exhaustion, case analysis, and even picture proofs have a place in all fields of mathematics. More relevantly for programmers, there are algorithm termination proofs, probabilistic proofs, loop invariants to design and monitor, and the ubiquitous NP-hardness proofs (I'm talking about you, [Travelling Salesman Problem](http://en.wikipedia.org/wiki/Travelling_salesman_problem)!). There are many books dedicated to showcasing such techniques, and rightly so. Clever proofs are what mathematicians strive for above all else, and once a clever proof is discovered, the immediate first step is to try to turn it into a general method for proving other facts. Fully flushing out such a process (over many years, showcasing many applications and extensions) is what makes one a world-class mathematician.

Another difficulty faced by programmers new to mathematics is the inability to check your proof absolutely. With a program, you can always write test cases and run them to ensure they all pass. If your tests are solid and plentiful, the computer will catch your mistakes and you can go fix them.

There is no corresponding "proof checker" for mathematics. There is no compiler to tell you that it's nonsensical to construct the set of all sets, or that it's a type error to quotient a set by something that's not an equivalence relation. The only way to get feedback is to seek out other people who do mathematics and ask their opinion. In solo, mathematics involves a lot of backtracking, revising mistaken assumptions, and stretching an idea to its breaking point to see that it didn't even make sense to begin with. This is "bug hunting" in mathematics, and it can often completely destroy a proof and make one start over from scratch. It feels like writing a few hundred lines of code only to have the final program run "rm -rf *" on the directory containing it. It can be really. really. depressing.

It is an interesting pedagogical question in my mind whether there is a way to introduce proofs and the language of mature mathematics in a way that stays within a stone's throw of computer programs. It seems like a worthwhile effort, but I can't think of anyone who has sought to replace a classical mathematics education entirely with one based on computation.

## Mathematical syntax

Another major reason programmers are unwilling to give mathematics an honest effort is the culture of mathematical syntax: it's ambiguous, and there's usually nobody around to explain it to you. Let me start with an example of why this is not a problem in programming. Let's say we're reading a Python program and we see an expression like this:

    
    foo[2]

The nature of (most) programming languages dictates that there are a small number of ways to interpret what's going on in here:

	  1. foo could be a list/tuple, and we're accessing the third element in it.
	  2. foo could be a dictionary, and we're looking up value associated to the key 2.
	  3. foo could be a string, and we're extracting the third character.
	  4. foo could be a custom-defined object, whose __getitem__ method is defined somewhere else and we can look there to see exactly what it does.

There are probably other times this notation can occur (although I'd be surprised if number 4 didn't by default capture all possible uses), but the point is that any programmer reading this program knows enough to intuit that square brackets mean "accessing an item inside foo with identifier 2." Part of the reasons that programs can be very easy to read is precisely because someone had to write a parser for a programming language, and so they had to literally enumerate all possible uses of any expression form.

The other extreme is the syntax of mathematics. The daunting fact is that there is no bound to what mathematical notation can represent, and much of mathematical notation is inherently ad hoc. For instance, if you're reading a math paper and you come across an expression that looks like this

$\delta_i^j$

The possibilities of what this could represent are literally endless. Just to give the unmathematical reader a taste: $\delta_i$ could be an entry of a sequence of numbers of which we're taking arithmetic $j^\textup{th}$ powers. The use of the letter delta could signify a slightly nonstandard way to write the [Kronecker delta function](http://en.wikipedia.org/wiki/Kronecker_delta), for which $\delta_i^j$ is one precisely when $i=j$ and zero otherwise. The superscript $j$ could represent _dimension_. Indeed, I'm currently writing an article in which I use $\delta^k_n$ to represent $k$_-dimensional [simplex numbers](http://en.wikipedia.org/wiki/Figurate_number#Triangular_numbers), _specifically because I'm relating the numbers to geometric objects called [simplices](http://en.wikipedia.org/wiki/Simplex), and the letter for those is  a capital $\Delta$. The fact is that using notation in a slightly non-standard way does _not_ invalidate a proof in the way that it can easily invalidate a program's correctness.

What's worse is that once mathematicians get comfortable with a particular notation, they will often "naturally extend" or even _silently drop_ things like subscripts and assume their reader understands and agrees with the convenience! For example, here is a common difficulty that beginners face in reading math that involves use of the summation operator. Say that I have a finite set of numbers whose sum I'm interested in. The most rigorous way to express this is not far off from programming:

Let $S = \left \{ x_1, \dots, x_n \right \}$ be a finite set of things. Then their sum is finite:

$\displaystyle \sum_{i=1}^n x_i$

The programmer would say "great!" Assuming I know what "+" means for these things, I can start by adding $x_1 + x_2$, add the result to $x_3$, and keep going until I have the whole sum. This is really just a left fold of the plus operator over the list $S$.

But for mathematicians, the notation is _far _more flexible. For instance, I could say

Let $S$ be finite. Then $\sum_{x \in S} x$ is finite.

Things are now more vague. We need to remember that the $\in$ symbol means "in." We have to realize that the strict syntax of having an iteration variable $i$ is no longer in effect. Moreover, the order in which the things are summed (which for a left fold is strictly prescribed) is arbitrary. If you asked any mathematician, they'd say "well of course it's arbitrary, in an abelian group addition is commutative so the order doesn't matter." But realize, this is yet another fact that the reader must be aware of to be comfortable with the expression.

But it _still_ gets worse.

In the case of the capital Sigma, there is nothing syntactically stopping a mathematician from writing

$\displaystyle \sum_{\sigma \in \Sigma} f_{\Sigma}(\sigma)$

Though experienced readers may chuckle, they will have no trouble understanding what is meant here. That is, syntactically this expression is unambiguous enough to avoid an outcry: $\Sigma$ just happens to also be a set, and saying $f_{\Sigma}$ means that the function $f$ is constructed in a way that depends on the choice of the set $\Sigma$. This often shows up in computer science literature, as $\Sigma$ is a standard letter to denote an alphabet (such as the binary alphabet $\left \{ 0,1 \right \}$).

One can even take it a step further and leave out the set we're iterating over, as in

$\displaystyle \sum_{\sigma} f_{\Sigma}(\sigma)$

since it's understood that the lowercase letter ($\sigma$) is usually an element of the set denoted by the corresponding uppercase letter ($\Sigma$). If you don't know greek and haven't seen that coincidence enough times to recognize it, you would quickly get lost. But programmers must realize: this is just the mathematician's secret handshake. A mathematician would be just as bewildered and confused upon seeing some of the pointer arithmetic hacks C programmers invent, or the always awkward infinite for loop, if they had not had enough experience dealing with the syntax of standard for loops.

    
    for (;;) {
       ;
    }

In fact, a mathematician would look at this in disgust! The fact that the C programmer has need for something as pointless as an "empty statement" should be viewed as a clumsy inelegance in the syntax of the programming language (says the mathematician). Since mathematicians have the power to change their syntax at will, they would argue there's no good reason _not_ to change it, if it were a mathematical expression, to something simpler.

And once the paper you're reading is over, and you start reading a new paper, chances are their conventions and notation will be ever-so-slightly different, and you have to keep straight what means what. It's as if the syntax of a programming language changed _depending on who was writing the program_!

Perhaps understandably, the frustration that most mathematicians feel when dealing with varying syntax across different papers and books is collectively called "technicalities." And the more advanced the mathematics becomes, the ability to fluidly transition between high-level intuition and technical details is all but assumed.

The upshot of this whole conversation is that the reader of a mathematical proof must hold in mind a vastly larger body of absorbed (and often frivolous) knowledge than the reader of a computer program.

At this point you might see all of this as my complaining, but in truth I'm saying this notational flexibility and ambiguity is a _benefit_. Once you get used to doing mathematics, you realize that technical syntax can make something which is essentially simple seem much more difficult than it is. In other words, we absolutely _must_ have a way to make things completely rigorous, but in developing and presenting proofs the most important part is to make the audience understand the big picture, see intuition behind the symbols, and believe the proofs. For better or worse, mathematical syntax is just a means to that end, and the more abstract the mathematics becomes, the more flexiblility mathematicians need to keep themselves afloat in a tumultuous sea of notation.

## You're on your own, unless you're around mathematicians

That brings me to my last point: reading mathematics is much more difficult than _conversing_ about mathematics in person. The reason for this is once again cultural.

Imagine you're reading someone else's program, and they've defined a number of functions like this (pardon the single-letter variable names; as long as one is willing to be vague I prefer single-letter variable names to "foo/bar/baz").

    
    def splice(L):
       ...
    
    def join(*args):
       ...
    
    def flip(x, y):
       ...

There are two parts to understanding how these functions work. The first part is that someone (or a code comment) explains to you in a high level what they do to an input. The second part is to weed out the finer details. These "finer details" are usually completely spelled out by the documentation, but it's still a good practice to experiment with it yourself (there is always the possibility for bugs or unexpected features, of course).

In mathematics there is no unified documentation, just a collective understanding, scattered references, and spoken folk lore. You're lucky if a textbook has a table of notation in the appendix. You are expected to derive the finer details and catch the errors yourself. Even if you are told the end result of a proposition, it is often followed by, "The proof is trivial." This is the mathematician's version of piping output to /dev/null, and literally translates to, "You're expected to be able to write the proof yourself, and if you can't then maybe you're not ready to continue."

Indeed, the opposite problems are familiar to a beginning programmer when they aren't in a group of active programmers. Why is it that people give up or don't enjoy programming? Is it because they have a hard time getting honest help from rudely abrupt moderators on help websites like stackoverflow? Is it because often when one wants to learn the basics, they are overloaded with the entirety of the documentation and the overwhelming resources of the internet and all its inhabitants? Is it because compiler errors are nonsensically exact, but very rarely helpful? Is it because when you learn it alone, you are bombarded with contradicting messages about what you should be doing and why (and often for the wrong reasons)?

All of these issues definitely occur, and I see them contribute to my students' confusion in my introductory Python class all the time. They try to look on the web for information about how to solve a very basic problem, and they come back to me saying they were told it's more secure to do it this way, or more efficient to do it this way, or that they need to import something called the "heapq module." When really the goal is not to solve the problem in the best way possible or in the shortest amount of code, but to show them how to use the tools they already know about to construct a program that works. Without a guiding mentor it's extremely easy to get lost in the jungle of people who think they know what's best.

As far as I know there is no solution to this problem faced by the solo programming student (or the solo anything student). And so it stands for mathematics: without others doing mathematics with you, its very hard to identify your issues and see how to fix them.

## Proofs, Syntax, and Community

For the programmer who is truly interested in improving their mathematical skills, the first line of attack should now be obvious. Become an expert at applying the basic methods of proof. Second, spend as much time as it takes to clear up what mathematical syntax means before you attempt to interpret the semantics. And finally, find others who are interested in seriously learning some mathematics, and work on exercises (perhaps a weekly set) with them. Start with [something basic like set theory](http://www.amazon.com/Naive-Theory-Undergraduate-Texts-Mathematics/dp/0387900926), and write your own proofs and discuss each others' proofs. Treat the sessions like code review sessions, and be the compiler to your partner's program. Test their arguments to the extreme, and question anything that isn't obvious or trivial. It's not uncommon for easy questions with simple answers and trivial proofs to create long and drawn out discussions before everyone agrees it's obvious. Embrace this and use it to improve.

Short of returning to your childhood and spending more time doing [recreational mathematics](http://www.youtube.com/watch?v=ee2If8jSxUo), that is the best advice I can give.

Until next time!
