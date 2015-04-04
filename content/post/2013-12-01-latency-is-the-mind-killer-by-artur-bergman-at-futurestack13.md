---
tags: []
date: '2013-12-01'
title: Latency is the Mind Killer by Artur Bergman at FutureStack13
---




Latency is the Mind Killer by Artur Bergman at FutureStack13

<iframe width="640" height="390" src="//www.youtube.com/embed/zrSvoQz1GOs" frameborder="0" allowfullscreen></iframe>


### Interesting points:

    General Recommendations for Latency Reduction
      - do Cache (duh!)
      - do purge (real-time purging is difficult, but awesome, when it works)
      - do use a CDN for HTTP/SSL termination at the edge (30-60% speed improvement)
      - do use surrogate keys

    Harden Machines, 9:49
      - 3 mio syn cookies/sec/machine after patching the kernel

    Surrogate Key, 15:30
      - tagging your cache-objects and expire by tags

    Dont be affraid of assembly (16:50):
      - a ruby script generates with metaprogramming assembly, that is compiled
      by varnish VCL and loaded as shared library, so it allows to match
      ~ 200 mio virtual hosts/sec on a standard laptop (wow!)
      - no dynamic memory allocation

    Short TTL
      - even 1 sec ttl allows you to protect your origin and survive flash traffic



### My personal takeaways:

    - Assembly in your Varnish config, thats a new perspective
    - a nice application of Ruby metaprogramming to generate assembly
    - Surrogate keys in Varnish are awesome, but they require premium subscription (HashNinja) or you could try to write you custom implementation
