---
layout: post
title: Blog migrated to Github pages
description: "Using Jekyll and Github pages to host this blog."
modified:
tags: [blog, hosting]
comments: true
share: true
---

I already blogged about the [original platform Orchard I used to host this blog](/The-Orchard-experience/). I needed a new blogging platform, and after all the complexity I wanted something simpler and easier to upgrade.

Lately Github pages and Jekyll have drawn a lot of attention. Tipping point for me was reading what it took for [Phil Haack](http://haacked.com/) to [move his blog over](http://haacked.com/archive/2013/12/02/dr-jekyll-and-mr-haack/). I tend to test new technology all the time, and decided to take a shot on Jekyll as a blogging platform. 

[Some people have gotten Jekyll to work ok on Windows](http://www.madhur.co.in/blog/2011/09/01/runningjekyllwindows.html). I didn't. I spent four hours on it, but failed. Ruby was ok, Ruby gems was ok, but installing some gems failed in compilation errors, and the resolutions that worked for some people did not help me. So I installed a new Linux VM just for this purpose. I would not call that experience painless either, but at least now I have a working Github-like local environment. 

First up I created a new dummy Jekyll site, and started experimenting. Everything worked like a charm: features are limited if you plan to host on Github pages, but they is enough for my blogging needs. I did not want to go the route of building locally and pushing to gh-pages, I wanted everything to be done at the server side, and only run Jekyll locally if I need to debug. 

Reading the convert blogs I thought there would be a very vivid community around Jekyll themes. In the end there wasn't too many to choose from, as most of the themes needed plugin support, and I had just ruled that out. Themes by [Made mistakes](http://mademistakes.com/) drew my attention as they were minimalistic the way I like, and I ended up forking his latest creation [HPSTR theme](https://github.com/mmistakes/hpstr-jekyll-theme) into my [own repo](https://github.com/teelahti/teelahti.fi). And it's not just the layout: this theme has Google analytics, social share buttons, Bing and Google site tools, and lots of other stuff included.  

After forking the theme it was simply changing settings and creating first posts; I was up and running very fast. I did not get the Jekyll import plugin to work, and decided to convert my post HTML's mostly manually to Markdown. Took some time, but the only problem I had was with character sets: Github allows only UTF-8 without byte order mark, and Visual Studio wants to save the BOM if you forget to override the default. 

The outcome I have right now is a good looking, typographically easily readable and responsive blog layout. 

<figure>
	<img src="/images/2014-01-26-responsive-view.png" alt="Desktop and mobile views compared.">
    <figcaption>Layout reacts to different screen sizes. Desktop and mobile views compared.</figcaption>
</figure>

There are some layout issues that I might tweak when I have time: 

- H1 styles with a desktop browser are massive, which sometimes looks bad with my too very long blog post titles. 
- Background pattern to something else, now I use the default
- Having the menu only on the hamburger icon dropdown might need a change: I would like to have the top level menu always visible. 
- Favicons: I moved my old, small favicon, but I also need to change the big Apple-specific favicons.

## Comments to Disqus

As the site is static, I needed a new home for comments. I would have liked to support [Discource](http://www.discourse.org/), but the theme had already support for Disqus and I opted the easy way. Importing the comments was the hard part: I had to create a Disqusting, [Wordpress-compatible import XML](http://help.disqus.com/customer/portal/articles/472150-custom-xml-import-format) to be able to import my comments to Disqus. Created the XML and imported, and now old comments are there and commenting works as expected. 

## RSS as before

I already had [my RSS feed](http://feeds.feedburner.com/Tero-Teelahti) at FeedBurner. Feed usage is in decline, but it does not hurt to have one. I just changed my source address to the Jekyll-generated feed.xml. 

## What's missing

I lost site search in conversion: the new theme does not have proper search, and I'm considering creating an option to the theme myself and creating a pull request to the original theme. 

I also lost the time-based archives view I had. That is not too big of a loss, as that revealed too easily that I do not write enough blog posts. 

I can't use Windows Live Writer to write posts anymore. That was a good tool, sadly abandoned by Microsoft. 

I do not have any WYSIWYG editor, I must just hope that markdown converts into nice HTML view and all images fall into their proper places. This is not a big con, as I use only a limited set of layout styles on my blog posts.

## Speed? Upgrades?

With [Orchard](http://www.orchardproject.net/) site speed and platform upgrades were my pain points. So how did this gh-pages + Jekyll adoption change the situation? Completely, I would say:

The site is compiled after every change, and Github serves pretty aggressive cache headers out. As a result my site is very fast. Hosting is pretty far of from Finland and that can be seen in increased latency times, but the negative effect is acceptable.

Github runs the site build and hosting platform, and I do not have to take care any of that. As I forked this blog from the theme repository, I can get fixes to HTML, CSS and some of the JS by fetching from the original theme repository. My biggest risk right now is, that there migth be errors on Github build that I cannot reproduce with my local Jekyll environment, but I'll take that risk as I can always revert to previous version with simple git commands. 

  


