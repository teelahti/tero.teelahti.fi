---
layout: post
title: How-to deploy to Azure website deployment slot from TFS
description: "It is not immediately evident how Azure's web site deployment slots work."
modified:
tags: [azure,deployment]
image: 
comments: true
share: true
---

I changed some of my websites deployment to use different [deployment slots on a single Azure web site](http://azure.microsoft.com/en-us/documentation/articles/web-sites-staged-publishing/) instead of having different web sites for different staging areas. I deploy all my staging areas automatically from TFS (using the GitContinuousDeploymentTemplate.12.xaml process), each area from different Git branch. Works for my setup. 

What did not work was deploying to other slots than the main slot. On [Azure portal](https://portal.azure.com) different slots have name and address scheme like **mywebsite-slotname**. I tried to use this name as deployment target:

<figure>
	<img src="/images/2014-10-24-failing-configuration.png" alt="Failing configuration.">
    <figcaption>Failing configuration.</figcaption>
</figure>

...and got failed build with error like:  

> An attempted http request against URI https://management.core.windows.net/long-guid-string-here-53e1f2/services/webspaces/WestEuropewebspace/sites/mywebsite-slotname/publishxml returned an error: (404) Not Found.

So clearly **mywebsite-slotname** is not the correct scheme. And there is no documentation available, thus this blog post.

I went on and downloaded publishing profile for the site slot. It had double underscore naming **mywebsite__slotname**, but that did not work either. Nor did single underscore. What finally worked, was the name the [old Azure portal](https://manage.windowsazure.com) used: **mywebsite(slotname)**. This is how my build process deployment target looks now, and deployment to the slot works. 

<figure>
	<img src="/images/2014-10-24-working-configuration.png" alt="Working configuration.">
    <figcaption>Working configuration.</figcaption>
</figure>

I hope this gets better documented. Luckily one can [create pull request for Azure documentation](https://github.com/Azure/azure-content/blob/master/CONTRIBUTING.md) nowadays; I might document this myself. 


