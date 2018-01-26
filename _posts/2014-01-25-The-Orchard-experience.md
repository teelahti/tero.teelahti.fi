---
layout: post
title: The Orchard experience
description: "My experiences with the Orchard CMS platform"
modified:
tags: [blog, hosting]
comments: true
share: true
---

When I originally started this blog I had two options: use some readymade blogging platform, or host one of the blogging platforms myself. I wanted a complete control of everything, and decided to build the blog to my own hosting. As .NET was (and partly still is) my thing, I wanted the platform to be .NET based. Sadly, none of the available platforms pleased me: [dasBlog](http://dasblog.codeplex.com/) was aging and was not updated, [DNN](http://www.dnnsoftware.com/) was too complex and written in Visual Basic. Luckily there was one new emerging platform called [Orchard](http://www.orchardproject.net/) that was exactly what I wanted. 

Start was nice and easy. One of Orchard's creators [Bertrand Le Roy](http://weblogs.asp.net/bleroy/) created his own blog on top of Orchard, and blogged about the experience. There was a nice overly simplistic theme, that looked just what I was after. After some hours (days?) I had a blog running on Orchard and hosted on [DiscountAsp](http://discountasp.net/). 

### Performance

A the beginning performance was a problem: as everything in Orchard was based on dynamic compilation, app restart was extremely slow. Things got better along the releases, but even the latest versions were not as fast as I would have liked. I think speed is one of the key factors in web usability, and therefore any times over one second are too long to have everything rendered on monitor (or mobile phone) glass.

### Customization

Orchard is very, very flexible. So flexible, that learning curve is way too steep. I managed to make customizations and my own theme, but I never fully understood the development model. Luckily you could get pretty far with plugins and customization with the management console. 

### Upgadeability  

This is where it all fell apart: I used almost all versions up to 1.7, and every time I upgraded it was pain. I never knew beforehand if the update would take an hour or three. One of my other sites I never got past one version as it failed with so mysterious errors that I was not able to find the reason. Still I needed to upgrade, as there were security fixes and performance fixes that I really needed. Maybe if I had gotten aboard later, the negative association of the upgrade would not have grown so big.  

This is not to say, that Orchard is a poor project; it definitely rocks if you take the time to learn it. Still, it is not a simple blogging platform, but a full blown CMS. 

I needed a platform change, and I'll next blog about that. 
