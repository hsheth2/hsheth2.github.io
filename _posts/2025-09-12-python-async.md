---
layout: post
title: "Python async: a step in the wrong direction"
---

I recently read “[Python has had async for 10 years \-- why isn't it more popular?](https://tonybaloney.github.io/posts/why-isnt-python-async-more-popular.html)” and the [ensuing discussion](https://news.ycombinator.com/item?id=45106189). To summarize the post, async has struggled because:

1. Network IO can be made async but file IO is not.
2. Many operations that are not GIL-blocking are event loop-blocking, meaning threads have a leg up. In fact, many async programs still end up heavily using thread pools.
3. Conversely, it’s also extremely easy to accidentally block the event loop.[^1]
4. Async requires a full parallel universe of APIs and libraries and it’s tricky to maintain both.

These are all valid and compelling arguments for why `asyncio` hasn’t been adopted in leaps and bounds. But if we take a step back, I’d claim there’s a deeper reason: **async was a step in the wrong direction from a language design perspective**.[^2]

`async` was initially added to reduce the callback craziness of stuff like Twisted while being possible to retrofit into the language. It was successful with this \- blocking is fundamentally easier than callbacks[^3] \- but caused new problems along the way.

After having used a variety of languages and concurrency flavors, I’ve developed the following opinions:

1. The `async` keyword isn’t worth it.
2. Structured concurrency should be the core coordination mechanism.
3. For Python, `gevent`’s approach was mostly right all along.

## Can we get rid of async?

Every language that introduces an `async` keyword necessarily runs into the [function coloring](https://journal.stuffwithstuff.com/2015/02/01/what-color-is-your-function/) problem, where a single use of async spreads like a virus and infects the rest of the codebase. Function coloring means that it’s difficult to adopt async incrementally. It also splits the ecosystem, forcing library developers to either pick a side or maintain parallel APIs.[^sans-io]

[^sans-io]: Stuff like [Sans-I/O](https://sans-io.readthedocs.io/) is billed as a solution, but I think it's just emblematic of the problems `async` causes.

I’d argue that JavaScript is the language with the most ergonomic async design. A big part of its success is that (1) the language already had an event loop and used callbacks heavily and (2) the Promises API made it easy to bridge between callbacks and promises. In other words, they were uniquely set up to provide some mitigations for function coloring.

If we broaden our scope from async to overall approaches to concurrency, Go is the clear winner on ergonomics. There are no `async` or `await` keywords; when you want a function to run concurrently, write `go myfunc(...)` and the runtime will run it in a separate green thread (aka goroutine). As a developer, I don’t need to know the details of how these goroutines are scheduled or how many OS threads we have \- the abstraction allows me to ignore these details.

```go
package main

import (
    "fmt"
)

func myfunc(s string) {
    fmt.Println(s)
}

func main() {
    go myfunc("runs in a goroutine!")
    // ... other code
}
```

**Go had two critical insights**:

1. If the runtime can ensure that a function yields back to the scheduler whenever it does something blocking, good things happen. Specifically, you don’t need the `async` keyword at all and hence sidestep the function coloring problem entirely. Second, it becomes impossible to block the event loop.[^4]
2. Concurrency should be a call-site choice, not an attribute of the called function.[^5]

Of course Go had the flexibility of being a newer language that could bake these ideas into the runtime. Everyone else had to deal with backwards compatibility concerns.

### Aside: “but explicit yield points are valuable”

One of the other arguments in favor of async is that the program will only switch to other tasks at specific yield points, and therefore is easier to reason about than threads or green threads. “[Unyielding](https://glyph.twistedmatrix.com/2014/02/unyielding.html),” written by the founder of Twisted, makes this argument most coherently.

I disagree with that argument: while it’s true that concurrency is hard to get right, I don’t think explicit yield points make it that much easier. In all but the simplest scenarios, you still need shared data structures and locks. Armin Ronacher elaborates on this idea in “[Playground Wisdom: Threads Beat Async/Await](https://lucumr.pocoo.org/2024/11/18/threads-beat-async-await/).”

## Making concurrency easier

The above Go code sample actually has a bug \- depending on what goes in that “other code”, the print statement may or may not be executed. More broadly, coordination and correctness across goroutines remains cumbersome in Go despite the existence of channels, WaitGroups, and context.

Unlike Go, Python has stuff like exceptions and cancellation semantics, and these make full-featured structured concurrency possible.[^6] The core idea of structured concurrency is pretty [simple](https://gavinhoward.com/2019/12/structured-concurrency-definition/): require that concurrent tasks can’t outlive their parent scope.

```python
import anyio
import httpx

async def worker(name, url):
    async with httpx.AsyncClient() as client:
        resp = await client.get(url)
        print(f"{name} got {resp.status_code}")

async def main_with_structure():
    async with anyio.create_task_group() as tg:
        tg.start_soon(worker, "worker1", "https://a.com")
        tg.start_soon(worker, "worker2", "https://b.com")
        # When exiting the with block, we automatically block until
        # all subtasks complete.
        # If either worker crashes, the whole group is automatically canceled.
        # You'll never leak/orphan a task.

anyio.run(main_with_structure)
```

This has other benefits as well. It makes resource cleanup, error handling, cancellation, and control-C handling just work. Stack traces are significantly easier to understand because the call stack is still somewhat sensible. I think that reasoning about structured concurrency feels more familiar to developers without a concurrency background. If you’d like to learn more, I’d highly recommend the Trio creator’s “[Notes on structured concurrency, or: Go statement considered harmful](https://vorpus.org/blog/notes-on-structured-concurrency-or-go-statement-considered-harmful/).”

In my mind, **structured concurrency is clearly the future**. In Python, Trio and AnyIO have proven that the idea works. It’s important to call out that it’s applicable for all forms of concurrency \- async, green threads, threads, and even multiprocessing.

## Making Python nicer

As it turns out, the Python gevent library is built on basically the same insights as Go. It uses green threads for concurrency[^7] and makes it extremely easy to spawn off tasks. Since it’s too late to bake automatic yielding into the Python runtime, gevent relies on monkeypatching to make the standard library cooperative.[^8] The end result is that writing gevent code feels pretty similar to writing Go.

```python
import gevent
from gevent import monkey
monkey.patch_all()

import requests

def worker(name, url):
    resp = requests.get(url)  # automatically yields when blocked
    # If this was async, requests would've blocked the event loop.
    print(f"{name} got {resp.status_code}")

def main():
    g1 = gevent.spawn(worker, "worker1", "https://a.com")
    g2 = gevent.spawn(worker, "worker2", "https://b.com")

    gevent.joinall([g1, g2])  # wait for both to finish

main()
```

While gevent is already quite solid,[^9] there’s two things we’d need to build to make it a fully viable replacement for async and the asyncio ecosystem.[^10]

1. A structured concurrency layer built on top of gevent. It would be to gevent as AnyIO is to asyncio. Type checking is also important here, and we can draw inspiration from the asyncer library.
2. A shim layer that brings async programs into the fold. It should be possible to build an asyncio event loop implementation that defers to gevent for all of its actual scheduling and execution.

Here’s what an amazing end state could look like:

```python
g.init()  # unfortunately we'll still need this
import requests

def worker(name, url):
    resp = requests.get(url)  # automatically yields when blocked
    print(f"{name} got {resp.status_code}")

async def async_worker(name, url): ...  # omitted

def main():
    with g.create_task_group() as tg:  # structured concurrency built in
        tg.start_soon(worker)("worker1", "https://a.com")
        tg.start_soon(worker)("worker2", "https://b.com")

        # Seamlessly works with async
        tg.start_soon(async_worker)("worker3", "https://c.com")

    print("All workers finished cleanly")

main()
```

It also introduces some super interesting possibilities for future work. Most exciting to me is the possibility of leveraging [free threading](https://docs.python.org/3/howto/free-threading-python.html) (aka no-GIL Python) by turning the gevent scheduler into a Go-style scheduler that multiplexes green threads (aka greenlets) onto multiple OS threads. While making most Python code totally thread-safe is tricky, there’s only a small jump from code that’s safe when run as a green thread to safe across non-GILed threads.

In case it wasn’t clear: I remain excited about the future of Python. I get the circumstances and reasoning that led to adding async, and am grateful that the flexibility it afforded enabled the prototyping of stuff like Curio and Trio. I hope Python leans more heavily towards green threads moving forwards and that future programming languages make concurrency and coordination more of a first-class citizen.

_Thanks to John Kim, Kevin Hu, and Shihao Cao for reviewing drafts of this post._

[^1]: Despite knowing all the pitfalls, I get caught by this occasionally. For instance, at DataHub my usage of FastMCP with synchronous tools caused [issues](https://github.com/jlowin/fastmcp/issues/864#issuecomment-3103990624) that we were only able to detect once we hit some level of scale.
[^2]: There’s also many issues with the asyncio library implementation, but I’m not going to focus on those here. I’d recommend “[I don’t understand Python’s Asyncio](https://lucumr.pocoo.org/2016/10/30/i-dont-understand-asyncio/)” or the more recent “[asyncio: a library with too many sharp corners](https://sailor.li/asyncio).”
[^3]: So good that durable execution platforms like Temporal let you block in even more places.
[^4]: Ever since Go added support for non-cooperative preemption, you can’t block the event loop for too long. That’s effectively what you want.
[^5]: Threading actually had this right from the start, but we threw away that insight with async.
[^6]: SourceGraph’s [conc](https://github.com/sourcegraph/conc) library makes part of structured concurrency possible, but cancellation / timeouts / control-C handling are still pretty limited. From what I can see, those really do require exceptions.
[^7]: There’s been many proposals over the years to bring something like stackless/greenlets/virtual threads to Python. For instance, “[From Async/Await to Virtual Threads](https://lucumr.pocoo.org/2025/7/26/virtual-threads/)” has similar ideas but doesn’t quite make the connection of gevent \+ greenlets being a presently viable vehicle for it.
[^8]: A common objection is “monkey-patching is brittle”. The gevent library has had years to iterate on its approach to monkeypatching. The more popular the library becomes, the more the rest of the ecosystem leans in \- so at scale this should become a moot point.
[^9]: This begs the question: gevent has been around since 2009, so why isn’t it already more popular? It is already moderately popular: currently \~31m downloads/month, but still a far cry from httpx’s 266m/month or FastAPI’s 128m/month (data via [PyPI Stats](https://pypistats.org/)). My hypothesis is that (1) the monkeypatching was worse back then and still sounds scary, (2) gevent didn’t quite have the “batteries included” experience of Twisted/Tornado, and so (3) it never developed a broad ecosystem or community.
[^10]: I’ve actually begun prototyping something like this, but haven’t gotten too far yet. Let me know if you’re working on something similar :)
