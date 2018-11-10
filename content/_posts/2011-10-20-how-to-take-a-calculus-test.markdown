---
author: jeremykun
date: 2011-10-20 22:47:32+00:00
draft: false
title: How to Take a Calculus Test
type: post
url: /2011/10/20/how-to-take-a-calculus-test/
categories:
- Teaching
tags:
- calculus
- exams
---

## [![](http://jeremykun.files.wordpress.com/2011/10/shhhhh-quiet-everyone-study-wallpaper.jpg)
](http://jeremykun.files.wordpress.com/2011/10/shhhhh-quiet-everyone-study-wallpaper.jpg)

## A Detailed Reference

As my readers may know, part of my TA duties include teaching a discussion section, and this semester it's Calculus. We're in week 9 now, closing in on the second midterm exam, and frankly put: my students suck at tests. I know they know the material, and they're certainly not any dumber than any other random group of students, but they just can't seem to score well on in-class exams and quizzes.

So today I staged an intervention, called "How to Take a Math Test." In it I provided a list of ten items about test-taking strategies for math, but I like to think of them as an insight into how graders grade for these elementary college courses. A quick Google search for "[how to take a math test](http://www.google.com/search?sourceid=chrome&ie=UTF-8&q=how+to+take+a+math+test)" gives a pitiful list of unhelpful pointers, mostly about how to _study _for a test, and not _what to write down_ on a test to show your knowledge.

What I'm _not _going to cover are the stupid obvious things, like: go to class, do your homework, study, and don't fall asleep during an exam. If you have no idea what's going on in lecture or discussion, then you have much bigger problems than test-taking skills, and you should go read your course textbook before reading this article. Here we care more about the question of what to do when you have no idea how to approach a problem, but know the general techniques for solving other problems.

Here is the complete list, without explanation.

# How to Take a Calculus Test

	  1. Show what you know.
	  2. Don't invent new math.
	  3. Don't contradict yourself.
	  4. Do the easy questions first.
	  5. If you don't know how to do a problem, start by writing down relevant things that you know are true in general.
	  6. Break difficult problems into manageable pieces.
	  7. Know what a function is, and know what things are functions.
	  8. If you aren't taking a derivative, it's probably wrong. (see the explanation below)
	  9. If you're doing obscene amounts of computation, it's probably wrong.
	  10. Don't care about the final answer.

## Point by Point

## 1. Show what you know.

This is really the most important part. As a grader, we start by assuming that a student knows nothing about Calculus, and it's the student's job to prove us wrong. For instance, if you're being quizzed on the derivative of $9^x / 3^x$, and you don't see any nice simplifications, then you should be writing down something like the following:

$\frac{d}{dx} (9^x) = 9^x \ln(9)$
$\frac{d}{dx} (3^x) = 3^x \ln(3)$
$\displaystyle (u / v)' = \frac{u'v - uv'}{v^2}$

Suppose at this point you have a brain aneurysm or mess up horribly on the subsequent algebra, whichever is more frightening. Suppose further that your professor still wants to grade your test. Even though you left the rest blank, or completed it with a boatload of errors, you've pointed out to the grader that you understand how to take the important derivatives, and you know how to piece them together. That accounts for the majority of credit on this problem.

## 2. Don't invent new math.

In other words, use what you know, and _only_ what you know. I had a student make an very creative "simplification":

$\textup{arccot}(xy) = \textup{arccot}(x) \cdot \textup{arccot}(y)$

I know this student has never seen such an identity before, because it's simply false (try, for example, $x = y = 1$). He seemed to be confused with properties of logarithms and properties of trigonometric functions, but in any event he couldn't have been too confident that this was true. The same goes for any identities: if you aren't 100% sure they work, either try plugging in easy numbers to verify they don't work, or just ignore that idea. Not all problems need an algebraic trick before the calculus comes in. At least in a first course on calculus, algebraic "tricks" are usually never _needed_ to solve a problem.

## 3. Don't contradict yourself.

Sometimes this is obvious, and students do it anyway. For instance, on a midterm a very large number of students approached the following problem by plugging in numbers and claiming the conclusion. Here is a mock version of a student's answer.

Use the intermediate value theorem to show that there exists a solution to the equation $\sin(x) = 1-x$ on the interval $[0, \pi]$.

$\sin(0) = 1 - 0 \ \checkmark$
$\sin(\pi) = 1 - \pi \ \checkmark$
So a solution exists.

This answer makes mathematicians cry. If this student knows trigonometry (and they are assumed to know it, as a prerequisite to this class), then they certainly see that they just claimed 0=1! From a grading standpoint, there is nothing in this solution that implies the student has any idea what's going on. He might vaguely remember that he's supposed to plug in the endpoints somewhere, but he didn't even stop to check if what he wrote down made sense.

Here's a subtler example. My students freaked out when they had to find the derivative of $|x|$ on the midterm, so every day in lecture the professor reminded them how to do it. On the next week's quiz, he put the same problem on there, and here's what many students wrote:

$\displaystyle \frac{d}{dx}(|x|) = 1$ if $x \geq 0$,
$\displaystyle \frac{d}{dx}(|x|) = -1$ if $x < 0$,
and it does not exist when $x = 0$.

Here the contradiction is that the student claimed that the derivative both exists and does not exist at $x=0$! Note the "or equal" part of $\geq$ above. If this were a history essay, the analogue would be claiming Richard Nixon was the 37th and 38th president of the United States! It doesn't matter what the correct answer is, because what you wrote is always false.

## 4. Do the easy questions first.

This one should be self-explanatory, but it still causes issues. Pick off the rote derivatives at the beginning of the test, and focus on the word problems later.

## 5. If you don't know how to do a problem, start by writing down relevant things that you know are true in general.

This one is in the same realm as showing what you know, but let me express it in a different way. Suppose you are asked to find the values of $x$ for which the following ridiculous function is increasing and decreasing:

$\displaystyle f(x) = \ln(7^{\sqrt{\arctan(x^{99})}})$

Of course, you've probably just had a heart attack, but if you're still alive you should start by writing down what's true about functions in general:

A differentiable function is increasing when its derivative is positive, and decreasing when its derivative is negative. So we need to find when $f'(x) > 0$, and $f'(x) < 0$.

The hope on the educators part is that this will help you figure out on the spot what to do next. Oh, so we need to take a derivative? How would I start taking the derivative of this massive thing. Well I know the derivative of $\arctan(x)$ is $1/(1+x^2)$, but that's an $x^99$ so there will be a chain rule somewhere... The more little pieces of information you can get across that you know, you'll both get a higher score and closer to a correct solution without scribbling down a bunch of nonsense and hoping the grader doesn't look.

But even with the rest of the problem left blank, this is close to half credit (depending on the grader). In general, half the credit goes to conceptual understanding, and the other half goes to technical ability (your ability to arrive at an answer and do algebra). Usually students know these general facts, but for some reason never write them down on a test. They think that if they can't _use_ it to find the answer, then they can't get any credit for the knowledge. As I've been saying all along, it's quite the opposite.

That being said, if you just write an essay about how to do problems in general and don't even make an attempt at using it to solve the problem at hand, you can't expect _that _much credit.

## 6. Break difficult problems into manageable pieces.

Using the same example above in 5., even if you don't have the stomach to compute the entire derivative (who does, really?) you can still show your knowledge by computing parts. For instance, you might start by writing down the following

$d/dx(x^{99}) = 99x^{98}$
$d/dx(\arctan(x)) = 1/(1+x^2)$
$\displaystyle d/dx(\arctan(x^{99})) = \frac{99x^{98}}{1+(x^{99})^2}$
$\vdots$

With just those three lines, you've shown you know the chain rule, the power rule, and the derivative of inverse tangent. Even if you don't finish, you've got most of the points already.

## 7. Know what a function is, and know what things are functions.

This one is always alarming. I had a student who wrote the following thing:

$\arctan(xy) = \textup{arc}(xy) \cdot \tan(xy)$
$x = y = 1, \textup{ so } \arctan(1 \cdot 1) = \textup{arc}\ 1 \cdot \tan \ 1 = \textup{arc} \cdot \textup{tan}$

It's alarming how often something like this crops up. If this doesn't make you laugh or feel pity or shock (and you're about to take a math test), then you should seriously consider taking a few minutes to figure out why this makes absolutely no sense.

On a finer point, this is the same as what is quite often written below:

$d/dx(\sin) = \cos$

This is nonsensical for just the same reason. Sine and cosine are _functions_, not your average values you can do algebra with. The argument to a function is crucial, and omitting it as above leads down the slippery slope of saying $\arctan = \textup{arc} \cdot \tan$.

## 8. If you aren't taking a derivative, it's probably wrong.

More precisely, if you aren't doing what you're supposed to be tested on, it's probably wrong. On the quiz that inspired this intervention, many of my students took the entire quiz (and got answers!) without taking a single derivative. Tests, and quizzes especially, are mostly meant to be a straightforward verification of your comprehension of the course material. If you don't use the material at all, you're quite likely to fail.

## 9. If you're doing obscene amounts of computation, it's probably wrong.

Tests are designed to be doable and to work out nicely. If you find yourself writing an essay's worth of square-root manipulations and analyzing eight cases, you probably made a mistake in your initial calculations. For my students, it was mixing up inverse trigonometric derivatives.

## 10. Don't care about the final answer.

This might be the hardest for students to swallow, but it's true. Nobody cares about the derivative of some contrived function at $x = 4$. As a grader, I don't even _look_ at the final answer until I've verified your steps are correct, and only then to make sure you didn't forget a negative sign. The truth is that mathematics is about the _argument_, not the answer.

For instance, if you find yourself with no time left and you boiled down your algebra to the alarming expression $1/(1-1)$, don't don't _don't_ just ignore it and call it equal to 0. You will get more partial credit by recognizing that your result is nonsensical and_ saying that_ than you will by ignoring the obvious problem. What you should say is something like:

I recognize that this doesn't make sense, because you can't divide by zero, but I don't have time to fix it. I think mixed up the derivatives of secant and tangent.

Of course, if you have a little extra time, you could continue to write what the derivatives should have been. This shows the grader that you are smart enough to recognize your own mistakes. In fact, if I were grading such a problem, I would go out of my way to give _more_ credit to a student who wrote such an explanation and got no final answer than the student who just wrote 0 or "does not exist."

## A Word About Math Education

A first course in calculus is _not_ interesting mathematics. In fact, I was among those students that abhorred calculus because it was nothing but monotonous repetition. It's an unfortunate truth of education in the United States that students are tortured in this boring, dry way.

The only time in my life I actually enjoyed calculus was when I programmed a video game in high school, in which the characters needed to jump. I modeled their velocity as the derivative of an appropriately constructed parabola. Now that was cool, and it got me inspired enough to seek my math teacher's help when I wanted to [rotate a curve representing a bullet's trajectory to an arbitrary angle](http://en.wikipedia.org/wiki/Rotation_matrix). That's when I started to pay attention to how math can lead to elegant computer programs.

There are a lot of things one can do with these elementary ideas in calculus. Unfortunately, the subject is shoved down our throats before we have an appetite for it. So the advice I have is to be strong, and get through it. At the very least, you'll be smarter for juggling all of these ideas and details in your head.
