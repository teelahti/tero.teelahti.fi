---
layout: post
title: Disable submit buttons on form submit with jQuery.validate and ASP.NET MVC 2
description: "I had a very common requirement to fill: when user clicks form submit button (or enter on keyboard) the button needs to be disabled in order to prevent double submits."
permalink: /blog/disable-submit-buttons-on-form-submit-with-jquery.validate-and-asp.net-mvc-2
disqus_identifier: disable-submit-buttons-on-form-submit-with-jquery.validate-and-asp.net-mvc-2
modified: 
tags: [mvc, ASP.NET, javascript, jquery]
comments: true
share: true
---

I had a very common requirement to fill: when user clicks form submit button (or 
enter on keyboard) the button needs to be disabled in order to prevent double submits. 
Double submits could of course be filtered at server side with various timestamp mechanisms, 
but this was not what I was after this time.

The first option that came into my mind was of course just to subscribe into form submit 
and disable buttons there like this:

```js
// Disable all submit buttons within 
// the form that is being submitted
$("form").submit(function () {
    var b = $("input[type=submit]", this);
    b.attr('disabled', 'disabled');
    // Re-enable button after some time in case something went wrong
    setTimeout(function () { b.removeAttr("disabled"); }, 3000);
});
```

This worked like a charm… except that this code acted also if form validation failed, 
which is far from optimal. So I needed to find a place to hook into jQuery validation pipeline. 
This is easy if you call .validate() from own JavaScript code, but in ASP.NET MVC jQuery validation is automatically wired up behind the scenes. So the only easy option I found was to slightly change the default MicrosoftMvcJQueryValidation.js file by tampering the default validation options (see MODIFIED: comments below):

```js
var options = {
        errorClass: "input-validation-error",
        errorElement: "span",
        errorPlacement: function (error, element) {
            var messageSpan = fieldToMessageMappings[element.attr("name")];
            $(messageSpan).empty();
            $(messageSpan).removeClass("field-validation-valid");
            $(messageSpan).addClass("field-validation-error");
            error.removeClass("input-validation-error");
            error.attr("_for_validation_message", messageSpan);
            error.appendTo(messageSpan);
        },
        messages: errorMessagesObj,
        rules: rulesObj,

        // MODIFIED: Ignoring hidden elements
        ignore: ":hidden",

        // MODIFIED: Submithandler added to be able to disable submit button
        submitHandler: function (form) {
            var b = $("input[type=submit]", form);
            b.attr('disabled', 'disabled');

            // Re-enable button after some time in case something went wrong
            setTimeout(function () { b.removeAttr("disabled"); }, 3000);

            form.submit();
        },

        success: function (label) {
            var messageSpan = $(label.attr("_for_validation_message"));
            $(messageSpan).empty();
            $(messageSpan).addClass("field-validation-valid");
            $(messageSpan).removeClass("field-validation-error");
        }
    };
```

There are two changes above: hidden elements are ignored by default for easier 
operation with complex forms (toggle block visibilities), and submitHandler is 
set to disable buttons.

Worked for me, hope this helps someone else.