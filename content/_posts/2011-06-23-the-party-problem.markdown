---
author: jeremykun
date: 2011-06-23 23:22:22+00:00
draft: false
title: The Party Problem
type: post
url: /2011/06/23/the-party-problem/
categories:
- Proof Gallery
tags:
- mathematics
---

**Problem**: At any party of 1000 people, must there always exist two people at the party who have the same number of friends at the party? For the sake of this problem, one cannot be friends with oneself, and friendship is bidirectional.

**Solution**: This must always happen. Suppose to the contrary, that every person at the party has a different number of friends at the party. The minimum number of friends one could have is 0, while 999 is the maximum. Thus, we have 1000 different numbers to pick from, and 1000 people to assign numbers, where no two people have the same number. So somebody at the party, say Bill, has no friends at the party, while another, say Julie, is friends with everybody. But this means Julie is friends with Bill, which is a contradiction, because Bill has no friends.

The same method obviously works for any party of size $n \geq 2$.
