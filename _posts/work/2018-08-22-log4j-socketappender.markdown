---
layout: post
title:  "Log4j SocketAppender"
tags: [gnuplot, visualisation]
categories: work
---

So the task is to add [GrayLog][graylog] logging direction to product without any code/dependency changes.
Our product is using log4j v1 as main logging solution.

Googling shows that there is such thing as "SocketAppender" that writes logs to socket.

So the process of log transfer is split into 2 steps:

### Update log4j file - append our additional Socket Appender:

```
log4j.appender.server=org.apache.log4j.net.SocketAppender
log4j.appender.server.Port=18081
log4j.appender.server.RemoteHost=localhost
log4j.appender.server.ReconnectionDelay=10000

log4j.rootLogger=INFO, server
```

### Write a simple application that would receive this socket logs and would forward them further:

* Logger configuration:

```java
private static void configureLogger(String host, int port) {
    final GelfLogHandler logHandler = new GelfLogHandler();
    logHandler.setHost("tcp:" + host);
    logHandler.setPort(port);
    logHandler.setVersion("1.1");
    logHandler.setFacility("java-test");
    logHandler.setExtractStackTrace("true");
    logHandler.setFilterStackTrace(true);
    logHandler.setTimestampPattern("yyyy-MM-dd HH:mm:ss,SSSS");
    logHandler.setMaximumMessageSize(8192);

    logger = Logger.getLogger(ServerCleanJava.class.getName());
    logger.setLevel(Level.INFO);
    logger.addHandler(logHandler);
}
```

* Code to receive log messages and forward them

```java
final ServerSocket server = new ServerSocket(serverPort, 1000, InetAddress.getLoopbackAddress());

while (true) {
    try (Socket client = server.accept();
            ObjectInputStream ois = new ObjectInputStream(client.getInputStream())
    ) {
        Object input;

        while ((input = ois.readObject()) != null) {
            LoggingEvent myEvent = (LoggingEvent) input;

            if (myEvent.getThrowableStrRep() == null) {
                logger.log(getLogLevel(myEvent.getLevel()), myEvent.getMessage().toString());
                continue;
            }

            logger.logp(getLogLevel(myEvent.getLevel()),
                    myEvent.getLoggerName(),
                    myEvent.getThreadName(),
                    myEvent.getMessage().toString(),
                    new String[]{String.join("\r\n", myEvent.getThrowableStrRep())});
        }
    } catch (SocketException | EOFException ex) { /*EOF, nothing to do here */ }
}
}
```



[graylog]: graylog.org

