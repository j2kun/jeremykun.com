---
author: jeremykun
date: 2011-12-30 21:36:28+00:00
draft: false
title: Row Reduction Over A Field
type: post
url: /2011/12/30/row-reduction-over-a-field/
categories:
- Algorithms
- Group Theory
- Linear Algebra
- Topology
tags:
- mathematics
- programming
- python
- row reduction
---

We're quite eager to get to applications of algebraic topology to things like machine learning (in particular, [persistent homology](http://en.wikipedia.org/wiki/Simplicial_homology#Applications)). Even though there's a massive amount of theory behind it (and we do plan to cover some of the theory), a lot of the actual computations boil down to working with matrices. Of course, this means we're in the land of linear algebra; for a refresher on the terminology, see our [primers](http://jeremykun.wordpress.com/primers/) on linear algebra.

In addition to applications of algebraic topology, our work with matrices in this post will allow us to solve important optimization problems, including [linear programming](http://en.wikipedia.org/wiki/Linear_programming). We will investigate these along the way.


## Matrices Make the World Go Round


Fix two vector spaces $V, W$ of finite dimensions $m,n$ (resp), and fix bases for both spaces. Recall that an $n \times m$ matrix uniquely represents a linear map $V \to W$, and moreover all such linear maps arise this way. Our goal is to write these linear maps in as simple a way as possible, so that we can glean useful information from them.

The data we want from a linear map $f$ are: a basis for the [kernel](http://en.wikipedia.org/wiki/Kernel_(matrix)) of $f$, a basis for the [image](http://en.wikipedia.org/wiki/Image_(matrix)) of $f$, the dimensions of both, and the eigenvalues and eigenvectors of $f$ (which is only defined if in addition $V=W$). As we have already seen, just computing the latter gives us a wealth of information about things like [the internet](http://jeremykun.wordpress.com/2011/06/12/googles-pagerank-introduction/) and [image similarity](http://jeremykun.wordpress.com/2011/07/27/eigenfaces/). In future posts, we will see how the former allows us to infer the shape (topology) of a large data set.

For this article, we will assume our vector spaces lie over the field $\mathbb{R}$, but later we will relax this assumption (indeed, they won't even be vector spaces anymore!). Luckily for us, the particular choice of bases for $V$ and $W$ is irrelevant. The function $f$ is fixed, and the only thing which changes is the matrix _representation_ of $f$ with respect to our choice of bases. If we pick the right bases, then the pieces of information above are quite easy to determine. Rigorously, we say two $n \times m$ matrices $A,B$ are _row equivalent_ if there exists an invertible matrix $M$ with $B = MA$. The reader should determine what the appropriate dimensions of this matrix are (hint: it is square). Moreover, we have the following proposition (stated without proof) which characterizes row equivalent matrices:

**Proposition**: Two matrices are row equivalent if and only if they represent the same linear map $V \to W$ up to a choice of basis for $W$.

The "row" part of row equivalence is rather suggestive. Indeed, it turns out that our desired form $B$ can be achieved by a manipulation of the rows of $A$, which is equivalently the left multiplication by a special matrix $M$.


## Reduced Row Echelon Form, and Elementary Matrices


Before we go on, we should describe the convenient form we want to find. The historical name for it is _reduced row echelon form_, and it imposes a certain form on the rows of a matrix $A$:



	  * its nonzero rows are above all of its zero rows,
	  * the leftmost entry in each nonzero row is 1,
	  * the leftmost entry in a row is strictly to the left of the leftmost entry in the next row, and
	  * the leftmost entry in each nonzero row is the only nonzero entry in its column.



The reduced row echelon form is _canonical_, meaning it is uniquely determined for any matrix (this is not obvious, but for brevity we refer the reader to an [external proof](http://www.cs.berkeley.edu/~wkahan/MathH110/RREF1.pdf)). For example, the following matrix $\mathbb{R}^5 \to \mathbb{R}^3$ has the given reduced row echelon form:




$\begin{pmatrix} 1 & 2 & 3 & 4 & 5 \\ 1 & 2 & 4 & 5 & 6 \\ 0 & 0 & 2 & 1 & 0 \end{pmatrix} \to \begin{pmatrix} 1 & 2 & 0 & 0 & 0 \\ 0 & 0 & 1 & 0 & -1 \\ 0 & 0 & 0 & 1 & 2 \end{pmatrix}$


The entries which contain a 1 and have zeros in the corresponding row and column are called _pivots_, and this name comes from their use in the algorithm below.

Calling this a "form" of the original matrix is again suggestive: a matrix in reduced row echelon form is just a representation with respect to a different basis (in fact, just a different basis for the codomain $W$). To prove this, we will show a matrix is row equivalent to its reduced row echelon form. But before we do that, we should verify that the reduced row echelon form actually gives us the information we want.

For the rightmost matrix above, and assuming we know the correct choice of basis for $W$ is $w_1, \dots, w_k$, we can determine a basis for the image quite easily. Indeed, if the $j$th column contains a single 1 in the $i$th row, then the vector $f(v_j) = w_i$ is in the image of $f$. Moreover, if we do this for each nonzero row (and because each nonzero row has a pivot) we obtain a basis for the whole image of $f$ as a subset of the $w_1 , \dots, w_k$. Indeed, they are linearly independent as they form a basis of $W$, and they span the image of $f$ because each basis vector $w_i$ which was not found in the above way corresponds to a row of all zeros. In other words, it is clear from the entries of the reduced row echelon form matrix that _no _vectors $f(v)$ expand as a linear combination of the unchosen $w_i$.

To put a matrix into reduced row echelon form, we allow ourselves three _elementary row operations_, and give an algorithm describing in what order to perform them. The operations are:



	  * swap the positions of any two rows,
	  * multiply any row by a nonzero constant, and
	  * add a nonzero multiple of one row to another row.

Indeed, we should verify that these operations behave well. We can represent each one by the left multiplication by an appropriate matrix. Swapping the $i$th and $j$th rows corresponds to the identity matrix with the same rows swapped. Multiplying the $i$th row by a constant $c$ corresponds to the identity matrix with $c$ in the $i,i$ entry. And adding $c$ times row $j$ to row $i$ corresponds to the identity matrix with a $c$ in the $i,j$ entry. We call these matrices _elementary matrices_, and any sequence of elementary row operations corresponds to left multiplication by a product of elementary matrices. As we will see by our algorithm below, these row operations are enough to put any matrix (with entries in a field) into reduced row echelon form, hence proving that all matrices are row equivalent to some matrix in reduced row echelon form.

Before we describe this algorithm, we should make one important construction which will be useful in the future. Fixing the dimension $n$ of our elementary matrices we note three things: the identity matrix is an elementary matrix, every elementary matrix is invertible, and the inverse of an elementary matrix is again an elementary matrix. In particular, every product of elementary matrices is invertible (the product of the inverses in reverse order), and so we can describe the group generated by all elementary matrices. We call this group the _general linear group_, denoted $\textup{GL}_n( \mathbb{R})$, and note that it has a very important place in the theory of Lie groups, which is (very roughly) the study of continuous symmetry. It has its name because we note that a matrix is in $\textup{GL}_n(\mathbb{R})$ if and only if its columns are linearly independent (and invertible). This happens precisely when it is row equivalent to the identity matrix. In other words, for any such matrix $A$ there exists a product of elementary matrices $E_1 \dots E_n$ such that $E_1 \dots E_n A = I_n$, and hence $A = E_n^{-1} \dots E_1^{-1}$. So we can phrase the question of whether a matrix is invertible as whether it is in $\textup{GL}_n(\mathbb{R})$, and answer it by finding its reduced row echelon form. So without further ado:


## The Row Reduction Algorithm


Now that we've equipped ourselves with the right tools, let's describe the algorithm which will transform any matrix into reduced row echelon form. We will do it straight in Python, explaining the steps along the way.

    
    def rref(matrix):
       numRows = len(matrix)
       numCols = len(matrix[0])
    
       i,j = 0,0


The first part is straightforward: get the dimensions of the matrix and initialize $i,j$ to 0. $i,j$ represent the current row and column under inspection, respectively. We then start a loop:

    
       while True:
          if i >= numRows or j >= numCols:
             break
    
          if matrix[i][j] == 0:
             nonzeroRow = i
             while nonzeroRow < numRows and matrix[nonzeroRow][j] == 0:
                nonzeroRow += 1
    
          if nonzeroRow == numRows:
             j += 1
             continue


Here we check the base cases: if our indices have exceeded the bounds of our matrix, then we are done. Next, we need to find a pivot and put it in the right place, and essentially we work by induction on the columns. Since we are working over a field, any nonzero element can be a pivot, as we my just divide the entire row by the value of the leftmost entry to get a 1 in the right place. We just need to find a row with a nonzero value, and we prefer to pick the row which has _the_ leftmost nonzero value, and if there are many rows with that property we pick the one in the row with the smallest index. In other words, we fix the leftmost column, try to find a pivot there by scanning downwards, and if we find none, we increment the column index and begin our search again. Once we find it, we may swap the two rows and save the pivot:

    
          temp = matrix[i]
          matrix[i] = matrix[nonzeroRow]
          matrix[nonzeroRow] = temp
    
          pivot = matrix[i][j]
          matrix[i] = [x / pivot for x in matrix[i]]


Once we have found a pivot, we simply need to eliminate the remaining entries in the column. We know this won't affect any previously inspected columns, because by the inductive hypothesis any entries which are to the left of our pivot are zero.

    
          for otherRow in range(0, numRows):
             if otherRow == i:
             continue
             if matrix[otherRow][j] != 0:
                matrix[otherRow] = [y - matrix[otherRow][j]*x
                 for (x,y) in zip(matrix[i], matrix[otherRow])]
    
          i += 1; j+= 1
    
       return matrix


After zeroing out the entries in the $j$th column, we may start to look for the next pivot, and since it can't be in the same column or row, we may restrict our search to the sub-matrix starting at the $i+1, j+1$ entry. Once the while loop has terminated, we have processed all pivots, and we are done.

We encourage the reader to work out a few examples of this on small matrices, and modify our program to print out the matrix at each step of modification to verify the result. As usual, the reader may find [the entire program](https://github.com/j2kun/row-reduction) on [this blog's Github page](https://github.com/j2kun/).

From here, determining the information we want is just a matter of reading the entries of the matrix and presenting it in the desired way. To determine the change of basis for $W$ necessary to write the matrix as desired, one may modify the above algorithm to accept a second square matrix $Q$ whose rows contain the starting basis (usually, the identity matrix for the standard basis vectors), and apply the same elementary row operations to $Q$ as we do to $A$. The reader should try to prove that this does what it should, and we leave any further notes to a discussion in the comments.

Next time, we'll relax the assumption that we're working over a field. This will involve some discussion of rings and $R$-modules, but in the end we will work over very familiar number rings, like the integers $\mathbb{Z}$ and the integers modulo $n$, and our work will be similar to the linear algebra we all know and love.

Until then!
