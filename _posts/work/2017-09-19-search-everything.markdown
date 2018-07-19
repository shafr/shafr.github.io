---
layout: post
title:  "Search everything - searching in Windows without indexing"
tags: [windows, tools]
categories: tools
published: false
---

Unlike Windows search - __search everything__ does not need to spend time indexing. It takes only few seconds to scan NTFS drive header and it's ready to search!

* To find a file, just type part of a name inside search bar: `pom.xml`
* To search inside some folder & subfolders: `path:C:\git\ pom.xml` 
* To exclude subfolders from search use `!` mark `path:C:\Mercurial !".hg" pom.xml` 
* To search for file contents use `content`: `pom.xml  content:junit`

Check out [official Website][official-website] to download `Search Everything` or go through [official documentation page][search-syntax] for more details.



[official-website]: https://www.voidtools.com/
[search-syntax]: https://www.voidtools.com/support/everything/searching/