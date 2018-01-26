---
layout: post
title: Selecting MVC action method based on the button clicked
description: "Very common problem in form-heavy solutions is to be able to have one HTML form, but two different submit buttons for it. Learn the MVC way to do solve this."
permalink: /blog/selecting-mvc-action-method-based-on-the-button-clicked
modified: 
tags: [mvc, ASP.NET]
comments: true
share: true
---

Very common problem in form-heavy solutions is to be able to have one HTML form, but two different submit buttons for it. Think "Save" and "Delete":

```html
<div id="buttons">
    <button name="Save">Save</button>
    <button name="Delete">Delete</button>
</div>
```

On controller side this poses a problem: these actions do very different tasks; Save usually validates data and saves it, Delete does not validate and deletes (and so forth). They might also have different access rights. So having these on one action breaks (at least my) principles. Fortunately ASP.NET MVC has a thing called [ActionMethodSelectorAttribute](http://msdn.microsoft.com/en-us/library/system.web.mvc.actionmethodselectorattribute.aspx) that you can extend. With that you can divide the logic into separate action methods, like:

```csharp
[HttpPost]
[ActionName("Edit")]
[Button("Save")]
public ActionResult Save(SampleModel model)
{
    // TODO: Save and redirect, this is just a sample
    ViewBag.Message = "Save button clicked and Save action method selected.";
    return View(model);
}
[HttpPost]
[ActionName("Edit")]
[Button("Delete")]
public ActionResult Delete(SampleModel model)
{
    // TODO: Save and redirect, this is just a sample
    ViewBag.Message = "Delete button clicked and Save action method selected.";
    return View(model);
}
```

Of course you might want to use constants instead of magic strings for button names. Note, that in the above example the action method name is exactly the same "Edit" for both actions. The underlying ButtonAttribute for the action method selection is listed below, feel free to use it: 

```csharp
using System;
using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.Web.Mvc;

/// <summary>
/// Declares a button attribute that selects action method to run. 
/// </summary>
[AttributeUsage(AttributeTargets.Method, AllowMultiple = false)]
public sealed class ButtonAttribute : ActionMethodSelectorAttribute
{
    private List<string> namesField;

    /// <summary>
    /// Initializes a new instance of the <see cref="ButtonAttribute"/> class.
    /// </summary>
    public ButtonAttribute()
    {
    }

    /// <summary>
    /// Initializes a new instance of the <see cref="ButtonAttribute"/> class.
    /// </summary>
    /// <param name="names">The button names that should match.</param>
    public ButtonAttribute(params string[] names)
    {
        if (names == null || names.Length == 0)
        {
            throw new ArgumentNullException(
                "names", 
                "Must specify at least one button name.");
        }

        this.namesField = new List<string>(names);
    }

    /// <summary>
    /// Gets button names. These are the form field names that are accepted when
    /// selecting proper action method.
    /// </summary>
    public IList<string> Names
    {
        get
        {
            if (this.namesField == null)
            {
                this.namesField = new List<string>();
            }

            return this.namesField;
        }
    }

    /// <summary>
    /// Checks whether the given controller action method is valid for execution 
    /// based on given button name.
    /// </summary>
    /// <param name="controllerContext">Controller  context.</param>
    /// <param name="methodInfo">Method context.</param>
    /// <returns>True if valid.</returns>
    public override bool IsValidForRequest(
        ControllerContext controllerContext, 
        System.Reflection.MethodInfo methodInfo)
    {
        if (controllerContext == null)
        {
            throw new ArgumentNullException("controllerContext", "Context can't be null.");
        }

        if (methodInfo == null)
        {
            throw new ArgumentNullException("methodInfo", "Method info can't be null.");
        }

        this.GuardState();

        bool returnValue = false;

        foreach (var name in this.Names)
        {
            ValueProviderResult result = controllerContext.Controller.ValueProvider
                .GetValue(name);
            returnValue = result != null;

            if (returnValue)
            {
                break;
            }
        }

        return returnValue;
    }

    private void GuardState()
    {
        if (this.Names == null)
        {
            throw new InvalidOperationException(
                "Button name must be initialized to non empty value.");
        }
    }
}
```
