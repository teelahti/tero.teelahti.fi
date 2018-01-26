---
layout: post
title: Techdays 2013 – SignalR
description: "Recap of my SignalR presentation at Finnish Techdays 2013."
permalink: /blog/techdays-2013-signalr
modified:
tags: [web, SignalR, presentation]
comments: true
share: true
---

A week ago we had [Microsoft TechDays 2013](http://www.techdays.fi/) at Finlandia Hall, 
Helsinki. For me this was fifth year in a row talking at Finnish Techdays; once I have 
talked about Azure, all the other talks have been about web technologies and trends. 
This time was no exception: I talked about real time web need and patterns, and about 
[SignalR](http://signalr.net/) as one implementation tool. I enjoyed talking, and I 
hope I provoked at least some of the 200 listeners to think beyond the traditional 
HTTP Request/Response pattern 
we use to build web apps.

Talk was recorded, the [video is available at Youtube](http://www.youtube.com/watch?v=eWe1uO0ZnHg). 
My slides (in Finnish) are [here](/attachments/TechDays_2013 Tero Teelahti - SignalR.pptx).

## Demos

I showed four demonstrations about different SignalR and general real time web concepts. 
All demo sources are available online, links below.

### Demo 1: Broadcasted HTML canvas drawing

First demo’s objective was to demonstrate what it takes to transform a simple drawing 
canvas to be collaborative: everyone can draw on the same canvas as all actions are 
broadcasted to all participants. More detailed explanation and 
[sources are at GitHub](https://github.com/teelahti/TD2013SignalRReplication). The fun 
part (for me) in this demo was, that I spent hours on “good enough” canvas drawing 
and broadcasting implementation, and only after I was done I noticed that SignalR 
samples project has a near identical [DrawingPad sample](https://github.com/SignalR/SignalR/tree/master/samples/Microsoft.AspNet.SignalR.Hosting.AspNet.Samples/Hubs/DrawingPad).

### Demo 2: Server side event visualization

In this demo I showed a specific use case of visualizing frequently changing server side 
data at browser. This could be amount of any business events, state of the runtime platform, 
amount of messages flowing in message bus, etc… My demo had “CPU” and “Network” graphs, 
although the data was random. This demo also included connecting other clients than 
browsers to the same data source: I created a command prompt visualizer that displayed 
exact same data than the web site graph. Full demo source and detailed explanation 
[available at GitHub](https://github.com/teelahti/TD2013ServerVisualization). 

<figure>
	<img src="/images/2013-03-12-image1.png" alt="Web UI showing realtime graph.">
    <figcaption>Web UI showing realtime graph.</figcaption>
</figure>


<figure>
	<img src="/images/2013-03-12-image2.png" alt="Command line UI showing the same realtime data.">
    <figcaption>Command line UI showing the same realtime data.</figcaption>
</figure>

### Demo 3: Store & forward + pub/sub between browser and server

This demo went farther into web sockets usage patterns. Main objective of this demo was to 
demonstrate what kind of infrastructure is needed to store commands at browser before 
pumping them into server in the background. This concept is very useful over slow networks. 
[More information and source at GitHub](https://github.com/teelahti/TD2013JSBus). After 
TechDays I extracted the JavaScript bus code from the demo to a 
[separate GitHub repository](https://github.com/teelahti/JSBus) and a 
[set](http://nuget.org/packages/JSBus/) of [NuGet](http://nuget.org/packages/JSBus.SignalR/) 
[packages](http://nuget.org/packages/JSBus.SignalR.Sample/). A separate blog post about this library will follow.

### Demo 4: Long running UI tasks concept

This demo finished the JavaScript bus (demo 3) concept by showing how it could be used in 
a very normal business application scenario: user selects multiple items from a list 
and sends them all at once to server for processing. I’ve seen many (failed) 
implementations, where developers spend lots of time honing last milliseconds off 
the operation to prevent timeouts or to match non-func requirements… and then someone 
selects even more items from the list and files another bug about the operation being 
too slow. The real solution is of course to do split list operation into a set of 
separate one item operations, and do everything in the background.

<figure>
	<img src="/images/2013-03-12-image3.png" alt="Long running UI operation two phase commit message pump.">
    <figcaption>Long running UI operation two phase commit message pump.</figcaption>
</figure>

This is not trivial: there are UX issues to be taken care of, designing commands 
to (almost) always succeed takes lots of thought, and ensuring commands are never 
lost (idempotence, living without transactions) is challenging (and fun). My 
demo gives some building blocks how this can be done over the web. Full source 
[available here](https://github.com/teelahti/TD2013LongRunningTasks).