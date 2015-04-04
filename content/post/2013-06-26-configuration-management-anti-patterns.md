---
date: '2013-06-26'
title: Configuration Management Anti-Patterns
tags:
- devops
---




Some Anti-Patterns for DevOps peeps explained, I personally like following tips:

  - Build packages. Seriously, it's worth it. Use [FPM](https://github.com/jordansissel/fpm) for it
  - don't deploy with your configuration tool
  - if you can't run end-to-end provisioning in a single run, it's a BUG
  - use a build system to run each type of machine in an isolated  environment - LXC/chroot
      -> Or use [Docker](http://docker.io) for easier management of LXC containers!


<script async class="speakerdeck-embed" data-id="02758ad0bc19013009de5aad18798b8a" data-ratio="1.72972972972973" src="//speakerdeck.com/assets/embed.js"></script>
