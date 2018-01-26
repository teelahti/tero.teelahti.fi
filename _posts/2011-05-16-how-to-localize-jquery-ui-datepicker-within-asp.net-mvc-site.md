---
layout: post
title: How-to localize jQuery UI Datepicker within ASP.NET MVC site
description: "Make your jQuery UI Datepicker follow your server side culture."
permalink: /blog/how-to-localize-jquery-ui-datepicker-within-asp.net-mvc-site
modified:
tags: [mvc, ASP.NET, javascript, jquery, localization]
comments: true
share: true
---

JQuery’s [date picker UI component](http://docs.jquery.com/UI/Datepicker) is very
[easy to localize on Javascript level](http://docs.jquery.com/UI/Datepicker/Localization).
On this blog post I’ll describe how to ensure that date picker culture follows site’s
server side culture. This is pretty trivial to accomplish, but it won’t hurt to
document it here.

First, you need to pick the translations you need from jQuery UI trunk. Place these
files on your script folder and include them on your page (or master page), here
I’m using my favorite static content bundler [SquishIt](https://github.com/jetheredge/SquishIt)
to combine and minify scripts:

```csharp
<%=SquishIt.Framework.Bundle.JavaScript()
    .Add("~/Scripts/jquery-ui-1.8.9.custom.min.js")
    .Add("~/Scripts/jquery.ui.datepicker-sv.js")
    .Add("~/Scripts/jquery.ui.datepicker-fi.js")
    .Render("~/Scripts/Site.#.js") %>
```

Next you need to store language information somewhere for client side use. Good or 
even best practice is to store that into HTML document root level with "lang" attribute:

```html
<html lang="<%=System.Threading.Thread.CurrentThread.CurrentUICulture.TwoLetterISOLanguageName %>">
```

Finally date picker needs to be told which language to use. This should be done on page load like this (note, that to set default language en-US you need to give an empty string):

```js
$(function () {
    // Current document language is at HTML root tag
    var lang = $('html').attr("lang");
    // Set datepicker language. 
    $.datepicker.setDefaults(
        $.datepicker.regional[lang === 'en' ? '' : lang]);
});
```

That’s it! Now your date picker follows your site’s language. This same pattern can of course be used for other JS libraries.
