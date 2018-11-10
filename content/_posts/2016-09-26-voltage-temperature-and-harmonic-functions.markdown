---
author: samidavies
date: 2016-09-26 16:00:52+00:00
draft: false
title: Voltage, Temperature, and Harmonic Functions
type: post
url: /2016/09/26/voltage-temperature-and-harmonic-functions/
categories:
- General
---

_This is a guest post by my friend and colleague Samantha Davies. Samantha is a math Ph.D student at the University of Washington, and a newly minted math blogger. Go check out her blog, [With High Probability](http://samidavies.wordpress.com)._

If I said "let's talk about temperature and voltage", you might be interested, but few would react the same if instead I suggested an umbrella term: harmonic functions.

Harmonic functions are often introduced as foreign operators that follow a finicky set of rules, when really they're extremely natural phenomena that everyone has seen before. Why the disconnect then? A complex analysis class won't take the time to talk about potential energy storage, and a book on data science won't discuss fluid dynamics. Emphasis is placed on instances of harmonic functions in one setting, instead of looking more broadly at the whole class of functions.

[caption id="attachment_9634" align="aligncenter" width="777"]![Screenshot 2016-09-16 09.24.25.png](https://jeremykun.files.wordpress.com/2016/09/screenshot-2016-09-16-09-24-25.png)
ams.org ©Disney/Pixar[/caption]

Understanding harmonic functions on both discrete and continuous structures leads to a better appreciation of any setting where these functions are found, whether that's [animation](http://www.ams.org/samplings/feature-column/fcarc-harmonic), heat distribution, a network of political leanings, random walks, [certain](https://en.wikipedia.org/wiki/Solenoidal_vector_field) fluid flows, or electrical circuits.

## Harmonic?

_Harmonic_ originated as a descriptor for something that's undergoing [harmonic motion](https://en.wikipedia.org/wiki/Simple_harmonic_motion). If a spring with an attached mass is stretched or compressed, releasing that spring results in the system moving up and down. The mass undergoes harmonic motion until the system returns to its equilibrium. These repetitive movements exhibited by the mass are known as [oscillations](https://en.wikipedia.org/wiki/Oscillation). In physics lingo, a simple harmonic motion is a type of oscillation where the force that restores an object to its equilibrium is directly proportional to the displacement.

[caption id="attachment_3118" align="aligncenter" width="83"]![animated-mass-spring](https://samidavies.files.wordpress.com/2016/08/animated-mass-spring.gif)
Wiki[/caption]

So, take the mass on a spring as an example: there's some restoring force which works to bring the spring back to where it would naturally hang still. The system has more potential energy when it's really stretched out from its equilibrium position, or really smooshed together from its equilibrium position (it's more difficult to pull a spring really far out or push a spring really close together).

Equations representing harmonic motion have solutions which can be written as functions of sine and cosine, and these became known as harmonics.  Higher dimensional parallels of harmonics satisfy a certain partial differential equation called [Laplace's equation](https://en.wikipedia.org/wiki/Laplace%27s_equation). As mathematicians are so skilled at using the same name for way too many things, today any real valued function with continuous second partial derivatives which satisfies Laplace's equation is called a continuous [harmonic function](https://en.wikipedia.org/wiki/Harmonic_function).

$\Delta$ denotes the [Laplace operator](https://en.wikipedia.org/wiki/Laplace_operator), also called the Laplacian. A continuous function $u$ defined on some region $\Omega$ satisfies Laplace's equation when $\Delta u=0$, for all points in $\Omega$. My choice of the word "region" here is technical: being harmonic only makes sense in open, connected, nonempty sets.

The Laplacian is most easily described in terms of Cartesian coordinates, where it's the sum of all $u$'s unmixed second partial derivatives:

$\begin{aligned}
\Delta u(v)=\sum\limits_{i=1}^n \frac{\partial^2 f}{\partial x_i^2}(v).
\end{aligned}$

For example, $u(x,y)=e^x \sin y$ is harmonic on all of $\mathbb{R}^2$ because

$\begin{aligned}
\Delta u(x,y)= \frac{\partial^2 f}{\partial x^2} \left (e^x \sin y\right ) + \frac{\partial^2 f}{\partial y^2} \left (e^x \sin y \right ) =e^x \sin y -e^x \sin y=0.
\end{aligned}$

Ironically, $\cos(x)$ and $\sin(x)$ are not harmonic in any region in $\mathbb{R}$, even though they define harmonic motion. Taking the second derivatives, $\frac{d^2}{dx^2} \cos(x)=-\cos(x)$ and $\frac{d^2}{dx^2} \sin(x)=-\sin(x)$ are only 0 at isolated points. In fact, harmonic functions on $\mathbb{R}$ are exactly the linear functions.

The [discrete Laplace operator](https://en.wikipedia.org/wiki/Discrete_Laplace_operator) is an analogue used on discrete structures like grids or graphs. These structures are all basically a set of vertices, where some pairs of vertices have an edge connecting them. A subset of vertices must be designated as the boundary, where the function has specified values called the boundary condition. The rest of the vertices are called interior.

A function $u$ on a graph assigns a value to each interior vertex, while satisfying the boundary condition. There's also a function $\gamma$ which assigns a value to each edge in a way such that for every vertex, the sum of its outgoing edges' values is 1 (without loss of generality, otherwise normalize arbitrary nonnegative weights). Keep in mind that the edge weight function is not necessarily symmetric, as it's not required that $\gamma(v,w)=\gamma(w,v)$. The discrete Laplacian is still denoted $\Delta$, and the discrete form of Laplace's equation is described by:

$\begin{aligned}
(\Delta u)(v) = \sum\limits_{w \in N(v)} \gamma(v,w)\left( u(v)-u(w)\right)=0,
\end{aligned}$

where $N(v)$, denotes the neighbors of $v$, which are the vertices connected to $v$ by an edge.

Below is an example of a harmonic function $\alpha$ on a grid which has symmetric edge weights. The function value is specified on the black boundary vertices, while the white interior vertices take on values that satisfy the discrete form of Laplace's equation.

[caption id="attachment_9562" align="aligncenter" width="272"]![harmonic-grid](https://jeremykun.files.wordpress.com/2016/09/harmonic-grid.png)
symmetric edge weights \\ function values[/caption]

You can easily check that $\alpha$ is harmonic at the corner vertices, but here's the grosser computation for the 2 most central vertices on the grid (call the left one $v_1$ and the other $v_2$):

$\begin{aligned}
(\Delta \alpha)(v_1) &= \sum\limits_{w \in N(v_1)} \gamma(v_1,w)\left( \alpha(v_1)-\alpha(w)\right)=\frac{1}{4} \left( \frac{24}{55}-0\right)+\frac{1}{4} \left(\frac{24}{55}+4 \right)+\frac{3}{8} \left(\frac{24}{55}-\frac{64}{55}\right)+\frac{1}{8} \left(\frac{24}{55}-8\right )=0,\\
(\Delta \alpha)(v_2) &= \sum\limits_{w \in N(v_2)} \gamma(v_2,w)\left( \alpha(v_2)-\alpha(w)\right)=\frac{1}{8}  \left(\frac{64}{55}-8 \right )+\frac{3}{8} \left(\frac{64}{55}-0\right)+\frac{3}{8} \left(\frac{64}{55}-\frac{24}{55}\right)+\frac{1}{8} \left(\frac{64}{55}-0\right)=0.
\end{aligned}$

## Properties of harmonic functions

The definition of a harmonic function is not enlightening... it's just an equation. But, harmonic functions satisfy an array of properties that are much more helpful in eliciting intuition about their behavior. These properties also make the functions particularly friendly to work with in mathematical contexts.

**Mean value property**

The [mean value property](https://en.wikipedia.org/wiki/Harmonic_function#The_mean_value_property) states that the value of a harmonic function at an interior point is the average of the function's values around the point. Of course, the definition of "average" depends on the setting. For example, in $\mathbb{R}$ harmonic functions are just linear functions. So given any linear function, say $f(x)=3x-2$, the value at a point can be found by averaging values on an interval around it:  $f(1)= \frac14 \int_{-1}^{3} (3x-2)=1$.

In $\mathbb{R}^n$, if $u$ is harmonic in a region Ω which contains a ball centered around $a$, then $u(a)$ is the average of $u$ on the surface of the ball. So in the complex plane, or equivalently $\mathbb{R}^2$, if the circle has radius $r_0$, then for all $0 <r<r_0$:

$\begin{aligned}
u(a)=\frac{1}{2 \pi} \int\limits_{0}^{2 \pi} u(a+re^{i \theta}) d \theta.
\end{aligned}$

In the discrete case, a harmonic function's value on an interior vertex is the average of all the vertex's neighbors' values.  If $u$ is harmonic at interior vertex $v$ then the mean value property states that:

$\begin{aligned}
u(v)=\sum\limits_{w \in N(v)} \gamma(v,w)u(w).
\end{aligned}$

In the picture below, the black vertices are the boundary while the white vertices are interior, and the harmonic function $\alpha$ has been defined on the graph. Here, $\gamma(v,w)=\frac{1}{\deg(v)}$, so this is an example with edge weights that are not necessarily symmetric. For instance, $\gamma(v,w)=\frac14$ while $\gamma(w,v)=\frac13$.

[caption id="attachment_9625" align="aligncenter" width="224"]![redone_pic](https://jeremykun.files.wordpress.com/2016/09/redone_pic.png)
Foundations of Data Science pg 156[/caption]

It's easy to verify $\alpha$ satisfies the mean value property at all interior vertices, but here's the check for $v$:

$\begin{aligned}
\alpha(v)=\sum\limits_{x \in N(v)} \gamma(v,x)\alpha(x)=\frac14 \cdot 5+\frac14 \cdot 5+\frac14 \cdot 5+\frac14 \cdot 1=4.
\end{aligned}$

For the settings considered here, the mean value property is actually equivalent with being harmonic. If $u$ is a continuous function which satisfies the mean value property on a region $\Omega$, then $u$ is harmonic in $\Omega$ _(proof in appendix)_. Any function $\alpha$ on a graph which satisfies the mean value property also satisfies the discrete Laplacian; just rearrange the mean value property to see this.

**Maximum principle**

The mean value property leads directly to the [maximum/ minimum principle](https://en.wikipedia.org/wiki/Maximum_principle) for harmonic functions. This principle says that a nonconstant harmonic function on a closed and bounded region must attain its maximum and minimum on the boundary. It's a consequence that's easy to see for continuous and discrete settings: if a max/min were attained at an interior point, that interior point is also the average of some set of surrounding points. But it's impossible for an average to be strictly greater than or less than all of its surrounding points unless the function is constant.

[caption id="attachment_9534" align="aligncenter" width="481"]![x2y2_and_x2-y2](https://jeremykun.files.wordpress.com/2016/09/x2y2_and_x2-y2.png?w=680)
laussy.org[/caption]

Above are plots of $x^2+y^2$ and $x^2-y^2$ on the set $[-3,3] \times [-3,3]$. $x^2+y^2$ is nowhere harmonic and $x^2-y^2$ is harmonic everywhere, which means that $x^2-y^2$ must satisfy the maximum/ minimum principle but there's no guarantee that $x^2+y^2$ does. Looking at the graph above, $x^2+y^2$  doesn't satisfy the the minimum principle because the minimum of $x^2+y^2$ on the domain is 0, which is achieved at the interior point (0,0). On the same set, the maximum of $x^2-y^2$ is 9, which is achieved at boundary points (3,0) and (-3,0), and the minimum of $x^2-y^2$ is -9, which is achieved at boundary points (0,3) and (0,-3).

**Uniqueness**

If a harmonic function is continuous on the boundary of a closed and bounded set and harmonic in the interior, then the values of the interior are uniquely determined by the values of the boundary. The proof of this is identical for the discrete and continuous case: if $u_1$ and $u_2$ were two such functions described above with the same boundary conditions, then $u_1-u_2$ is harmonic and its boundary values are 0. By the max/min principle, all the interior values are also 0, so $u_1 = u_2$ on the whole set.

**Solution to a Dirichlet problem**

A [Dirichlet problem](https://en.wikipedia.org/wiki/Dirichlet_problem) is the problem of finding a function which solves some partial differential equation through out a region given its values on the region's  boundary. When considering harmonic functions in the discrete or continuous setting, the PDE to be solved is the appropriate form of Laplace's equation.

So, given a region and a set of values to take on the boundary, does there exist a function which takes the designated values on the boundary and is harmonic in the interior of the region? The answer in the continuous setting is yes, so long as the boundary condition is sufficiently smooth. In the discrete setting, it's much more complicated, especially on networks with infinitely many vertices. For most practical instances though, like grids or finite graphs with edge weight function $\gamma(v,w)=\frac{1}{\deg(v)},$ the answer is still yes.

## Examples

I'll go into detail about a harmonic function on a continuous structure, steady state temperature, and on a discrete structure, voltage. These phenomena are already familiar to us, but weaving previous knowledge with a new appreciation for harmonic functions is crucial to understanding how they, and other natural instances of harmonic functions, behave.

**Temperature**

Suppose you have an insulated object, like a wire, plate, or cube, and apply some temperature on its boundary. The temperature on the boundary will affect the temperature of the interior, and eventually these interior temperatures stabilize to some distribution which doesn't change as time continues. This is known as the [steady state temperature distribution](http://mathfaculty.fullerton.edu/mathews/c2003/TemperaturesMod.html).

A temperature function $u$ of spatial variables $x_i$ and time variable $t$, satisfies the heat equation

$\begin{aligned}
\frac{\partial u}{\partial t}-\alpha \Delta u=0,
\end{aligned}$

where $\alpha>0$ is a constant which represents the material's ability to store and conduct thermal energy _(these [modules for complex analysis](http://mathfaculty.fullerton.edu/mathews/c2003/TemperaturesMod.html) have a nice derivation of the heat equation )_. The requirement that the temperature distribution is steady state yields the necessary condition that $\frac{\partial u}{\partial t}=0$ for all $t,x_i$. So, functions solving the heat equation must satisfy $\Delta u=0$, which means they are harmonic.

Intuitively, this is no surprise because any continuous function which satisfies the mean value property is harmonic. Still, temperature is a great example because it creates a familiar visual for a continuous harmonic function. Below is a picture of a steady state temperature distribution on a square metal plate of length $\pi$ millimeters, where the bottom edge has temperature set to $\pi$ ℃ and all other edges are set to 0℃.

[caption id="attachment_9704" align="aligncenter" width="491"]![diffyqs5231x.png](https://jeremykun.files.wordpress.com/2016/09/diffyqs5231x.png)
jirka.org/diffyqs[/caption]

Since in continuous settings the Dirichlet problem always has a unique solution for harmonic functions, there's a unique temperature function which takes the designated values on the boundary and is harmonic in the interior of the region. That function is:

$\begin{aligned}
u(x,y)=\sum\limits_{n=0}^{\infty} \frac{4}{2n+1} \sin((2n+1) x) \left (\frac{\sinh((2n+1)(\pi-y))}{\sinh((2n+1) \pi)} \right ).
\end{aligned}$

([Here's](http://www.jirka.org/diffyqs/htmlver/diffyqsse33.html) the derivation of that equation, but it's too much Diff EQs for here). So the value of $u$ at any point in the interior, like $(1.5,0.5)$, can be calculated:

 $\begin{aligned}
u(1.5,0.5) = \sum\limits_{n=0}^{\infty} \frac{4}{2n+1} \sin((2n+1) 1.5) \left (\frac{\sinh((2n+1)(\pi-0.5))}{\sinh((2n+1) \pi)} \right ) \approx 2.17.
\end{aligned}$℃

**Voltage**

An electrical network can easily be abstracted to a graph. Any point in the network where circuit elements meet is a vertex, and the wires (or other channels) are edges. Each wire has some amount of conductance. As the name suggests, conductance is a measure for how easy it is for electric charge to pass through the wire.

Edges in the graph are assigned nonnegative values representing the wires' conductance relative to the total conductance emanating from the vertex. These values are the edge weights in the graph, and again they're not necessarily symmetric. If $c_{v,w}$ is the conductance of the edge between $v$ and $w$ and $c_v=\sum_{x:N(v)}c_{v,x} $ is the total conductance emanating from $v$ then, $\gamma(v,w)=\frac{c_{v,w}}{c_v}$ while $\gamma(w,v)=\frac{c_{v,w}}{c_w}$.

The ground node in a network is an arbitrary node in the circuit picked to have an electrical potential energy per charge of 0 volts. So, the voltage at a node is the difference in electrical potential energy per charge between that node and the ground node.

The picture below shows an electrical network after the positive and negative terminals of a battery have been attached to two nodes._ _In this network, the conductance for all the wires is the same, so $\gamma(v,w)=\frac{1}{\deg(v)}$ for all edges $(v,w)$. When the positive and negative terminals of a battery are attached to two nodes in a circuit, a flow of electric charge, called current, is created and carried by electrons or ions.

The vertices representing the nodes attached to the battery are the boundary vertices, and here the node with the negative terminal attached to it as the ground node. After the battery is attached, voltage is induced on the rest of the nodes. The voltage taken on by each node minimizes the total energy lost as heat in the system.

[caption id="attachment_3760" align="aligncenter" width="320"]![voltage.jpeg](https://samidavies.files.wordpress.com/2016/08/voltage.jpeg)
source: Simons Foundation[/caption]

The reader can quickly double check that the function is harmonic at all the interior points, or equivalently showing that the mean value property holds. After a couple extra facts about current it's easy to show that the voltage at a node is always the average of its neighbors' voltages, making voltage a harmonic function _(proof in_ _appendix). _

## Wrap it up

At the end of the day, understanding harmonic functions makes you a better scientist (or better animation artist, apparently). If you want to understand phenomena like potential energy, data modeling, fluid flow, etc, then you've got to understand the math that controls it! Check out the appendix for proofs and extra facts that fell somewhere in the intersection of "things I didn't think you'd care about" and "things I felt guilty leaving out".

## Appendix

There are tons of references with more information about discrete harmonic functions, but I'm specifically interesting in those relating random walks and electrical networks. [Here](http://www.cs.cornell.edu/jeh/bookMay2015.pdf) is a book whose 5th chapter presents some introductory material. Also [this](https://www.simonsfoundation.org/mathematics-and-physical-science/network-solutions/), from the Simons Foundation, and [that](https://www.math.ucdavis.edu/~saito/data/discr-harm-anal/benjamini-lovasz-disc-harm.pdf), a paper from Benjamini and Lovász, are sources which dive deeper. The piece from the Simons Foundation further explains the relation between harmonic functions and minimizing the loss of energy in a network, like the voltage example with heat.

Again, [here](http://www.ams.org/samplings/feature-column/fcarc-harmonic) is an article about harmonic functions in animation.

These complex analysis [modules](http://mathfaculty.fullerton.edu/mathews/c2003/ComplexUndergradMod.html), have sections about temperature distribution and fluid flow. They're a pretty good tool for all your complex analysis needs, including some sections on harmonic functions in complex analysis.

**Harmonic** $\Longleftrightarrow$** mean value property**

This is obvious for the discrete case, as the discrete Laplacian can be rewritten to show that the function's value at a point is just the average of its neighbors. Given a continuous function, $u$, which satisfies the mean value property throughout a disk, there exists (by [Poisson's formula](https://en.wikipedia.org/wiki/Dirichlet_problem#Example:_the_unit_disk_in_two_dimensions)) a function, $v$, harmonic in the same disk and equal to $u$ on the boundary. By uniqueness, $u=v$ through out the disk and $u$ is harmonic in the disk. For anyone concerned about a region which isn't a disk, the general fact is that the [Dirichlet problem](https://en.wikipedia.org/wiki/Dirichlet_problem) for harmonic function always has a solution.

**Proof that voltage is a harmonic function**

Voltage satisfies the mean value property and is therefore harmonic. As before $c_{u,v}$ is the conductance of the edge between $u$ and $v$ and $c_u$ is the total conductance emanating from $u$, $c_u =\sum_{x:N(u)}c_{u,x} $. Let $p_{u,v}=\frac{c_{uv,}}{c_u}$ be the edge value on the edge from $u$ to $v$ in the graph.

Let $i_{u,x}$ denote the current flowing through node $u $ to node $x$, $v_{u}$ denote the voltage at node $u$, $c_{u,x}$ denote the conductance of the edge between $u$ and $x$, and $r_{u,x}=\frac{1}{c_{u,x}}$ denote the resistance of the edge between $u$ and $x$. [Ohm's law](https://en.wikipedia.org/wiki/Ohm%27s_law) relates current, resistance, and voltage by stating that

$\begin{aligned}
i_{u,x} = \frac{v_u-v_x}{r_{u,x}}=\left (v_u-v_x \right )c_{u,x}
\end{aligned}$.

[Kirchoff's law](https://en.wikipedia.org/wiki/Kirchhoff%27s_circuit_laws) states that the total current from a node is 0, so for any $u$ in the network

$\begin{aligned}
\sum\limits_{x} i_{u,x}=0.
\end{aligned}$

Now, we're ready to show that voltage is a harmonic function.

$\begin{aligned}
\sum\limits_{x} i_{u,x}=0 \qquad &\Longleftrightarrow \qquad \sum\limits_{x} \left ( v_u-v_x \right ) c_{u,x}=0 \\
\Longleftrightarrow \qquad  \sum\limits_{x}  v_u c_{u,x}= \sum\limits_{x} v_x  c_{u,x} \qquad &\Longleftrightarrow \qquad v_u c_u=\sum\limits_{x} v_x p_{u,x}c_{u}\\
&\Longleftrightarrow \qquad v_u=\sum\limits_{x} v_x p_{u,x}.
\end{aligned}$
