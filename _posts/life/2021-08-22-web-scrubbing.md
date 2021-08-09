---
layout: post
title:  "Scrubbing Car websites for statistics"
tags: [life]
categories: life
---

I would like to share how to get data from any (unless web developers decided to make it really obscure for everyone ) web page. 

I'll be using chrome browser + TamperMonkey plugin.

## TLDR:
you can find examples in the [separate repo](https://github.com/shafr/cars) + [github-hosted page](https://shafr.github.io/cars/)

## Preparation phase
Save web page that you would like to locally.
Open html source code and remove all `<script>` tags

Add 
```
<script src = "https://code.jquery.com/jquery-3.4.1.min.js" ></script>
``` 
to `head` tag.


Open page in broser, check that Jquery is there using command:

```
$().jquery
```

If no error appears & you see version of Jquerry - you are ready for scrubbing!

This would allow you to run jquerry querries in console & test your requests.


## Few words about jquery methods
So main goal is to find either `.class` field under the tag or specific tag, or specific order of tag, so selection is possible.

Below are some examples that might help in fetching data:

```
$(item).find(".classname")                //Contents under .classname
$(item).find(".classname:first")          //First element with .classname
$(item).find(".classname:nth-child(3n)")  //3rd item with .classname
$(item).find(".classname > div")          //div tag contents under .classname
$(item).find(".classname").attr('href')   //attribute href under .classname
```
 
Note - that you have to add `.text()` at the end of query to convert from jQuery into text.

## Implementation

Now go fishing for items. Most often they are stored under one parent or have same `class` name.:

```
var elements = $(".list_parent_class .subitem_class")
or if no parent defined:
var elements = $(".subitem_class")
```

After that we'll itterate over all items like this:

```
$(elements).each((index, item) => extractAllFields(item));
```

Method extractAllFields would contain code that would match selectors and store them in variables :
```
function extractAllFields(item) {
     let nameField=$(eachOrder).find(".headline-block").text().replace(/\s\s+/g, ' ')
     ...
}
```

Result would be stored in the object & after that in the list:

```
var results = [];

let result = {
    name: nameField
    km: <>
    year: <>
    ...
}

results.push(car);
```

Final step - putting result in the clipboard:

```
GM_setClipboard(JSON.stringify(cars));
```

So you'll end up with clipboard with JSON 


## TODO's and TODONT's
* pagination - so it would automatically expand all pages that were found for querry.
* onLoad script running is not the greatest idea - probably button to run scrubbing would be better
* progressbar that would show progress of loading page 
