---
date: '2015-05-25'
title: I'm betting my professional future on Elixir and why you should too
slug: i-m-betting-on-elixir-and-why-you-should-too
draft: true
tags:
- opinion
- devops
- scalability
---


First of all: who am I and why should you even listen?

I'm not very active in Ruby (or any other) community and you probably have not heard about me before.
What makes me special is that I was one of the first hired engineers at DaWanda (german Etsy) and helped to grow their backend platform from initial 5 manually configured servers to over 150 dedicated / virtual servers. In that time it was a monolithic Rails app (now it might be more SOA like architecture). We had hit every problem a successful Rails app has to overcome:

  - high memory consumption per process
  - high cost of scaling up (colocation hosting requires upfront planning and some strategic thinking)
  - slow start-up times of the app
  - very slow test suite
  - slow development cycles after a certain phase
  - many coupled dependencies in the app (our own and also third party libraries)
  - polyglot persistence:
    - mysql
    - memcache
    - redis
    - SOLR
    - Varnish (not a database, but still a stateful componnent, that can get out of sync with real data)

The founder Michael Pütz and me became the first DevOps team and we had to build quite a lot of tooling around the app to keep it running:

  - custom monitoring solution (our inhouse version of Nagios, that in the end sucked like hell)
  - custom dashboard(s) to have a cluster wide insight into the app's business and server metrics
  -




<!--more-->