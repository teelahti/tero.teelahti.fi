---
layout: post
title: The promise of OWIN starts to materialize
description: "First OWIN implementations are mature... and really useful."
modified:
tags: [web, IIS, .NET, authentication]
comments: true
share: true
---

[OWIN](http://owin.org/) stands for the "Open web interface for .NET". Basically it is a reasonably simple specification that defines how data goes through the request pipeline, and how to attach to that pipeline. It is a specification for both the server and the application (middleware on OWIN's terms) part.

When I first saw the project I was not that convinced, but since then lots of applications that rely on OWIN and not the old System.Web stack has emerged, and also there are some hosting components that implement the spec. [SignalR](http://signalr.net/) is a good example of middleware, and [Katana](http://katanaproject.codeplex.com/documentation) a host. For me the new [project Helios](http://blogs.msdn.com/b/webdev/archive/2014/02/18/introducing-asp-net-project-helios.aspx) is also very interesting and I hope the project succeeds, as that would make hosting ASP.NET WebApi very lightweight. And light is never bad.

So the ecosystem has matured, then what? What really made me to support OWIN is what it did to my codebase. In one of my pet projects I use claims based authentication and authorization with Windows Azure Access Control Services; That is a great project (although being replaced with Azure AD), but on the .NET MVC application side it has been a pain to integrate. The amount of web.config carbage it needs is huge, and I have broken it multiple times. Luckily [Microsoft released some OWIN-based implementation](http://blogs.msdn.com/b/webdev/archive/2014/02/21/using-claims-in-your-web-app-is-easier-with-the-new-owin-security-components.aspx) of the server side components, and promised drastically simplified configuration model. You just register th middleware to OWIN, specify where to find the metadata, and give the application identifier:

```csharp
public void ConfigureAuth(IAppBuilder app)
{
    app.UseCookieAuthentication(
        new CookieAuthenticationOptions
        {
            AuthenticationType =
               WsFederationAuthenticationDefaults.AuthenticationType
        });

    app.UseWsFederationAuthentication(new WsFederationAuthenticationOptions
        {
            MetadataAddress = "https://login.windows.net/some-azure-ad.onmicrosoft.com/federationmetadata/2007-06/federationmetadata.xml",
            Wtrealm = "http://myapps/somerealm",
        });
}
```

For me simplified configuration was not the only benefit: OWIN registration also gave me an option to register *everything authentication related* at the same place, which makes the code very readable. Before OWIN I had :

- Various XML configurations for WS Federation registration
- Custom ClaimsAuthenticationManager to do in-the-app claims transformation (look for database for some extra information and include that in claims)
- Account controller to handle sign in and sign out actions
- Handler to add user's roles to all outgoing request for better usability (hide client side elements on single page application based on user's role)

Now I have instead something along these lines:

```csharp
public void ConfigureAuth(IAppBuilder app)
{
	app.SetDefaultSignInAsAuthenticationType(WsFederationAuthenticationDefaults.AuthenticationType);
	app.UseCookieAuthentication(
		 new CookieAuthenticationOptions
		 {
			 AuthenticationType = WsFederationAuthenticationDefaults.AuthenticationType,

			 // Make claims transformation to avoid using an external
			 // STS to map certain users to certain role claims
			 Provider = new CookieAuthenticationProvider
			 {
				 OnResponseSignIn = ctx =>
				 {
					 ctx.Identity = TransformClaims(ctx.Identity);
				 }
			 }
		 });

	app.UseWsFederationAuthentication(new WsFederationAuthenticationOptions
	{
		MetadataAddress = ConfigurationManager.AppSettings["medatata"];,
		Wtrealm = ConfigurationManager.AppSettings["realm"];
	});

	// Map sign in action
	app.Map("/signin", map =>
	{
		map.Run(async ctx =>
		{
			if (ctx.Authentication.User == null ||
				!ctx.Authentication.User.Identity.IsAuthenticated)
			{
				ctx.Response.StatusCode = 401;
			}
			else
			{
				ctx.Response.Redirect("/");
			}
		});
	});

	// Map signout action
	app.Map("/signout", map =>
	{
		map.Run(async ctx =>
		{
			ctx.Authentication.SignOut();
			ctx.Response.Redirect("/");
		});
	});
}

private static ClaimsIdentity TransformClaims(ClaimsIdentity identity)
{
	// ... add what ever claims needed based on your own data source
	return identity;
}
```

Kudos for [Dominick Baier](http://leastprivilege.com/) for his [clear post on this subject](http://leastprivilege.com/2014/02/21/test-driving-the-ws-federation-authentication-middleware-for-katana/) that helped me forward with sign in and out actions.

## WebApi + OWIN

At the same time I also moved Web API to OWIN based hosting, even though I actually run on IIS. Reasoning was the same than with claims auth: I find the configuration model better.

If you're an ASP.NET developer, I suggest you start experimenting with the OWIN pipeline. It will pay out.