---
layout: post
title: "How GitHub Actions won CI"
---

Since GitHub Actions CI/CD became [generally available](https://github.blog/2019-08-08-github-actions-now-supports-ci-cd/) at the end of 2019, it’s dominated its competition.[^1]

A few years ago, there used to be a thriving ecosystem of CI providers, like Travis CI and CircleCI, with healthy competition between them. Nowadays, every repo I come across uses GitHub Actions instead.

How did GitHub corner CI so quickly? By bundling Actions with existing software and leveraging their community.

## Bundling

GitHub is owned by Microsoft, and bundling software is a [classic part](https://www.youtube.com/watch?v=IF0GL2xEzIc) of the Microsoft playbook. In this case, it’s a lot easier to use one provider for both source control and CI, especially when all GitHub paid plans come bundled with free build minutes.[^2] GitHub Actions is automatically available on all repos, whereas other CI tools must be installed through the marketplace. For a product that, at its core, resells commodity compute at a massive markup,[^3] the reduction in friction probably has an outsized impact on usage. While they once said “[GitHub welcomes all CI tools](https://github.blog/2017-11-07-github-welcomes-all-ci-tools/)”, it seems some are more welcome than others.

## Reusable CI

There’s a relatively short list of ultra-common building blocks people do in CI, like installing dependencies and running linters and tests. However, GitHub also recognized that there’s a [long tail](https://about.codecov.io/blog/discovering-the-most-popular-and-most-used-github-actions/) of functions developers want to reuse, but GitHub couldn’t reasonably build out themselves, like generating coverage reports, deploying to various cloud providers, publishing releases, and managing caches for various language/frameworks.

GitHub Actions enabled developers to build and reuse these building blocks, and made it easy to publish them open source for others to use as well. GitHub, which already had a huge community of open source-minded developers, was able to bootstrap a [rich ecosystem](https://github.com/marketplace?type=actions) of custom actions fairly quickly. This ecosystem, in turn, makes GitHub Actions easier to use than any other CI tool, because the mundane parts are already done for you. Doing CI with GitHub Actions is as simple as pulling in dependencies when writing software.

## A local optimum

While Travis CI and other providers make you use external scripts for reusability, GitHub Actions went one level higher, promoting these composable actions for reusability. With Travis CI,[^4] complex CI logic would be embedded in your shell scripts, whereas with Actions it’s written in a JavaScript-like language embedded within the YAML configs. From the standpoint of technical purity, I think this is the wrong take. I’d much rather write shell scripts that I can run and test locally, and minimize the difference between local development and CI. Nonetheless, I find myself increasingly building complex workflows filled with community-built actions, since it genuinely is a better quickstart experience than building shell scripts someone else has built before. That’s the power of open source, and yet GitHub Actions’s take on it feels like a local optimum.

There’s different takes on how to escape this local optimum - a better build system that interfaces nicely[^5] with CI (e.g. [Dagger](https://dagger.io), [Earthly](https://earthly.dev/), [Bazel](https://bazel.build/)) is the most promising so far.[^6] Unfortunately, these tend to be all-or-nothing tools, so unless we scrap our existing build systems and migrate, we’re stuck writing ugly GitHub Actions pseudo-JS YAML spaghetti with no types or unit tests.[^7] The blog post [“GitHub Actions could be so much better”](https://blog.yossarian.net/2023/09/22/GitHub-Actions-could-be-so-much-better) offers an even more poignant critique of the user experience, covering the difficult local development experience, lacking debugging experience, and security footguns.

## Open source vendor lock-in

The shift to actions and YAML instead of CI shell scripts serves a second, strategic purpose: increasing vendor lock-in. This is where the technical purity of providers like Travis CI hurt their long-term prospects by decreasing stickiness. While it’s easy to wholesale switch to GitHub Actions and then incrementally adopt actions, it’s very difficult to incrementally switch away when your entire CI process is intertwined with bespoke actions. It’s ironic - the code for these actions is usually community-built and open-source, and yet you get locked into GitHub Actions anyways.

## Wrap-up

The GitHub Actions product is a collection of frustrating technical decisions (limited local development, print-oriented debuggability, security footguns, etc) and one compelling one: reusable actions.[^8] This technical decision meshed extremely well with GitHub’s already dominant position and enabled them to leverage their community to build a formidable product moat. Coupled with their ability to bundle a generous free tier, it’s no surprise that GitHub Actions became the [dominant CI provider](https://decan.lexpage.net/files/SANER-2022a.pdf) on GitHub in just 18 months after launching.

<!-- _Thanks to Mohak Jain for his feedback on early drafts of this article._ -->

## Notes

[^1]: Determining CI provider market share turned out to be quite the rabbit hole. In 2017, GitHub [published a chart](https://github.blog/2017-11-07-github-welcomes-all-ci-tools/) showing Travis CI at 50% market share, and CircleCI in second at ~25%, and Jenkins in third. This one was weighted by the CI context info on commits, and the numbers sound pretty reasonable to me. A [paper](https://decan.lexpage.net/files/SANER-2022a.pdf) from 2022 that surveyed npm packages with GitHub repos found GitHub Actions at 51.7%, followed by Travis at 42.5% and CircleCI at 10.2%. A [survey by JetBrains](https://www.jetbrains.com/lp/devecosystem-2023/team-tools/#ci_tools) in 2023 shows Jenkins in the lead at 54%, with GitHub Actions and GitLab CI trailing closely at 51% each and CircleCI at 11% and Travis CI at 9%. The results from 2022 and 2023 reports differ significantly. I suspect the reason these numbers vary so wildly is because they’re using different denominators - one used npm-associated GitHub repos and the other surveyed individuals.
[^2]: It also helped that Travis CI [gutted](https://www.travis-ci.com/blog/2020-11-02-travis-ci-new-billing/) their free tier during that period.
[^3]: Their markup is probably around 2-5x over their underlying infrastructure cost, evidenced by the [cottage industry](https://twitter.com/jarredsumner/status/1759597721877647644) of companies that offer hosted runners for massive discounts. AWS only wishes they could get those kinds of margins.
[^4]: I’m picking on Travis CI here since they were the biggest, but this applies to most of the CI providers I’m familiar with.
[^5]: Build systems and CI [aren’t so different](https://gregoryszorc.com/blog/2021/04/07/modern-ci-is-too-complex-and-misdirected/) and probably would benefit from some unification.
[^6]: The other option is to outsource CD processes to [Git-centric](https://www.swyx.io/netlify-git-centric) hosting providers like Vercel or Netlify. While this doesn’t replace CI completely, it can take away a decent chunk of the complexity.
[^7]: Yes, I know about [act](https://github.com/nektos/act) and [actionlint](https://github.com/rhysd/actionlint) and have used them both. While better than nothing, the local development story with GitHub Actions is still nowhere near seamless.
[^8]: An interesting comparison to think about: we know that GitHub Actions and Azure Pipelines [share infra](https://twitter.com/natfriedman/status/1159526215658561536) under the hood, and their yaml formats certainly look pretty similar. The uptick in usage of Azure DevOps has been pretty small relative to that of GitHub Actions, and that difference must be explainable by the decisions GitHub made differently.
