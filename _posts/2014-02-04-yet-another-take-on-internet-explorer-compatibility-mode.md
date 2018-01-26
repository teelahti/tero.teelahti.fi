---
layout: post
title: Yet another take on Internet Explorer compatibility mode
description: "List all IE rendering modes in order of preference to cover both internet and intranet zones."
modified:
tags: [IIS, web, browsers]
comments: true
share: true
---

I have touched this subject already twice: first I [I blogged about forcing site rendering to be done with Internet Explorer’s latest engine](/blog/disable-internet-explorer-compatibility-view-via-web-config). Then [I faced a situation where separate intranet zone (bad idea, Microsoft!) fallbacks to compatibility mode](/blog/problems-with-internet-explorer-compatibility-view/) and does not respect the IE=edge meta tag as internet zone web sites do. 

Well... the saga isn't over, as I faced this situation at work today. Again. I was going to put the IE=11 meta tag in place to force normal mode, but then I started to doubt how older IE's (9, 10) would interpret the "11" tag. Short answer is: they don't. [Luckily you can specify many different modes](http://twigstechtips.blogspot.fi/2010/03/css-ie8-meta-tag-to-disable.html), and the browser will pick the first one it supports. To apply this use either a meta tag in your page: 
 
```html
<meta http-equiv="X-UA-Compatible" content="IE=11; IE=10; IE=9; IE=8; IE=7; IE=edge" />
```

Or apply this IIS configuration to add the correct headers:

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
        value="IE=11; IE=10; IE=9; IE=8; IE=7; IE=edge"/>
    </customHeaders>
  </httpProtocol>
</system.webserver>
```

Not nice, but works.
