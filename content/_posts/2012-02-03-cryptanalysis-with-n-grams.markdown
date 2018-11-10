---
author: jeremykun
date: 2012-02-03 19:52:16+00:00
draft: false
title: Cryptanalysis with N-Grams
type: post
url: /2012/02/03/cryptanalysis-with-n-grams/
categories:
- Algorithms
- Discrete
- Optimization
- Probability Theory
tags:
- cryptanalysis
- linguistics
- mathematics
- natural language data
- ngrams
- programming
- python
- substitution cipher
---

## [![](http://jeremykun.files.wordpress.com/2012/01/cipher_jefferson.jpg)
](http://jeremykun.files.wordpress.com/2012/01/cipher_jefferson.jpg)




_This post is the third post in a series on computing with natural language data sets. For the first two posts, see the relevant section of our [main content page](http://jeremykun.wordpress.com/main-content/)._





## A Childish Bit of Fun


In this post, we focus on the problem of decoding substitution ciphers. First, we'll describe a few techniques humans use to crack ciphers. We'll find these unsatisfactory, and move on to a simplistic algorithm which does a local search on the space of all possible decryptions, where we utilize our word segmentation algorithm from last time to determine the likelihood that a decryption is correct. We will continue this series's trend of working in Python, so that we can reuse our code from previous posts. Finally, we'll experiment by running the code on actual substitution ciphers used in history. And next time, we'll work on improving the search algorithm for speed and accuracy. As usual, [all of the code](https://github.com/j2kun/cryptanalysis-n-grams) used in this blog post is available on [this blog's Github page](https://github.com/j2kun/).

So let's get down to it.

**Definition**: A message which is human readable is called _plaintext_, and an encrypted message is called _ciphertext_.

When I was but a young lad, I enjoyed working through the puzzles in a certain book on long car rides. I wasn't able to find the book on Amazon, but every page was just another famous quote obfuscated by a substitution cipher, and the reader's goal was to decipher the quote by hand. In other words, each puzzle provided the ciphertext, and you had to find the corresponding plaintext. Most people intuitively understand the idea behind a substitution cipher, but we can also define it cleanly with the terminology from our post on [metrics on words](http://jeremykun.wordpress.com/2011/12/19/metrics-on-words/). (If the word "monoid" scares you, skip the mathematical definition and read the example below first.)

**Definition**: Let $\Sigma$ be a fixed alphabet. A _substitution key _is a bijection $f: \Sigma \to \Sigma$. A _substitution cipher_ is the induced monoid homomorphism $\overline{f}$ on $\Sigma^*$, the set of all strings of letters in $\Sigma$.

Then for any plaintext message $w \in \Sigma^*$, the ciphertext is precisely $\overline{f}(w)$, and for any encrypted message $w_{\textup{enc}} \in \Sigma^*$, the corresponding plaintext message is $\overline{f}^{-1}(w_{\textup{enc}})$. Note that $\bar{f}$ is uniquely determined by $f$, so that the problem of deciphering a message reduces to determining the correct key.

To explain this in plain English, the substitution key is a one-way matching-up of letters in the English alphabet. For instance, we might take A to G, B to S, C to Q, etc., but we could have A go to G and G doesn't have to go to A. When encrypting a plaintext message, we just replace each A with a G, each B with an S, and continue until we have counted for every letter in the message. The "bijection" condition above just means that every letter is associated with some other letter, and there is no conflict of association (for instance, we can't have that both A and B are associated with L, because this would yield multiple decryptions of any encryption and vice versa). Finally, the "induced monoid homomorphism" simply means that to encrypt a message, we use the key to encrypt it letter-by-letter. Here is an example:

    
    Plaintext message: holy spumoni batman
    Substitution key (associations are vertical):
                       abcdefghijklmnopqrstuvwxyz
                       nopqrstuvwxyzabcdefghijklm
    
    Ciphertext: ubyl fchzbav ongzna


This particular key has a famous name ([rot13](http://rot13.com/index.php)), because it is simply a rotation of the alphabet by 13 letters. Also, we note that if we call $r$ the substitution cipher induced by this key, then we see $r$ has the very special property that $r = r^{-1}$ or equivalently $r^2 = \textup{id}_{\Sigma^*}$. So applying the encryption method twice actually gives us back the original plaintext message. But of course a rotation cipher is too simplistic; in general a substitution key can match any two letters together to make for a more complex code.

Decoding the substitution ciphers in my childhood puzzle book involved a few tricks, which when combined and applied (more or less at random) likely yielded the right decryption. These included:



	  * Looking at one-letter words, and picking I, A, and occasionally O as the substitution.
	  * Looking at short two letter words and three letter words, and trying words like "to," "an," and "the" in their place. In other words, partially decipher part of the text, and see if using that partial substitution leads to absurd decryptions of other parts of the message.
	  * Looking for doubled-letters, and replacing them with common doubled-letters like "ee," "tt," "ss," "ff," and "ll"
	  * Find the most common letter, and try substituting that with common letters like e, s, t, r, l, or n.

Unfortunately, most of these rely heavily on a few cop outs. First, the text from this puzzle book included punctuation, word spaces, and other distinguishing features of the English language. In real life, ciphers are usually just one fat block of text, or separated into blocks of a fixed width; when decrypted correctly, a human's natural ability at word segmentation makes the message obvious. Second, I knew ahead of time that the plaintext message was a famous quote! I had inside knowledge about the content of the message, and so decryption came more easily. Often encoded message are not full sentences, and often the people doing the encrypting will strip out common words, but still maintain the sensibility of the decoded phrase (e.g. "dropoff midnight joeys bar back door"). Furthermore, the text could deliberately have spelling errors and other types of message adulteration to avoid decryption.

In other words, the messages in the puzzle book were flawless and designed to be easy to solve. We are more interested in designing a solver which maintains quality in the midst of imperfection and trickery.

That being said, the patterns we used as a child give insight into how we might construct an algorithm to decrypt messages. During manual decryption, one would often get very close to the solution and notice that one incorrectly substituted two letters, but that the rest of the message is correct. By twiddling the incorrectly substituted letters, one would arrive at the correct decryption, and pat oneself on the back. This is the key behind the algorithm that follows, in that we will start with a random decryption, and incrementally improve it until we can't do so any more. But before we get there, we need to figure out how to represent our data appropriately.


## Representing a Cipher as a Piece of Data


One easy way to represent a cipher key is much like the example above: simply use a 26-character string of letters like "nopqrstuvwxyzabcdefghijklm" where we assume that the letter 'a' maps to the first character of the string, 'b' to the second, and so on. This representation will benefit us later when we want to make slight adjustments to a key: we can simply swap any two letters in the list, or do permutations of triples of letters.

Now that we have a key, we can design a function that encrypts a message. In Python, we use the nice string methods for character replacement:

{{< highlight python >}}import string

alphabet = "abcdefghijklmnopqrstuvwxyz"
def encrypt(msg, key):
   return msg.translate(string.maketrans(alphabet, key)){{< /highlight >}}

The translate method of a string is very special: it requires a table of translations from _the entire ASCII alphabet_ of 256 characters to operate. To alleviate the pain of setting this up for relatively simple translations, Python provides us with the "maketrans" function, which when given an input and output alphabet, constructs a translation table in which the i-th character of the first argument is translated to the i-th character of the second argument, and leaves everything else unchanged. Note that here we don't include capital letters. The interested reader can see the source code for the minor modifications that fix capitalization; it's not very interesting, so we omit it here.

For example, with the following key we can encrypt some test messages:

    
    >>> key = "qwertyuiopasdfghjklzxcvbnm"
    >>> encrypt("why hello there", key)
    'vin itssg zitkt'


And a decryption function is quite similar:

{{< highlight python >}}def decrypt(msg, key):
   return msg.translate(string.maketrans(key, alphabet)){{< /highlight >}}

See that decrypting the encrypted message above works as expected:

    
    >>> decrypt("vin itssg zitkt", key)
    'why hello there'


Next, we need to be able to "twiddle" a key. Our ultimate algorithm will start with a random key, and improve it incrementally by changing two letters at a time. We can use the same "translate" function again to do so:

{{< highlight python >}}def keySwap(key, a, b):
   return key.translate(string.maketrans(a+b, b+a)){{< /highlight >}}

In other words, if the letter $x$ is mapped to $a$, and $y$ is mapped to $b$, then this function returns a key that maps $x$ to $b$ and $y$ to $a$. So now that we've got a representation for a key, let's figure out how to "make a key better."


## Letter Trigrams


Our general strategy is as follows: start with a random key, and then come up with some sort of way to judge the key based on its decryption. From there, swap pairs of letters in the key to look at keys which are "close by." If any swap is judged to be better than the current key, use that as the new key, and start the process over again. We stop looking for new keys after a certain number of steps, or we get a decryption with a certain level of accuracy.

This algorithm is a common paradigm in optimization. The usual name is "steepest descent" or "steepest ascent," and the analogy is evident. Suppose we want to get to the top of the highest peak in Tibet. We can start from some random place in Tibet, and look around us. If we are standing next to a place that is higher than we are presently, move to that location and repeat. There are obviously some problems with this algorithm: first, we will always get to some peak, but we may not get to the _highest_ peak. To alleviate this, we can run the algorithm from a large number of random starting locations, and compare all of the peaks we arrive at. Certainly, with enough random starting points, we are very likely to find the highest peak (eventually, we will randomly start _on_ the goal itself, or at least very close to it!). Second, if we were to try this algorithm in Illinois, we might never find _any_ hills at all! This would leave us blindly wandering around some corn field, and is clearly a waste of our time. Before we do any work, we should have a good idea that the space we're searching through is more like Tibet than Illinois, and preferably we'd only have one major peak.

Now, our description of "close by" keys is really that. Recalling our first post in the series on [metrics on words](http://jeremykun.wordpress.com/2011/12/19/metrics-on-words/), we want to investigate cleverly-chosen keys which are close to the given key with respect to the Levenshtein metric. Using the analogy, we are looking for which directions are higher in 26 dimensions, so we can't look in all directions for an increase. Instead, we want to know ahead of time which directions are more likely to be higher, and check those directions only. We will see how to do this momentarily.

The difficult part, really, is determining the "value" of a given decryption. The underlying problem is one of the main underlying problem in this whole series: how do we tell if a string of characters is sensible language? On one hand, if we know it's sensible we can segment it. We saw to that [last time](http://jeremykun.wordpress.com/2012/01/15/word-segmentation/). But how do we tell if a string of characters is sensible?

Of course, it's well beyond the scope of this post to give an exact answer to that problem, but it turns out that a reasonable _approximate _answer is within our grasp. As we did in word segmentation by looking at sequences of words, let's look here at sequences of _letters_.

**Definition**: A letter _n-gram_ is a sequence of $n$ letters, i.e. an element of $\Sigma^n$.

Note that with a large corpus of internet text (as we discussed in [word segmentation](http://jeremykun.wordpress.com/2012/01/15/word-segmentation/)), we can compute the counts of triples of letters. Borrowing again from Norvig's page, we have a list of [letter trigrams](http://norvig.com/ngrams/count_3l.txt) and [letter bigrams](http://norvig.com/ngrams/count_2l.txt). All possible 2-grams and 3-grams occur in the files, and here is a sample of the most common and least common from both:

For bigrams:

    
    in	134812613554
    th	133210262170
    er	119214789533
    re	108669181717
    he	106498528786
    ...
    qy	6901470
    zq	6170496
    jx	5682177
    qz	4293975
    jq	2858953


And trigrams:

    
    the	82103550112
    ing	43727954927
    and	43452082914
    ion	39907843075
    tio	32705432538
    ent	31928292897
    ...
    jwq	10340
    jqy	8871
    zqy	8474
    jzq	7180
    zgq	6254


Note that even though we aren't discerning words themselves, a true decryption will definitely contain the common trigrams and bigrams, but if our key is wrong, there are likely (just by randomness) some uncommon trigrams and bigrams in the resulting decryption. Thus, we can take the set of all letter trigrams in a sequence, compute the probability of each trigram occuring at random, and take the product of all of them to get a score for a given decryption.


## Implementation: Steepest Ascent, and Generating Neighbors


The steepest ascent algorithm is pretty much the same for any problem. In pseudo-python, it looks something like:

{{< highlight python >}}def steepestAscent(posn, evaluatePosn, generateNeighbors, numSteps):
   val = evaluatePosn(posn)
   neighbors = generateNeighbors(posn)

   for i in numSteps:
     next = neighbors.next()
     nextVal = evaluatePosn(next)

     if nextVal > val:
        val = nextVal
        posn = next
        neighbors = generateNeighbors(next)

   return posn{{< /highlight >}}

So we need a function which generates neighbors of a given position, and an evaluation function. Before we actually write the real implementation of our steepest ascent algorithm on decryption keys, let's write the evaluation function, and then the function to generate neighboring keys.

First, the evaluate the quality of a decryption, we need a function that extracts all letter trigrams. We can do this in general for letter n-grams:

{{< highlight python >}}def letterNGrams(msg, n):
   return [msg[i:i+n] for i in range(len(msg) - (n-1))]{{< /highlight >}}

Now recall the class we designed in the post on word segmentation that loads the word-count file, and computes probabilities. As it turns out, we can reuse that code to load any file where each line has a word and a count. So with a slight modification and an include, we import the word segmentation algorithm from last time (this is included in our [implementation](https://github.com/j2kun/cryptanalysis-n-grams) on [this blog's Github page](https://github.com/j2kun/). See the file segment.py for the minor changes).

In other words, to load our trigram word file, we simply instantiate the object, and then use the same sort of logarithmic sum as we did for word segmentation:

{{< highlight python >}}trigramLetterProb = OneGramDist('count-3l.txt')
def trigramStringProb(msg):
   return sum(math.log10(trigramLetterProb(trigram))
      for trigram in letterNGrams(msg, 3)){{< /highlight >}}

So our "evaluatePosn" function above will simple be this "trigramStringProb" function. To give an example of this:

    
    >>> trigramStringProb("hellotherefriend")
    -42.62490211229232
    >>> x = [encrypt("hellotherefriend",
                     shuffled(alphabet)) for i in range(20)]
    >>> y = [(z,trigramStringProb(z)) for z in x]
    >>> for (a,b) in y:
    ...     print("%s, %f" % (a,b))
    ...
    zuaayfzuruoriueb, -75.711233
    ejzzfgejljmlsjwk, -90.312349
    ghnnctghshisuhoe, -64.815609
    ikggrzikykfyqkld, -91.449079
    akhhuqakfktfjkdo, -89.589869
    gayynvgarahrpadl, -68.828649
    pottgipoaovakosb, -68.253187
    hozznjhowolwuobx, -81.541286
    ihuusoihnhvnrhyl, -78.413089
    dmqquldmbmcbnmyk, -81.434687
    amvvtwamomkozmfr, -76.938938
    znddfwznunjuhnie, -76.856587
    rxddemrxkxuktxla, -82.547184
    tjddsktjxjoxfjun, -83.725443
    wxbbcdwxjxvjhxsy, -95.146985
    hsvvonhsasgamspc, -66.135361
    inaavdinoneomngl, -59.646548
    tcjjpxtcbcqbkcov, -88.000009
    burrpvbujuajgusk, -75.768519
    fkmmbxfkvkqvyknl, -94.509938


And so we see that for incorrect decryptions, the score is orders of magnitude smaller: they naturally contain many uncommon letter trigrams.

To generate neighboring keys, we also use n-grams, but this time we work with bigrams. The idea is this: take the most uncommon bigram found in the attempted decryption of the message, and fix the key by replacing the bigram with a more common bigram.

We do this quite gradually, in that if we see, say, "xz," we may note that "ez" is more common and just swap x and e in the key. This way we don't just always try to replace all uncommon bigrams with "th" or "in." In code:

{{< highlight python >}}bigramLetterProb = OneGramDist('count-2l.txt')
def neighboringKeys(key, decryptedMsg):
   bigrams = sorted(letterNGrams(decryptedMsg, 2),
                    key=bigramLetterProb)[:30]

   for c1, c2 in bigrams:
      for a in shuffled(alphabet):
         if c1 == c2 and bigramLetterProb(a+a) >
                         bigramLetterProb(c1+c2):
            yield keySwap(key, a, c1)
         else:
            if bigramLetterProb(a+c2) > bigramLetterProb(c1+c2):
               yield keySwap(key, a, c1)
            if bigramLetterProb(c1+a) > bigramLetterProb(c1+c2):
               yield keySwap(key, a, c2)

   while True:
      yield keySwap(key, random.choice(alphabet),
                         random.choice(alphabet)){{< /highlight >}}

First, we create the bigram letter probability lookup table, as with trigrams. To generate the neighboring keys, first we sort all bigrams in the word so that the least common come first, and then we take the first 30 of them. Then we shuffle the alphabet (so as not to bias the beginning of the alphabet) and look for improvements in the key. Note that this function is an iterator. In other words, it doesn't "return" a value in the sense that it halts execution. Instead, it "yields" a value until the caller asks for another (with the "next()" function), and then it returns to the computation it was doing until it reaches another yield. This way, we don't have to generate a huge list of keys ahead of time, and risk the possibility that they are never used. Instead, we cook up new keys on demand, and only compute as many as are needed. Since we will often discover a better key within the first few iterations, this will undoubtedly save us a lot of unnecessary computation. Finally, after exhausting our list of the 30 least common bigrams, we make random swaps, hoping for an improvement.

Notice that this function requires both the key and the decrypted message. This alters our steepest ascent algorithm superficially, because the generateNeighbors function requires two arguments. We also changed all of the variable names to be relevant to this problem.

{{< highlight python >}}def steepestAscent(msg, key, decryptionFitness, numSteps):
   decryption = decrypt(msg, key)
   value = decryptionFitness(decryption)
   neighbors = iter(neighboringKeys(key, decryption))

   for step in range(numSteps):
      nextKey = neighbors.next()
      nextDecryption = decrypt(msg, nextKey)
      nextValue = decryptionFitness(nextDecryption)

      if nextValue > value:
         key, decryption, value = nextKey, nextDecryption, nextValue
         neighbors = iter(neighboringKeys(key, decryption))
         print((decryption, key))

   return decryption
{{< /highlight >}}

Note that we also print out the partial results, so the user can visually see the intermediate key choices. Now the very last step is to actually run the code on some random starting keys, and collect, segment, and display the results:

{{< highlight python >}}def shuffled(s):
   sList = list(s)
   random.shuffle(sList)
   return ''.join(sList)

def preprocessInputMessage(chars):
   return ''.join(re.findall('[a-z]+', chars.lower()))

def crackSubstitution(msg, numSteps = 5000, restarts = 30):
   msg = preprocessInputMessage(msg)
   startingKeys = [shuffled(alphabet) for i in range(restarts)]
   localMaxes = [steepestAscent(msg, key, trigramStringProb, numSteps)
                 for key in startingKeys]

   for x in localMaxes:
      print(segmentWithProb(x))

   prob, words = max(segmentWithProb(decryption) for decryption in localMaxes)
   return ' '.join(words){{< /highlight >}}

We first preprocess the message to ensure everything is lowercase characters (we remove anything else), and then generate a bunch of random starting keys, perform the steepest ascent on those keys, and display the results, along with the most probable, as chosen by word segmentation. Let's see how it performs in the real world.


## The Germans and the Russians: Real Codes Decrypted


Let's try running our code on a test message:

    
    >>> msg = 'ujejvzrqfeygesvsoofsujwigfeestgufvvzgujjejcfwf\
    qfevlgwvswpzsizfnasvvgeswnqfevrpfovfyswnqafigfvqegisogarv\
    zgoflgljlgwvfxgfkvsckaxkvtfikjkoozjpnseafeestgufvvzgujje'
    >>> crackSubstitution(msg)
    [... lots of output ...]
    'dorothy parker it is said once arrived at the door of an
    apartment in which a glittering party was taking place at
    precisely the same moment a beautiful but vacuous showgirl
    arrived at the door'


In addition to being correct, most of the attempts were very close as well, giving the first few letters such decodings as "coroti" or "gorothy". Let's try a harder one. This message was sent by Baron August Schluga, a German spy in WWI ([source](http://books.google.com/books?id=Ew0yhEGzvwUC&pg=PA85&lpg=PA85&dq=August+Schulga&source=bl&ots=WNt8cJ-iqo&sig=z1XnIkeR1yYpyC2MF3ZfQ1DXefs&hl=en&sa=X&ei=a2QnT8bdNaer2AWxgtTfAg&ved=0CCAQ6AEwAA#v=onepage&q=August%20Schulga&f=false)):

    
    >>> msg = 'NKDIFSERLJMIBFKFKDLVNQIBRHLCJUKFTFLKSTENYQNDQNT\
    TEBTTENMQLJFSNOSUMMLQTLCTENCQNKREBTTBRHKLQTELCBQQBSFSKLTMLS\
    SFAINLKBRRLUKTLCJUKFTFLKFKSUCCFRFNKRYXB'
    >>> crackSubstitution(msg)
    [... lots of output ...]
    'english complaining over lack of munitions they regret
    that the promised support of the french attack north of
    arras is not possible on account of munition
    insufficiency wa'


Here's a code sent by [Aldrich Ames](http://en.wikipedia.org/wiki/Aldrich_Ames), the most notorious CIA mole to have ever been caught. It was a portion of a message sent in 1992 that was found on his person when he was arrested:

    
    >>> msg = 'cnlgvqvelhwttailehotweqvpcebtqfjnppedmfmlfcyfsqf\
    spndhqfoeutnpptppctdqnifsqdtwhtnhhlfjolfsdhqfedhegnqtwvnqht\
    nhhlfjwebbitspthdtxqqfoeutyfslfjedefdnifsqgnlngnpcttqedoedf\
    gqfitlxni'
    >>> crackSubstitution(msg)
    ...
    'parch third weez bridge with s pile to mass info fr op you
     to us and to give asses spent about new de add rom ground
     to indicate what de add rom will be used next to give
     your o minion about caracas p eeting in october xab'


This is a bit more disheartening because it's obviously close to correct, but not quite there.   A human can quickly fix the errors, switching p with m, and z and k. That being said, perhaps by slightly increasing the number of steps we could find our way to the right decryption.

Here's another, from the same source above, sent by Confederate General J.E. Johnston during the Siege of Vicksburg, May 25, 1863 during the U.S. Civil War. It was intercepted and then deciphered by Lincoln's three-man team of cryptanalysts:

    
    >>> msg = 'AKMSSROOHDCRDSMCRVRORGDWTHDRPBGRDORWRUUNGFHPGYGQ\
    WTRNTCGYGQPTRDLPTHAHOPKGQPHTGWMDCWTHKHROPTHHDHFYHDNMFIHCWTM\
    PROYGQKEGKHBHBGTDOPGDXM'
    >>> crackSubstitution(msg)
    ...
    'x raff is send in fa division when it po in si will come to \
    you which do you thing the x est route how and where is the \
    enemy encambedwhatisyourkorepepohnstonja'


Again, we are close but not quite there. In fact, this time the decryption even fails to segment the last block, even when there are useful pieces inside it. This is a side-effect of our zealous segmentation model that punishes unknown words exponentially in their length.

Unfortunately, our program seems to fail more often than succeed. Indeed, the algorithm is not all that good. One might hope the following function is usually the identity on any given message, but it rarely is:

    
    def testDecryption(msg):
       crackSubstitution(encrypt(msg, shuffled(alphabet)))


In fact I have yet to see one example of this function returning sensible output for _any_ input.

    
    >>> testDecryption("the quick brown fox jumped over \
    the lazy dog")
    ...
    'the pladjusigbvicklymenizesthefrowniq'
    >>> testDecryption("i love mathematics and computer \
    programming")
    ...
    'of typlasmplasourancutldispedetheallonh'
    >>> testDecryption("the time has come the walrus said to \
    speak of many things of ships and shoes and sealing wax of \
    cabbages and kings of why the sea is boiling hot and whether \
    pigs have wings")
    ...
    'the tive has move the calfwssaidtosreakouvanythingsoushirs\
    andshoesandsealingcaboumappagesandkingsouchytheseaispoiling\
    hotandchethefrigshazecings'


That last one was _close_, but still rather far off. What's more, for random small inputs the function seems to generate sensible output!

    
    >>> testDecryption("slkfhlakjhahlaweirhurv")
    [... some output ...]
    'l some store test and he chi'


Disregarding the fun we could have decrypting random message, we cry, "What gives?!" It seems that there's some sort of measure of entropy that comes into play here, and messages with less entropy have a larger number of interpretations. Here entropy could mean the number of letters used in the message, the number of _distinct_ letters used in the message, or some combination of both.

The last obvious annoyance is that thee program is _really _slow. If we watch the intermediate computations, we note that it will sometimes approach the correct solution, and then stray away. And what's more, the number of steps per run is fixed. Why couldn't it be based on the amount of progress it has made so far, pushing those close solutions a bit further to the correct key, perhaps by spending more time just on those successful decryptions.

Next time, we'll spend our time trying to improve the steepest ascent algorithm. We'll try to make it more quickly abandon crappy starting positions, and squeeze the most out of successful runs. We'll further do some additional processing in our search for neighboring keys, and potentially involve letter 2-, 3-, 4-, and even 5-grams.

But all in all, this worked out pretty well. We often emphasize the deficiencies of our algorithms, but here we have surprisingly many benefits. For one, we actually decoded real-life messages! With this program in hand even as few as twenty years ago, we would have had a valuable tool for uncovering nefarious secrets encoded via substitution.

Even more, by virtue of our data-driven solution, we inherently bolster our algorithm with additional security. It's _stable_, in the sense that minor data corruption (perhaps a typo, or nefarious message obfuscation) is handled well: our segmentation algorithm allows for typos, and a message with one or two typos still had a high letter trigram score in our probabilistic model. Hence we trivially bypass any sort of message obfuscation: if the average human can make sense of the decrypted message, so could our program.

And as with word segmentation, it's extensible: simply by swapping out the data sets and making minor alphabet changes, we can make our program handle encrypted messages in _any language_. This exponentially increases the usefulness of our approach, because data sets are cheap, while sophisticated algorithms are expensive (at least, good ones _can_ be sophisticated).

So look forward to next time when we improve the accuracy and speed of the steepest-ascent algorithm.

Until then!
