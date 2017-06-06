---
date: '2013-10-24'
title: Caching With Varnish, Step-By-Step
tags:
- devops
---



## A basic introduction to Varnish:

<iframe width="640" height="390" src="//www.youtube.com/embed/qbtZuyE-6YQ" frameborder="0" allowfullscreen></iframe>


## Interesting Points:

  Advanced Cache Invalidation:

    - https://www.youtube.com/watch?v=qbtZuyE-6YQ&feature=player_detailpage#t=2336 (38:00)
    - Tag pages with custom headers:
      - X-Skus: 49991,12345,453453
    - execute with bans or hashninja
    - possible database driven expiry (triggers)


See for more information: [Varnish Cache Invalidation]({{< relref "post/2013/2013-10-25-varnish-cache-invalidation.md" >}})



