---
layout: post
title: Applying zebra striping with jQuery tablesorter and tablesorterPager plugin
description: "jQuery plugin to do zebra striping in unison with tablesorter plugin."
modified:
tags: [javascript, jquery]
comments: true
share: true
---

A small but annoying bug I found today ([and seems that someone else is having the same problem](http://www.webdeveloper.com/forum/showthread.php?t=241414)):
when using [jQuery.tablesorter](http://tablesorter.com/docs/)) plugin together with tablesorterPager,
applying the pager clears some properties from the table; In this case namely zebra striping. After
initialization first table page is not striped, but next ones are after the first table page change.

I found some crazy complex solutions, like creating new widgets to replace the built in "zebra", but
the good enough solution ended up being lot easier: asking tablesorter to reapply widget:

```js
var targetTable = $("table#some");
targetTable
  .tablesorter({
    widthFixed: true,
    widgets: ["zebra"],
  })
  .tablesorterPager({
    container: $("#pager"),
    size: 10,
    positionFixed: false,
    page: 0,
  });
// tableSorterPager clears zebra striping,
// re-apply it here. For some reason does not
// work if called directly in continuation
// to previous jQuery functions
targetTable.trigger("applyWidgetId", "zebra");
```

jQuery.tablesorter is outdated and not actively developed; If I could choose, I would go
for some other plugin like [datatables.net](http://www.datatables.net/) or
[soon-to-be-released](http://blog.jqueryui.com/2011/02/unleash-the-grid/) "official"
[jQuery UI grid](http://wiki.jqueryui.com/w/page/34246941/Grid). In this case I did not
have a choice.
