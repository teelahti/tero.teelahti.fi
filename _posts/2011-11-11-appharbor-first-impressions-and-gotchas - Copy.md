---
layout: post
title: Appharbor first impressions and gotchas
description: "Trying out appHarbor hosting."
permalink: /blog/appharbor-first-impressions-and-gotchas
modified:
tags: [hosting, web, deployment, workflow]
comments: true
share: true
---

Lately I have done too much work and too little play. I decided to fix the situation 
a bit by starting to go through my never ending list: "TODO: Try these technologies or services". 
Since I had one site that needed relocation to new hosting I decided to finally try 
[AppHarbor](https://appharbor.com/). The service is a no friction cloud hosting with 
a tagline "Azure done right".

What makes it special is the deployment model: you can deploy applications by single 
[git](http://git-scm.com/) repository push (git push appharbor master), or you have 
service hook at [Github](https://github.com/) to do the deployment directly from your 
Github repository. "Special" in this context means "Special within .NET development"; 
non-MS world has had [Heroku](http://www.heroku.com/) and some others for a while.

Although I knew the concept and I’ve read many praising tweets about AppHarbor, still 
the deployment workflow amazed me: it feels very natural to do a git push to deploy, 
the deployment is very fast (less than one minute from push to site being live for a 
small site), it runs unit tests before deployment, and the price is free for one hosted 
instance. Couldn’t ask for more (for free). From opening an AppHarbor account to site 
being live could have been just 5 minutes but I had some gotchas I list below for 
future reference. Some of these are very well documented also on 
[AppHarbor knowledge base](http://support.appharbor.com/kb), some not:

- ASP.NET Web site project did not work: I had many strange problems and the fix was to convert site to Web application project. One of the problems was that I was not able to create “Release” configuration for Web site project.
- Solution files must be intact. Every now and then, especially when adding and removing projects, Visual Studio leaves all kinds of clutter to solution file. If AppHarbor build finds a reference to a project that is not included it fails. Fast. Of course it is kind of what you would expect as you only want to deploy perfect builds, but it caught me a bit off guard as locally my site worked perfectly.
- There must be only one solution file; if there are many one of them must be named AppHarbor.sln
- Any content items – I had App_data folder with some JSON files – won’t get deployed unless you specifically set them as “Content” in Visual Studio property editor.
- Ensure that your [web.config compilation element](http://msdn.microsoft.com/en-us/library/s10awwz0.aspx) has targetFramework="4.0" specified or else your site is hosted on .NET 2 application pool.

Regardless of these gotchas and 2 hours of extra trial and error my verdict after first 
deployment is: AppHarbor is extremely usable and easy if you deploy a simple site; 
not many different server roles, no complex integration, no special identity federation 
needs etc. For a complex solution I would still take [Windows Azure](http://www.microsoft.com/windowsazure/) or dedicated 
hosting. That might change as AppHarbor is young and actively developed.