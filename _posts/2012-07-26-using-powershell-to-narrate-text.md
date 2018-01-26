---
layout: post
title: Using PowerShell to narrate text
description: "Making a speak-command for powershell."
permalink: /blog/using-powershell-to-narrate-text
modified:
tags: [powershell, fun]
comments: true
share: true
---

I visited [NDC 2012](http://www.ndcoslo.com/) and enjoyed the conference a lot. Again. 
Awesome speaker lineup without too much product group advertisements. Lots of thought 
provoking lessons. Lots of fun tongue-in-the-cheek style stuff in between. Like 
[Damian Edwards](http://damianedwards.wordpress.com/) and 
[Rob Conery](http://wekeroad.com/) "fighting" each other with 
[SignalR](https://github.com/SignalR/SignalR) and [Socket.io](http://socket.io/), 
respectively (video [here](http://vimeo.com/43676938)). On that cage match Rob used a 
cool narrator from command line (they used narrators since Damian had lost his voice), 
and for some reason that fascinated me.

My first thought was that this must be possible in Windows (without all the nice effects 
and only an official sounding voice). And I was right: PowerShell does the trick since it 
can easily reference [SpeechSynthesizer](http://msdn.microsoft.com/en-us/library/ms596245) 
class. At the end of this post is the complete PowerShell script I used. To make usage easier 
I also added an alias creation into my Profile.ps1:

```PowerShell
New-Alias Speak $HOME\Documents\WindowsPowershell\Speak.ps1
```

With this setup I can narrate text and optionally give any installed voice to the narrator. E.g.

```PowerShell
C:\>Speak “Speak this”
```

Here is the PowerShell script Speak.ps1:

```PowerShell
# Create the text to speak (with default)
$text = "Hello world";
if ($args.Length -ge 1) 
{
    $text = $args[0];
}
[System.Reflection.Assembly]::LoadWithPartialName("System.Speech") | out-null
$spk = New-Object System.Speech.Synthesis.SpeechSynthesizer
# Change voice if instructed
if ($args.Length -eq 2) 
{
    # Check that voice exists
    ForEach ($voice in $spk.GetInstalledVoices()) 
    {
        if ($voice.VoiceInfo.Name -eq $args[1]) 
        {
            $spk.SelectVoice($args[1]);
        }
        else 
        {
            # Try longer system name
            $fromShortName = "Microsoft " + $args[1] + " Desktop"
            if ($voice.VoiceInfo.Name -eq $fromShortName) 
            {
                $spk.SelectVoice($fromShortName);
            }
        }
    }
}
$spk.SpeakAsync($text)
```