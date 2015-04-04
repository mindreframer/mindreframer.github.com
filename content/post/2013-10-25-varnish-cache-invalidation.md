---
date: '2013-10-25'
title: Varnish Cache Invalidation
tags:
- devops
- varnish
---


## Solutions from Varnish:
  - [Default approach](https://www.varnish-software.com/static/book/Cache_invalidation.html)
  - [Hashtwo/Hashninja](https://www.varnish-software.com/blog/advanced-cache-invalidation-strategies)
  Hashtwo maintains an additional hash, in addition to the main hash that links objects and content in Varnish. You can put whatever you want into the hash and it will maintain a many-to-many relationship between keys and objects
  So, in the example above the content presentation layer could spit out the same list of articles in a header and hashtwo will maintain pointers from article numbers to cached object. The hash is pretty efficient and won't require much overhead.
  - [Super Fast Purger](https://www.varnish-software.com/blog/vac-203-high-performance-cache-invalidation-api-aka-super-fast-purger), [video](http://vimeo.com/74388108)


## How Fastly deals with it:

  - http://www.fastly.com/blog/surrogate-keys-part-1
  - http://www.fastly.com/blog/surrogate-keys-part-2
  - https://www.varnish-cache.org/trac/wiki/VDD13Q2_notes

## Bans vs Purges:

  - https://www.varnish-cache.org/docs/3.0/tutorial/purging.html
  - https://www.varnish-software.com/blog/bans-and-purges-varnish-30
  - https://gist.github.com/aderowbotham/5517123


## Home-Grown Solutions:
  - [Tag, you're it! Keep your reverse - Proxy Cache Up-To-Date, 2013.09](http://drupaltv.org/video/tag-youre-it-keep-your-reverse-proxy-cache-date)
  - [Tagged Cache Invalidation, 2012.09](http://blog.kevburnsjr.com/tagged-cache-invalidation)
  - [Use Tagged Cache Invalidation instead of purging specific URLs in Varnish, 2013](https://groups.drupal.org/node/297773)
  - [Varnish Cache Invalidation Via PostgreSQL and RabbitMQ, 2012](https://github.com/ocharles/varnish-cache-invalidation)
  - [Database Driven Cache Invalidation, 2011](http://www.hagander.net/talks/Database%20driven%20cache%20invalidation.pdf), [video](https://ep2013.europython.eu/conference/talks/data-driven-cache-invalidation)
  - [Wikia Approach, pp. 62-67](http://s.urge.omniti.net/i/content/slides/ArturBergman.pdf)

## Database Triggers:
  - Postgres:
    - [CartoDB - centralize-varnish-trigger](https://github.com/CartoDB/cartodb/issues/197)
    - [Postgres NOTIFY for cache busting and more](http://www.chrisstucchio.com/blog/2013/postgres_external_triggers.html)

## Some Varnish Links:

  - [OAuth with Varnish](http://www.adayinthelifeof.nl/2012/07/06/using-varnish-to-offload-and-cache-your-oauth-requests/)
  - [Caching Everything, 2013.08](http://www.speedawarenessmonth.com/caching-everything-step-by-step/)
  - [Moving Varnish Caching Logic Into PHP With the cURL VMOD](http://blog.iweb-hosting.co.uk/blog/2012/11/20/moving-varnish-caching-logic-into-php-with-the-curl-vmod/)

## Caching Logged in Users

  - [Caching logged in users](https://www.varnish-cache.org/trac/wiki/VCLExampleCachingLoggedInUsers)
