---
author: jeremykun
date: 2012-03-15 06:01:07+00:00
draft: false
title: Learning Programming — Finger-Painting and Killing Zombies
type: post
url: /2012/03/15/learning-programming-zombies/
categories:
- Teaching
tags:
- calculus
- java
- mathematics
- programming
---

[caption id="attachment_1778" align="aligncenter" width="584"][![](http://jeremykun.files.wordpress.com/2012/03/zmob-chain-gun.png)
](http://jeremykun.files.wordpress.com/2012/03/zmob-chain-gun.png) Zmob, my first (and only) original game.[/caption]

_By the end, the breadth and depth of our collective knowledge was far beyond what anyone could expect from any high school course in any subject. _


## Education Versus Exploration


I'm a lab TA for an introductory Python programming course this semester, and it's been...depressing. I remember my early days of programming, when the possibilities seemed endless and adding new features to my programs was exciting and gratifying, and I brimmed with pride at every detail, and I boasted to my friends of the amazing things I did, and I felt powerful. The world was literally at my fingertips. I could give substance to any idea I cared to entertain and any facet of life I wanted to explore. I had developed an insatiable thirst for programming that has lasted to this very day.

[caption id="attachment_1776" align="alignright" width="218"][![](http://jeremykun.files.wordpress.com/2012/03/spaghetti-baby.jpg?w=218)
](http://jeremykun.files.wordpress.com/2012/03/spaghetti-baby.jpg) My younger self, if programming were more noodley.[/caption]

The ironic thing is that today I look back on the programs I wrote and cringe with unending embarrassment. My old code was the artistic equivalent of a finger-painting made by a kindergartener. Sure, it might look _kind of_ like a horse, but only because the kid has no idea what he's doing. The programs I wrote were bug-ridden, hard to read, poorly organized, and a veritable spaghetti-slop of logic.

But I can't deny how much fun I had, and how much I learned. I will describe all of that in more detail below, but first I'd like to contrast my experience with the students I'm teaching this semester. Their labs are no more than mindlessly shuffling around data, and implementing dry, boring functions like [Horner's method](http://en.wikipedia.org/wiki/Horner_scheme) for evaluating polynomials. And (amazingly) their projects are even less interesting. I think the biggest difference is that my students don't have to actually solve any problems by writing programs. And so their experience is boiled down to following directions and pretending to be a computer in order to follow their own program's logic.

I'm certainly not saying that following directions and simulating a computer in your head aren't important things to be a good programmer. What I'm saying is that my students get no gratification from their work. Their results are just as dry as the problem, and the majority of the joy I see among them is when they finish a problem and don't have to think about it anymore (even if their solution is completely wrong).

The course has other problems with it. For instance, the professor teaches the students C paradigms instead of Python paradigms (I don't think he ever learned the right way to do things in Python), and he confuses them with talk of stack frames and registers and all sorts of irrelevant architectural details. Remember, these students have never programmed before, and some started the course just barely competent with a computer. I didn't know what a stack frame was until I had three years of programming under my belt (two of those years were the early, experimental years).

All of this has gotten me thinking pretty regularly about how I might teach my own course, if I might ever have one. This post will roughly be an outline of how my own computer science education began. I'll distill the most important aspects of it: the things that made me want to keep programming and the things that taught me deep ideas in natural contexts.


## My First Time was with Java


My high school ([Campolindo High](http://www.acalanes.k12.ca.us/campolindo/), in Moraga, CA) was blessed with a computer science course. With my early exposure to computers (at 3 years old, by my parents' accounts), my love of video games, and my basic grasp of HTML, it seemed inevitable that I belonged in the class. In retrospect, it was perhaps the most beneficial course I ever took, followed closely by Honors/AP English, German, and public policy. Not only did it provide me with the aforementioned thirst for programming, but it planted a mathematical seed in my mind that would flourish years later like a giant bean stalk, which I'm still in the process of climbing today.

Right off the bat the course was different. The teacher's name was Mr. Maters, and by the end of the first week we ceased to have lectures. Mr. Maters showed us barely enough to get a simple program running with input and output, and then we were left to our own devices.

There were roughly two options for getting credit. The first was to follow an outline of exercises and small projects from a book on GUI programming in Java. Most students followed these exercises for the first two months or so, and I did at least until I had made a stupid little pizza shop program that let you order pizzas.

The second option was wide open. The students could do whatever they wanted, and Mr. Maters jokingly told us, "At the end of each quarter I'll judge your worth, and if I deem you deserve an A, you'll get an A, but if I deem otherwise... you'll get an F!"

Of course, Mr. Maters was the nicest guy you ever met. He would calmly sit at his computer in the front of the lab, maintaining a help queue of students with questions. He would quietly and calmly listen to a student's question, and then shed some insight into their problem. Mr. Maters would get a better idea of a student's progress by how frequent and how poignant their questions were, and more often than not students who were waiting in the queue would solve their own problems before getting to the front.

Most of the students in the class chose the "wide open" route, and that meant designing games. I'm not talking about _good _games, mind you, I'm talking about games made by high schoolers. I made the ugliest Whack-a-Mole you ever saw, a lifeless AI for a Battleship game, and a video poker game that featured Mr. Maters's face on the back of every card (and replacing the faces of the kings, queens, and jacks). For the last one, I even collaborated with other students who made card games by jointly designing the Maters-themed deck. Collaboration would become a bigger theme the second year I took the course (yes, I took the same course twice), but before we get there, there were some other indispensable features I want to mention.

First, the lab room was set up so that Mr. Maters could remotely control any computer in the room from his desk. The program he used was dubbed the reverent name, "Vision," and the slackers feared its power. Vision allowed Mr. Maters to look at our code while we were asking him questions at the front, and also helped him monitor students' progress. Second, we were allowed a shared drive on the school's network so that we could instantly pass files back and forth between lab computers. This had a few direct learning benefits, like sharing code examples, sprites, and sound files we used in our programs. But more importantly it gave a sense of culture to the class. We occasionally had contests where every student in the class submitted a picture of Maters's face photoshopped into some ridiculous and funny scene (really, MS-Painted into a scene). Recall, this was the early days of internet memes, and naturally we youngsters were at the forefront of it.

Third, we were given "exploration" days every so often, on which we were freed from any obligation to work. We could play games, browse around online, or just sit and talk. More often than not we ended up playing LAN Unreal Tournament, but by the end of my second year I chose to spend those days working on my programs too; my games turned out to be more fun to work on than others were to play.

All of these instilled a sense of relaxation in the course. We weren't being taught to the midterms or the AP exam (although I did take the AP eventually, and I scored quite well considering I didn't study at all for it). We weren't even being told to work on some days. The course was more of a community, and even as we teased Mr. Maters we revered him as a mentor.

As I did, most students who took a first year in the course stuck around for a second year. And that was when the amazing projects started to come.


## Zmob


The second year in the computer science class was all games all the time. Moreover, we started by looking at real-time games, the kinds of side-scrolling platformers we loved to play ourselves (yeah, Super Mario Brothers and Donkey Kong Country). I tried my hand at one, but before long I was lost in figuring out how to make the collisions work. Making the levels and animating the character and making the screen scroll were all challenging but not beyond my reach.

[caption id="attachment_1773" align="aligncenter" width="584"][![](http://jeremykun.files.wordpress.com/2012/03/fox-side-scroller.png)
](http://jeremykun.files.wordpress.com/2012/03/fox-side-scroller.png) One of my early side-scrollers based on the Starfox series.[/caption]

But once I got fed up with getting him to jump on blocks, I found a better project: Zmob (short for Zombie Mob). It was inspired by collaboration. I helped a friend nail down how to draw two circles in a special way: one was large and fixed, and the other was smaller, always touching the first, and the line between their two centers went through the position of the mouse. In other words, the smaller circle represented the "orientation" of the pair of circles, and it was always facing toward the mouse. It was a basic bit of trigonometry, but once I figured out how to do it I decided a top-down zombie shooting game would be fun to work on. So I started to it. Here's the opening screen of an early version (typos and errors are completely preserved):

[caption id="attachment_1768" align="aligncenter" width="584"][![](http://jeremykun.files.wordpress.com/2012/03/zmob-intro.png)
](http://jeremykun.files.wordpress.com/2012/03/zmob-intro.png) The intro screen to Zmob 1.0[/caption]

In the game you control the black circle, and the grey circle is supposed to represent the gun. Zombies (blue circles) are spawned regularly at random positions and they travel at varying speeds directly toward your character. You can run around and if you hold down Shift you can run faster than them for a time. And of course, you shoot them until they die, and the game ends when you die. The number of zombies spawned increases as you go on, and your ammunition is limited (although you can pick up more ammo after you get a certain number of kills) so you will eventually die. To goal is to get a high score.

The game plays more like reverse-shepherding than a shooter, and while it might be hard, I don't think anyone but me would play it for more than ten minutes at a time.

The important part was that I had a lot of ideas, and I needed to figure out how to make those ideas a reality. I wanted the zombies to not be able to overlap each other. I wanted a gun that poisoned zombies and when a poisoned zombie touched a healthy zombie, the healthy one became poisoned. I wanted all sorts of things to happen, and the solutions naturally became language features of Java that I ended up using.

[caption id="attachment_1769" align="aligncenter" width="584"][![](http://jeremykun.files.wordpress.com/2012/03/zmob-poisoned.png)
](http://jeremykun.files.wordpress.com/2012/03/zmob-poisoned.png) The poison gun. White zombies are poisoned, while blue zombies are healthy.[/caption]

For instance, at first I just represented the zombies as circles. There was no information that made any two zombies different, so I could store them as a list of x,y coordinates. Once I wanted to give them a_ _health bar, and give them variable speeds, and poison them, I was forced to design a zombie _class_, so that I could give each zombie an internal state (poisoned or not, fast or slow, etc.). I followed this up by making a player class, an item class, and a bullet class.

And the bullets turned out to be my favorite part. I wanted every bullet on the screen to be updated just by me calling an "update()" function. It turns out this was the equivalent of making a bullet into an _interface_ which each specialized bullet class inherited from. Already I saw the need and elegance behind object oriented programming, something that was totally lost on me when I made those stupid "Shape" interfaces they have you do in basic tutorials. I was solving a problem I actually needed to solve, and an understanding of inheritance was forever branded into my mind.

And the bullet logic was a joy in itself. The first three guns I made were boring: a pistol, a machine gun, and a shotgun. Each sprayed little black circles in the expected way. I wanted to break out and make a cool gun. I called my first idea the wave beam.

[caption id="attachment_1770" align="aligncenter" width="584"][![](http://jeremykun.files.wordpress.com/2012/03/zmob-wave-gun.png)
](http://jeremykun.files.wordpress.com/2012/03/zmob-wave-gun.png) The wave beam: sinusoidal bullets.[/caption]

The idea behind the wave beam is  that the bullets travel along a sinusoidal curve in the direction they were shot. This left me with a huge difficulty, though: how does one rotate a sine wave by an arbitrary angle? I had x and y coordinates for the bullets, but all of the convoluted formulas I randomly tried using sines and cosines and tangents ended up failing miserably. The best I could get was a sort of awkwardly-stretched sideways sine.

After about a week of trying with no success, I finally went to my statistics teacher at the time (whom I still keep in touch with) and I asked him if he knew of any sort of witchcraft mathemagic that would do what I wanted.

After a moment's thought, he pulled out a textbook and showed me a page on rotation matrices. To my seventeen-year-old eyes, the formula was as mysterious as an ancient rune:


![](http://upload.wikimedia.org/wikipedia/en/math/7/5/2/752fd6396a9c9d026f10eccb39ddca15.png)



My particular code ended up looking like:

    
    x += frame*Math.cos(angle) + Math.sin(frame)*Math.sin(angle)
    y += frame*Math.sin(angle) + Math.sin(frame)*Math.cos(angle)


When I ran the code, it worked so perfectly I shouted out loud. After my week of struggle and botched attempts to figure this out, this solution was elegant and beautiful and miraculous. After that, I turned to calculus to make jumping look more natural in my Fox side-scroller. I experimented with other matrix operations like shearing and stretching. By the end of that year, I had a better understanding of a "change of basis" (though I didn't know the words for it) than most of the students I took linear algebra with in college! It was just a different coordinate system for space; there were rotated coordinates, fat and stretchy coordinates, along with skinny and backward coordinates. I tried all sorts of things in search of fun gameplay.

And it wasn't just mathematics that I learned ahead of my time. By the end of the year I had "finished" the game. I designed a chain gun that set off chain reactions when it hit zombies, I had given it a face lift with new graphics for the player and zombies. I even designed a smart tile-layout system to measure the size of the screen and display the background appropriately. I had gotten tired of measuring the sizes by hand, so I wrote a program to measure it for me. That sounds trivial, but it's really the heart of problem solving in computer science.

[![Zmob, with images](http://jeremykun.files.wordpress.com/2012/03/zmob-images.png)
](http://jeremykun.files.wordpress.com/2012/03/zmob-images.png)

The whole class "beta tested" it, i.e., spent a few days of class just playing it to have fun and find bugs. And they found lots of bugs. Overt ones (divide by zero errors making bullets go crazy) and subtler ones (if you time everything right, the zombies can't get close enough to hurt you, and just keep bumping into each other).

One pretty important issue that came up was speed. Once I added images, I decided to use a Java library to rotate the images on every frame so they were pointing in the right direction. Now some people say Java is slow, but this part was _really _slow, especially when it got up to a hundred or more zombies. My solution, it just so happened, was a paradigm in computer science called _caching_. You pre-compute all of the rotations you'll ever need ahead of time, and then store them somewhere. In fact, what I really did was called _lazy-loading_, a slightly more sophisticated technique that involved only storing the computed rotations once they were needed.

And I never learned the name of this technique until I got to a third-year college course in dynamic web programming when we discussed the Hibernate object-relational mapping for databases! Just like with linear algebra, my personalized problems resulted in me reinventing or rediscovering important concepts far earlier than I would have learned them otherwise. I was giving myself a deep understanding of the concepts and what sorts of problems they could solve.  This is distinctly different from the sort of studying that goes on in college: students memorize the name of a concept and what it means, but only the top students get a feel for why it's important and when to use it.


## An Honest Evaluation in Retrospect


I'll admit it, I was more dedicated to my work than the average kid. A small portion of the class was only engaged in the silly stuff. Some students didn't have a goal in mind, or they did but didn't pursue the issue with my kind of vigor. We didn't have access to many good examples outside of our own web browsing and the mediocre quality of the books Mr. Maters had on hand. The choice of Java was perhaps a steep learning curve for some, but I think in the end it did more good than harm.

But on the other hand, those of us that did work well got to explore, and absorb the material at our own pace. We got to struggle with problems we actually wanted to solve, leading to new insights. One of my classmates made a chat client and a networked version of Tron, while others made role-playing games, musical applications, encryption algorithms, painting programs, and much more. By the end, the breadth and depth of our collective knowledge was far beyond what anyone could expect from _any high school course in any subject_. I don't say that lightly; I spent a lot of time analyzing literature and debating contemporary issues and memorizing German vocabulary and fine-tuning essays and doing biology experiments, but programming was different. It was engaging and artistic and technical and logical and_ visceral_. Moreover, it was a skill that makes me marketable. I could drop out of graduate school today and find a comfortable job as a software engineer in any major city and probably in any industry that makes software. That class was truly what set me on the path to where I am today.

And worst of all, it absolutely breaks my heart_ _ to hear my students say "I didn't think programming would be like _this_. I'm just not cut out for it." The best response I can muster is "Don't judge programming by this class. It can be fun, truly."


## What They Need


It's become woefully clear to me that to keep students interested in programming, they need a couple of things:


**1. Instant gratification**


My students spend way too much time confused about their code. They need have some way to make a change and see the effects immediately. They need teaching tools designed by [Bret Victor](http://www.youtube.com/watch?v=PUv66718DII) (skip ahead to 10:30 in the video to see what I mean, but the whole thing is worth watching). And they need to work on visual programs. Drawing programs and games and music. Programs whose effects they can experience in a non-intellectual way, as opposed to checking whether they're computing polynomial derivatives correctly.


**2. Projects that are relevant, or at least fun.**


Just like when I was learning, student need to be able to explore. Let them work on their own projects, and have enough knowledge as a teacher to instruct them when they get stuck (or better yet, brainstorm _with_ them). If everyone having a customized project is out of the question, at least have them work on something relevant. The last two projects in the class I teach were regrettably based on file input/output and matrix sums. Why not let them work on a video game, or a search engine (it might sound complicated, but that's the introductory course over at [udacity](http://www.udacity.com/overview/Course/cs101)), or some drawing/animation, a chat client, solve Sudoku puzzles, or even show them how to get data from Facebook with the Graph API. All of these things can be sufficiently abstracted so that a student at any level can handle it, and each requires the ability to use certain constructs (basic networking for a chat client, matrix work for a sudoku, file I/O in parts of a search engine, etc.). Despite the wealth of interesting things they could have students do, it seems to me that the teachers just don't want to come up with interesting projects, so they just have their students compute matrix sums over and over and over again.


**3. The ability to read others' code.**


This is an integral part of learning. Not only should students be able to write code, but they must be able to read foreign code. They have to be able to look at examples and extract the important parts to use in their own original work. They have to be able to collaborate with their classmates, work on a shared project, and brainstorm new ideas while discussing bugs. They have to be able to _criticize_ code as they might criticize a movie or a restaurant. Students should be very opinionated about software, and they should strive to find the right way to do things, openly lampooning pieces of code that are bloated or disorganized (okay, maybe not too harshly, but they should be mentally aware).

These three things lie at the heart of computer science and software development, and all of the other crap (the stack frames and lazy-loading and linux shells) can wait until students are already hooked and eager to learn more. Moreover, it can wait until they have a _choice_ to pursue the area that requires knowledge of the linux shell or web frameworks or networking security or graphics processing. I learned all of the basics and then some without ever touching a linux terminal or knowing what a bit was. I don't doubt my current students could do the same.

And once students get neck deep in code (after spending a year or two writing spaghetti code programs like I did), they can start to see beauty in the elegant ways one can organize things, and the expressive power one has to write useful programs. In some sense programming is like architecture: a good program has beauty in form and function. That's the time when they should start thinking about systems programming and networking, because that's the time when they can weigh the new paradigms against their own. They can criticize and discuss and innovate, or at least appreciate how nice it is and apply the ideas to whatever zombie-related project they might be working on at the time.

I hold the contention that every computer science curriculum should have multiple courses that function as blank canvases, and they should have one early on in the pipeline (if not for part of the very first course). I think that the reason classes aren't taught this way is the same reason that mathematics education is what it is: teaching things right is _hard work__!_ As sad as it sounds, professors (especially at a research institution) don't have time to design elaborate projects for their students.

And as long as I'm in the business of teaching, I'll work to change that. I'll design courses to be fun, and help my future coworkers who fail to do so. Even in highly structured courses, I'll give students an open-ended project.

So add that onto my wish list as a high school teacher: next to "[Math Soup for the Teenage Soul](http://jeremykun.wordpress.com/2011/06/26/teaching-mathematics-graph-theory/)," a class called "Finger-paint Programming." (or "Programming on a Canvas"? "How to Kill Zombies"? Other suggested titles are welcome in the comments :))
