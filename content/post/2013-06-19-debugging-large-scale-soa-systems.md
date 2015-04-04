---
date: '2013-06-19'
title: Debugging Large Scale Service Oriented Systems
tags:
- devops
---


## Debugging Large Scale Service Oriented Systems

<iframe width="640" height="360" src="http://www.youtube.com/embed/NpTT30wLL-w?feature=player_detailpage" frameborder="0" allowfullscreen></iframe>


How do you track down a problem in production? Having a homogenouis system, that you can query and that has all the information for a request that passes your production environment is really powerful.

### Used approach:
  - [Elastic Search](http://www.elasticsearch.org/)
  - Rack-Middlewares, that report stuff
  - Integration with Resque / background jobs
  - Use `Thread['local']` - variables, to pass information around
  - inspired by [Google Dapper](http://highscalability.com/blog/2010/4/27/paper-dapper-googles-large-scale-distributed-systems-tracing.html)
