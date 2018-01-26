---
layout: post
title: Element cloning problems with jQuery mobile AJAX page transitions
description: "jQuery mobile view caching causes some headache."
permalink: /blog/element-cloning-problems-with-jquery-mobile-ajax-page-transitions
disqus_identifier: element-cloning-problems-with-jquery-mobile-ajax-page-transitions
modified:
tags: [javascript, jquery mobile, mobile]
comments: true
share: true
---

I’m building a site that will mainly be used with mobile browsers (> 60 %), and so I 
decided to build it mobile first and then adapt to desktop browser widths with 
[CSS media queries](http://www.w3.org/TR/css3-mediaqueries/). Natural framework 
choice for easy mobile development is [jQuery mobile](http://jquerymobile.com/); 
now I’ve been playing a couple of nights with it already and mostly have liked 
the experience: this framework is very convention based, and at least as long 
as you follow the conventions everything is remarkably easy.

On one of the pages I have a canvas that I fill with bar charts when page is displayed. 
This worked very well until page was displayed by jQuery mobile AJAX based page transition. 
Over two hours of debugging did not reveal me why the canvas did not show anything even 
though I visited the drawing function and everything seemed to be in place. My code to 
draw the canvas used "pagecreate" event as instructed in docs, and looked like this:

```js
(function () {
    "use strict";
    var barchartCanvas = $("#graph");
    $.subscribe(
        "report.data/refresh", 
        ksx.drawBarChart.bind(barchartCanvas.get(0)));
    $('#reportPage').live('pagecreate', function (event) {
        ksx.refreshReportData(barchartCanvas.data("url"));
    });
})();
```

Finally I realized what was going on: when jQuery mobile changes a page with an 
AJAX call, it stores the current page into DOM for later use.What happens here 
is that there are multiple instances of canvas#graph element on the page, and 
my code happened to update the first found element… which was the cached one, 
not the visible version. To fix this situation I had to change the code to use 
pagecreate event’s target property as base for all operations, like this:

```js
(function () {
    "use strict";
    var last;

    $('#reportPage').live('pagecreate', function (event) {
        var barchartCanvas = $(event.target).find("#graph"),
            key = "report.data/refresh";

        $.unsubscribe(key, last);
        last = ksx.drawBarChart.bind(barchartCanvas.get(0));
        $.subscribe(key, last);

        ksx.refreshReportData(barchartCanvas.data("url"));
    });
})();
```

Problem solved. This is something you need to remember and understand when using jQuery mobile.