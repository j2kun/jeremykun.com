---
author: jeremykun
date: 2011-07-13 23:29:14+00:00
draft: false
title: Three Circles and Collinear Centers of Dilation
type: post
url: /2011/07/13/three-circles-and-collinear-centers-of-dilation/
categories:
- Geometry
- Proof Gallery
---

**Problem**: Suppose their are three circles in the plane of distinct radii. For any two of these circles, we may find their _center of dilation_ as the intersection point of their common tangents. For example, in the following picture we mark the three centers of dilation for each pair of circles:

![](http://www.cut-the-knot.org/proofs/threecircles.gif)


We notice that the three centers of dilation are collinear. Show they are always collinear for any three non-intersecting circles of distinct radii.

**Solution**: We augment any such layout of three circles with a three-dimensional construction: atop each circle place a cone with height equal to its radius. For any two circles, there is a line containing the apexes of their corresponding cones. We call this the "apex-line" of the two base circles. Clearly, the apex-line of two circles intersects their center of dilation, because the center of dilation of the two circles is also the center of dilation of the two cones.

Now, let $P$ be the plane containing the apexes of each cone. Then $P$ also contains the apex-lines of each pair of circles, and so $P$ also contains all three centers of dilation. Since $P$ contains some center of dilation, it must intersect the plane containing the base circles, which also contains all three centers of dilation. Since any two planes which intersect do so in a line, and both planes contain all three centers of dilation, we conclude that the centers of dilation are collinear.

This proof is quite inspired. The fact became obvious once we change our point of view from two dimensions to three. Such a "shift of perspective" is a powerful tool, and it is very difficult to determine when it is appropriate and helpful. Nevertheless, mathematics is filled with such beautiful proofs.
