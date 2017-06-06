---
date: '2017-06-06'
title: 'Blog revival - 2017 edition'
draft: false
tags:
- general
---

It seems like I was under water for 2 years... I became a father of a very active boy and at the same time I have shifted my professional focus to many new and very differnt things... It is still not quite clear to me what long-term effect that will have in my life, but my horizon widened drastically...

Elixir, Clojure, Golang... Those three languages dominated my attention recently. United by first class concurrency constructs, they are very different in their philosophies.

### Elixir

Elixir cares about programmer productivity and gives you a LISP-y language in regular, Ruby-like clean syntax on top of Erlang / OTP. It is an amazing platform and I would love to explore that space some time later. Why not now? A simple realization that it would be quite hard to have my complete application in a single big repository (mono-repo), even with umbrella-projects become a deal-breaker to me.

I want my application to be a single big thing. Supervisor trees, Actors, Processes give you nice primitives to segrate your application in smaller units, and Erlang apps are developed in big, monolithic style. The compilation step in Elixir makes it quite painful, CI / deployments become slow and require special attention... I dont know how a proper solution would look like. To be clear: this is a potential roadblock for applications with lots of code. 95% of startups can ignore this and still go really far.

### Clojure

Clojure is awesome. Applied carefully, LISP parenthesis blend with whitespace and you end up with just the essence of your domain problem. Really powerful. My nitpicks are similar: slow compilation for deployment artefacts, slow startup times for big-ish apps, big jar / war files. Another possible problem: it requires highly skilled people to maintain the code afterwards. Lots of run-time magic can potentially complicate development.


### Go

So... Go. I have dabbled with Go in 2013 and mostly missed the point. It felt a bit cumbersome and not very flexible. The amount of learning material was quite low, number of real life projects using Go was also not that impressive and I have decided to keep it on hold.

Fast forward to 2016 - 2017. There are many high-profile open source projects in the DevOps space written in Go, lots of databases in Go, lots of everything in Go.

Quick compilation, small binaries, great performance, minimal impact GC, lots of tooling around static analysis, code coverage, runtime inspection. Go naturally lends itself to code generation by making some interesting design choices.

A folder with a bunch of go-files is a package. File-names do no matter, that means your package could be a single file or hundreds of files: it is still one single package.

Go has a very strong notion of packages. Package declaration comes first. Import statements follow. The format of a go file is pre-scribed, there is no flexibility here.

It feels restrictive, but it opens up opportunities for simplicity by going back to basics.
You become productive in Go after a while and your code stays performant enough for most usecases. Mechanical sympathy means you get away with simpler solutions, because they are just fine.

Abstractions: well... Go makes is hard to do lots of runtime magic tricks, so you will need to replace metaprogramming with static code generation and make those parts simple to have maintainable code longterm.


I am very intrigued by the social effects a Golang codebase brings, it seems to attract people with no-frills, down-to-earth attitude.

Overall I want to invest in Go more in my near term future.

