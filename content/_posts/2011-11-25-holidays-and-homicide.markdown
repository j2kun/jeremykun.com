---
author: jeremykun
date: 2011-11-25 22:33:21+00:00
draft: false
title: Holidays and Homicide
type: post
url: /2011/11/25/holidays-and-homicide/
categories:
- Statistics
tags:
- crime
- data visualization
- holidays
- homicide
- mathematics
- programming
- thanksgiving
---

[![](http://jeremykun.files.wordpress.com/2011/11/sherlock.jpg)
](http://patrickmate.blogspot.com/2010/11/423-thanksgiving-murder.html)


## A Study In Data


Just before midnight on Thanksgiving, there was [a murder by gunshot](http://www.suntimes.com/news/9053912-418/suspect-held-in-fatal-shooting-at-uic-medical-center.html) about four blocks from my home. Luckily I was in bed by then, but all of the commotion over the incident got me thinking: is murder disproportionately more common on Thanksgiving? What about Christmas, Valentine's Day, or Saint Patrick's Day?

Of course, with the right data set these are the kinds of questions one can answer! After an arduous Google search for agreeable data sets, I came across this project called the [History of Violence Database](http://cjrc.osu.edu/researchprojects/hvd/) (perhaps the most ominous database name ever!). Unfortunately most of the work in progress there puts the emphasis on _history, _cataloging homicide incidents only earlier than the 1920's.

But one page I came across contained [a complete list of the dates of each known homicide in San Francisco from 1849-2003](http://cjrc.osu.edu/researchprojects/hvd/usa/sanfran/). What's more, it is available in a simple, comma-delimited format. (**To all data compilers everywhere**: this is how data should be transferred! _Don't_ only provide it in Excel, or SPSS, or whatever proprietary software you might use. Text files are universally accessible.)

With a little [sed](http://en.wikipedia.org/wiki/Sed) preprocessing and some [Mathematica magic](http://code.google.com/p/math-intersect-programming/downloads/list), I whipped together this chart of homicide counts by day of the year (click on the image to get a larger view):

[caption id="attachment_1251" align="aligncenter" width="584"][![](http://jeremykun.files.wordpress.com/2011/11/homicides-chart.png)
](http://jeremykun.files.wordpress.com/2011/11/homicides-chart.png) Homicides in San Francsico 1849 - 2003, organized by day of the year.[/caption]

Here the red grid lines mark the highest ten homicide counts, the green grid lines mark the lowest ten, and the blue lines mark specific holidays. Some of the blue and red lines cover the same date, and so in that case the red line is the one displayed. Finally, the horizontal yellow line represents the median homicide count of 19, so one can compare individual dates against the median.

Now it would be a terrible thing to "conclude" something about general human behavior from this particular data set. But I'm going to do it anyway because it's fun, and it lets me make fascinating and controversial observations. Plus, I need interesting tidbits of information to drop at parties with math and statistics students.

Here are my observations:



	  * There is a correlation between some holidays and homicide.
	  * New Year's Day is by far the most violent day of the year, followed by Christmas Day. On the other hand, Christmas _Eve_ is only slightly above average.
	  * The safest days of the year is January 5th. Having no other special recognition, it should be deemed National Peace Day, or at least National Too Pooped from New Year's to Commit Murder Day.
	  * New Year's Day (likely, Morning) is not dangerous because of excessive alcohol consumption alone. If it were, Saint Patrick's Day would surely be similar. Although to be fair, one should compare this with the same statistic for Dublin.
	  * None of the following holidays are significantly more dangerous than the average day: Groundhog Day, Valentine's Day, St. Patrick's Day, April Fool's Day, Cinco de Mayo, my birthday (August 28th), Halloween, Veteran's Day, and New Year's Eve (before midnight).
	  * On the other hand, the days following July 4th are quite vicious, even though July 3rd is very quiet.
	  * The days near November 24th are particularly violent because Thanksgiving (and Black Friday?) often fall on those days. Family gatherings are _clearly_ high-risk events.
	  * Last-minute Christmas shopping (Dec. 13th, 15th) obviously brings out the rage in everyone.
	  * March and October are the docile months, while January, June, July, and December are the worst. Murder happens more often in the usual vacation months than at other times of the year.

Of course, some of the above points are meant to be facetious, but they bring up some interesting questions. Why does homicide show up more often during certain months of the year? It's well known that [most murder victims are personal acquaintances](http://news.google.com/newspapers?nid=1314&dat=19940711&id=Uz8xAAAAIBAJ&sjid=cAoEAAAAIBAJ&pg=5650,10456) of the assailant (specifically, friends and family members); does this mean that family time rejuvenates or fuels strife? Are people more stressed during these times of year? Are June and July more violent simply because [heat aggravates people](http://www.guardian.co.uk/environment/2001/may/30/g2.weather), or at least gets them to interact with others more?

Unfortunately these aren't the kinds of questions that lend themselves to mathematical proof, and as such I can't give a definitive answer. But feel free to voice your own opinion in the comments!

For your viewing pleasure, here are the homicide counts on each day for the top and bottom 67 days, respectively, in ascending order:

    
    highest:
    {{"04/05", 24}, {"04/19", 24}, {"05/15", 24}, {"05/24", 24},
     {"05/25", 24}, {"06/28", 24}, {"08/05", 24}, {"08/17", 24},
     {"09/01", 24}, {"09/03", 24}, {"09/19", 24}, {"09/20", 24},
     {"10/26", 24}, {"11/02", 24}, {"11/23", 24}, {"02/01", 25},
     {"02/08", 25}, {"02/11", 25}, {"02/15", 25}, {"04/21", 25}, 
     {"05/07", 25}, {"06/04", 25}, {"06/07", 25}, {"07/24", 25},
     {"08/01", 25}, {"08/25", 25}, {"09/07", 25}, {"10/21", 25},
     {"10/23", 25}, {"11/03", 25}, {"11/10", 25}, {"11/27", 25},
     {"01/06", 26}, {"01/18", 26}, {"03/01", 26}, {"03/24", 26},
     {"05/30", 26}, {"07/04", 26}, {"07/29", 26}, {"08/09", 26},
     {"09/21", 26}, {"11/09", 26}, {"11/25", 26}, {"12/06", 26},
     {"05/02", 27}, {"09/06", 27}, {"09/24", 27}, {"10/11", 27},
     {"11/08", 27}, {"12/12", 27}, {"12/20", 27}, {"07/18", 28},
     {"09/04", 28}, {"12/02", 28}, {"05/18", 29}, {"07/01", 29},
     {"07/07", 29}, {"10/27", 29}, {"11/24", 29}, {"01/28", 30},
     {"01/24", 31}, {"07/05", 31}, {"08/02", 31}, {"12/15", 31},
     {"12/13", 32}, {"12/25", 36}, {"01/01", 43}}
    lowest:
    {{"01/05", 6}, {"02/29", 6}, {"06/20", 7}, {"07/03", 7},
     {"04/15", 8}, {"02/03", 9}, {"02/10", 9}, {"09/16", 9},
     {"03/04", 10}, {"05/16", 10}, {"09/29", 10}, {"10/12", 10},
     {"12/16", 10}, {"02/04", 11}, {"05/17", 11}, {"05/23", 11},
     {"06/06", 11}, {"06/12", 11}, {"07/11", 11}, {"09/22", 11},
     {"11/12", 11}, {"11/16", 11}, {"12/19", 11}, {"03/13", 12},
     {"03/20", 12}, {"05/21", 12}, {"05/29", 12}, {"07/14", 12},
     {"08/13", 12}, {"09/05", 12}, {"10/28", 12}, {"11/22", 12},
     {"01/19", 13}, {"02/06", 13}, {"02/09", 13}, {"04/22", 13},
     {"04/28", 13}, {"05/04", 13}, {"05/11", 13}, {"08/27", 13},
     {"09/15", 13}, {"10/03", 13}, {"10/13", 13}, {"12/03", 13},
     {"01/10", 14}, {"01/26", 14}, {"01/31", 14}, {"02/13", 14},
     {"02/18", 14}, {"02/23", 14}, {"03/14", 14}, {"03/15", 14},
     {"03/26", 14}, {"03/31", 14}, {"04/11", 14}, {"05/12", 14},
     {"05/28", 14}, {"06/19", 14}, {"06/24", 14}, {"07/20", 14},
     {"07/31", 14}, {"08/10", 14}, {"10/22", 14}, {"12/22", 14},
     {"01/07", 15}, {"01/14", 15}, {"01/16", 15}}


Unfortunately many holidays are defined year by year. Thanksgiving, Easter, Mother's Day, Father's Day, MLK Jr. Day, Memorial Day, and the Chinese New Year all can't be analyzed with this chart because they fall on different days each year. It would not be very difficult to organize this data set according to the rules of those special holidays. We leave it as an exercise to the reader to do so. Remember that [the data and Mathematica notebook](https://github.com/j2kun/holidays-and-homicide) used in this post are available from [this blog's Github page](https://github.com/j2kun).

And of course, it would be quite amazing to find a data set which provides the dates of (even the last fifty years of) homicide history in the entire US, and not just one city. If any readers know of such a data set, please let me know.

Until next time!
