---
layout: post
title:  "VS code goodies for working with text"
tags: ["vs code", "peek"]
categories: life
---

I've been preparing for my CSSLP exam, that involved lots of reading & taking notes.
Here I wanted to share some tools or techniques that I had found that might help someone.

### Vs code markdown image paste plugin
Each time you take screenshot - you can simply press key combination and it would paste image in the folder & create markdown link.

[Plugin marketplace url](https://marketplace.visualstudio.com/items?itemName=mushan.vscode-paste-image)

You'll need to update location of where images would be stored for convenience:
```
  "pasteImage.path": "${projectRoot}/assets/images/",
```
& Hotkey combination. Mine is bind to `CTRL+ALT+V`.

![Image insertion demo](/assets/2022-03-31/image-insertion.gif)

### Join Lies
When pasting text sections form books most often they are pasted as unformatted multi-line code. So either you should manually merge them by removing end line separators .

`CTRL+SHIFT+J` to merge lines. I would re-bind that to `CTRL+SHIFT+Q` so it can be reached with one hand without looking at keyboard.

### VS code workspace-specific configuration
So VS code has user & workspace configuration. If you know that in this workspace you would be only doing text-based work, some of development features can be disabled. You can sync this workspace settings along with the code/text from repository.

So for example, things that are distracting in text-editing mode"
* line numbers
* minimap
* all whitespaces

```conf
{
    "editor.glyphMargin": false,
    "editor.minimap.enabled": false,
    "editor.lineNumbers": "off",
    "files.trimTrailingWhitespace": true,
    "editor.renderWhitespace": "trailing"
}
```

![Vs settings demo](/assets/2022-03-31/vs-code-settings.gif)

Unfortunately you cannot disable plugins in this config file.

### Gif Creation
I recently found tool called `peek` on Linux.
Creating gif's was never that easy.
Just choose section of screen, hit record & it will capture footage in .gif format.

No gif demo here, I haven't figured out how to capture gif from gif creation :)