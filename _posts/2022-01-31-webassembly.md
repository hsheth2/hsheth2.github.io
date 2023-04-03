---
layout: post
title:  "Pay attention to WebAssembly"
---

_[Read in Japanese](https://postd.cc/pay-attention-to-web-assembly/) thanks to the folks at POSTD._

WebAssembly is at an inflection point. Over the next few years, I expect to see increased adoption of WebAssembly across the tech sphere, from containerization to plugin systems to serverless computing platforms. The following is a discussion of what WebAssembly is, what makes it a relevant technology, and where it’s being used today. I’ll also describe some potentially high-impact applications and make some predictions about its future.

## What is WebAssembly?

WebAssembly (abbreviated Wasm) is an intermediate layer between various programming languages and many different execution environments. You can take code written in over 30 different languages and compile it into a .wasm file, and then can execute that file in the browser, on a server, or even on a car.

The name “WebAssembly” is misleading. While it was initially designed to make code run fast on the web, it now can run in a variety of environments outside of the browser as well. Moreover, WebAssembly is not assembly but rather a slightly higher-level bytecode.

Plenty of ink has been spilled on describing WebAssembly and explaining its history, so I’ll simply refer to some good primers here:

* [A cartoon intro to WebAssembly - Mozilla Hacks - the Web developer blog](https://hacks.mozilla.org/2017/02/a-cartoon-intro-to-webassembly/) 
* [WebAssembly. Scary name, exciting applications. \| Nicky blogs](https://nickymeuleman.netlify.app/blog/webassembly) 
* [How WebAssembly changes software distribution \| Max Desiatov](https://desiatov.com/why-webassembly/) 


## Where does WebAssembly excel?

WebAssembly excels because of the following five characteristics:

* **Portable**: The binary format for Wasm bytecode is standardized, meaning that any runtime capable of executing Wasm will be able to run any Wasm code.[^1] This is similar to Java’s promise of “write once, run anywhere”. In the browser, [95% of users’ browsers](https://caniuse.com/wasm) can execute WebAssembly, and the remaining gap can be bridged using a wasm2js compiler. For servers, there are runtimes like [Wasmtime](https://github.com/bytecodealliance/wasmtime) and [Wasmer](https://github.com/wasmerio/wasmer). Even resource-constrained IoT devices can join the fun using [WAMR](https://github.com/bytecodealliance/wasm-micro-runtime).[^2]
* **Universal**: Many languages can compile into Wasm. This support goes beyond systems languages like C, C++, and Rust to include garbage-collected, high-level languages like Go, Python, and Ruby.[^3] A full list of languages that compile to Wasm can be found [here](https://github.com/appcypher/awesome-wasm-langs).
* **“Near-Native Performance”**: Wasm is often [described](https://developer.mozilla.org/en-US/docs/WebAssembly) as having “near-native performance”. What this actually means is that WebAssembly is almost always faster than JavaScript, especially for compute-intensive workloads, and averages between 1.45 and 1.55 times slower than [native code](https://www.usenix.org/conference/atc19/presentation/jangda), but results do [vary by runtime](https://00f.net/2021/02/22/webassembly-runtimes-benchmarks/).
* **Fast Startup Time**: The cold start time of Wasm is important enough that it warrants a category of its own. On the server, it can achieve 10-100x [faster cold starts](https://repositum.tuwien.at/bitstream/20.500.12708/17598/1/Gackstatter%20Philipp%20-%202021%20-%20A%20WebAssembly%20Container%20Runtime%20for%20Serverless%20Edge...pdf) than Docker containers because it does not need to create a new OS process for every container. In the browser, decoding Wasm and translating it to machine code is faster than parsing, interpreting, and optimizing JavaScript, and so Wasm code can begin executing at peak performance more quickly than JavaScript can.[^4]
* **Secure**: WebAssembly was designed with the web in mind and so security was a priority. Code running in a Wasm runtime is memory sandboxed and capability constrained, meaning that it is restricted to doing what it is explicitly allowed to do.[^5] While sandboxed, Wasm code can still be granted access to the underlying system, including system-level interfaces and hardware features.

## Where is WebAssembly useful?

### Speeding up JavaScript

The initial motivation behind Wasm and its precursor asm.js was to speed up client-side code on the web, and there are many examples of Wasm excelling in this arena:

* The core of the Figma design tool, for example, is written in C++ and then compiled to WebAssembly. They found major [performance and usability wins](https://www.figma.com/blog/building-a-professional-design-tool-on-the-web/) by writing in C++, while [compiling to WebAssembly](https://www.figma.com/blog/webassembly-cut-figmas-load-time-by-3x/) cut load times by 3x and dramatically reduced download sizes.
* The password manager 1Password saw up to [13-39x speedups](https://blog.1password.com/1password-x-may-2019-update/) on form-heavy sites when switching to Wasm. Wasm performance is also [more consistent](https://developers.google.com/web/updates/2019/02/hotpath-with-wasm) than JavaScript, which is important for latency-sensitive applications.[^6]

### Programming Language Interoperability

WebAssembly lets us more easily cross the boundaries between programming languages. Libraries and frameworks are usually written in a single language, which makes it difficult to make use of that code from other languages without a full rewrite. With WebAssembly, we can more easily execute code written in other languages. **This enables us to reuse code rather than reinventing the wheel.** 

Right now, this is mainly used to port applications to the web. Here’s some examples:

* Figma makes use of a low-level C++ library called Skia for some graphics algorithms rather than building their own or porting them to JavaScript.[^7] 
* My favorite chess server, lichess.org, runs the world-class Stockfish chess engine in users’ browsers, saving them the computational burden of running it server-side.
* [Google Earth](https://medium.com/google-earth/google-earth-comes-to-more-browsers-thanks-to-webassembly-1877d95810d6) and [Adobe Photoshop](https://web.dev/ps-on-the-web/) ported their C++ codebases to the web using Wasm.

Porting applications to the web is the easiest place to start, and we’ll likely see that [trend continue](https://paulbutler.org/2020/the-webassembly-app-gap/). However, Wasm’s interoperability is not limited to the browser. It’s also been used to make code work cross-platform and cross-device:

* The [Uno Platform](https://platform.uno/) is a UI platform that lets you write a single application and have it run across Windows, macOS, iOS, Android, Linux, and browsers. It seems to be fairly Windows-centric, as applications are written in C# and XAML, and so many of the use cases are based around reducing the effort required to port legacy applications to new platforms.
* [Amazon Prime](https://www.amazon.science/blog/how-prime-video-updates-its-app-for-more-than-8-000-device-types), [Disney+](https://medium.com/disney-streaming/introducing-the-disney-application-development-kit-adk-ad85ca139073), and the [BBC](https://www.youtube.com/watch?v=28paRXqI-Gk) all use WebAssembly in their video platforms. For example, Amazon Prime uses it to ship new features to a huge variety of device types while maintaining acceptable performance.

Beyond application portability, WebAssembly can also serve as a cross-language bridge on the server-side. Unfortunately we haven’t seen too much of this yet, since the interfaces used to communicate with the operating system (the [Web Assembly System Interface](https://hacks.mozilla.org/2019/03/standardizing-wasi-a-webassembly-system-interface/), abbreviated WASI) and work across language boundaries (the [Wasm Component Model](https://github.com/WebAssembly/component-model)) are still in development and have not yet reached the requisite maturity level.


### Plugin Systems

When most applications reach a certain level of maturity, they need to allow for extensibility by end users. Historically applications have reached for copious config systems or built complex DSLs, but these invariably turn out to be exceedingly painful to manage or force developers to work with unfamiliar languages.

Let’s consider an example: configuring request filtering rules in a system like NGINX. In order to do so, a sysadmin must declaratively implement their desired logic in a custom configuration language that they’re unfamiliar with. They’re beholden to the types of matching and filtering operators that the NGINX designers anticipated, which often severely limits their ability to implement the behavior they want. If anything goes wrong, debugging can be frustrating because of the lack of available tooling.

Some newer applications have opted for a different approach: provide a standard set of interfaces and embed a Wasm runtime, and let end users provide Wasm binaries that implement the needed custom logic. This yields a much more flexible and familiar interface for end users: they can implement arbitrarily complex business logic and can do so in whatever language they choose. This was not possible with other languages because of security concerns, but Wasm makes it feasible because the runtime can sandbox the user-provided code.

A few examples of where this is used today:



* The Envoy proxy, originally developed by Lyft and now used across the industry, allows extensions to be [built with Wasm](https://github.com/proxy-wasm/spec/blob/master/docs/WebAssembly-in-Envoy.md) and loaded dynamically at runtime. The Istio service mesh, which is built on top of Envoy, has followed suit.
* Redpanda, a Kafka alternative, lets users write [in-stream custom data transformations](https://vectorized.io/blog/wasm-architecture/) using Wasm.
* The Open Policy Agent allows for policies to be [defined using Wasm](https://www.openpolicyagent.org/docs/latest/wasm/).
* The Minecraft server [Feather](https://github.com/feather-rs/feather) uses WebAssembly to run plugins in a sandbox.


### Embedded Sandboxing

The idea of embedding WebAssembly within other applications is useful beyond plugin systems. In fact, it can be used to sandbox entire third-party libraries or to construct layers of security for first-party code.

Firefox is [leading the way](https://hacks.mozilla.org/2021/12/webassembly-and-back-again-fine-grained-sandboxing-in-firefox-95/) in this area by protecting itself against bugs in third-party libraries, like the ones they use for spell checking or image decoding. In conjunction with a tool called RLBox, which provides a [tainting layer](https://hacks.mozilla.org/2020/02/securing-firefox-with-webassembly/), they can protect against vulnerabilities in those libraries without resorting to heavy-handed process isolation. For Firefox, they don’t even ship Wasm binaries in their final release; the process of compiling to Wasm and then transpiling to another language, coupled with RLBox, provides the security they need. 

This approach might prevent some serious vulnerabilities from being exploited. Since attackers usually chain multiple vulnerabilities together, such intermediate security layers will probably be invaluable moving forwards.


### Containerization

In an oft-cited [tweet](https://twitter.com/solomonstre/status/1111004913222324225?ref_src=twsrc%5Etfw%7Ctwcamp%5Etweetembed%7Ctwterm%5E1111004913222324225%7Ctwgr%5E%7Ctwcon%5Es1_&ref_url=https%3A%2F%2Fnickymeuleman.netlify.app%2Fblog%2Fwebassemblysecurity), Docker founder Solomon Hykes underscored the importance of WebAssembly:

> If WASM+WASI existed in 2008, we wouldn't have needed to created Docker. That's how important it is. Webassembly on the server is the future of computing.

There’s [good reason](https://kubesphere.io/blogs/will-cloud-native-webassembly-replace-docker_/) to believe that Wasm represents the future of containerization. **Compared to Docker, it has 10-100x faster cold start times, has a smaller footprint, and uses a better-constrained capability-based security model.** Making Wasm modules, as opposed to containers, the standard unit of compute and deployment would enable better scalability and security.

Such a transition isn’t going to happen overnight, so Wasm-based containerization will likely integrate into existing orchestration systems rather than attempting to replace Docker entirely.

I anticipate this space will be buzzing with activity over the next few years. A few projects are already leading the charge:



* Microsoft Azure’s Deis Labs built [Krustlet](https://krustlet.dev/), which is a way to run Wasm workloads in existing Kubernetes clusters.
* Deis Labs also released [Hippo](https://github.com/deislabs/hippo), a Wasm-centric platform-as-a-service. I would guess that [Fermyon](https://github.com/fermyon) is trying to commercialize that tech.
* With their [wasmCloud](https://github.com/wasmCloud/wasmCloud) project, [Cosmonic](https://cosmonic.com/) is building a platform and orchestration tier that combines Wasm containerization with the actor model for distributed systems.
* The [Lunatic](https://github.com/lunatic-solutions/lunatic) platform also embraces the actor model and seems to have the best support running multiple light containers on top of a single WebAssembly runtime process. 
* [Suborbital](https://suborbital.dev/)’s [Atmo](https://github.com/suborbital/atmo) is another platform and orchestration system, but is more oriented towards serverless workloads.


### FaaS/Serverless Platforms

Function-as-a-service platforms need to execute user-provided code quickly and safely. Since serverless platforms are often used to run code for short durations, startup times are a particularly important metric. **The ultra-fast cold starts and broad language support make Wasm a good choice for serverless workloads.**[^8]

The CDN-edge computing platforms provided by [Cloudflare Workers](https://blog.cloudflare.com/webassembly-on-cloudflare-workers/) and [Fastly Compute@Edge](https://www.fastly.com/blog/how-compute-edge-is-tackling-the-most-frustrating-aspects-of-serverless) already provide the ability to run WebAssembly. Fastly claims 100x faster startup times than other offerings in the market, and attributes this speedup to their WebAssembly-based compiler and runtime. Netlify and Vercel are also building products in this space.

The serverless platforms built by major cloud providers aren’t far behind: AWS Lambda launched WebAssembly serverless functions a few months ago, and I expect that GCP and Azure will follow suit.


### Blockchains

Platforms like Ethereum and Solana provide a mechanism for users to write code, dubbed “smart contracts”, which can run on the blockchain. Ethereum built a fully custom system, creating a language called Solidity, a binary format for the compiled bytecode, and the Ethereum Virtual Machine for sandboxed execution. Solana opted to reuse some existing innovations, harnessing the LLVM compiler infrastructure to compile C, C++, or Rust code into a binary bytecode format inspired by the Berkeley Packet Filter, but still built their own runtime called Sealevel.

WebAssembly already provides much of this infrastructure: it lets users write code in the language of their choosing, provides compiler infrastructure to produce Wasm bytecode, and has numerous high-performance runtimes.

But if Ethereum and Solana have already built this infrastructure, what value does WebAssembly provide? The main value-add is actually around ecosystems. For example, Ethereum has its own language for writing smart contracts, which means that it is unable to leverage all the libraries and common functions that have been written in other languages. Solana is a bit better since it can use the Rust ecosystem. Assuming the technical challenges can be overcome, **WebAssembly opens up smart contract development to a much wider audience and enables them to use the libraries and tools they’re already comfortable with.**

I am definitely not the first to make this realization. The Polkadot network, for example, uses a [WebAssembly-based virtual machine](https://wiki.polkadot.network/docs/learn-wasm) as its runtime. The EOS virtual machine is also [based on WebAssembly](https://eos.io/news/eos-virtual-machine-a-high-performance-blockchain-webassembly-interpreter/). [CosmWasm](https://cosmwasm.com/) uses it to build smart contracts that work across multiple blockchains. There was also a proposal called [eWASM](https://github.com/ewasm/design) to replace the Ethereum Virtual Machine with a limited subset of WebAssembly, but it seems that effort has since fizzled out. The Wasmer runtime provides a “singlepass” compiler mode that is explicitly built for blockchains, while WasmEdge claims to have an Ethereum-compatible smart contract execution engine.


## Predictions and Opportunities


### A New Application Architecture

Just as Docker could not replace virtual machines entirely, Wasm cannot replace Docker entirely. For instance, Docker containers can’t run custom OS kernels while virtual machines can. Similarly, Wasm containers can’t use some specialized CPU instructions, like x86’s 256-bit AVX instructions,[^9] and hence can’t compete with Docker on performance for some applications.

In my opinion, the set of workloads that Docker can support but Wasm can’t is currently larger than the analogous delta between Docker and virtual machines. However, Wasm is still a developing technology and hence will incrementally be able to address more types of workloads. Docker’s rise was closely coupled with the rise of microservice architectures. This took monolithic applications that were well-suited for virtual machines and replaced them with microservices that were well-suited for Docker containers. We’ll probably see **a new application architecture that takes advantage of WebAssembly’s unique capabilities**.

As per Conway’s law, an application’s architecture reflects the communication structure of the organization that produces it. Every new “reference architecture” throughout the history of computing has reduced the amount of coordination that is required between people. From mainframes to virtual machines to Docker containers, the number of people required to produce a deployable unit has progressively decreased. We’ve achieved this by decomposing systems into smaller and smaller components and by allowing the people building those components to work independently against well-defined interfaces. While microservices have decomposed monolithic applications into several small independent services, **WebAssembly makes it easier to decompose microservices into even smaller components**.[^10]

What will this look like? Here’s a few possibilities:



* When you split applications into the core business logic and the glue code needed to work with other systems, it turns out that the business logic is usually pretty small compared to the rest. By separating the interface of the glue code from the implementation of the capability it provides, it becomes possible to build business logic-centric applications and delegate the rest to external capability providers. Coupled with the long sidelined [actor model](https://www.brianstorti.com/the-actor-model/), this is the essence of [wasmCloud](https://github.com/wasmCloud/wasmCloud)’s approach.
* Another possibility is that serverless architecture is the next step beyond microservices. Most services can be segmented into stateful and stateless portions, and the stateless portions can run as arbitrarily scalable serverless functions. In this case, WebAssembly serves as a convenient and easily scalable runtime for those serverless functions.
* WebAssembly might change the way we take on third-party dependencies. Modern code relies heavily on third-party libraries,[^11] and most of these dependencies are not vetted fully or frequently. As software supply chain issues like the recent [Log4j vulnerabilities](https://en.wikipedia.org/wiki/Log4Shell) come to light, I expect people will start to take the security of third-party libraries more seriously. Approaches like Firefox’s use of Wasm and RLBox to isolate certain libraries will become more widespread. It might also be feasible to isolate third-party libraries into separate capability-constrained containers within the same Wasm runtime, assuming the performance limitations can be overcome.[^12]

### Brownfield Deployment

Wasm will eventually need to interoperate with Docker in some way. For the next couple years this is not strictly necessary, since Wasm will primarily be used in greenfield deployments with few requirements for backwards compatibility. But ultimately brownfield deployments need to be easy for Wasm to fully win the containerization race, especially in enterprise settings.

One potential outcome is that Docker will integrate a Wasm runtime. While plausible, I expect Wasm will be sufficiently differentiated to warrant separate tooling entirely. Instead, **the unification of Docker and Wasm containers will happen at the orchestration layer**.

It’s less clear if Kubernetes will effectively integrate Wasm-based execution or if a new orchestration system will emerge. On one hand, Kubernetes is currently the unrivaled king of orchestration. It has incredible momentum, and the Wasm containerization movement would be wise to ride on its coattails. Folks at Microsoft are investing in that future by building [Krustlet](https://github.com/krustlet/krustlet), which lets you run Wasm workloads in Kubernetes. On the other hand, Wasm code will have different requirements than Docker containers and hence Kubernetes might not be the right fit. For example, it would be useful to set up shared memory for inter-container communication when using Wasm-based third-party library isolation, which would be difficult to do with Kubernetes. Such Wasm-native orchestrators will eventually build bridges that ease migration from or integration with Docker.

While I’m hopeful for the upcoming wave of Wasm orchestrators, Kubernetes is sufficiently entrenched that it’s probably not going anywhere in the short-term.


### Standardized Serverless/Edge Framework

Most serverless providers have their own framework for defining routes and lambda functions. Cloudflare, for instance, defines its own “cf” type and provides a CLI tool called wrangler for setting up code scaffolding. Fastly has its own set of interfaces for interacting with caches and logging, and AWS Lambda has a similar setup. The Fission framework for Kubernetes has its own set of libraries for integration with various languages. Some platforms try to circumvent this problem by letting users provide a Docker container, such that the platform only needs to handle execution. [Knative](https://knative.dev/docs/) and [Fly.io](https://fly.io/) both follow this approach. However, they must then keep a “warm pool” of workers to reduce the impact of cold start times, or pass this problem on to their users.

There’s an opportunity to build a standardized serverless function definition and deployment spec. The popular [Serverless Framework](https://github.com/serverless/serverless) does a decent job at abstracting deployment, but still leaks provider-specific details into the function implementations. As soon as those details are abstracted away, multi-cloud deployments become much easier and hence the framework becomes much more powerful. It could eventually be like the Terraform of serverless.[^13]


### Package Management

Every programming language has an ecosystem around it. Most modern languages have a centralized package registry: Python has PyPI, NodeJS has npm, and Rust has Crates.io. Such registries, and the tooling and workflows that accompany them, are important to developing a high-quality ecosystem and making developer lives much easier.

For Wasm, the [WebAssembly Package Manager](https://wapm.io/) (WAPM) promised to fill that gap. However, in practice the project seems largely dormant. At the time of writing, only three packages have been updated in the [past two months](https://web.archive.org/web/20211229050050/https://wapm.io/). The issue is that packages are supposed to build on each other, but WAPM only works well for standalone Wasm binaries with no inter-dependencies. The other option for a developer is to publish Wasm modules to npm, but of course this is not ideal for building a Wasm ecosystem beyond JavaScript or AssemblyScript as it does not encourage cross-language interoperability.

The issue isn’t really the fault of WAPM or npm, but rather a rough edge with WebAssembly itself.

> attempting to write any non-trivial WebAssembly application that tries to interoperate across runtime or language boundaries requires significant effort today, and exchanging any non-fundamental data types (such as strings or structures) involves pointer arithmetic and low-level memory manipulation.
> 
> ― [Introduction to WebAssembly components \| radu's blog](https://radu-matei.com/blog/intro-wasm-components/) 

This is exactly the problem that the WebAssembly Component Model will solve. Wasm components standardizes the WebAssembly Interface format, and provides [code generators](https://github.com/bytecodealliance/wit-bindgen) for both implementing and consuming those interfaces. In other words, it lets us easily cross runtime and language boundaries with Wasm.

There’s a big opportunity to build a high-quality package manager for WebAssembly. It should use Wasm components codegen to generate bindings for using Wasm modules from other languages. If the tooling is sufficiently good, it could make cross-language development a breeze, which would be the real unlock for the server-side WebAssembly ecosystem. The Wasm package registry could even syndicate across other package registries, automatically publishing packages with appropriate generated bindings to PyPI, npm, and Crates.io.


## Conclusion

At this point you’re probably thinking: if WebAssembly is so good, why isn’t it more widely used? Let me volunteer some responses:



* WebAssembly’s marketing hasn’t been great. The name is a misnomer, since it is neither restricted to the web nor is it assembly. WebAssembly has primarily been marketed and [pushed towards web developers](https://blog.bitsrc.io/whats-wrong-with-web-assembly-3b9abb671ec2), but its real potential lies beyond the browser. The real unlock will come when C++ and Rust developers, en masse, start to recognize the potential that Wasm holds.
* WebAssembly standardization isn’t there yet. For example, the WebAssembly System Interface has numerous extensions that have not been officially standardized, but various runtimes implement a selection of these extensions. The promise of universal portability has not yet been fully realized.
* Cross-language interactions suck. We need WebAssembly components and good code generators for a critical mass of languages before people actually start to use Wasm across different languages.
* The developer experience leaves much to be desired. I’d love to see improvements in tooling, especially [around debugging](https://thenewstack.io/the-pain-of-debugging-webassembly/), and integrations with package managers, build systems, and IDEs.
* I hate to say this, but we probably need a few more severe software supply-chain incidents, of similar scale to Log4Shell, before WebAssembly’s library isolation capabilities are fully appreciated.

WebAssembly has been deployed in a fairly impressive list of places and serves an assortment of use cases, but these represent isolated pockets of activity within the broader tech world. Among my friends, the small fraction who have heard of WebAssembly think it’s really exciting in principle, but are not building with it because it isn’t quite mature yet. However, many of these issues are being actively worked on and will probably reach an acceptable state within the next year or two. As such, it seems **we’re on the brink of an explosion in WebAssembly activity, ecosystem, and community**. 

_Discuss on [Hacker News](https://news.ycombinator.com/item?id=30155295) or [send me your thoughts](https://harshal.sheth.io/about). Thanks to Nihar Sheth, Mohak Jain, Andrew Sun, and Michelle Fang for their feedback on early drafts of this article._


## Notes

[^1]:

     In reality, there’s a bit more nuance here. Wasm has two [standard APIs](https://v8.dev/blog/emscripten-standalone-wasm): Web APIs and WebAssembly System Interface (WASI) APIs. WebAssembly is also rapidly evolving, so there are a number of experimental features like threading that are widely implemented but not officially standardized. Beyond this, when Wasm is embedded within another application, that other application might also provide its own APIs. The Wasm code should execute if it only uses APIs and features that the runtime provides, which turns out to be a fairly reasonable assumption.

[^2]:
     For some reason, it seems like every WebAssembly runtime name starts with “wa”. There’s also [WasmEdge](https://github.com/WasmEdge/WasmEdge), [WAVM](https://github.com/WAVM/WAVM), and [wasm3](https://github.com/wasm3/wasm3). One of the few exceptions is [Fizzy](https://github.com/wasmx/fizzy), but even that project is hosted by an organization called wasmx. 

[^3]:

     However, running interpreted languages, like Python and Ruby, or languages with complex runtimes, like Go, on Wasm probably won’t yield good performance.

[^4]:

     In Firefox, Wasm compilation is actually [faster](https://hacks.mozilla.org/2018/01/making-webassembly-even-faster-firefoxs-new-streaming-and-tiering-compiler/) than the network delivers packets. The [WebAssembly.instantiateStreaming](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/WebAssembly/instantiateStreaming) method lets us begin the compilation process before we’ve even finished downloading the file, so there’s only minimal additional latency before the Wasm code starts executing.

[^5]:

     Ok, there’s still some rough edges here. The capability-based permission systems aren’t super granular yet and most Wasm runtimes don’t protect against side-channel attacks like Spectre, so some additional strategies are necessary. Cloudflare’s Kenton Varda has written a [detailed article](https://blog.cloudflare.com/mitigating-spectre-and-other-security-threats-the-cloudflare-workers-security-model/) on their threat model and the mitigations they’ve implemented.

[^6]:

     Because Wasm can avoid issues of deoptimization that arise when deviating from the JavaScript “fast path”, it executes reliably fast while matching or exceeding JavaScript’s peak performance. Funnily enough, you can actually get JavaScript to run faster in a browser by compiling it to WebAssembly and running that instead. Lin Clark gave an [excellent talk](https://www.youtube.com/watch?v=CRaMls9oVBw) on how and why this works.

[^7]:

     From a personal conversation with a tech leader at Figma a few years back. Many browsers, including Google Chrome and Firefox, already use Skia under the hood. However, they do not expose Skia APIs directly and so applications must use the slower browser DOM or SVG interfaces. Figma draws directly to the browser canvas element, bypassing these slower layers, but still makes use of some Skia functionality by [embedding](https://skia.org/docs/user/modules/canvaskit/) it within their application.

[^8]:
     It’s worth noting that there are other alternatives. AWS Lambda, for example, uses the lightweight [Firecracker MicroVM](https://firecracker-microvm.github.io/). In a head-to-head, WebAssembly does have some [performance advantages](https://arxiv.org/ftp/arxiv/papers/2010/2010.07115.pdf).

[^9]:
     WebAssembly SIMD support for 128-bit types is currently experimental, but is implemented in many browsers and runtimes. “Long SIMD” support [remains for future work](https://github.com/WebAssembly/design/blob/5b2c607fe173c813214afde33e0ea82d33dd0983/FutureFeatures.md#long-simd). 

[^10]:
     The counterargument to this claim is that “just because we can decompose microservices doesn’t mean we will”. This is certainly a valid criticism, and is actually one that has also been applied to monoliths in the context of microservices. For instance, a recent [article](https://arnoldgalovics.com/microservices-in-production/) titled “Don’t start with microservices in production – monoliths are your friend” generated a ton of [discussion](https://news.ycombinator.com/item?id=29576352). Nevertheless, microservice architectures have been tremendously effective and productive when deployed in fitting circumstances, and I expect the same will be true with WebAssembly-centric architectures. It’s less clear how many fitting circumstances exist in the context of WebAssembly.

[^11]:

     This problem is so well-known that there are even [memes](https://www.reddit.com/r/ProgrammerHumor/comments/6s0wov/heaviest_objects_in_the_universe/) [about](https://xkcd.com/2347/) [it](https://www.reddit.com/r/ProgrammerHumor/comments/992u1p/dependencies_101/).

[^12]:
     Someone should probably build a company that does this. Software supply-chain is top-of-mind right now given the recency of the Log4j vulnerability, and it seems like most existing companies are focused on verifying dependencies instead of isolating them.

[^13]:
     Perhaps this isn’t the best comparison, since Terraform only abstracts the deployment and interactions with cloud providers whereas this framework would operate at the code layer as well.

