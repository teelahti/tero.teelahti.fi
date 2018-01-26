---
layout: post
title: Controller dependency missing on test? Try MvcContrib TestControllerBuilder
description: "Use MvcContrib to help your unit test setups."
permalink: /blog/controller-dependency-missing-on-test-try-mvccontrib-testcontrollerbuilder
modified: 
tags: [mvc, ASP.NET, testing]
comments: true
share: true
---

Ever faced this situation: You have nice and easy controller method, say:

```csharp
public ActionResult Demonstrate(string id) {   
    this.Repository.Demonstrate(id);   
    string url = this.Url.Action(MVC.Errors.Suck(id));   
    return this.Redirect(url); 
}
```

Then you go and create test for it (or created the test before, whatever suits you):

```csharp
[TestMethod]   
public void Demonstrate_ValidInput_Redirects()   
{   
    // Arrange   
    var controller = new MyDemonstratingController();   
 
    // ... mock something here   
   
    // Act  
    controller.Demonstrate("kaboom");  
        
    // Assert  
    // ... test that everything was called  
}
```

…only to get NullReferenceException, since you did not set everything up that is needed by 
the UrlHelper class (controller’s Url property).

To satisfy the basic dependencies for a controller you can use [MvcContrib’s](http://mvccontrib.codeplex.com/) 
TestControllerBuilder class like this:

```csharp
TestControllerBuilder builder = new TestControllerBuilder();   
builder.InitializeController(controller);
```

InitializeController method adds mock implementations of the following:

- HttpContext
- HttpRequest
- HttpResponse
- HttpSession
- Form
- TempData
- QueryString
- ApplicationPath
- PathInfo

There are also other helper methods than InitializeController in TestControllerBuilder, 
but for me InitializeController has been the most useful method from that library so far.
