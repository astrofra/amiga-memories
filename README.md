# Amiga Memories

_A walk along memory lane_ (An automatic review generator)

![splash screen](img/am-splash.png)

## How does Amiga Memories work?

Amiga Memories is a project that aims to make video programmes that can be published on the internet. The images and sound produced by Amiga Memories are 100% automatically calculated.

## The script

An Amiga Memories video is mostly based on a narrative. The purpose of the script is to define the spoken and written content. The spoken text will be read by a voice synthesizer (Text To Speech or TTS), the written text is simply drawn on the image as subtitles.

A typical script would look like this:

```cpp
{	
	text	= "Hidden in the dezzert, are a people known as the Fremen!",
	sub	= ["Cachés dans le déserts vit un peuple du nom de Fremen..."],
	led	= [{power = 1, drive = 0}, {power = 1, drive = 1}], 
	camera	= {name = "right_close", motion = "PanLeft"}	
}
```

Here, in addition to the spoken & written narration, the script controls the camera movements as well as the LED activity of the computer.

## The video

Amiga Memories' video images are computed by the GameStart 3D engine (pre-[HARFANG 3D](https://github.com/harfang3d/harfang3d)). Although the 3D assets are designed to be played back in real time with a variable framerate, the engine is capable of breaking down the video sequence into 30th or 60th of a second, as TGA files.

![TGA files](img/frame-sequence.jpg)

By default, the images are generated in 720p to be assembled into a video stream ( H264 for example).

## The audio

The audio is mainly voice-over, produced by the voice synthesizer, or Text To Speech (TTS). Amiga Memories uses the open-source [MaryTTS project](http://mary.dfki.de/), developed at the [German Research Center for Artificial Intelligence](https://www.dfki.de).

## Audio video synchronisation

Once the sequence has been fully rendered, Amiga Memories exports an edit list in text format which links the various audio media needed by the project. This file lets you produce the full audio mix, in sync with the image sequence.

The Amiga Memories edit list uses the Samplitude format, and can be reviewed and remixed without any modification by tools like Reaper/Cockos.

![audio track](img/audio-generator.jpg)

The remix is then exported as a single WAV file, to be mixed with the final video.

## Assembling a video

Image/sound mixing is not handled by the Amiga Memories SDK.

From the TGA sequence and the exported WAV audio, it is possible to compress a final AVI file in a few clicks, using VirtualDub or MP4 with FFMPEG.





