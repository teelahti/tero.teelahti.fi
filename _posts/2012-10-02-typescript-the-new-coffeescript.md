---
layout: post
title: TypeScript, the new CoffeeScript?
description: "Discussing the future of TypeScript."
modified:
tags: [javasript, typescript]
comments: true
share: true
---

Today Microsoft’s Anders Hejlsberg [introduced](https://channel9.msdn.com/posts/Anders-Hejlsberg-Introducing-TypeScript) 
[TypeScript](http://www.typescriptlang.org/), which basically is a language that 
compiles into JavaScript, very similar to [CoffeeScript](http://coffeescript.org/). 
There are some differences, though: whereas CoffeeScript tries to make writing JavaScript 
very brief and removes lots of {}-stuff from the language, TypeScript tries to create 
an efficient type system on top of JavaScript.

I have tried to approach CoffeeScript a couple of times, but every time using it for real has had lots of doubts:

- New syntax to learn, both myself and other team members
- New tooling needed
- Debugging story not that good (although getting better)
- Will it fly? Do I need to roll back to JS in a year or two?

Overall I have not felt that the benefits would outnumber the drawbacks.

My first feelings with TypeScript are very similar to above; I still have 
great doubts about the future of this language, but some aspects are better: 
overall the syntax is very JavaScript-like, and as I have a C# background I 
could easily dive into TypeScript. Even more importantly: the tooling seems 
to be great from day #1 and I’m sure it will get even better. Other smart 
moves from Microsoft are: [TypeScript is open sourced](http://typescript.codeplex.com/), 
it has Node.js support right out of the box, and it has the best sponsor there 
is for a new language, [Anders Hejlsberg](http://en.wikipedia.org/wiki/Anders_Hejlsberg). 

I do not see myself writing any apps in TypeScript, at least not in a while, 
but I will follow the project very closely and play with it every now and 
then. You never know, it might even fly – especially if the community gets 
over the fact that TypeScript is Microsoft-initiated.