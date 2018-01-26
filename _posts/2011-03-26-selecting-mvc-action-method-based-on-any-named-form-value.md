---
layout: post
title: Selecting MVC action method based on any named form value
description: "Route MVC form posts by form values to different action methods."
permalink: /blog/selecting-mvc-action-method-based-on-any-named-form-value
disqus_identifier: selecting-mvc-action-method-based-on-any-named-form-value
modified: 
tags: [mvc, ASP.NET]
comments: true
share: true
---

Yesterday [I blogged about using form button names to select action 
methods](/blog/selecting-mvc-action-method-based-on-the-button-clicked) 
on an ASP.NET MVC controller. After using that attribute for a 
while I realized that I can make a generalization out of that: why 
not use any form value in the action method selection process? 
This way I can avoid code like this:

```csharp
[HttpPost]
public ActionResult Fruit(SampleModel model) {
    if (!ModelState.IsValid) {
        return View(model);
    }
    if (model.IsApple) {
        // Do something
        EatApple(model);
    }
    else {
        // Do something else
        SmashOthers(model);
    }
    TempData["Message"] = "Saved";
    return RedirectToAction("Index");
}
```

That is not too bad, but when more choices are introduced it gets worse 
and worse (i.e. more if-then-else's). Solution for this is very similar 
with the [ButtonAttribute approach](/blog/selecting-mvc-action-method-based-on-the-button-clicked): 
introduce an attribute that takes form element name, and list of accepted values. If 
there is a match the action method is selected, otherwise the search continues. Usage example:

```csharp
[HttpPost]
[ActionName("Fruit")]
[FormValue("SelectedFruit", "Apple")]
public ActionResult Apple(FormValueModel model)
{
    // TODO: Validate and act on data, then redirect; this is just a sample
    EatApples(model);    
    ViewBag.Message = "Selected: " + model.SelectedFruit;
    return View(model);
}

[HttpPost]
[ActionName("Fruit")]
[FormValue("SelectedFruit", "Pear", "Orange")]
public ActionResult PearOrOrange(FormValueModel model)
{
    // TODO: Validate and act on data, then redirect; this is just a sample
    SmashOther(model);
    ViewBag.Message = "Selected: " + model.SelectedOFruit;
    return View(model);
}
```

Beware, that this method has two shortcomings:

1. The order of attributes is very important. If you change it you very easily get a 404.
2. There must be no ambiguity on selections or otherwise ASP.NET MVC will give you an error. 
Usually this happens if you attempt to create one action method that picks only some values, 
and then another without FormValue attribute that picks all the rest; when MVC framework faces 
this situation and input values match the first, FormValue-decorated action method, it also 
matches the one without decoration -> error. To fix this attributes must cover the whole set 
of choices.

Regardless of the shortcomings I still think this is yet another valuable tool to keep my controllers thin.

Here is the full listing for FormValueAttribute:

```csharp
using System;
using System.Collections.Generic;
using System.Web.Mvc;

/// <summary>
/// Defines an action method selector that checks form values. If form item 
/// name and value matches, the action method is selected.
/// </summary>
[AttributeUsage(AttributeTargets.Method, AllowMultiple = false)]
public sealed class FormValueAttribute : ActionMethodSelectorAttribute
{
    private List<string> valuesField;

    /// <summary>
    /// Initializes a new instance of the <see cref="FormValueAttribute"/> class.
    /// </summary>
    public FormValueAttribute()
    {
    }

    /// <summary>
    /// Initializes a new instance of the <see cref="FormValueAttribute"/> class.
    /// </summary>
    /// <param name="name">The form element name.</param>
    /// <param name="values">The values, one of these should match.</param>
    public FormValueAttribute(string name, params string[] values)
    {
        if (string.IsNullOrEmpty(name))
        {
            throw new ArgumentNullException("name", "Must specify a form element name.");
        }

        if (values == null || values.Length == 0)
        {
            throw new ArgumentNullException("values", "Must specify at least one value.");
        }

        this.Name = name;
        this.valuesField = new List<string>(values);
    }

    /// <summary>
    /// Gets or sets the form field name.
    /// </summary>
    /// <value>The name.</value>
    public string Name { get; set; }

    /// <summary>
    /// Gets form item values. These are the values of the form item <see cref="Name"/> 
    /// that should match in order this action method to be selected. 
    /// </summary>
    public IList<string> Values
    {
        get
        {
            if (this.valuesField == null)
            {
                this.valuesField = new List<string>();
            }

            return this.valuesField;
        }
    }

    /// <summary>
    /// Checks whether the given controller action method is valid for execution based on 
    /// given form field <see cref="Name"/> and <see cref="Values"/>.
    /// </summary>
    /// <param name="controllerContext">Information about the controller.</param>
    /// <param name="methodInfo">Information about the method.</param>
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

        // The way of getting only the name without any prefixes might 
        // be incorrect on some situation since there might be a hierarchy 
        // of values in the form Some.Other.Value
        ValueProviderResult result = controllerContext.Controller.ValueProvider.GetValue(this.Name);

        if (result != null)
        {
            // check if any of the values match
            foreach (var value in this.Values)
            {
                returnValue = string.Equals(value, result.AttemptedValue as string);

                if (returnValue)
                {
                    break;
                }
            }
        }

        return returnValue;
    }

    private void GuardState()
    {
        if (string.IsNullOrEmpty(this.Name))
        {
            throw new InvalidOperationException(
                "Form field name must be initialized to non empty value");
        }

        if (this.Values == null || this.Values.Count == 0)
        {
            throw new InvalidOperationException(
                "Form field match values must be initialized.");
        }
    }
}
```
