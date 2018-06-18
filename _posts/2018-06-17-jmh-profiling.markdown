---
layout: post
title:  "After Profiling is done or JMH Microbenchmark in action"
tags: [java, performance, jmh]
categories: performance
---

Which method is faster, when reading single 5mb file?
```java
public static String readFileContents1(Path pathToFile){
    return new Scanner(pathToFile).useDelimiter("\\Z").next();
}

public static String readFileContents2(Path pathToFile){
    return new String(Files.readAllBytes(pathToFile));
}
```

* How much faster ? 
* How fast would it be during multi-thread calls, with a big input files?
* Are there any limitations in moder os or performance drawbacks that would slow this process ? 


Another one, since java8 is around for a while - getGroupDir has around 80 files, 100K each :
```java
public List<String> method1() throws IOException {
    List<String> singleIds = new ArrayList<>();

    for (File groupFile : fileHandler.getGroupDir().toFile().listFiles()) {
        String groupFileContents = FileHandler.readFileContents(groupFile.toPath());
        Collection<String> results = extractLinks(groupFileContents);
        singleIds.addAll(results);
    }

    fileHandler.saveSingleIdsToFile(singleIds);
    return singleIds;
}
```
```java
public List<String> method2() throws IOException {
    List<String> singleIds =
            Files.list(fileHandler.getGroupDir())
                    .map(file -> readFileContents(file.toFile()))
                    .filter(s -> !s.isEmpty())
                    .map(this::extractLinks)
                    .flatMap(Collection::stream)
                    .collect(Collectors.toList());

    fileHandler.saveSingleIdsToFile(singleIds);

    return singleIds;
}
```
```java
public List<String> method3() throws IOException {
    List<String> singleIds =
            Files.list(fileHandler.getGroupDir())
                    .parallel()
                    .map(FileHandler::readFileContents)
                    .map(this::extractLinks)
                    .collect(ArrayList::new, List::addAll, List::addAll);

    fileHandler.saveSingleIdsToFile(singleIds);

    return singleIds;
}
```

The answer is - __JMH__

# Here is results from profiling execution:
```
Benchmark Mode  Cnt   Score   Error  Units
method1   avgt   40  41.099 ± 1.433  ms/op
method2   avgt   40  43.211 ± 3.390  ms/op
method3   avgt   40  39.395 ± 0.808  ms/op
```
(No much differnece, who would thought ?)

```
Benchmark          Mode  Cnt    Score   Error  Units
readFileContents1  avgt   40  102.399 ± 7.475  ms/op
readFileContents2  avgt   40   10.083 ± 0.426  ms/op
```
(Huuuge x10 diference on reading each file contents)


There are also some goodies that can be used with JMH:
* [Gradle plugin][gradle-plugin] 
* [TeamCity plugin][teamcity-plugin]



[gradle-plugin]: https://github.com/melix/jmh-gradle-plugin
[teamcity-plugin]: https://github.com/presidentio/teamcity-plugin-jmh