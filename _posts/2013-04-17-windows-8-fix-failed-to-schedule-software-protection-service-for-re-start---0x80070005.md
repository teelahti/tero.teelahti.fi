---
layout: post
title: "Windows 8 fix: Failed to schedule Software Protection service for re-start - 0x80070005"
description: "Fixing an annoying Windows issue."
permalink: /blog/windows-8-fix-failed-to-schedule-software-protection-service-for-re-start---0x80070005
disqus_identifier: windows-8-fix-failed-to-schedule-software-protection-service-for-re-start---0x80070005
modified:
tags: [windows, fix]
comments: true
share: true
---

I have had some weird problems on my Windows 8 laptop, and while fixing those 
I noticed a recurring Error event on my event log:

> "Failed to schedule Software Protection service for re-start at 2113-03-24T10:21:45Z. Error Code: 0x80070005." (Source: Security-SPP, Event ID: 16385)

0x80070005 is a permission denied error. After some searching and trial/error I found 
the fix from a [Technet forum post](http://social.technet.microsoft.com/Forums/en-US/winserver8gen/thread/51432342-0d53-4ab4-b366-2482f95279ff/); 
Give Network service account full access control rights to the directory:

```bat
%systemroot%\System32\Tasks\Microsoft\Windows\SoftwareProtectionPlatform
```

This fixed the situation immediately. Hope this helps someone else.