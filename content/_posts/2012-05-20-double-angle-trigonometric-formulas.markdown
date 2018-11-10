---
author: jeremykun
date: 2012-05-20 04:28:53+00:00
draft: false
title: Double Angle Trigonometric Formulas
type: post
url: /2012/05/19/double-angle-trigonometric-formulas/
categories:
- Linear Algebra
- Proof Gallery
tags:
- double angle identities
- geometric transformations
- mathematics
- matrices
- trigonometry
---

**Problem**: Derive the double angle identities


$\sin(2\theta) = 2\sin(\theta)\cos(\theta)\\ \cos(2\theta) = \cos^2(\theta) - \sin^2(\theta)$




**Solution**: Recall from linear algebra how one rotates a point in the plane. The matrix of rotation (derived by seeing where $(1,0)$ and $(0,1)$ go under a rotation by $\theta$, and writing those coordinates in the columns) is




$A = \begin{pmatrix} \cos(\theta) & -\sin(\theta) \\ \sin(\theta) & \cos(\theta) \end{pmatrix}$




Next, note that to rotate a point twice by $\theta$, we simply multiply the point (as a vector) by $A$ twice. That is, multiply by $A^2$:




$AAv = A^2v$




Computing $A^2$ gives the following matrix:




$A^2 = \begin{pmatrix} \cos^2(\theta) - \sin^2(\theta) & -2\sin(\theta)\cos(\theta) \\ 2\sin(\theta)\cos(\theta) & \cos^2(\theta) - \sin^2(\theta) \end{pmatrix}$




But rotating twice by $\theta$ is the same as rotating once by $2\theta$, so we have the equality:




$\begin{pmatrix} \cos(2\theta) & -\sin(2\theta) \\ \sin(2\theta) & \cos(2\theta) \end{pmatrix} = \begin{pmatrix} \cos^2(\theta) - \sin^2(\theta) & -2\sin(\theta)\cos(\theta) \\ 2\sin(\theta)\cos(\theta) & \cos^2(\theta) - \sin^2(\theta) \end{pmatrix}$




The matrices are equal, so they must be equal entrywise, giving the identities we desire. $\square$




**Discussion**: There are (painful, messy) ways to derive these identities by drawing triangles on the unit circle and cultishly chanting "[soh-cah-toa](http://en.wikipedia.org/wiki/Trigonometry#Mnemonics)." The key idea in this proof that one might study geometric _transformations_, and it is a truly mature viewpoint of mathematics. Specifically, over the last two hundred years the field of mathematics has changed focus from the study of mathematical "things" to the study of transformations of mathematical things. This proof is an elementary example of the power such perspective can provide. If you want to be really high-brow, start asking about transformations of transformations of things, and transformations of _those _transformations, and recurse until you're doing something original.
