---
layout: post
title:  "NoSQL databases in Java for storing List of String"
tags: [java, nosql]
categories: work
---

What we have is 2.5 GB file with some data, which should be parsed and saved with `unique key` = timestamp and `value` = all other parsed fields. 

I've tried different solutions:

# RocksDb (facebook)
Key and Value should be byte[]. That's it. So you need to write own wrapper, handle wrapping/boxing. Lot's of implementation which is not needed for this task.

# PalDB (LinkedIn)
Looks like some internal project - allows to store different format of data's but seems like that it does not support of simultaneous reading and writing of data and also it's not multi threaded. So you need to create a separate DbWriter and DbReader instance to access db and handle somehow it.

# MapDb 
__Greatest library ever__. It just maps your Collection class to a local drive. So my 2.5 GB collection was mapped into 2.4GB local file. Opening file takes seconds. Query times are also relatively small - around 20-30 ms. Not sure about production use cases, but for my goals it works great.