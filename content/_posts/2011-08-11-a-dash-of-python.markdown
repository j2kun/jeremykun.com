---
author: jeremykun
date: 2011-08-11 02:26:55+00:00
draft: false
title: A Dash of Python
type: post
url: /2011/08/10/a-dash-of-python/
categories:
- Primers
- Programming Languages
tags:
- primer
- programming
- python
---

We will orient our dash of Python around the first and simplest problem from [ProjectEuler.net](http://projecteuler.net).


## Installing Python


To get Python on your computer, go to [python's website](http://www.python.org/download/releases/3.2.1/)  and follow the instructions for downloading and installing the interpreter. Most Window's users can simply [click here](http://www.python.org/ftp/python/3.2.1/python-3.2.1.msi) to download an installer, Mac OS 10.6 - 10.7 users can [click here](http://www.python.org/ftp/python/3.2.1/python-3.2.1-macosx10.6.dmg) to get their installer, and linux users can (and should) fend for themselves.

For non-terminal buffs, you can use Python's official text editor, called IDLE, for editing and running Python programs. It comes packaged with the download links above. For terminal junkies, or people wishing to learn the terminal, you can use your favorite terminal editor (nano for beginners, vim or emacs for serious coders) to write the code, then type

    
    $> python source.py


at a command prompt to run the code, which we assume here is called "source.py" and is in the present working directory. To learn more about the Python interpreter, see [the official Python tutorial](http://docs.python.org/tutorial/interpreter.html). On to the puzzle.


![](http://zetcode.com/tutorials/pythontutorial/images/pythonlogo.png)






## Python


**Problem**: Find the sum of all positive multiples of 3 or 5 below 1000.

To spoil the fun and allow the reader to verify correctness, the answer is 233168. Of course, this problem can be solved quite easily by using nice formulas for arithmetic progressions, but for the sake of learning Python we will do it the programmer's way.

The first step in solving this problem is to figure out how we want to represent our data. Like most languages, Python has a _built-in type_ for integers. A built-in type is simply a type of data that is natively supported by a language, be it a number, a character of text, a list of things, or a more abstract type like, say, a shopping cart (not likely, but possible). So one program we might start with is

    
    3+5+6+9


which is also known as the sum of all multiples of 3 or 5 less than 10. This evaluates to 23, and we may pat ourselves on the back for a successful first program! Python understands most simple arithmetic expressions we'd hope to use, and [a complete list](http://www.tutorialspoint.com/python/python_basic_operators.htm) is very googleable.

Unfortunately to type out all such numbers up to 1000 is idiotic. The whole point of a computer is that it does the hard work for us! So we identify a few key goals:



	  * We want a test for "divisible by n"
	  * We want to be able to keep track of those numbers which have the desired divisibility property
	  * We want to apply our test to all numbers less than 1000 in a non-repetitive way

The first is quite easy. Looking at our list of operators, we find the "remainder" operator %. In particular, "a % b", when performed on two integers $a,b$, gives $a \mod b$, the remainder when $a$ is divided by $b$. In particular, if "a % 3" is zero, then $a$ is divisible by 3, and similarly for 5. Again looking at our list of operators, we have an == equality operator (we will see plain old = later for variable assignment) and an "or" boolean or operator. So our test for divisibility by 3 or 5 is simply

    
    x % 3 == 0 or x % 5 == 0


Typing this into the python interpreter (with "x" replaced with an actual number) will evaluate to either "True" or "False", the built-in types for truth and falsity. We will use the result of this test shortly.

Once we find a number that we want to use, we should be able to save it for later. For this we use _variables_. A variable is exactly what it is in mathematics: a placeholder for some value. It differs from mathematics in that the value of the variable is always known at any instant in time. A variable can be named anything you want, as long as it fits with [a few rules](http://docs.python.org/reference/lexical_analysis.html#identifiers). To assign a value to a variable, we use the = operator, and then we may use them later. For example,

    
    x = 33
    x % 3 == 0 or x % 5 == 0


This program evaluates to True, but it brings up one interesting issue. Instead of a single expression, here we have a sequence of expressions on different lines, and as the program executes it keeps track of the contents of all the variables. For now this is a simple idea to swallow, but later we will see that it has a lot of important implications.

Once we can test whether a number is divisible by stuff, we want to do something special when that test results in True. We need a new language form called an "if statement." It is again intuitive, but it has one caveat that is unique to Python. An if statement has the form:

    
    if test1:
       body1
    elif test2:
       body2
    <span style="font-family:'Courier 10 Pitch', Courier, monospace;font-size:x-small;"><span style="line-height:19px;" class="Apple-style-span">... </span></span>elif testK:
       bodyK
    else: 
       bodyElse


The "test#" expressions evaluate to either True or False. The entire block evaluates in logical order: if "test1" evaluates to true, evaluate the sequence of statements in "body1," and ignore the rest; if "test1" evaluates to false, do the same for "test2" and "body2". Continuing in this fashion, if all tests fail, execute the sequence of statements in the "bodyElse" block.

The quirk is that whitespace matters here, and Python will growl at the programmer if he doesn't have consistent spacing. Specifically, the body of any if statement (a sequence of statements in itself) must be indented consistently for each line. Any nested if statements within that must be further indented, and so on. An indentation can be a tab, or a fixed number of spaces. As long as each line in an indented block follows the same indentation rule, it doesn't matter how far the indentation is. We use three spaces from here on. This unambiguously denotes which lines are to be evaluated as the body of an if statement. While it may seem confusing at first, indenting blocks of code will soon become second nature, and it is necessary for rigor.

For instance, the following tricky program was written by a sloppy coder, and it will confuse the Python interpreter (and other coders).

    
    x = 1
    
    if False:
       y = 4
      x = x + 1
    
    x


If one tries to run this code, Python will spit out an error like:

    
    IndentationError: unindent does not match any outer
     indentation level


In other words, Python doesn't know whether the programmer meant to put "x = x + 1" into the body of the if statement or not. Rather than silently resolve the problem by picking one, Python refuses to continue. For beginners, this will save many headaches, and good programmers almost always have consistent indenting rules as a matter of tidiness and style.

Combining variables, our divisibility test, and if statements, we can construct a near-solution to our problem:

    
    theSum = 0
    numberToCheck = 1
    
    if numberToCheck % 3 == 0 or numberToCheck % 5 == 0:
        theSum = theSum + numberToCheck
    
    numberToCheck = 2
    
    if numberToCheck % 3 == 0 or numberToCheck % 5 == 0:
        theSum = theSum + numberToCheck
    
    numberToCheck = 3
    ...


While this works, and we could type this block of code once for each of the 1000 numbers, this again is a colossal waste of our time! Certainly there must be a way to not repeat all this code while searching for divisible numbers. For this we look to _loops_. Loops do exactly what we want: alter a small piece of a block of code that we want to run many times.

The simplest kind of loop is a _while _loop. It has the form:

    
    while testIsTrue:
       body


The while loop is almost self-explanatory: check if the test is true, evaluate the body if it is, repeat. We just need to make sure that the test eventually becomes false when we're done, so that the loop terminates.

Incorporating this into our problem, we have the following program

    
    theSum = 0
    numberToCheck = 1
    
    while numberToCheck < 1000:
       if numberToCheck % 3 == 0 or numberToCheck % 5 == 0:
          theSum = theSum + numberToCheck
    
       numberToCheck = numberToCheck + 1
    
    print(theSum)


Notice that the indentation makes it clear when the nested if body ends, and when the while body itself ends.

We add the extra "print" statement to allow the user to see the result of the computation. The "print" function has quite a lot of detail associated with how to use it, but in its simplest it prints out the value of its argument on a line by itself.

Running this code, we see that we get the correct value, and we applaud ourselves for a great second program.


## Diving Deeper for Lists


While we could end here, we want to give the reader a taste for what else Python can do. For instance, what if we wanted to _do _something with the numbers we found instead of just adding them up? What if we, say, wanted to find the median value or the average value of the numbers? Of course, this has no apparent use, but we still want to know how to do something besides adding.

What we really want to do is save all the numbers for later computation. To do this, we investigate Python's native _list_ type. Here are some examples of explicitly constructed lists:

    
    list1 = []
    list2 = [2,3,4,5]
    list3 = range(1,1000)
    list4 = ['a', 7, "hello!", [1,2,3,4]]


Obviously, Python's _lists_ are comma-separated lists of things enclosed in square brackets. The things inside the list need not be homogeneous, and can even include other lists. Finally, the "range(a,b)" function gives a list with the integers contained in the interval $[a,b)$, where $a,b$ are integers. One must be slightly careful in naming lists, because the "list" token is a reserved keyword in Python. It may not be used to name any variable.

Lists have quite amazing functionality; they are a more powerful sort of built-in type than integers. Specifically, lists have a whole bunch of named operations, which we call _methods_. Instead of invoking these operations with a familiar infix symbol like +, we do so with the _dot operator_, and then the name of the method. For instance, the following program appends the number 5 to the list [1,2,3]:

    
    list1 = [1,2,3]
    list1.append(5)


The "append" method is a native part of all Python lists, and we apply it to its argument with the function notation. In other words, this code might in some other language look like "append(list1, 5)",  but since we recognize that the "list1" object is the "owner" of the append operation (you can only append something to a list), it deserves a special place to the left of the operation name.

Applying this new data type to our original program, we get the following code:

    
    goodNumbers = []
    numberToCheck = 1
    
    while numberToCheck < 1000:
       if numberToCheck % 3 == 0 or numberToCheck % 5 == 0:
          goodNumbers.append(numberToCheck)
    
       numberToCheck = numberToCheck + 1
    
    print(sum(goodNumbers))


The "sum" function is a special function in Python (a method of no object, so we call it _global_) which sums the elements in a list, provided that addition is defined for those objects (if one continues her Python education past this blog entry, she will see such odd uses of the symbol +).

Now, to get back at the values in the list, we use the _index_ operation, which has the syntax:

    
    list1[index]


and returns the element of "list1" at the specified index. In Python, as with most programming languages, lists are indexed from zero, so the first element of a list is "list1[0]". To find the median value of our list of goodNumbers, we could use the following code:

    
    length = len(goodNumbers)
    
    if length % 2 == 0:
       twoMids = (goodNumbers[length/2] + goodNumbers[length/2 - 1])
       median = twoMids / 2.0
    else:
       median = goodNumbers[length/2]
    
    print(median)


The global "len" function gives the length of a number of different objects (lists, strings, etc). A good exercise for the reader is to walk through the above code line by line to understand why it works. Run it on lists of a number of different sizes, not just the results of the Project Euler problem. Better yet, try to break it! Even this simple program has a small bug in it, if we use the appropriate list instead of "goodNumbers". If one finds the bug, he will immediately be prompted with what to do in case such input shows up. Should one warn the user or return some placeholder value? This question is a common one in computer science and software engineering, and companies like Microsoft and Google give it quite a lot of thought.

Finally, one may want to "save" this bit of code for later. As we already implied, we may use this code to find the median of any list of numbers, given the appropriate input. Mathematically, we want to define the "median" function. The idea of a function is a powerful one both in mathematics and in programming, so naturally there is a language form for it:

    
    def functionName(args...):
       body
       return(returnValue)


A few notes: the entire body of a function definition needs to be indented appropriately; the definition of a function must come before the function is ever used; and not every function requires a return statement.

The easiest way to learn functions is to convert our median-finding code into a median function. Here it is:

    
    def median(myList):
       length = len(myList)
       
       if length % 2 == 0:
          twoMids = (myList[length/2] + myList[length/2 - 1])
          medianValue = twoMids / 2.0
       else:
          medianValue = myList[length/2]
    
       return(medianValue)


And now, to use this function, we do what we expect:

    
    print(median([1,2,3,4,5]))
    print(median(range(1,1000)))
    print(median(goodNumbers))


In the same way that we used loops to reuse small bits of code that had slight changes, we here reuse longer bits of code that have more complicated changes! Functions are extremely useful both for readability and extensibility, and we will revisit them again and again in future.

So here we've covered a few basic constructs in Python: numbers, conditional executions with if statements, looping with whiles, the basics of list manipulation, and simple function definition. After this small bit of feet-wetting, the reader should be capable to pick up (and not be bewildered by) a beginner's book on programming in Python. Here are a couple such free online sources:



	  * [Non-Programmer's Guide to Python: WikiBooks](http://en.wikibooks.org/wiki/Non-Programmer%27s_Tutorial_for_Python_3.0)
	  * [A Byte of Python](http://www.swaroopch.com/notes/Python_en:Table_of_Contents)
	  * [Learning to Program - Alan Gauld](http://www.alan-g.me.uk/l2p/index.htm)
	  * [More Sources](http://wiki.python.org/moin/BeginnersGuide/NonProgrammers)

Feel free to ask me any Python questions here, and I'll do my best to answer them. Until next time!
