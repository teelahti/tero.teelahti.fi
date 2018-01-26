---
layout: post
title: SSL, IE8 and strict cache headers (will not work)
description: "Caching in IE8 is somewhat broken."
permalink: /blog/ssl-ie8-and-strict-cache-headers-will-not-work
modified:
tags: [ASP.NET, mvc, caching, browsers]
comments: true
share: true
---

Recently I encountered a bug that only some users saw, and which did not reproduce locally on development environment. The setup was:

- An intranet page has an IFrame
- ...that is dynamically changed to point to an attachment
- ...which is served from MVC action returning [FileContentResult](http://msdn.microsoft.com/en-us/library/system.web.mvc.filecontentresult.aspx)

This is a pretty common pattern to open files on browser without leaving the current 
page. And it worked like charm in all browsers, except on Internet Explorer 8 on 
testing environment, where IE just showed an error message that the address cannot 
be opened. IE 7 might be affected too, but I did not test on that.

First suspect was the way IFrame src attribute was changed with JavaScript. For 
some reason even that simple task is very hard to do in a cross browser manner... 
anyway, after hours of frustration that did not fix the issue. 
[Fiddler](http://www.fiddler2.com/fiddler2/) to the rescue (as IE8 does not 
have internal network listening tool). And to my surprise the PDF document being 
loaded to the browser actually loaded to the last bit, and only after that IE said 
that it cannot open the web address. The reason turned out to be pretty logical: 
when IE is on top of SSL connection and web server sends very strict cache headers, 
IE removes the document before external program (the PDF reader in this case) 
can get handle of the file. Actually this is a known issue documented e.g. on 
Microsoft [KB196505](http://support.microsoft.com/default.aspx?scid=kb;EN-US;q196505) and 
[KB316431](http://support.microsoft.com/kb/316431), and on 
[]Drupal issue tracker](http://drupal.org/node/163298). Luckily this is fixed in 
IE 9, and even fixed when running IE 8 mode on top of IE 9 (another proof that 
the browser modes on IE 9 are not 100 % compatible with the actual old browsers). 

## Fix

To prevent caching pages I had a hand made MVC no cache action filter attribute (NoBrowserCacheAttribute) which is registered globally and did this:

```csharp
// Set all the various headers that control caching
var cache = filterContext.HttpContext.Response.Cache;
cache.SetExpires(DateTime.UtcNow.AddDays(-1));
cache.SetValidUntilExpires(false);
cache.SetRevalidation(HttpCacheRevalidation.AllCaches);
cache.SetCacheability(HttpCacheability.NoCache);
cache.SetNoStore();
```

But IE does not like the Pragma: no-cache header or the Expires: -1 header that 
yield from the above settings. Here are the settings that fixed the IE issue 
for me (used these instead of the above settings):

```csharp
var response = filterContext.HttpContext.Response;
response.Cache.SetExpires(DateTime.UtcNow);
response.CacheControl = "private";
```

There are a couple of ways to use these less offensive cache settings per action method basis:

- Allow multiple declarations of the NoBrowserCacheAttribute, and declare it again with some different properties on the file outputting action methods
- Create a new action filter that is used only on file outputting action methods
- Create new file content class that changes HTTP headers
- Signal the no cache attribute that it should be less offensive

The last one was what I ended up doing: I created a static method 
SetSafeAttachmentCache() to the attribute, and called that from affected 
action methods; not very pedant but easy and works. The information (bit) 
was then stored in HttpContext.Items collection, and read from there at 
the time of writing HTTP headers.