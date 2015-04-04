---
date: '2014-11-05'
title: Scalable Deployments - How we deploy Rails app to 100+ hosts in a minute (Cookpad
  - JP)
tags:
- devops
---



## Mamiya: Fast deployments with Serf and S3


Nice and simple usecase for [Serf](https://www.serfdom.io/): massive fast deployments. I really like the simplicity of the approach. Serf could be replaced by [Consul](https://consul.io/), it even has got remote execution framework, so deployment would be even simpler!



  - [On Github](https://github.com/sorah/mamiya)
  - [Japanese Presentation video](http://rubykaigi.org/2014/presentation/S-ShotaFukumori)



<!--more-->


<script async class="speakerdeck-embed" data-id="b22712e0246e0132bddb12a238f45ab0" data-ratio="1.77777777777778" src="//speakerdeck.com/assets/embed.js"></script>

https://speakerdeck.com/sorah/scalable-deployments-how-we-deploy-rails-app-to-150-plus-hosts-in-a-minute


SCALABLE DEPLOYMENTS - HOW WE DEPLOY RAILS APP TO 100+ HOSTS IN A MINUTE

Shota Fukumori
If you're developing webapps, I guess you deploy sometime using tools like Capistrano. We think existing tools slow for huge apps and a lot of servers.

We serves cookpad.com, which is a huge Rails app, and the largest recipe site in Japan. It's backed 120+ app servers. We've used Capistrano + SSH + rsync, but it became a bottleneck, slower and slower, as well as server increases. Our developer have wanted to focus on development. Deployments should be done in short time.

In this talk I'll introduce about our new deploy tool Mamiya, and will talk about how we deploy webapp in a minute.
