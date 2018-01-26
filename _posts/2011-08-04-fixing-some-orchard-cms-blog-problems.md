---
layout: post
title: Fixing some Orchard CMS blog problems
description: "Orchard CMS (the engine behind this blog) had some bugs on the archive module. Debugging and fixing those."
permalink: /blog/fixing-some-orchard-cms-blog-problems
disqus_identifier: fixing-some-orchard-cms-blog-problems
modified:
tags: [orchard]
comments: true
share: true
---

## Blog archives part not working when blog is the site home page

When you create a new blog in [Orchard CMS](http://orchardproject.net/) and set it to be 
the home page blog archives list (part) refuses to display anything. Reason for this seems 
to be that Orchard database table called Orchard_Blogs_BlogArchivesPartRecord has a column 
called BlogSlug, and it defaults to “blog” even though blog is the home page (i.e. slug = ""). 
A clear bug, but I didn’t want to wait for a fix and just changed the value to null, and 
list of archived blog posts came to life.

Here is the SQL I used, note that the Id is specific to my scenario, if you use this change 
it to your blogs Id:

```sql
UPDATE       Orchard_Blogs_BlogArchivesPartRecord
SET          BlogSlug = NULL
WHERE        (Id = 25)
```

## Windows Live Writer + Orchard messes created and published dates

When you create blog posts with Windows Live Writer and put a historical Post date to the post, this date will end up being the created date, and published date will be the date of writing. This affects e.g. RSS feed and archives list. I just moved 95 blog posts from years 2003-2011 to a new blog and my archives list looked like this after beforementioned BlogSlug fix:

<figure>
	<img src="/images/2011-09-04-image1.png" alt="Wrong archive count">
</figure>

Not exactly what I was after. Time for another fast hack SQL; again, Container_id 
is specific to my DB, don’t just blindly run this on your DB:

```sql
UPDATE       Common_CommonPartRecord
SET          PublishedUtc = CreatedUtc
WHERE        (Container_id = 8)
```

Now blog posts have correct times. This does not immediately fix the issue: 
Orchard seems to update archive list e.g. when next blog post is created. I 
created a dummy post and removed if, and now my archive looks correct:

<figure>
	<img src="/images/2011-09-04-image2.png" alt="Correct archive count">
</figure>

…except that current year displays empty, but that probably is an issue with the 
theme and needs some more attention in the future.