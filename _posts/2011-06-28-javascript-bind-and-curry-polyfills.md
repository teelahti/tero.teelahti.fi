---
layout: post
title: JavaScript bind and curry polyfills
description: "Currying and binding in Javascript."
permalink: /blog/javascript-bind-and-curry-polyfills
modified:
tags: [javascript]
comments: true
share: true
---

Although I’m a C# guy, I’ve recently really started to like JavaScript. It is so 
dynamic and “different” that it forces you to really think what you are doing 
and how do you want it structured – which is a good thing. And if you just 
want to get things done quick and dirty JavaScript is also a perfect match for that.

When I begun to use JavaScript on daily basis I naturally soon learned to use more 
and more closures and all that they bring with them. For a while I wrote over and 
over again code like this:

```js
whatever.success(function(data) {
    render(data, context);
});
function render(data, context) {
    $.tmpl("tmpl", data).appendTo(context);
}
```

Then I realized that this is not very JavaScript-like. I guess this was the moment 
I actually started to understand JavaScript. Since then I have more and more used 
the power of "this” and currying in JavaScript. Both of these materialize in 
bind-function, like so:

```js
whatever.success(render.bind(context));

function render(data) {
    $.tmpl("tmpl", data).appendTo(this);
}
```

But opening a page with such code in IE8 brought me back to reality: out of the 
box [bind works only on certain browsers](https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Function/bind). 
Luckily almost everything in JS 
[can be fixed afterwards with polyfills](http://remysharp.com/2010/10/08/what-is-a-polyfill/) 
and bind is no exception. Since I had some troubles finding/creating a polyfill for both bind 
and curry that would work on most browsers I’ll document what I’ve used below. I hope these 
save someone else's time. Bind function is taken almost directly from 
[excellent Mozilla article](https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Function/bind), 
and curry is derived from that.

```js
// Function.prototype.bind polyfill from 
// https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Function/bind
if (!Function.prototype.bind) {
    Function.prototype.bind = function (obj) {
        // closest thing possible to the ECMAScript 5 internal IsCallable function
        if (typeof this !== 'function') {
            throw new TypeError('Function.prototype.bind - what is trying to be bound is not callable');
        }

        var slice = [].slice,
            args = slice.call(arguments, 1),
            self = this,
            nop = function () { },
            bound = function () {
                return self.apply(this instanceof nop ? this : (obj || {}),
                                  args.concat(slice.call(arguments)));
            };

        bound.prototype = this.prototype;

        return bound;
    };
}

if (!Function.prototype.curry) {
    Function.prototype.curry = function () {
        var slice = [].slice,
            args = slice.apply(arguments);

        return this.bind.apply(this, args.concat(slice.call(arguments)));
    };
}
```
