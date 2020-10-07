---
layout: post
title: How to shoot yourself in the foot with an IoC container
description: "IoC containers are powerful but dangerous."
disqus_identifier: how-to-shoot-yourself-in-the-foot-with-an-ioc-container
modified:
tags: [performance, DI, IoC]
comments: true
share: true
---

In the project I recently worked for our solution's web interface froze every now and then. This problem had been going on for a while, but every time the problem went away by itself without any intervention. No problem, until the issue escalated even to developer workstations, making them slow.

## Investigation

The problem was easily pinpointed to be at the service layer (IIS WAS hosted). Investigation was started by adding more application pools, and immediately the responsiveness of the service increased. The main reason being that worker processes were restarted, but we did not know it then. Gladly we knew that this was not a fix, just a temporary cure, there was still something badly wrong.

So my coworker used some of his parallel Linq magic to create a denial of service test that targeted our service layer. Then we ran it... and our service died in 15 seconds on database connection pool problems. To check whether this really was a connection pool issue we increased connection pool size, but with no noticeable impact. Also, on some tests the service died immediately after 2 seconds. This was clearly not a connection pool problem.

Then we started to gather some performance data. We used performance monitor and resource monitor. Here is a screenshot from task manager presenting one server after a days use:

> Original image lost at some blog conversion, sorry. This image showed a _lot_ of threads on system.

Notice anything strange? Here is the situation after worker process were restarted:

> Original image lost at some blog conversion, sorry. This image showed a decent amount of threads on a system.

Clearly the amount of threads explodes during use. That was very strange since all our threads are managed by trusted Windows Process Activation Services. Except that we had some custom thread handling on one place only, a logger class called ThreadedLogger that calls (heavy) logging in a background thread, and manages those threads itself. This class was adapted from some good
[Stackoverflow answers](http://stackoverflow.com/questions/1181561/how-to-effectively-log-asynchronously)):

```csharp
public abstract class ThreadedLogger<T> : IDisposable
{
    private Queue<action> queue = new Queue<action>();
    private ManualResetEvent hasNewItems = new ManualResetEvent(false);
    private ManualResetEvent terminate = new ManualResetEvent(false);
    private ManualResetEvent waiting = new ManualResetEvent(false);

    private Thread loggingThread;

    protected ThreadedLogger()
    {
        this.loggingThread = new Thread(new ThreadStart(this.ProcessQueue));
        this.loggingThread.IsBackground = true;

        // This is performed from a bg thread, to ensure
        // the queue is serviced from a single thread
        this.loggingThread.Start();
    }

    // ...
}
```

As seen from above, this class creates a new background thread and manages it by itself.
This is intentional, because this is the only way to use a background thread without WCF
or IIS ripping it down when the primary thread completes. Ironically this was implemented
to increase performance. Reading the code back and forth I did not find any bugs that would
explode the amount of threads. Well, it turned out that this code is almost perfect; the
reason was how the code was instantiated.

When service or web site starts, logger is registered into an IoC container:

```csharp
container.RegisterType<ILogger, LoggerFacade>();
```

Then the logger is taken into use through dependency property or constructor injection:

```csharp
[Dependency]
public ILogger Logger { get; set; }
```

Nice and easy? Except that was a perfect way to shoot yourself in the foot with an inversion of control container. Now every time this dependency is resolved a new thread is started, and that thread is never disposed. Since most of the dependencies are registered with RegisterType() instead of RegisterInstance(), it had been used also for the logger without any further thought.

The fix?

Nice and easy: just changed the registration of logger class to singleton. This is the
good part of IoC containers: they provide a Single Point of Fixâ„¢ for this kind of issues:

```csharp
container.RegisterType<ILogger, LoggerFacade>(
    new ContainerControlledLifeTimeManager());
```
