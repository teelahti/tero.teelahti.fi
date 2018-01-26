---
layout: post
title: Mass convert WMA files to MP3's
description: "Making a second copy of your lossless WMA files for mobile devices."
modified:
tags: [powershell, media]
comments: true
share: true
---

I've always been a music fan. Not a die-hard-fan, but one with lots of music and decent equipment. During the era of CD's, I routinely bought new discs, and they accumulated in hundreds. And then hard disk prices fell and network speeds grew, and I wanted to digitize all I had. This was years ago, maybe around year 2004. I wanted everything in lossless format, as digitizing was slow and I was not going to do it again. "Alternative" media format (.flac, .ogg) support was poor in Windows world, and I chose [lossless windows media audio (WMA)](http://en.wikipedia.org/wiki/Windows_Media_Audio_9_Lossless). I spent many evenings changing the disc on my laptop, and typing album and track names when they were not automatically found from media info databases. 

Fast forward almost ten years, and I have to admit I made a wrong decision: lossless WMA support is not on all devices and music servers I need. [Plex Media Server](https://plex.tv/) is the one I would need the support most, as I use it to serve all our family media to all connected devices. It became evident, that I need a copy of my lossless audio library in some other format. I decided, that this copy can be in lossy format so that it would be easier to copy to offline devices, like my car's radio system. And as the format needed to be something that was ubiquitously supported, I went for MP3. Luckily I found [a blog post by GeoffBa](http://geoffba.blogspot.fi/2011/04/converting-from-wma-to-mp3.html) that automated this task in PowerShell. I made some changes so that I can re-run the script to keep lossless and lossy folders synchronized. The script I used is attached below; I have used it about a year already without a glitch. I hope it helps someone else in my situation. 

```PowerShell
# Convert WMA files to MP3
# Creates new mirrored folder structure
# 
# Adapted from: 
# http://geoffba.blogspot.fi/2011/04/converting-from-wma-to-mp3.html
 
$tool = '"C:\Program Files (x86)\WinFF\ffmpeg.exe"'
$succescounter = $failurecounter = 0
$sourceFolder = 'M:\Media\Music'
$targetFolder = 'M:\Media\MusicMP3'
$failedConversions = New-Object "System.Collections.Generic.List``1[System.String]"

# Start by copying all source files that are already mp3 or flac
echo "Copying all files that are already in correct format"
Invoke-Expression "& robocopy $sourceFolder $targetFolder *.mp3 *.flac *.jpg *.jpeg /e"

# Find .wma files and iterate through the folders recursively
foreach ($child in $(Get-ChildItem $sourceFolder -include *.wma -recurse))
{
    $wmaname = $child.fullname
     
    # Create name for target file.
    # Note that the function is case-sensitive so we handle that first.
    $wmaname = $wmaname.Replace("WMA","wma")
    $mp3name = $wmaname.Replace("wma","mp3")

	# Change target folder
	$mp3name = $mp3name.Replace($sourceFolder,$targetFolder)
	$newFileDirectory = $child.Directory.FullName.Replace($sourceFolder,$targetFolder)
	
	# Do nothing if target file already exists
	if (!(Test-Path -literalpath $mp3name)) 
	{	
		# Create target directory if it does not exist
		if (!(Test-Path -literalpath $newFileDirectory))
		{
			New-Item -ItemType directory -Path $newFileDirectory
		}
	 
		# The argument string that tells ffmpeg what to do...
		$arguments = '-i "' + $wmaname + '" -y -acodec libmp3lame -threads 0 -ab 160k -ac 2 -ar 44100 -map_metadata:g 0:g "' + $mp3name + '"'
		echo ">>>>> Processing: $mp3name"
		Invoke-Expression "& $tool $arguments"
	 
		# Lets see what we just converted, did everything go OK?
		$mp3file = get-item -literalpath $mp3name
	 
		# if conversion went well the mp3 file is larger than 0 bytes
		if ($mp3file.Length -gt 0)
		{
			echo "<<<<< Converted $wmaname"
			$succescounter++
		}
		else
		{
			echo "<<<<<< Failed converting $wmaname"
			Remove-Item $mp3name       
			$failedConversions.Add($wmaName)
			$failurecounter++
		}
	}
}
 
# We are done, so lets inform the user what the succesrate was.
Echo "Processing completed, $succescounter conversions were succesfull and $failurecounter were not."

if ($failureCount -gt 0) 
{
	echo "List of failed files:"
	echo $failedConversions
}
```