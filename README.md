# cvrf-intercom-tool

This is a tool for creating Black Mesa-style announcements using audio spliced from the game's announcer files (not the VOX, but rather the female announcer used before the HECU takeover). This tool was made to allow easier creation of announcements for CVRF, but anyone is free to use and contribute to it.

![Screenshot](https://i.imgur.com/8XBJZhq.png)

# How to use

Writing an announcement requires entering words into the text box that are present in the tool's IntercomAssets file. There is a collection of around 160 files present in this build (excluding `*.import` files), and more can be added by importing to the project and re-building.
If a word (file name) is present in the assets folder, it will be colored green in the text box.

As well as this, you can use a colon symbol (:) immediately after a word to add a delay. The length of this delay is configurable on the interface, but by default is 200 ms. The example announcement shown in the screenshot is:

```
warning: anomalous energy field detected on: level 5: all personnel evacuate immediately
```

By pressing the preview button, the tool will play a login tone first (which is configured with the "Emergency announcement?" checkbox), followed by the sequence of words you give it, adding extra delays after a word based on if a colon is placed at the end.

### Saving recordings

Saving a recording simply involves supplying a file name (if left untouched, it will default to the current unix timestamp which may be confusing) and pressing the "Record to File" button. The announcement will play, similar to the preview button, but will now record the output to a .wav file in the `Recordings` folder of the tool's working directory.

In the future, I'd like to have support for automatically converting the output .wav files to other formats, but have not found a good solution for that as of yet.

### Note: File names

* Some words are combined into a single file because they were unable to be spliced apart seamlessly. Currently, those files are: ``isnow``, ``networkteam``, and ``testlab``. Use those file names if looking for the phrases ``is now``, ``network team``, or ``test lab``.

* The files in the base release do not include names that were present in the original announcer lines. These may be included some time in the future.

* You can manually play announcement login sounds using the following as words in you announcement text: ``_login_normal``, ``_login_emergency``, ``_split_normal``, and ``_split_emergency``.



# Download

The tool can be downloaded on this repo's [Releases](https://github.com/the-sink/cvrf-intercom-tool/releases) page.
