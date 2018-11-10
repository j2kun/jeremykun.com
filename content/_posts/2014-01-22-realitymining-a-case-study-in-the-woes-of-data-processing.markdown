---
author: jeremykun
date: 2014-01-22 04:11:49+00:00
draft: false
title: RealityMining, a Case Study in the Woes of Data Processing
type: post
url: /2014/01/21/realitymining-a-case-study-in-the-woes-of-data-processing/
categories:
- Data Structures
- Graph Theory
tags:
- big data
- data analysis
- data mining
- matlab
- python
- reality mining
- research
- social networks
---

This post is intended to be a tutorial on how to access the [RealityMining dataset](http://realitycommons.media.mit.edu/realitymining.html) using Python (because who likes Matlab?), and a rant on how annoying the process was to figure out.

RealityMining is a dataset of smart-phone data logs from a group of about one hundred MIT students over the course of a year. The data includes communication and cell tower data, the latter being recorded every time a signal changes from one tower to the next. They also conducted a survey of perceived friendship, personal attributes, and a few other things. See [the website](http://realitycommons.media.mit.edu/realitymining2.html) for more information about what data is included. Note that the website lies: there is no lat/long location data. This is but the first sign that this is going to be a rough road.

In order to access the data yourself, you must [fill out a form](http://realitycommons.media.mit.edu/realitymining4.html) on the RealityMining website and wait for an email, but I've found their turnaround time to giving a download link is quite quick. The data comes in the form of a .mat file, "realitymining.mat", which is a proprietary Matlab data format (warning sign number two, and largely the cause of all my problems).

Before we get started let me state my goals: to extract the person-to-person voice call data, actual proximity data (whether two subjects were connected to the same cell tower at the same time), and perceived friendship/proximity data. The [resulting program](https://github.com/j2kun/reality-mining) is free to use and modify, and is posted on [this blog's Github page](https://github.com/j2kun).


## Loading realitymining.mat into Python


Once I found out that the Python [scipy library](http://scipy.org/) has a function to [load the Matlab data into Python](http://docs.scipy.org/doc/scipy/reference/generated/scipy.io.loadmat.html), I was hopeful that things would be nice and user friendly. Boy was I wrong.

To load the matlab data into Python,

{{< highlight python >}}
import scipy.io

matlab_filename = ...
matlab_obj = scipy.io.loadmat(matlab_filename)
{{< /highlight >}}

Then you get a variable matlab_obj which, if you try to print it stalls the python process and you have to frantically hit the kill command to wrestle back control.

Going back a second time and being more cautious, we might inspect the type of the imported object:

{{< highlight python >}}
>>> type(matlab_obj)
<class 'dict'>
{{< /highlight >}}

Okay so it's a dictionary, probably why it tried to print out its entire 2GB contents when I printed it. What are it's keys?

{{< highlight python >}}
>>> matlab_obj.keys()
dict_keys(['network', '__header__', '__version__', '__globals__', 's'])
{{< /highlight >}}

So far so good (the only ones that matter are 'network' and 's'). So what is 's'?

{{< highlight python >}}
>>> type(matlab_obj['s'])
<class 'numpy.ndarray'>
>>> len(matlab_obj['s'])
1
{{< /highlight >}}

Okay it's an array of length 1... What's its first element?

{{< highlight python >}}
>>> type(matlab_obj['s'][0])
<class 'numpy.ndarray'>
>>> len(matlab_obj['s'][0])
106
{{< /highlight >}}

Okay so 's' is an array of one element containing the array of actual data (I remember the study has 106 participants). Now let's look at the first participant.

{{< highlight python >}}
>>> type(matlab_obj['s'][0][0])
<class 'numpy.void'>
{{< /highlight >}}

Okay... what's a numpy.void? Searching Google for "What's a numpy.void" gives little, but combing through [Stackoverflow answers](http://stackoverflow.com/a/10645505/438830) gives the following:


<blockquote>From what I understand, void is sort of like a Python list since it can hold objects of different data types, which makes sense since the columns in a structured array can be different data types.</blockquote>


So basically, numpy arrays that aren't homogeneous are 'voids' and you can't tell any information about the values. Great. Well I suppose we could just try *printing* out the value, at the cost of potentially having to kill the process and restart.

{{< highlight python >}}
>>> matlab_obj['s'][0][0]
([], [[]], [[]], [[]], [[]], [[]], [[]], [[]], [[]], [[]], [[]], [[]], [[]], [[]], [[]], [[]], [[]], [], [[]], [[0]], [], [[0]], [], [[0]], [], [], [], [], [], [], [], [], [], [], [], [], [[413785662906.0]], [], [], [[]], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [])
{{< /highlight >}}

Okay... so the good news is we didn't die, but the bad news is that there is almost no data, and there's no way to tell what the data represents!

As a last straw let's try printing out the second user.

{{< highlight python >}}
>>> matlab_obj['s'][0][1]
([[(array([[ 732338.86915509]]), array([[354]], dtype=uint16), array([[-1]], dtype=int16), array(['Packet Data'],
dtype='&lt;U11'), array(['Outgoing'],
dtype='&lt;U8'), array([[0]], dtype=uint8),
...
* a thousand or so lines later *
...
[2, 0], [2, 0], [2, 0], [2, 0], [2, 0], [2, 0], [2, 0], [2, 0], [2, 0], [0, 0], [2, 0], [3, 0], [3, 0], [3, 0], [3, 0], [3, 0]])
{{< /highlight >}}

So this one has data, but still we have the problem that we have no idea what the various pieces of data represent! We could guess and check, but come on we're in the 21st century.


## Hopelessness, and then Hope


At this point I gave up on a Python approach. As far as I could tell, the data was in a completely unusable format. My only recourse was to spend two weeks obtaining a copy of Matlab from my institution, spend an hour installing it, and then try to learn enough Matlab to parse out the subset of data I wanted into a universal (plaintext) format, so I could then read it back into Python and analyze it.

Two days after obtaining Matlab, I was referred to [a blog post](http://sociograph.blogspot.com/2011/04/communication-networks-part-2-mit.html) by Conrad Lee who provided the source code he used to parse the data in Python. His code was difficult to read and didn't work out of the box, so I had to disassemble his solution and craft my own. This and [a tutorial I later found](http://docs.scipy.org/doc/scipy/reference/tutorial/io.html), and enough elbow grease, were enough to help me figure things out.

The first big insight was that a numpy.void _also acts like a dictionary!_ There's no way to tell this programmatically, no keys() attribute on a numpy.void, so apparently it's just folklore and bad documentation. To get the fields of a subject, we have to know its key (the RealityMining documentation tells you this, with enough typos to keep you guessing).

{{< highlight python >}}
>>> subjects = matlab_obj['s'][0]
>>> subjects[77]['my_hashedNumber']
array([[78]], dtype=uint8)
>>> subjects[76]['mac']
array([[ 6.19653599e+10]])
>>> subjects[76]['mac'][0][0]
61965359909.0
{{< /highlight >}}

The 'mac' and 'my_hashedNumber' are supposed to be identifiers for the subjects. It's not clear why they have two such identifiers, but what's worse is that not all participants in the study (not all subjects in the array of subjects, at least) have mac numbers or hashedNumbers. So in order to do anything I had to extract the subset of valid subjects.

{{< highlight python >}}
def validSubjects(allSubjects):
   return [s for s in allSubjects if hasNumeric(s,'mac') and hasNumeric(s,'my_hashedNumber')]
{{< /highlight >}}

I define the hasNumeric function in the next section. But before that I wanted to keep track of all the stupid ids and produce my own id (contiguous, starting from zero, for valid subjects only) that will replace me having to deal with the stupid matlab subject array. So I did.

{{< highlight python >}}
def idDicts(subjects):
   return (dict((i, s) for (i,s) in enumerate(subjects)),
      dict((getNumeric(s,'mac'), (i, s)) for (i,s) in enumerate(subjects)),
      dict((getNumeric(s, 'my_hashedNumber'), (i, s)) for (i,s) in enumerate(subjects)))
{{< /highlight >}}

Given a list of subjects (the valid ones), we create three dictionaries whose keys are the various identifiers, and whose values are the subject objects (and my own id). So we'll pass around these dictionaries in place of the subject array.


## Extracting Communication Events


The important data here is the set of person-to-person phone calls made over the course of the study. But before we get there we need to inspect how the data is stored more closely. Before I knew about what follows, I was getting a lot of confusing index errors.

Note that the numpy object that gets returned from scipy's loadmat function stores single-type data differently from compound data, and what's worse is that it represents a string (which in Python should be a single-type piece of data) as a compound piece of data!

So I wrote helper functions to keep track of checking/accessing these fields. I feel like such a dirty programmer writing code like what follows, but I can still blame everyone else.

Single-type data (usually numeric):

{{< highlight python >}}
def hasNumeric(obj, field):
   try:
      obj[field][0][0]
      return True
   except:
      return False

def getNumeric(obj, field):
   return obj[field][0][0]
{{< /highlight >}}

Compound-type data (usually Arrays, but also dicts and strings):

{{< highlight python >}}
def hasArray(obj, field):
   try:
      obj[field][0]
      return True
   except:
      return False

def getArray(obj, field):
   return obj[field][0]
{{< /highlight >}}

Note the difference is for single indexing (using [0]) or multiple (using [0][0]). It occurred to me much later that there is an option to loadmat that may get rid of some or all of this doubly-nested array crap, but by then I was too lazy to change everything; it would undoubtedly be the case that some things would break and other wouldn't (and even if that's not the case, you can't blame me for assuming it). I will never understand why the scipy folks chose this representation as the default.

This issue crops up when inspecting a single comm event:

{{< highlight python >}}
>>> subjects[76]['comm'][0][0]
([[732238.1947106482]], [[0]], [[-1]], ['Voice call'], ['Outgoing'], [[16]], [[4]])
{{< /highlight >}}

Again this record is a numpy.void with folklore keys, but notice how numeric values are doubly nested in lists while string values are not. Makes me want to puke.

Communication events can be "Incoming," "Outgoing," or "Missed," although the last of these does not exist in the documentation. Not all fields exist in every record. Some are empty lists and some are double arrays containing nan, but you can check by hand that everyone that has a nonempty list of comm events has the needed fields as well:

{{< highlight python >}}
>>> len([x for x in subjects if len(x['comm']) > 0 and len(x['comm'][0]) > 0])
81
>>> len([x for x in subjects if len(x['comm']) > 0 and len(x['comm'][0]) > 0 and
... all([hasArrayField(e, 'description') for e in x['comm'][0]])])
81
{{< /highlight >}}

The exception is the duration field. If the duration field does not exist (if the field is an empty list), then it definitely corresponds to the "Missed" direction field.

It could otherwise be that the duration field is zero but the call was not labeled "Missed." This might happen because they truncate the seconds, and the call lated less than one second (dubious) or because the call was also missed, or rejected without being missed. The documentation doesn't say. Moreover, "Missed" doesn't specify if the missed call was incoming or outgoing. So incorporating that data would ruin any chance of having a _directed_ graph representation.

One possibility is that the outgoing calls with a duration of 0 are missed outgoing calls, and incoming calls always have positive duration, but actually there are examples of incoming calls of zero duration. Madness!

After sorting all this out (really, guessing), I was finally able to write a program that extracts the person-to-person call records in a specified date range.

First, to extract all communication events:

{{< highlight python >}}
def allCommEvents(idDictionary):
   events = []
   for subjectId, subject in idDictionary.items():
      if hasArray(subject, 'comm'):
         events.extend([(subjectId, event) for event in getArray(subject, 'comm')])

   return events
{{< /highlight >}}

Then to extract that subset of communication events that were actually phone calls between users within the study:

{{< highlight python >}}
def callsWithinStudy(commEvents, hashNumDict):
   return [(subjectId, e) for (subjectId, e) in commEvents
           if (getArray(e, 'description') == "Voice call" and
              getNumeric(e, 'hashNum') in hashNumDict)]
{{< /highlight >}}

Now we can convert the calls into a nicer format (a Python dictionary) and apply some business rules to deal with the ambiguities in the data.

{{< highlight python >}}
def processCallEvents(callEvents, hashNumDict):
   processedCallEvents = []

   for subjectId, event in callEvents:
      direction = getArray(event, 'direction')
      duration = 0 if direction == 'Missed' else getNumeric(event, 'duration')
      date = convertDatetime(getNumeric(event, 'date'))
      hashNum = getNumeric(event, 'hashNum')
      otherPartyId = hashNumDict[hashNum][0]

      eventAsDict = {'subjectId': subjectId,
                      'direction': direction,
                      'duration': duration,
                      'otherPartyId': otherPartyId,
                      'date': date}
      processedCallEvents.append(eventAsDict)

   print("%d call event dictionaries" % len(processedCallEvents))
   return processedCallEvents
{{< /highlight >}}

All I needed to do was filter them by time now (implement the `convertDateTime` function used above)...


## Converting datetimes from Matlab to Python


Matlab timestamps are floats like


<blockquote>834758.1231233</blockquote>


The integer part of the float represents the number of days since Jan 1, 0AD. The fractional part represents a fraction of a day, down to seconds I believe. To convert from the matlab Format to the Python format, use

{{< highlight python >}}
def convertDatetime(dt):
   return datetime.fromordinal(int(dt)) + timedelta(days=dt%1) - timedelta(days=366) - timedelta(hours=5)
{{< /highlight >}}

This is taken without permission from Conrad's blog (I doubt he'll care), and he documents his reasoning in [a side-post](http://sociograph.blogspot.com/2011/04/how-to-avoid-gotcha-when-converting.html).

This then allows one to filter a list of communication events by time:

{{< highlight python >}}
def inRange(dateRange, timevalue):
   start, end = dateRange
   unixTime = int(time.mktime(timevalue.timetuple()))
   return start <= unixTime <= end

def filterByDate(dateRange, events):
   return [e for e in events if inRange(dateRange, e['date'])]
{{< /highlight >}}

Phew! Glad I didn't have to go through that hassle on my own.


## Extracting Survey Data


The dataset includes a survey about friendship and proximity among the participants. That means we have data on



	  1. Who considers each other in the same "close group of friends."
	  2. An estimate on how much time at work each person spends with each other person.
	  3. An estimate on how much time outside work each person spends with each other person.

This information comes in the form of three lists. These lists sit inside a different numpy.void sitting in the original matlab_object from the beginning of the post.

{{< highlight python >}}
matlab_obj = scipy.io.loadmat(matlab_filename)
matlab_obj['network'][0][0]
{{< /highlight >}}

Now the access rules (getNumeric, getArray) we used for the matlab_obj['s'] matrix don't necessarily apply to the values in the 'network' matrix. The friendship survey is accessed by

{{< highlight python >}}
friends = network['friends']
{{< /highlight >}}

and it's an array, each element of which is a participant's response to the survey (claimed to be stored as a 0-1 array). So, for example, to get the number corresponding to whether id1 considers id2 a close friend, you would use

{{< highlight python >}}
friends = network['friends'][id1][id2]
{{< /highlight >}}

This is all straightforward, but there are two complications (stupid trivialities, really). The first is that the matrix is not 0-1 valued, but (nan-1.0)-valued. That's right, if the individual didn't consider someone a friend, the record for that is numpy's nan type, and if they did it's the float 1.0. So you need to either replace all nan's with zeros ahead of time, or take account for that in any computations you do with the data.

I don't know whether this is caused by scipy's bad Matlab data import or the people producing the data, but it's a clear reason _to not use proprietary file formats to distribute data_.

The second problem is that the survey is stored as an array, where the _index_ of the array corresponds to the person the respondent is evaluating for friendship. The problem with this is that not all people are in the survey (for whatever reason, people dropping out or just bad study design), so they include a separate array in the network object called "sub_sort" (a totally unhelpful name). Sub_sort contains in its $i$-th position the hashNum (of the user from the 's' matrix) of "survey-user" $i$ (that is the user whose answer is represented in index $i$ of the network array).

This is incredibly confusing, so let's explain it with an example. Say that we wanted to parse user 4's friendship considerations. We'd first access his friends list by

{{< highlight python >}}
friends = network['friends'][4]
{{< /highlight >}}

Then, to see whether he considers user 7 as a friend, we'd have to look up user 7 in the sub_sort array (which requries a search through said array) and then use the index of user 7 in that array to index the friends list appropriately. So

{{< highlight python >}}
subsortArray = network['sub_sort'][0]
user7sIndex = subsortArray.indexof(7)
network['friends'][4][user7sIndex]
{{< /highlight >}}

The reason this is such terrible design is that an array is the _wrong data structure to use_. They should have used a list of dictionaries or a dictionary with ordered pairs of hashNums for keys. Yet another reason that matlab (a language designed for numerical matrix manipulation) is an abysmal tool for the job.

The other two survey items are surveys on proximity data. Specifically, they ask the respondent to report how much time per day he or she spends within 10 feet of each other individual in the study.

{{< highlight python >}}
inLabProximity = network['lab']
outLabProximity = network['outlab']
{{< /highlight >}}

The values in these matrices are accessed in exactly the same way, with the values being in the set {nan, 1.0, 2.0, 3.0, 4.0, 5.0}. These numbers correspond to various time ranges (the documentation is a bit awkward about this too, using "at least" in place of complete time ranges), but fine. It's no different from the friends matrix, so at least it's consistent.


## Cell Tower Data


Having learned all of the gotchas I did, I processed the cell tower data with little fuss. The only bothersome bit was that they provide two "parallel" arrays, one called "locs" containing pairs of (date, cell tower id), and a second called "loc_ids" containing numbers corresponding to a "second" set of simplified cell tower ids. These records correspond to times when a user entered into a region covered by a specific tower, and so it gives very (coarse location) data. It's not the lat/long values promised by the website, and even though the ids for the cell towers are governed by a national standard, the lat/long values for the towers are not publicly or freely available in database form.

Why they need two sets of cell tower ids is beyond me, but the bothersome part is that they didn't include the dates in the second array. So you must assume the two arrays are in sync (that the events correspond elementwise by date), and if you want to use the simplified ids you still have to access the "locs" array for the dates (because what use would the tower ids be without dates?).

One can access these fields by ignoring our established rules for accessing subject fields (so inconsistent!). And so to access the parallel arrays in a reasonable way, I used the following:

{{< highlight python >}}
towerEvents = list(zip(subject['locs'], subject['loc_ids']))
{{< /highlight >}}

Again the datetimes are in matlab format, so the date conversion function above is used to convert them to python datetimes.

**Update:** As I've continued to work with this data set, I've found out that, once again contrary to the documentation, the tower id 1 corresponds to being out of signal. The documentation claims that tower id 0 implies no signal, and this is true of the "locs" array, but for whatever reason they decided to change it to a 1 in the "loc_ids" array. What's confusing is that there's no mention of the connection. You have to guess it and check that the lengths of the corresponding lists of events are equal (which is by no means proof that the towers ids are the same, but good evidence).

The documentation is also unclear as to whether the (datestamp, tower id) pair represents the time when the user _started_ using that tower, or the time when the user _finished_ using that tower. As such, I must guess that it's the former at the risk of producing bad data (and hence bad research).


## Conclusions


I love free data sets. I really do, and I appreciate all the work that researchers put into making and providing their data. But all the time I encounter the most horrible, terrible, no good, very bad data sets! RealityMining is only one small example, and it was actually nice because I _was_ able to figure things out eventually. There are other datasets that have frustrated me much more with inconsistencies and complete absence of documentation.

Is it really that hard to make data useable? Here are the reasons why this was such an annoying and frustrating task:



	  1. The data was stored in a proprietary format. Please please please release your data in plaintext files!
	  2. The documentation contradicted the data it was documenting, and was altogether unclear. (One contradiction is too often. This was egregious.)
	  3. There was even inconsistency within the data. Sometimes missing values were empty lists, sometimes numpy.nan, and sometimes simply missing.
	  4. Scipy has awful defaults for the loadmat function.
	  5. Numpy data structures are apparently designed for opacity unless you know the folklore and spend hours poring over documentation.

It seems that most of this could be avoided by fixing 1 and 2, since then it's a problem that an automated tool like Google Refine can fix (though I admit to never having tried Refine, because it crashed on the only dataset I've ever given it). I know scientists have more important things to worry about, and I could just blame it on the 2004 origin of the data set, but in the age of reproducibility and big data (and seeing that this data set is widely used in social network research), it's just as important to release the data as it is to make the data fit for consumption. RealityMining is like a math paper with complicated terms defined only by example, and theorems stated without proof that are actually false. It doesn't uphold the quality that science must, it makes me question the choices made by _other_ researchers who have had to deal with the dataset, and it wastes everyone else's time.

In this respect, I've decided to post my Python code in a [github repository](https://github.com/j2kun/reality-mining), as is usual on this blog. You'll have to get the actual RealityMining dataset yourself if you want to use it, but once you have it you can run my program (it depends only on the numpy/scipy stack and the standard library; tested in Python 3.3.3) to get the data I'm interested in or modify it for your own purposes.

Moral of the story: For the sake of science, please don't distribute a _database_ as a Matlab matrix! Or anything else for that matter!
