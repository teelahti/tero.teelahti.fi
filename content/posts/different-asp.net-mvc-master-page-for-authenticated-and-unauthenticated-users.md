---
title: Different ASP.NET MVC master page for authenticated and unauthenticated users
date: 2012-01-11T00:00:00+00:00
description: "Selecting master page dynamically."
tags: [ASP.NET, mvc]
slug: different-asp.net-mvc-master-page-for-authenticated-and-unauthenticated-users
---

I guess this is a common problem: you need to have different web site layout for unauthenticated users. In simple cases this is very easy: just use masterPageFile attribute on views. But it gets more complex when you have views that are used in both authenticated and unauthenticated context. Luckily MVC lets you plug into almost anything, and this can be solved with an action filter like this:

```csharp
using System.Web.Mvc;
/// <summary>
/// A globally registered attribute to change view master
/// page based on whether user is authenticated or not.
/// Uses magic strings for the file names, could
/// be changed to something more elegant.
/// </summary>
public sealed class SwitchMasterPageFilter : IActionFilter
{
    public void OnActionExecuting(
        ActionExecutingContext filterContext)
    {
    }
    public void OnActionExecuted(
        ActionExecutedContext filterContext)
    {
        var result = filterContext.Result as ViewResult;
        if (result != null)
        {
            bool authenticated = filterContext.HttpContext
                             .User.Identity.IsAuthenticated;
            result.MasterName = authenticated ?
                "~/Views/Shared/Site.master"
              : "~/Views/Shared/SiteUnauthenticated.master";
        }
    }
}
```

Remember to register the filter on your site bootstrapper and you are good to go.
