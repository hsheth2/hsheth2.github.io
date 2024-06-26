---
layout: page
title: Projects
permalink: /projects
---

I've worked on a bunch of different things over the years.
Although I'm always [working on new stuff](https://github.com/hsheth2), this should serve as a mostly complete compilation.

## Major Projects

### **CourseTable**: course search tool for Yale students

I led a team of ~10 undergrads working on full rebuild of CourseTable, a tool used by Yale students to find courses. After the launch of v2, CourseTable was used by 95% of Yale undergrads and handled ~5 million requests each semester.

- Visit the [CourseTable website](https://coursetable.com).
- Yale Daily News [article](https://yaledailynews.com/blog/2020/10/30/yale-computer-society-launches-coursetable-2-0/) covering the launch of CourseTable 2.0.
- All the [code](https://github.com/coursetable/coursetable) is open source.

### **Skua**: distributed tracing in the Linux kernel

<!-- ![Skua architecture]({{ "/assets/images/skua-diagram.png" | relative_url }}) -->

Skua extends the [Jaeger](https://www.jaegertracing.io/) distributed tracing framework to integrate kernel-level traces produced by [LTTng](https://lttng.org/).
[Andrew Sun](https://andrewsun.com/) and I presented at the [2018 MIT PRIMES conference](https://math.mit.edu/research/highschool/primes/conference/conf-2018.php) and at [DevConf US 2018](https://devconf.info/us/2018).

- Take a look at our [slides](https://l.sheth.io/skua-slides).
- Watch the [video](https://youtu.be/vyCU8D5KYek?t=1h7m7s) of our presentation.
- Our [code](https://github.com/docc-lab/skua) is open source - try it out!

### **Tarpan**: a routing protocol design to replace BGP

Tarpan is a completely in-band variant of the [D-BGP](https://www.darwinsbgp.com/) protocol. D-BGP, designed by our research mentor [Raja Sambasivan](https://www.rajasambasivan.com/), contains all the necessary characteristics to move the Internet away from the Border Gateway Protocol and its limitations, while maintaining backwards compatibility to facilitate incremental adoption. [Andrew Sun](https://andrewsun.com/) and I presented at the [2017 MIT PRIMES conference](https://math.mit.edu/research/highschool/primes/conference/conf-2017.php) and were also named semifinalists in the 2017 [Siemens Competition](https://en.wikipedia.org/wiki/Siemens_Competition).

- Look at our [slides](https://math.mit.edu/research/highschool/primes/materials/2017/conf/12-1-Sheth-Sun.pdf).
- Read the [paper](https://l.sheth.io/tarpan).
- We implemented Tarpan as an [extension](https://github.com/hsheth2/tarpan/compare/aa93417671b609a56997bc2c676cbfc640199e7a...master) to the [Quagga router](https://www.quagga.net/). Take a look at our [code](https://github.com/hsheth2/tarpan).

### **GoNet**: a TCP/IP network stack in Go

[Aashish Welling](https://github.com/omegablitz) and I implemented a user-space network stack in Go. We presented at the [2015 MIT PRIMES conference](https://math.mit.edu/research/highschool/primes/conference/conf-2015.php) and were also named semifinalists in the 2015 [Siemens Competition](https://en.wikipedia.org/wiki/Siemens_Competition).

- Read the [paper](https://arxiv.org/abs/1603.05636), titled _An Implementation and Analysis of a Kernel Network Stack in Go with the CSP Style_.
- Our [code](https://github.com/hsheth2/gonet) is open source and probably has more Github stars than it deserves.

### **when2water**: an intelligent irrigation controller

Along with my brother [Nihar Sheth](https://nihar.sheth.io), I built a low-cost irrigation controller that uses machine learning and local weather data to reduce water usage by almost 60%. We then built a website and API, and even installed a couple irrigation controllers in people's homes in our community. We were one of 31 teams to win the $1k local award prize as part of the [Google Science Fair](https://en.wikipedia.org/wiki/Google_Science_Fair), and were also named [state winners](https://www.newea.org/2015/07/01/wef-announces-sjwp-2015-winner-and-finalists/) in the [Stockholm Junior Water Prize](https://www.wef.org/resources/for-the-public/SJWP/).

- Try it out on our [website](https://when2water.org/).
- News articles in the [Westford Eagle](https://westford.wickedlocal.com/article/20140808/news/140807176) and [Lowell Sun](https://www.lowellsun.com/2015/07/18/award-winning-westford-brothers-devise-program-to-conserve-water/).
- Our [code](https://github.com/when2water/when2water) is hosted on Github.

### CTFs

While not really a project per-se, I've spent a fair amount of time on [Capture The Flag](https://ctftime.org/ctf-wtf/) competitions, a type of information security competition. I've had the pleasure of working with some really bright people over a bunch of different competitions, including CSAW HSF, picoCTF, TJCTF, HSCTF, and PACTF.

This all culminated in us running our own competition, [CTF(x)](https://ctf-x.github.io/). Almost [500 teams](https://ctftime.org/event/348) participated in the CTF, and no team was able to get a perfect score. After the competition, we posted detailed [writeups](https://github.com/ctf-x/ctfx-problems-2016) for all the problems.

## Minor Projects

#### Usable Projects

- [Embedding Playground](https://github.com/john-sungjin/embedding-playground) - A small utility to quickly play around with and iterate on embeddings. [Try it out!](https://embed.sheth.io/)
- [PPA Stats](https://github.com/hsheth2/ppa-stats) - The fastest way to view download statistics for a package published in a PPA on Launchpad. [Try it out!](https://ppa-stats.sheth.io/)
- [Yale Event Calendars](https://github.com/hsheth2/yale-event-calendars) - Adds Yale-related calendars directly to your calendar, and keeps them automatically updated. [Try it out!](https://yale-calendars.sheth.io/)

#### Maintenance

- [cava-ppa](https://github.com/hsheth2/cava-ppa) - An Ubuntu package for the [CAVA](https://github.com/karlstav/cava) music visualizer. Take a look at the [download stats](https://ppa-stats.sheth.io/#/?ppaName=ppa&ppaOwner=hsheth2&packageName=cava).
- [mysql-low-memory](https://github.com/hsheth2/mysql-low-memory) - A MySQL Docker image with lower memory requirements. I have no clue who's using it, but it has 50K+ pulls on the [Docker Hub](https://hub.docker.com/r/hsheth2/mysql-low-memory).

#### Hackathons

I've competed in a bunch of different hackathons. The code that we write during hackathons isn't pretty, and may require [minimal configuration and tweaking](https://xkcd.com/1742/) to get working. In this list, 🥇 indicates first place, 🥈 indicates second place, and 🏆 indicates some other prize.

- [Opinionate](https://github.com/hsheth2/opinionate) - MIT Blueprint 2015 🥈
- [Pinpoint](https://github.com/hsheth2/pinpoint) - MIT Blueprint 2016
- [Gesture Control](https://github.com/arxenix/gesture-control) - HackExeter 2016 🥈
- [vox](https://github.com/hsheth2/vox) - PennApps XIV
- [Ensemble](https://github.com/hsheth2/ensemble) - MIT Blueprint 2017 🥇
- [Pulse](https://github.com/as-com/pulse) - HackNEHS 2017
- [virtual-screen](https://github.com/hsheth2/virtual-screen) - MIT Blueprint 2018🥇
- [EnvizVR](https://github.com/Reichenbachian/YHacks) - YHacks 2018
- [GPUppy](https://github.com/as-com/gpuppy) - HackMIT 2019 🏆
- [Flython](https://devpost.com/software/flython) - TreeHacks 2020

[//]: graveyard projects: hermes, emask, gomod

[//]: finished but not big enough: sieve, tanks, space-game, UML generator
