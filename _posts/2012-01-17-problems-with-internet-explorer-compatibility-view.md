---
layout: post
title: Problems with Internet Explorer compatibility view
description: "IE has different intranet setup that messes up modern web applications."
permalink: /blog/problems-with-internet-explorer-compatibility-view
modified:
tags: [IIS, web, browsers]
comments: true
share: true
---

A while ago [I blogged about forcing site rendering to be done with Internet Explorer’s latest engine](/blog/disable-internet-explorer-compatibility-view-via-web-config). 
This feature is very [well documented by Microsoft](http://msdn.microsoft.com/en-us/library/cc288325(v=vs.85).aspx). 
Not that well documented is that adding the X-UA-Compatible header with value “IE=edge” does 
only half of the job: it overrides document mode, but not browser mode, and therefore you 
might end with situation like below - even if you carefully tried to avoid it by placing 
the meta tag (I know, I just did).

<figure>
	<img src="/images/2012-01-17-image1.png" alt="IE drops into compatibility view with now good reason">
</figure>

This is especially problem in an intranet environment, since there is a very 
stupid default in IE: "Display intranet sites in compatibility view".

<figure>
	<img src="/images/2012-01-17-image2.png" alt="IE's very conservative default intranet settings">
    <figcaption>IE's very conservative default intranet settings</figcaption>
</figure>

As you see, by default this is checked and causes all kinds of funky problems in 
your web pages. Not good. After reading lots of 
[Stackoverflow](http://stackoverflow.com/) questions I found that the only 
way to override browser mode on intranet is to use IE=9 instead IE=edge. I would 
have liked to live on the edge but there is nothing you can do. Here is the 
IIS configuration to add the correct header:

```xml
<system.webserver>
  <httpProtocol>
    <customHeaders>
      <!-- No need to expose the platform -->
      <remove 
        name="X-Powered-By" />
      <!-- Do not show IE compatibility view -->
      <remove 
        name="X-UA-Compatible"/>
      <add 
        name="X-UA-Compatible" 
        value="IE=9"/>
    </customHeaders>
  </httpProtocol>
</system.webserver>
```

### Update 4.2.2014
Check my [newer post](/yet-another-take-on-internet-explorer-compatibility-mode/) for better solution that covers more IE versions. 