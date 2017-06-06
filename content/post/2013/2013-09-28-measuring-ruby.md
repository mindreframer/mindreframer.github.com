---
date: '2013-09-28'
title: Measuring Ruby
tags:
- performance
---



<iframe width="640" height="360" src="//www.youtube.com/embed/LWyEWUD-ztQ?feature=player_embedded" frameborder="0" allowfullscreen></iframe>


http://confreaks.com/videos/2668-gogaruco%25202013-measuring-ruby

## Profiling Ruby App:

  - Use latest Ruby :)
  - Audit memory usage with `memory_profiler`
  - run `rack_mini_profiler` in dev and production
  - use `flamegraphs` to find slowest code
  - use `rbtrace` to understand, what your code is doing

## Links:
  - https://github.com/SamSaffron/memory_profiler
  - https://github.com/MiniProfiler/rack-mini-profiler
  - https://github.com/SamSaffron/flamegraph
  - https://github.com/tmm1/rbtrace
  - http://samsaffron.com/archive/2013/03/19/flame-graphs-in-ruby-miniprofiler
