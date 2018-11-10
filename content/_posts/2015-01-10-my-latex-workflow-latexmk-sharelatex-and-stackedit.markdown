---
author: jeremykun
date: 2015-01-10 14:00:00+00:00
draft: false
title: 'My LaTeX Workflow: latexmk, ShareLaTeX, and StackEdit'
type: post
url: /2015/01/10/my-latex-workflow-latexmk-sharelatex-and-stackedit/
categories:
- General
tags:
- latex
- paper writing
- research
- sharelatex
- software
- stackedit
- tex
- workflow
---

Over the last year or so I've gradually spent more and more of my time typing math. Be it lecture notes, papers, or blog posts, I think in the last two years I've typed vastly more dollar signs (TeX math mode delimiters) than in the rest of my life combined. As is the natural inclination for most programmers, I've tried lots of different ways to optimize my workflow and minimize the amount of typing, configuring, file duplicating, and compiler-wrestling I do in my day-to-day routine.

I've arrived at what I feel is a stable state. Here's what I use.

First, my general setup. At home I run OS X Mavericks (10.9.5), and I carry a Chromebook with me to campus and when I travel.

## For on-the-fly note taking

I haven't found a better tool than [StackEdit](https://stackedit.io/).

[![stackedit-logo](https://jeremykun.files.wordpress.com/2015/01/stackedit-logo.png?w=660)
](https://stackedit.io/)

**Mindset:** somewhere in between writing an email with one or two bits of notation (just write TeX source and hope they can read it) and writing a document that needs to look good. These are documents for which you have no figures, don't want to keep track of sections and theorem numbering, and have no serious bibliography.

**Use cases:**

	  * **In class notes:** where I need to type **fast** and can sacrifice on prettiness.** **Any other workflow besides Markdown with TeX support is just awfully slow, because the boilerplate of LaTeX proper involves so much typing (\begin{theorem} \end{theorem}, etc.)
	  * **Notes during talks:** these notes usually have fewer formulas and more sentences, but the ability to use notation when I want it really helps.
	  * **Short drafts of proofs:** when I want to send something technical yet informal to a colleague, but it's in such a draft phase that I'm more concerned about the idea being right—and on paper—than whether it looks good.

**Awesome features:** I can access documents from Google Drive. Integration with Dropbox (which they have) is not enough because I don't have Dropbox on every computer I use (Chromebook, public/friends' computers). Also, you can configure Google Drive to open markdown files with StackEdit by default (otherwise Drive can't open them at all).

**How it could improve: **The service gets sluggish with longer documents, and sometimes the preview page jumps around like crazy when you have lots of offset equations. Sometimes it seems like it recompiles the whole document when you only change one paragraph, and so the preview can be useless to look at while you're typing. I recently discovered you can turn off features you don't use in the settings, so that might speed things up.

Also, any time something needs to be aligned (such as a matrix or piecewise notation), you have to type \begin{}'s and \end{}'s, so that slows down the typing. It would be nice to have some shortcuts like \matrix[2,3]{1,3,4,4,6,8} or at least an abbreviation for \begin and \end (\b{} and \e{}, maybe?). Also some special support for (and shortcuts for) theorem/proof styling would be nice, but not necessary. Right now I embolden the **Theorem** and italicize the _Proof._, and end with a tombstone $\square$ on a line by itself. I don't see a simple way to make a theorem/proof environment with minimal typing, but it does occur to me as an inefficiency; the less time I can spend highlighting and formatting things the better.

**Caveats:** Additional features, such as exporting from StackEdit to pdf requires you to become a donor ($5/year, a more than fair price for the amount I use it). I would find the service significantly less useful if I could not export to pdf.

## For work while travelling

My favorite so far is [ShareLaTeX](https://www.sharelatex.com/).

[![sharelatex](https://jeremykun.files.wordpress.com/2015/01/sharelatex.png)
](https://www.sharelatex.com/)I've used a bunch of online TeX editors, most notably Overleaf (formerly WriteLaTeX). They're both pretty solid, but a few features tip me toward ShareLaTeX. I'll italicize these things below.

**Mindset:** An editor I can use on my Chromebook or a public machine, yet still access my big papers and projects in progress. Needs support for figures, bibliographies, the whole shebang. Basically I need a browser replacement for a desktop LaTeX setup. I generally **do not** need collaboration services, because the de facto standard among everyone I've ever interacted with is that you can only expect people to have Dropbox. You cannot expect them to sign up for online services just to work with you.

**Use cases:**

	  * **Drafting actual research papers**
	  * **Writing slides/talks**

**Awesome features: **_Dropbox integration!_ This is crucial, because I (and everyone I know) does their big collaborative projects using Dropbox. ShareLaTeX (unlike Overleaf) has seamless Dropbox integration. The only caveat is that ShareLaTeX only accesses Dropbox files that are in a specially-named folder. This causes me to use a bunch of symbolic links that would be annoying to duplicate if I got a new machine.

Other than that, ShareLaTeX (like Overleaf) has tons of templates, all the usual libraries, great customer support, and great collaborative features for the once in a blue moon that someone else uses ShareLaTeX.

_Vim commands. _The problem is that they don't go far enough here. They don't support vim-style word-wrapping (gq), and they leave out things like backward search (? instead of /) and any : commands you tend to use.

_Github integration._ Though literally no mathematicians I know use Github for anything related to research, I think that with the right features Github could become the "right" solution to paper management. The way people store and "archive" their work is horrendous, and everyone can agree a waste of time. I have lots of ideas for how Github could improve academics' lives and the lives of the users of their research, too many to list here without derailing the post. The point is that ShareLaTeX having Github integration is forward thinking and makes ShareLaTeX more attractive.

**How it could improve: **Better vim command support. It seems like many of these services are viewed by their creators as a complete replacement for offline work, when really (for me) it's a temporary substitute that needs to operate seamlessly with my other services. So basically the more seamless integration it has with services I use, the better.

**Caveats: **Integration comes at a premium of $8/month for students, and $15/month for non-students.

## Work at home

This is where we get into the nitty gritty of terminal tools. Because naively writing papers in TeX on a desktop has a lot of lame steps and tricks. There are (multiple types of) bibliography files to manage, you have to run like four commands to compile a document, and the TeX compiler errors are often nonsense.

I used to have a simple script to compile;display;clean for me, but then I came across the [latexmk](http://users.phys.psu.edu/~collins/software/latexmk-jcc/) program. What you can do is configure latexmk to automatically recompile when a change is made to a source file, and then you can configure a pdf viewer (like [Skim](http://skim-app.sourceforge.net/)) to update when the pdf changes. So instead of the workflow being "Write. Compile. View. Repeat," It's "Compile. View. Write until done."

Of course lots of random TeX distributions come with crusty GUIs that (with configuration) do what latexmk does. But I love my vim, and you have your favorite editor, too. The key part is that latexmk and Skim don't care what editor you use.

For reference, here's how I got it all configured on OS X Mavericks.

	  1. Install latexmk (move the perl script downloadable from [their website](http://users.phys.psu.edu/~collins/software/latexmk-jcc/) to anywhere on your $PATH).
	  2. Add `alias latexmk='latexmk.pl -pvc'` to your `.profile`. The -pvc flag makes latexmk watch for changes.
	  3. Add the following to a new file called .latexmkrc in your home directory (it says: I only do pdfs and use Skim to preview):
`$pdf_mode = 1;
$postscript_mode = 0;
$dvi_mode = 0;
$pdf_previewer = "open -a /Applications/Skim.app";
$clean_ext = "paux lox pdfsync out";`
	  4. Install [Skim](http://skim-app.sourceforge.net/).
	  5. In Skim's preferences, go to the Sync tab and check the box "Check for file changes."
	  6. Run the following from the command line, which prevents Skim from asking (once for each file!) whether you want to auto reload that file:
`$ defaults write -app Skim SKAutoReloadFileUpdate -boolean true`

Now the workflow is: browse to your working directory; run `latexmk yourfile.tex` (this will open Skim); open the tex document in your editor; write. When you save the file, it will automatically recompile and display in Skim. Since it's OS X, you can scroll through the pdf without switching window focus, so you don't even have to click back into the terminal window to continue typing.

Finally, I have two lines in my .vimrc to auto-save every second that the document is idle (or when the window loses focus) so that I don't have to type :w every time I want the updates to display. To make this happen only when you open a tex file, add these lines instead to `~/.vim/ftplugin/tex.vim`

` set updatetime=1000
autocmd CursorHoldI,CursorHold,BufLeave,FocusLost silent! wall
`

**Caveats: **I haven't figured out how to configure latexmk to do anything more complicated than this. Apparently it's possible to get it setup to work with "Sync support," which means essentially you can go back and forth between the source file lines and the corresponding rendered document lines by clicking places. I think reverse search (pdf->vim) isn't possible with regular vim (it is apparently with macvim), but forward search (vim->pdf) is if you're willing to install some plugins and configure some files. So here is the place where Skim does care what editor you use. I haven't yet figured out how to do it, but it's not a feature I care much for.

* * *

One deficiency I've found: there's no good bibliography manager. Sorry, Mendeley, I really can't function with you. I'll just be hand-crafting my own bib files until I find or make a better solution.

Have any great tools you use for science and paper writing? I'd love to hear about them.
