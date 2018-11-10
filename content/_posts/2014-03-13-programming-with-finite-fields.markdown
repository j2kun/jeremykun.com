---
author: jeremykun
date: 2014-03-13 15:00:11+00:00
draft: false
title: Programming with Finite Fields
type: post
url: /2014/03/13/programming-with-finite-fields/
categories:
- Algorithms
- Cryptography
- Field Theory
- Number Theory
- Ring Theory
tags:
- classes
- decorators
- division algorithm
- euclidean algorithm
- euclidean domain
- factoring
- field characteristic
- finite fields
- gcd
- operator overloading
- polynomial ring
- python
- randomized algorithm
- typecasting
---

Back when I was first exposed to programming language design, I decided it would be really cool if there were a language that let you define your own number types and then do all your programming within those number types. And since I get excited about math, I think of really exotic number types ([Boolean rings](http://en.wikipedia.org/wiki/Boolean_ring), [Gaussian integers](http://en.wikipedia.org/wiki/Gaussian_integer), [Octonions](http://en.wikipedia.org/wiki/Octonions), oh my!). I imagined it would be a language feature, so I could do something like this:

{{< highlight python >}}
use gaussianintegers as numbers

x = 1 + i
y = 2 - 3i
print(x*y)

z = 2 + 3.5i     # error
{{< /highlight >}}

I'm not sure _why _I thought this would be so cool. Perhaps I felt like I would be teaching a computer math. Or maybe the next level of abstraction in playing god by writing programs is to play god by designing languages (and I secretly satisfy a massive god complex by dictating the actions of my computer).

But despite not writing a language of my own, programming with weird number systems still has a special place in my heart. It just so happens that we're in the middle of a long [series on elliptic curves](http://jeremykun.com/2014/02/08/introducing-elliptic-curves/), and in the next post we'll actually implement elliptic curve arithmetic over a special kind of number type (the [finite field](http://jeremykun.com/2014/02/26/finite-fields-a-primer/)). In this post, we'll lay the groundwork by implementing number types in Python that allow us to work over any finite field. This is actually a pretty convoluted journey, and to be totally rigorous we'd need to prove a bunch of lemmas, develop a bunch of [ring theory](http://jeremykun.com/2013/04/30/rings-a-primer/), and prove the correctness of a few algorithms involving polynomials.

Instead of taking the long and winding road, we'll just state the important facts with links to proofs, prove the easy stuff, and focus more heavily than usual on the particular Python implementation details. As usual, [all of the code](https://github.com/j2kun/finite-fields) used in this post is available on [this blog's Github page](https://github.com/j2kun?tab=repositories).


## Integers Modulo Primes


The simples kind of finite field is the set of integers modulo a prime. We've dealt with this number field extensively on this blog (in [groups](http://jeremykun.com/2012/12/08/groups-a-primer/), [rings](http://jeremykun.com/2013/04/30/rings-a-primer/), [fields](http://jeremykun.com/2014/02/26/finite-fields-a-primer/), with [RSA](http://jeremykun.com/2011/07/29/encryption-rsa/), etc.), but let's recall what it is. The _modulo_ operator $\mod$ (in programming it's often denoted %) is a binary operation on integers such that $x \mod y$ is the unique positive remainder of $x$ when divided by $y$.

**Definition:** Let $p$ be a prime number. The set $\mathbb{Z}/p$ consists of the numbers $\left \{ 0, 1, \dots, p-1 \right \}$. If you endow it with the operations of addition (mod $p$) and multiplication (mod $p$), it forms a [field](http://jeremykun.com/2014/02/26/finite-fields-a-primer/).

To say it's a field is just to say that arithmetic more or less behaves the way we expect it to, and in particular that every nonzero element has a (unique) multiplicative inverse. Making a number type for $\mathbb{Z}/p$ in Python is quite simple.

{{< highlight python >}}
def IntegersModP(p):
   class IntegerModP(FieldElement):
      def __init__(self, n):
         self.n = n % p
         self.field = IntegerModP

      def __add__(self, other): return IntegerModP(self.n + other.n)
      def __sub__(self, other): return IntegerModP(self.n - other.n)
      def __mul__(self, other): return IntegerModP(self.n * other.n)
      def __truediv__(self, other): return self * other.inverse()
      def __div__(self, other): return self * other.inverse()
      def __neg__(self): return IntegerModP(-self.n)
      def __eq__(self, other): return isinstance(other, IntegerModP) and self.n == other.n
      def __abs__(self): return abs(self.n)
      def __str__(self): return str(self.n)
      def __repr__(self): return '%d (mod %d)' % (self.n, self.p)

      def __divmod__(self, divisor):
         q,r = divmod(self.n, divisor.n)
         return (IntegerModP(q), IntegerModP(r))

      def inverse(self):
         ...?

   IntegerModP.p = p
   IntegerModP.__name__ = 'Z/%d' % (p)
   return IntegerModP
{{< /highlight >}}

We've done a couple of things worth note here. First, all of the double-underscore methods are operator overloads, so they are called when one tries to, e.g., add two instances of this class together. We've also implemented a [division algorithm](http://en.wikipedia.org/wiki/Division_algorithm) via __divmod__ which computes a (quotient, remainder) pair for the appropriate division. The built in Python function [divmod](http://docs.python.org/2.7/library/functions.html#divmod) function does this for integers, and we can overload it for a custom type. We'll write a more complicated division algorithm later in this post. Finally, we're dynamically creating our class so that different primes will correspond to different types. We'll come back to why this encapsulation is a good idea later, but it's crucial to make our next few functions reusable and elegant.

Here's an example of the class in use:

{{< highlight python >}}
>>> mod7 = IntegersModP(7)
>>> mod7(3) + mod7(6)
2 (mod 7)
{{< /highlight >}}

The last (undefined) function in the IntegersModP class, the inverse function, is our only mathematical hurdle. Luckily, we can compute inverses in a generic way, using an algorithm called the _extended Euclidean algorithm_. Here's the mathematics.

**Definition:** An element $d$ is called a _greatest common divisor_ (gcd) of $a,b$ if it divides both $a$ and $b$, and for every other $z$ dividing both $a$ and $b$, $z$ divides $d$. For $\mathbb{Z}/p$ gcd's and we denote it as $\gcd(a,b)$. [1]

Note that we called it 'a' greatest common divisor. In general gcd's need not be unique, though for integers one often picks the positive gcd. We'll actually see this cause a tiny programmatic bug later in this post, but let's push on for now.

**Theorem:** For any two integers $a,b \in \mathbb{Z}$ there exist unique $x,y \in \mathbb{Z}$ such that $ax + by = \gcd(a,b)$.

We could beat around the bush and try to prove these things in various ways, but when it comes down to it there's one algorithm of central importance that both computes the gcd and produces the needed linear combination $x,y$. The algorithm is called the Euclidean algorithm. Here is a simple version that just gives the gcd.

{{< highlight python >}}
def gcd(a, b):
   if abs(a) < abs(b):
      return gcd(b, a)

   while abs(b) > 0:
      q,r = divmod(a,b)
      a,b = b,r

   return a
{{< /highlight >}}

This works by the simple observation that $\gcd(a, aq+r) = \gcd(a,r)$ (this is an easy exercise to prove [directly](http://jeremykun.com/2013/02/16/methods-of-proof-direct-implication/)). So the Euclidean algorithm just keeps applying this rule over and over again: take the remainder when dividing the bigger argument by the smaller argument until the remainder becomes zero. Then the $\gcd(x,0) = x$ because everything divides zero.

Now the so-called 'extended' Euclidean algorithm just keeps track of some additional data as it goes (the partial quotients and remainders). Here's the algorithm.

{{< highlight python >}}
def extendedEuclideanAlgorithm(a, b):
   if abs(b) > abs(a):
      (x,y,d) = extendedEuclideanAlgorithm(b, a)
      return (y,x,d)

   if abs(b) == 0:
      return (1, 0, a)

   x1, x2, y1, y2 = 0, 1, 1, 0
   while abs(b) > 0:
      q, r = divmod(a,b)
      x = x2 - q*x1
      y = y2 - q*y1
      a, b, x2, x1, y2, y1 = b, r, x1, x, y1, y

   return (x2, y2, a)
{{< /highlight >}}

Indeed, the reader who hasn't seen this stuff before is encouraged to trace out a run for the numbers 4864, 3458. Their gcd is 38 and the two integers are 32 and -45, respectively.

How does this help us compute inverses? Well, if we want to find the inverse of $a$ modulo $p$, we know that their gcd is 1. So compute the $x,y$ such that $ax + py = 1$, and then reduce both sides mod $p$. You get $ax + 0 = 1 \mod p$, which means that $x \mod p$ is the inverse of $a$. So once we have the extended Euclidean algorithm our inverse function is trivial to write!

{{< highlight python >}}
def inverse(self):
   x,y,d = extendedEuclideanAlgorithm(self.n, self.p)
   return IntegerModP(x)
{{< /highlight >}}

And indeed it works as expected:

{{< highlight python >}}
>>> mod23 = IntegersModP(23)
>>> mod23(7).inverse()
10 (mod 23)
>>> mod23(7).inverse() * mod23(7)
1 (mod 23)
{{< /highlight >}}

Now one very cool thing, and something that makes some basic ring theory worth understanding, is that we can compute the gcd of any number type using the _exact same code_ for the Euclidean algorithm, provided we implement an abs function and a division algorithm. Via a chain of relatively easy-to-prove lemmas, if your number type has enough structure (in particular, if it has a division algorithm that satisfies [some properties](http://en.wikipedia.org/wiki/Euclidean_domain#Definition)), then greatest common divisors are well-defined, and the Euclidean algorithm gives us that special linear combination. And using the same trick above in finite fields, we can use the Euclidean algorithm to compute inverses.

But in order to make things work programmatically we need to be able to deal with the literal ints 0 and 1 in the algorithm. That is, we need to be able to silently typecast integers up to whatever number type we're working with. This makes sense because all rings have 0 and 1, but it requires a bit of scaffolding to implement. In particular, typecasting things sensibly is _really difficult_ if you aren't careful. And the problems are compounded in a language like Python that blatantly ignores types whenever possible. [2]

So let's take a quick break to implement a tiny type system with implicit typecasting.

[1] The reader familiar with our series on [category theory](http://jeremykun.com/2013/05/24/universal-properties/) will recognize this as the _product_ of two integers in a category whose arrows represent divisibility. So by abstract nonsense, this proves that gcd's are unique up to multiplication by a unit in any ring. ↑
[2] In the process of writing the code for this post, I was sorely missing the stronger type systems of Java and Haskell. Never thought I'd say that, but it's true. ↑


## A Tiny Generic Type System


The main driving force behind our type system will be a decorator called @typecheck. We covered decorators toward the end of our [primer on dynamic programming](http://jeremykun.com/2012/01/12/a-spoonful-of-python/), but in short a decorator is a Python syntax shortcut that allows some pre- or post-processing to happen to a function in a reusable way. All you need to do to apply the pre/post-processing is prefix the function definition with the name of the decorator.

Our decorator will be called typecheck, and it will decorate binary operations on our number types. In its basic form, our type checker will work as follows: if the types of the two operands are the same, then the decorator will just pass them on through to the operator. Otherwise, it will try to do some typecasting, and if that fails it will raise exceptions with reckless abandon.

{{< highlight python >}}
def typecheck(f):
   def newF(self, other):
      if type(self) is not type(other):
         try:
            other = self.__class__(other)
         except TypeError:
            message = 'Not able to typecast %s of type %s to type %s in function %s'
            raise TypeError(message % (other, type(other).__name__, type(self).__name__, f.__name__))
         except Exception as e:
            message = 'Type error on arguments %r, %r for functon %s. Reason:%s'
            raise TypeError(message % (self, other, f.__name__, type(other).__name__, type(self).__name__, e))

      return f(self, other)

   return newF
{{< /highlight >}}

So this is great, but there are two issues. The first is that this will only silently typecast if the thing we're casting is on the right-hand side of the expression. In other words, the following will raise an exception complaining that you can't add ints to Mod7 integers.

{{< highlight python >}}
>>> x = IntegersModP(7)(1)
>>> 1 + x
{{< /highlight >}}

What we need are the right-hand versions of all the operator overloads. They are the same as the usual operator overloads, but Python gives preference to the left-hand operator overloads. Anticipating that we will need to rewrite these silly right-hand overloads for every number type, and they'll all be the same, we make two common base classes.

{{< highlight python >}}
class DomainElement(object):
   def __radd__(self, other): return self + other
   def __rsub__(self, other): return -self + other
   def __rmul__(self, other): return self * other

class FieldElement(DomainElement):
   def __truediv__(self, other): return self * other.inverse()
   def __rtruediv__(self, other): return self.inverse() * other
   def __div__(self, other): return self.__truediv__(other)
   def __rdiv__(self, other): return self.__rtruediv__(other)
{{< /highlight >}}

And we can go ahead and make our IntegersModP a subclass of FieldElement. [3]

But now we're wading into very deep waters. In particular, we know ahead of time that our next number type will be for Polynomials (over the integers, or fractions, or $\mathbb{Z}/p$, or whatever). And we'll want to do silent typecasting from _ints and IntegersModP_ to Polynomials! The astute reader will notice the discrepancy. What will happen if I try to do this?

{{< highlight python >}}
>>> MyInteger() + MyPolynomial()
{{< /highlight >}}

Let's take this slowly: by our assumption both MyInteger and MyPolynomial have the __add__ and __radd__ functions defined on them, and each tries to typecast the other the appropriate type. But which is called? According to Python's documentation if the left-hand side has an __add__ function that's called first, and the right-hand sides's __radd__ function is only sought if no __add__ function is found for the left operand.

Well that's a problem, and we'll deal with it in a half awkward and half elegant way. What we'll do is endow our number types with an "operatorPrecedence" constant. And then inside our type checker function we'll see if the right-hand operand is an object of higher precedence. If it is, we return the [global constant](http://docs.python.org/2/library/constants.html) NotImplemented, which Python takes to mean that no __add__ function was found, and it proceeds to look for __radd__. And so with this modification our typechecker is done. [4]

{{< highlight python >}}
def typecheck(f):
   def newF(self, other):
      if (hasattr(other.__class__, 'operatorPrecedence') and
            other.__class__.operatorPrecedence > self.__class__.operatorPrecedence):
         return NotImplemented

      if type(self) is not type(other):
         try:
            other = self.__class__(other)
         except TypeError:
            message = 'Not able to typecast %s of type %s to type %s in function %s'
            raise TypeError(message % (other, type(other).__name__, type(self).__name__, f.__name__))
         except Exception as e:
            message = 'Type error on arguments %r, %r for functon %s. Reason:%s'
            raise TypeError(message % (self, other, f.__name__, type(other).__name__, type(self).__name__, e))

      return f(self, other)

   return newF
{{< /highlight >}}

We add a default operatorPrecedence of 1 to the DomainElement base class. Now this function answers our earlier question of why we want to encapsulate the prime modulus into the IntegersModP class. If this typechecker is really going to be generic, we need to be able to typecast an int by passing the single int argument to the type constructor with no additional information! Indeed, this will be the same pattern for our polynomial class and the finite field class to follow.

Now there is still one subtle problem. If we try to generate _two copies of the same number type_ from our number-type generator (in other words, the following code snippet), we'll get a nasty exception.

{{< highlight python >}}
>>> mod7 = IntegersModP(7)
>>> mod7Copy = IntegersModP(7)
>>> mod7(1) + mod7Copy(2)
... fat error ...
{{< /highlight >}}

The reason for this is that in the type-checker we're using the Python built-in 'is' which checks for _identity, _not semantic equality. To fix this, we simply need to [memoize](http://jeremykun.com/2012/03/22/caching-and-memoization/) the IntegersModP function (and all the other functions we'll use to generate number types) so that there is only ever one copy of a number type in existence at a time.

So enough Python hacking: let's get on with implementing finite fields!

[3] This also compels us to make some slight modifications to the constructor for IntegersModP, but they're not significant enough to display here. Check out [the Github repo](https://github.com/j2kun/finite-fields) if you want to see. ↑
[4] This is truly a hack, and we've considered submitting a feature request to the Python devs. It is conceivably useful for the operator-overloading aficionado. I'd be interested to hear your thoughts in the comments as to whether this is a reasonable feature to add to Python. ↑


## Polynomial Arithmetic


Recall from our [finite field primer](http://jeremykun.com/2014/02/26/finite-fields-a-primer/) that every finite field can be constructed as a quotient of a polynomial ring with coefficients in $\mathbb{Z}/p$ by some prime ideal. We spelled out exactly what this means in fine detail in the primer, so check that out before reading on.

Indeed, to construct a finite field we need to find some irreducible monic polynomial $f$ with coefficients in $\mathbb{Z}/p$, and then the elements of our field will be remainders of arbitrary polynomials when divided by $f$. In order to determine if they're irreducible we'll need to compute a gcd. So let's build a generic polynomial type with a polynomial division algorithm, and hook it into our gcd framework.

We start off in much the same way as with the IntegersModP:

{{< highlight python >}}
# create a polynomial with coefficients in a field; coefficients are in
# increasing order of monomial degree so that, for example, [1,2,3]
# corresponds to 1 + 2x + 3x^2
@memoize
def polynomialsOver(field=fractions.Fraction):

   class Polynomial(DomainElement):
      operatorPrecedence = 2
      factory = lambda L: Polynomial([field(x) for x in L])

      def __init__(self, c):
         if type(c) is Polynomial:
            self.coefficients = c.coefficients
         elif isinstance(c, field):
            self.coefficients = [c]
         elif not hasattr(c, '__iter__') and not hasattr(c, 'iter'):
            self.coefficients = [field(c)]
         else:
            self.coefficients = c

         self.coefficients = strip(self.coefficients, field(0))

      def isZero(self): return self.coefficients == []

      def __repr__(self):
         if self.isZero():
            return '0'

         return ' + '.join(['%s x^%d' % (a,i) if i > 0 else '%s'%a
                              for i,a in enumerate(self.coefficients)])

      def __abs__(self): return len(self.coefficients)
      def __len__(self): return len(self.coefficients)
      def __sub__(self, other): return self + (-other)
      def __iter__(self): return iter(self.coefficients)
      def __neg__(self): return Polynomial([-a for a in self])

      def iter(self): return self.__iter__()
      def leadingCoefficient(self): return self.coefficients[-1]
      def degree(self): return abs(self) - 1

{{< /highlight >}}

All of this code just lays down conventions. A polynomial is a list of coefficients (in increasing order of their monomial degree), the zero polynomial is the empty list of coefficients, and the abs() of a polynomial is one plus its degree. [5] Finally, instead of closing over a prime modulus, as with IntegersModP, we're closing over the field of coefficients. In general you don't have to have polynomials with coefficients in a field, but if they do come from a field then you're guaranteed to get a sensible Euclidean algorithm. In the [formal parlance](http://jeremykun.com/2013/06/01/rings-a-second-primer/), if $k$ is a field then $k[x]$ is a Euclidean domain. And for our goal of defining finite fields, we will always have coefficients from $\mathbb{Z}/p$, so there's no problem.

Now we can define things like addition, multiplication, and equality using our typechecker to silently cast and watch for errors.

{{< highlight python >}}
      @typecheck
      def __eq__(self, other):
         return self.degree() == other.degree() and all([x==y for (x,y) in zip(self, other)])

      @typecheck
      def __add__(self, other):
         newCoefficients = [sum(x) for x in itertools.zip_longest(self, other, fillvalue=self.field(0))]
         return Polynomial(newCoefficients)

      @typecheck
      def __mul__(self, other):
         if self.isZero() or other.isZero():
            return Zero()

         newCoeffs = [self.field(0) for _ in range(len(self) + len(other) - 1)]

         for i,a in enumerate(self):
            for j,b in enumerate(other):
               newCoeffs[i+j] += a*b

         return Polynomial(newCoeffs)
{{< /highlight >}}

Notice that, if the underlying field of coefficients correctly implements the operator overloads, none of this depends on the coefficients. Reusability, baby!

And we can finish off with the division algorithm for polynomials.

{{< highlight python >}}
      @typecheck
      def __divmod__(self, divisor):
         quotient, remainder = Zero(), self
         divisorDeg = divisor.degree()
         divisorLC = divisor.leadingCoefficient()

         while remainder.degree() >= divisorDeg:
            monomialExponent = remainder.degree() - divisorDeg
            monomialZeros = [self.field(0) for _ in range(monomialExponent)]
            monomialDivisor = Polynomial(monomialZeros + [remainder.leadingCoefficient() / divisorLC])

            quotient += monomialDivisor
            remainder -= monomialDivisor * divisor

         return quotient, remainder
{{< /highlight >}}

Indeed, we're doing nothing here but formalizing the grade-school algorithm for doing polynomial long division [6]. And we can finish off the function for generating this class by assigning the field member variable along with a class name. And we give it a higher operator precedence than the underlying field of coefficients so that an isolated coefficient is cast up to a constant polynomial.

{{< highlight python >}}
@memoize
def polynomialsOver(field=fractions.Fraction):

   class Polynomial(DomainElement):
      operatorPrecedence = 2

      [... methods defined above ...]

   def Zero():
      return Polynomial([])

   Polynomial.field = field
   Polynomial.__name__ = '(%s)[x]' % field.__name__
   return Polynomial
{{< /highlight >}}

We provide a modest test suite in the [Github repository for this post](https://github.com/j2kun/finite-fields), but here's a sample test:

{{< highlight python >}}
>>> Mod5 = IntegersModP(5)
>>> Mod11 = IntegersModP(11)
>>> polysOverQ = polynomialsOver(Fraction).factory
>>> polysMod5 = polynomialsOver(Mod5).factory
>>> polysMod11 = polynomialsOver(Mod11).factory
>>> polysOverQ([1,7,49]) / polysOverQ([7])
1/7 + 1 x^1 + 7 x^2
>>> polysMod5([1,7,49]) / polysMod5([7])
3 + 1 x^1 + 2 x^2
>>> polysMod11([1,7,49]) / polysMod11([7])
8 + 1 x^1 + 7 x^2
{{< /highlight >}}

And indeed, the extended Euclidean algorithm works without modification, so we know our typecasting is doing what's expected:

{{< highlight python >}}
>>> p = polynomialsOver(Mod2).factory
>>> f = p([1,0,0,0,1,1,1,0,1,1,1]) # x^10 + x^9 + x^8 + x^6 + x^5 + x^4 + 1
>>> g = p([1,0,1,1,0,1,1,0,0,1])   # x^9 + x^6 + x^5 + x^3 + x^1 + 1
>>> theGcd = p([1,1,0,1]) # x^3 + x + 1
>>> x = p([0,0,0,0,1]) # x^4
>>> y = p([1,1,1,1,1,1]) # x^5 + x^4 + x^3 + x^2 + x + 1
>>> (x,y,theGcd) == extendedEuclideanAlgorithm(f, g)
True
{{< /highlight >}}

[5] The mathematical name for the abs() function that we're using is a _[valuation](http://en.wikipedia.org/wiki/Valuation_(algebra))._ ↑
[6] One day we will talk a lot more about polynomial long division on this blog. You can do a lot of cool algebraic geometry with it, and the ideas there lead you to awesome applications like robot motion planning and automated geometry theorem proving. ↑


## Generating Irreducible Polynomials


Now that we've gotten Polynomials out of the way, we need to be able to generate irreducible polynomials over $\mathbb{Z}/p$ of any degree we want. It might be surprising that irreducible polynomials of any degree exist [7], but in fact we know a lot more.

**Theorem: **The product of all irreducible monic polynomials of degree dividing $m$ is equal to $x^{p^m} - x$.

This is an important theorem, but it takes a little bit more field theory than we have under our belts right now. You could summarize the proof by saying there is a one-to-one correspondence between elements of a field and monic irreducible polynomials, and then you say some things about splitting fields. You can see a more detailed proof outline [here](http://math.stackexchange.com/a/106732/13528), but it assumes you're familiar with the notion of a minimal polynomial. We will probably cover this in a future primer.

But just using the theorem we can get a really nice algorithm for determining if a polynomial $f(x)$ of degree $m$ is irreducible: we just look at its gcd with all the $x^{p^k} - x$ for $k$ smaller than $m$. If all the gcds are constants, then we know it's irreducible, and if even one is a non-constant polynomial then it has to be irreducible. Why's that? Because if you have some nontrivial gcd $d(x) = \gcd(f(x), x^{p^k} - x)$ for $k < m$, then it's a factor of $f(x)$ by definition. And since we know _all_ irreducible monic polynomials are factors of that this collection of polynomials, if the gcd is always 1 then there are no other possible factors to be divisors. (If there is any divisor then there will be a monic irreducible one!) So the candidate polynomial must be irreducible. In fact, with a moment of thought it's clear that we can stop at $k= m/2$, as any factor of large degree will necessarily require corresponding factors of small degree. So the algorithm to check for irreducibility is just this simple loop:

{{< highlight python >}}
def isIrreducible(polynomial, p):
   ZmodP = IntegersModP(p)
   poly = polynomialsOver(ZmodP).factory
   x = poly([0,1])
   powerTerm = x
   isUnit = lambda p: p.degree() == 0

   for _ in range(int(polynomial.degree() / 2)):
      powerTerm = powerTerm.powmod(p, polynomial)
      gcdOverZmodp = gcd(polynomial, powerTerm - x)
      if not isUnit(gcdOverZmodp):
         return False

   return True
{{< /highlight >}}

We're just computing the powers iteratively as $x^p, (x^p)^p = x^{p^2}, \dots, x^{p^j}$ and in each step of the loop subtracting $x$ and computing the relevant gcd. The powmod function is just there so that we can reduce the power mod our irreducible polynomial after each multiplication, keeping the degree of the polynomial small and efficient to work with.

Now _generating_ an irreducible polynomial is a little bit harder than testing for one. With [a lot of hard work](http://math.stackexchange.com/questions/41557/probability-that-a-random-univariate-polynomial-of-degree-n-is-irreducible), however, field theorists discovered that irreducible polynomials are quite common. In fact, if you just generate the coefficients of your degree $n$ monic polynomial at random, the chance that you'll get something irreducible is at least $1/n$. So this suggests an obvious randomized algorithm: keep guessing until you find one.

{{< highlight python >}}
def generateIrreduciblePolynomial(modulus, degree):
   Zp = IntegersModP(modulus)
   Polynomial = polynomialsOver(Zp)

   while True:
      coefficients = [Zp(random.randint(0, modulus-1)) for _ in range(degree)]
      randomMonicPolynomial = Polynomial(coefficients + [Zp(1)])

      if isIrreducible(randomMonicPolynomial, modulus):
         return randomMonicPolynomial
{{< /highlight >}}

Since the probability of getting an irreducible polynomial is close to $1/n$, [we expect to require](http://jeremykun.com/2014/03/03/martingales-and-the-optional-stopping-theorem/) $n$ trials before we find one. Moreover we could give a pretty tight [bound](http://jeremykun.com/2013/04/15/probabilistic-bounds-a-primer/) on how likely it is to deviate from the expected number of trials. So now we can generate some irreducible polynomials!

{{< highlight python >}}
>>> F23 = FiniteField(2,3)
>>> generateIrreduciblePolynomial(23, 3)
21 + 12 x^1 + 11 x^2 + 1 x^3

{{< /highlight >}}

And so now we are well-equipped to generate any finite field we want! It's just a matter of generating the polynomial and taking a modulus after every operation.

{{< highlight python >}}
@memoize
def FiniteField(p, m, polynomialModulus=None):
   Zp = IntegersModP(p)
   if m == 1:
      return Zp

   Polynomial = polynomialsOver(Zp)
   if polynomialModulus is None:
      polynomialModulus = generateIrreduciblePolynomial(modulus=p, degree=m)

   class Fq(FieldElement):
      fieldSize = int(p ** m)
      primeSubfield = Zp
      idealGenerator = polynomialModulus
      operatorPrecedence = 3

      def __init__(self, poly):
         if type(poly) is Fq:
            self.poly = poly.poly
         elif type(poly) is int or type(poly) is Zp:
            self.poly = Polynomial([Zp(poly)])
         elif isinstance(poly, Polynomial):
            self.poly = poly % polynomialModulus
         else:
            self.poly = Polynomial([Zp(x) for x in poly]) % polynomialModulus

         self.field = Fq

      @typecheck
      def __add__(self, other): return Fq(self.poly + other.poly)
      @typecheck
      def __sub__(self, other): return Fq(self.poly - other.poly)
      @typecheck
      def __mul__(self, other): return Fq(self.poly * other.poly)
      @typecheck
      def __eq__(self, other): return isinstance(other, Fq) and self.poly == other.poly

      def __pow__(self, n): return Fq(pow(self.poly, n))
      def __neg__(self): return Fq(-self.poly)
      def __abs__(self): return abs(self.poly)
      def __repr__(self): return repr(self.poly) + ' \u2208 ' + self.__class__.__name__

      @typecheck
      def __divmod__(self, divisor):
         q,r = divmod(self.poly, divisor.poly)
         return (Fq(q), Fq(r))

      def inverse(self):
         if self == Fq(0):
            raise ZeroDivisionError

         x,y,d = extendedEuclideanAlgorithm(self.poly, self.idealGenerator)
         return Fq(x) * Fq(d.coefficients[0].inverse())

   Fq.__name__ = 'F_{%d^%d}' % (p,m)
   return Fq
{{< /highlight >}}

And some examples of using it:

{{< highlight python >}}
>>> F23 = FiniteField(2,3)
>>> x = F23([1,1])
>>> x
1 + 1 x^1 ∈ F_{2^3}
>>> x*x
1 + 0 x^1 + 1 x^2 ∈ F_{2^3}
>>> x**10
0 + 0 x^1 + 1 x^2 ∈ F_{2^3}
>>> 1 / x
0 + 1 x^1 + 1 x^2 ∈ F_{2^3}
>>> x * (1 / x)
1 ∈ F_{2^3}
{{< /highlight >}}
{{< highlight python >}}
>>> k = FiniteField(23, 4)
>>> k.fieldSize
279841
>>> k.idealGenerator
6 + 8 x^1 + 10 x^2 + 10 x^3 + 1 x^4
>>> y
9 + 21 x^1 + 14 x^2 + 12 x^3 ∈ F_{23^4}
>>> y*y
13 + 19 x^1 + 7 x^2 + 14 x^3 ∈ F_{23^4}
>>> y**5 - y
15 + 22 x^1 + 15 x^2 + 5 x^3 ∈ F_{23^4}
{{< /highlight >}}

And that's it! Now we can do arithmetic over any finite field we want.

[7] Especially considering that other wacky things happen like this: $x^4 +1$ is reducible over _every_ finite field! ↑


## Some Words on Efficiency


There are a few things that go without stating about this program, but I'll state them anyway.

The first is that we pay a big efficiency price for being so generic. All the typecasting we're doing isn't cheap, and in general cryptography needs to be efficient. For example, if I try to create a finite field of order $104729^{20}$, it takes about ten to fifteen seconds to complete. This might not seem so bad for a one-time initialization, but it's clear that our representation is somewhat bloated. We would display a graph of the expected time to perform various operations in various finite fields, but this post is already way too long.

In general, the larger and more complicated the polynomial you use to define your finite field, the longer operations will take (since dividing by a complicated polynomial is more expensive than dividing by a simple polynomial). For this reason and a few other reasons, a lot of research has gone into efficiently finding irreducible polynomials with, say, [only three nonzero terms](http://en.wikipedia.org/wiki/Primitive_polynomial_(field_theory)#Primitive_trinomials). Moreover, if we know in advance that we'll only work over fields of characteristic two we can make a whole lot of additional optimizations. Essentially, all of the arithmetic reduces to really fast bitwise operations, and things like exponentiation can easily be implemented in hardware. But it also seems that the expense coming with large field characteristics corresponds to higher security, so some researchers have tried to meet in the middle an get efficient representations of [other field characteristics](http://www.lca.ic.unicamp.br/~jlopez/mc202/ibe3m.pdf).

In any case, the real purpose of our implementation in this post is not for efficiency. We care first and foremost about understanding the mathematics, and to have a concrete object to play with and use in the future for other projects. And we have accomplished just that.

Until next time!
