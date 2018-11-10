---
author: jeremykun
date: 2014-02-08 16:00:14+00:00
draft: false
title: Introducing Elliptic Curves
type: post
url: /2014/02/08/introducing-elliptic-curves/
categories:
- Cryptography
- General
tags:
- cryptography
- elliptic curves
- nsa
- rsa
---

With all the recent revelations of government spying and [backdoors](http://jiggerwit.wordpress.com/2013/09/25/the-nsa-back-door-to-nist/) into cryptographic standards, I am starting to disagree with the argument that you should never roll your own cryptography. Of course there are massive pitfalls and very few people actually need home-brewed cryptography, but history has made it clear that blindly accepting the word of the experts is not an acceptable course of action. What we really need is more understanding of cryptography, and implementing the algorithms yourself is the best way to do that. [1]

For example, the crypto community is [quickly moving away](http://arstechnica.com/security/2013/08/crytpo-experts-issue-a-call-to-arms-to-avert-the-cryptopocalypse/) from the RSA standard ([which we covered in this blog post](http://jeremykun.com/2011/07/29/encryption-rsa/)). Why? It turns out that people are getting just good enough at factoring integers that secure key sizes are getting too big to be efficient. Many experts have been calling for the security industry to switch to Elliptic Curve Cryptography (ECC), because, as we'll see, the problem appears to be more complex and hence achieves higher security with smaller keys. Considering [the known backdoors placed by the NSA into certain ECC standards](http://jiggerwit.wordpress.com/2013/09/25/the-nsa-back-door-to-nist/), elliptic curve cryptography is a hot contemporary issue. If nothing else, understanding elliptic curves allows one to understand the existing backdoor.

I've seen some [elliptic curve primers floating around](http://arstechnica.com/security/2013/10/a-relatively-easy-to-understand-primer-on-elliptic-curve-cryptography/) with all the recent talk of cryptography, but very few of them seem to give an adequate technical description [2], and legible implementations designed to explain ECC algorithms aren't easy to find (I haven't found any).

So in this series of posts we're going to get knee deep in a mess of elliptic curves and write a full implementation. If you want motivation for elliptic curves, or if you want to understand how to implement your own ECC, or you want to understand the nuts and bolts of an existing implementation, or you want to know some of the major open problems in the theory of elliptic curves, this series is for you.

The series will have the following parts:

	  1. [Elliptic curves as elementary equations](http://jeremykun.com/2014/02/10/elliptic-curves-as-elementary-equations/)
	  2. [The algebraic structure of elliptic curves](http://jeremykun.com/2014/02/16/elliptic-curves-as-algebraic-structures/)
	  3. [Points on elliptic curves as Python objects](http://jeremykun.com/2014/02/24/elliptic-curves-as-python-objects/)
	  4. Elliptic curves over finite fields

	    1. [Finite fields primer](http://jeremykun.com/2014/02/26/finite-fields-a-primer/) (just mathematics)
	    2. [Programming with finite fields](http://jeremykun.com/2014/03/13/programming-with-finite-fields/)
	    3. [Back to elliptic curves](http://jeremykun.com/2014/03/19/connecting-elliptic-curves-with-finite-fields-a-reprise/)

	  5. [Diffie-Hellman key exchange](http://jeremykun.com/2014/03/31/elliptic-curve-diffie-hellman/)
	  6. [Shamir-Massey-Omura encryption and Digital Signatures](http://jeremykun.com/2014/04/14/sending-and-authenticating-messages-with-elliptic-curves/)

Along the way we'll survey a host of mathematical topics as needed, including group theory, projective geometry, and the theory of cryptographic security. We won't assume any familiarity with these topics ahead of time, but we do intend to develop some maturity through the post without giving full courses on the side-topics. When appropriate, we'll refer to the relevant parts of the [many primers](http://jeremykun.com/primers/) this blog offers.

A list of the posts in the series (as they are published) can be found on the [Main Content](http://jeremykun.com/main-content/) page. And as usual all programs produced in the making of this series will be available on [this blog's Github page](https://github.com/j2kun).

For anyone looking for deeper mathematical information about elliptic curves (more than just cryptography), you should check out the standard book, [The Arithmetic of Elliptic Curves](http://www.amazon.com/gp/product/0387094938/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=0387094938&linkCode=as2&tag=mathinterpr00-20&linkId=QJKK6IC76V4H4Z63).

[1] Okay, what people usually mean is that you shouldn't _use_ your own cryptography for things that actually matter, but I think a lot of the warnings are interpreted or extended to, "Don't bother implementing cryptographic algorithms, just understand them at a fuzzy high level." I imagine this results in fewer resources for people looking to learn cryptography and the mathematics behind it, and at least it prohibits them from appreciating how much really goes into an industry-strength solution. And this mindset is what made the NSA backdoor so easy: the devil was in the details. ↑
[2] From my heavily biased standpoint as a mathematician. ↑
