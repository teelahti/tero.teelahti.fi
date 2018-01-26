---
layout: post
title: How to change your Outlook default calendar
description: "Outlook default data file settings are a mess. Finally found a way to change the calendar that is shown on the todo-pane."
modified:
tags: [tools]
comments: true
share: true
---

Since Office 2013 was launched, I've had some problems with Outlook and account settings: I can set up all the accounts, but Outlook refuses to display my default Exchange calendar on the todo-pane, and instead shows an empty calendar from one of the other accounts that I use for email only. I like the todo-pane as its easy to glance whats coming with it. I've searched for resolution a couple of times, and most Microsoft community answers suggest to change the default data file on via Outlook > Account Settings:

![Outlook default data file settings](/images/2014-08-06-outlook-default-data-file.PNG)

Unfortunately changing that setting back and forth does not affect what's shown on the todo-pane; I already had my Exchange account as default. Next suggestion I found was to change the same setting via Windows Control Panel's mail section: 

![Control panel mail settings](/images/2014-08-06-control-panel-mail-settings.PNG)

...but that was exactly the same setup than the previous one done via Outlook, nothing changed. Out of curiosity I decided to check what's under the mail profiles section. 

![Control panel mail profiles](/images/2014-08-06-control-panel-mail-profiles.PNG)

And from there I hit properties, and under properties you can find yet another data file selection dialog. Changing this data file under the profile finally changed my Outlook's default calendar. Shouldn't be this hard. 

<figure class="half">
	<img src="/images/2014-08-06-control-panel-mail-profiles-setup.PNG" alt="Control panel mail setup for a profile">
	<img src="/images/2014-08-06-control-panel-mail-profiles-default-data-file.PNG" alt="Default data file for a profile">
	<figcaption>Yet another place to set the default Outlook data file.</figcaption>
</figure>

