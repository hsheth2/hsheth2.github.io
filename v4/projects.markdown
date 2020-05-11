---
layout: page
title: Projects
permalink: /projects/
---

I've worked on a bunch of different things over the years. 
Although I'm always [working on new stuff](https://github.com/hsheth2), this should serve as a mostly complete compilation.

## Research

### **Skua**: distributed tracing in the Linux kernel 

![Skua architecture]({{site.url}}/assets/images/skua-diagram.png)

Skua extends the [Jaeger](https://www.jaegertracing.io/ ) distributed tracing framework to integrate kernel-level traces produced by [LTTng](https://lttng.org/ ).
[Andrew Sun](https://andrewsun.com/) and I presented at the [2018 MIT PRIMES conference](https://math.mit.edu/research/highschool/primes/conference/conf-2018.php) and at [DevConf US 2018](https://devconf.info/us/2018).

- Take a look at our [slides](https://l.sheth.io/skua-slides).
- Watch the [video](https://youtu.be/vyCU8D5KYek?t=1h7m7s) of our presentation.
- Our [code](https://github.com/docc-lab/skua) is open source - try it out! May require minimal configuration and tweaking.

### **Tarpan**: a routing protocol design to replace BGP

![Tarpan's modifications to Quagga]({{site.url}}/assets/images/tarpan-modifications-diagram.png)

Tarpan is a completely in-band variant of the [D-BGP](https://www.darwinsbgp.com/) protocol. D-BGP, designed by our research mentor [Raja Sambasivan](https://www.rajasambasivan.com/), contains all the necessary characteristics to move the Internet away from the Border Gateway Protocol and its limitations, while maintaining backwards compatibility to facilitate incremental adoption. [Andrew Sun](https://andrewsun.com/) and I presented at the [2017 MIT PRIMES conference](https://math.mit.edu/research/highschool/primes/conference/conf-2017.php).

- Look at our [slides](https://math.mit.edu/research/highschool/primes/materials/2017/conf/12-1-Sheth-Sun.pdf)
- Read the [paper](https://l.sheth.io/tarpan).
- We implemented Tarpan as an [extension](https://github.com/hsheth2/tarpan/compare/aa93417671b609a56997bc2c676cbfc640199e7a...master) to the [Quagga router](https://www.quagga.net/). Take a look at our [code](https://github.com/hsheth2/tarpan).

