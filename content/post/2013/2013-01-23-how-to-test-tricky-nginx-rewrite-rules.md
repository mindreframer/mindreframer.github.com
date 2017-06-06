---
date: '2013-01-23'
title: How to test tricky nginx rewrite rules - Part I
tags:
- devops
---


So, you're using [Nginx] to serve your web-application and feel great about using such a nice piece of russian software mastery and indeed, you're in good company: many high profile sites rely on [Nginx] - [Github], [Heroku], [Cloudflare] to name a few.

But the configuration language feels tricky and usually it's a very painful process, until you get something usable and working. And the configuration file keeps on growing and growing... You know, [organic growth](http://en.wikipedia.org/wiki/Organic_growth), they say... Sometimes it's rather explosive growth... How do you make sure, that all those weird and old rules are still working and that they should be kept around?


Let's review how we usually test such configuration changes:

  - change the config (in production!)
  - reload nginx with new configuration (with syntax check before)
  - pray the site is still up and running
  - curl some url, that should now work
  - pad yourself on the shoulder or repeat the whole cycle
  - if you broke something, revert your change quickly and pretend nothing has happened...
  - sometimes your successful change breaks something else... But you've got users to find that out, right?

Sure, you can live that way till you die and still be a happy and awesome human being, but this way of working is such a pile of CRAP. It's fundamentally broken. We're engineers, for Christ's sake! We like our stuff to be ... Verifiable. Solid. Easy to change. Understandable.


First we should identify the problems, that stop us from testing [Nginx].

**PAIN points**

  - [1] Nginx must be compiled and installed somewhere
  - [2] It takes time to configure it all right and remember all the commandos
  - [3] Nginx configuration operates with IPs and domains and URLS and ports and files and folders and many more
  - [4] Nginx is written in C and has no [REPL] and no debugger
  - [5] Configuration is not a Turing complete programming language


Plenty of reasons not to test [Nginx] configuration... Sad panda. Guess that's just it. No way to test them. Except in production. Or in QA/staging environment, if you're lucky.


**Possible solutions**

  - **[1]** Use [Vagrant]. Don't mess with your working environment! Really, if you don't know, what this is, go and read about it! It's awesome. Thx to [Mitchell Hashimoto] you can recreate in scriptable fashion server environment on your local machine.
  - **[2]** Use Configuration Management Software like [Puppet] or [Chef]. Manual server-management is suicide! You will hate your life. And you should cherish it instead.
  - **[3]** Use a real, lightweight DNS-Server for this, for example [Dnsmasq], when you have to  deal with domains, subdomains, etc. `/etc/hosts`- file is fine, but works not for wildchar subdomains. Use it for IPs.
  - **[4]** Script your testing steps with UnitTests/Cucumber/whatever.
  - **[5]** Well, no real help here, but you can use templating in [Puppet]/[Chef] to reduce some repetition. Still not the real thing.


So, a **desired solution** would be:

- A [Vagrant] VM with your Linux destribution, that you're using in production with [Nginx] installed + properly configured and a script, that ensures, you're doing the right thing + everything is in [DVCS].



[Move on to solution in Part II]({{< relref "post/2013/2013-01-24-how-to-test-tricky-nginx-rewrite-rules-part-2.md" >}})





[Nginx]: http://wiki.nginx.org/Main
[Dnsmasq]: http://www.thekelleys.org.uk/dnsmasq/doc.html
[Github]: http://github.com
[Heroku]: http://heroku.com
[Cloudflare]: http://cloudflare.com
[REPL]: http://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop
[Vagrant]: http://vagrantup.com
[Puppet]:  http://puppetlabs.com/
[Chef]: http://www.opscode.com/chef/


[Mitchell Hashimoto]: https://twitter.com/mitchellh
[DVCS]: http://en.wikipedia.org/wiki/Distributed_revision_control
