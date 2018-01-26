---
layout: post
title: Disable Internet Explorer compatibility view via web.config
description: "How to avoid new Internet Explorer trying to play too smart."
permalink: /blog/disable-internet-explorer-compatibility-view-via-web-config
disqus_identifier: disable-internet-explorer-compatibility-view-via-web-config
modified:
tags: [IIS, web, browsers]
comments: true
share: true
---

New Internet Explorers have a necessary (?) but annoying feature called "Compatibility view". 
I do not need that in my sites since I try to keep my HTML in good shape. Therefore on 
all projects I want to disable the feature since usually it breaks the layout. Disabling 
compatibility view can be done by adding a meta tag to HTML head:

```html
<meta http-equiv="X-UA-Compatible" content="IE=edge" >
```

…or, as it turns out, 
[by adding a custom HTTP header with the same content](http://msdn.microsoft.com/en-us/library/cc288325(v=vs.85).aspx). 
This HTTP-header-way is much better for me as I can include it in my 
[default web.config changes](http://teelahti.fi/blog/iis-7.x-cache-optimizations) I 
use on almost every web project. 

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
        value="IE=edge"/>
    </customHeaders>
  </httpProtocol>
```

### Update 4.2.2014
Check my [newer post](/yet-another-take-on-internet-explorer-compatibility-mode/) for better solution that covers more IE versions. 