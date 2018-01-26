---
layout: post
title: Azure Blob Storage CORS headers and ScriptCS
description: "Used ScriptCS for a tactical task and was pleasantly surprised about the state of ScriptCS"
modified:
tags: [azure,web,scriptcs]
image: 
comments: true
share: true
---

One of [Basware's](http://www.basware.com) products I work for uses CDN to deliver content for end users. 
CDN provider is Edgecast, and primary & secondary origins are Azure Blob storage accounts. So far we 
have not needed any cross domain access to the CDN, but now a new feature required Javascript requests 
from our application domain to the CDN domain... and browsers naturally block this nowadays. 

I knew right away that I need to set the [Cross Origin Resource Sharing (CORS)](http://en.wikipedia.org/wiki/Cross-origin_resource_sharing)
headers to our origin servers, but setting this up was harder than it is supposed to be: Azure's Powershell
SDK does not have support to alter this value, and there is no UI to set it in the management portal. There 
is of course the [management REST API](https://msdn.microsoft.com/en-us/library/azure/ee460799.aspx) you can 
use to do anything, but calling it with curl is hard due to the authentication scheme. Setting the 
[DefaultServiceVersion property](https://msdn.microsoft.com/en-us/library/azure/dd894041.aspx) proved to be 
as complex before, so I knew what to expect.

I checked Github and there were [a couple of projects that matched my problem](https://github.com/search?q=azure+cors). 
Still I found none of them immediately useful; this kind of tool that you use only once should have a very 
low barrier of entry: git clone and run. So I decided to try to create one myself. With some help from 
blog posts like [Bill Wilders post on the subject](http://blog.codingoutloud.com/2014/02/21/stupid-azure-trick-6-a-cors-toggler-command-line-tool-for-windows-azure-blobs/)
I was able to create a working version in an hour. My tech stack for this is 
[ScriptCS](http://scriptcs.net/), as it supports Nuget references out of the box. I referenced the 
[WindowsAzure.Storage package](http://www.nuget.org/packages/WindowsAzure.Storage/) that had the methods I needed.

[The end result is a tool](https://github.com/teelahti/AzureCorsSetter) that (given you have ScriptCS installed) 
you can just clone and run - ScriptCS takes care of the package restoration automatically. Tool supports dumping current 
values to console, adding CORS rules, and clearing rules. And the syntax is easy enough for anyone to use:

```bat
scriptcs addCors.csx -- [storageAccount] [storageAccountKey] [origins]
```

ScriptCS runs also on [Mono](http://www.mono-project.com/), so you could even say this is cross platform. 
Not as good as Node or Go based solution would have been, but still good enough.  

Naming is the hardest part... this tool turned out to be just ["AzureCorsSetter"](https://github.com/teelahti/AzureCorsSetter).