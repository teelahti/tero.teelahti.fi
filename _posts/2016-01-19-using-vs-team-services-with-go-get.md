---
layout: post
title: Using VS Team Services with go get
description: "Go has only one way of referencing packages, and it is not evident howto do that with Visual Studio Team Services"
modified:
tags: [go]
image: 
comments: true
share: true
---

I use [VS Team Services](https://www.visualstudio.com/products/visual-studio-team-services-vs) 
for some of my repositories. I use the Git repository type, and most of the time 
everything works fine. Until today I reorganized some of my [Go](https://golang.org/) 
code to be more idiomatic, meaning that I leverage the native Go package system as it 
is designed: the only way to reference packages is by their full repository URL:

```go
package main

using (
    "myorg.visualstudio.com/DefaultCollection/_git/MyRepo"
)
```

and you can also load packages with Go get command, like:

```bash
go get myorg.visualstudio.com/DefaultCollection/_git/MyRepo
```

I can (barely) live with the fact that VS Team Services adds the unnecessarily ugly 
"DefaultCollection" and "_git" in to the URL. But the real problem is that the above 
doesn't work with go cmd, you just get very misguiding message:

> package myorg.visualstudio.com/DefaultCollection/_git/MyRepo: 
> unrecognized import path "myorg.visualstudio.com/DefaultCollection/_git/MyRepo"

Adding the verbose flag (-v) to the command gives one extra tidbit of information:

> Parsing meta tags from https://myorg.visualstudio.com/DefaultCollection/_git/MyRepo?go-get=1 (status code 203)
> import "myorg.visualstudio.com/DefaultCollection/_git/MyRepo": 
> parsing myorg.visualstudio.com/DefaultCollection/_git/MyRepo: 
> http: read on closed response body

My first guess was an authentication issue, and making a curl request for the address 
supported my guess as it was an authentication redirect. But Go uses Git internally, 
and git clone worked. I couldn't find this issue anywhere related to VS Team Services 
(maybe gophers don't use it?), but I found a same issue for Gitlab. It turned out, that 
neither Gitlab or VS Team Services adds automatically the .git ending to the URL, and 
therefore go get command never reaches the actual repository. This is fixed in Gitlab 
since, but issue remains in VS Team Services. The fix is to make the URL even uglier: 

```go
package main

using (
    "myorg.visualstudio.com/DefaultCollection/_git/MyRepo.git"
)
```

and the corresponding go get command:

```bash
go get myorg.visualstudio.com/DefaultCollection/_git/MyRepo.git
```

I hope this helps someone else to fix the problem quicker. 