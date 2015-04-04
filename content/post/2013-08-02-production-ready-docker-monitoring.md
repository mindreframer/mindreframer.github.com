---
tags:
- devops
- docker
date: '2013-08-02'
title: Production-ready Docker monitoring
---


There is an <a href='https://groups.google.com/forum/#!msg/docker-club/PfgpE3p1QKw/bWpKpkSf7pYJ'>interesting discussion in the docker user-group</a> about docker specific process monitoring. Here is a response from Jérôme Petazzoni, one of the core developers of docker:


<pre><code class="nohighlight">
    Let's see what we can do with docker as it is today.
    If we were to write an upstart service or systemd unit, it would probably do something like the following:

    ID=$(docker run -d foo)
    docker wait $ID

    When the container exits/crashes, a new one is restarted automatically.
    This is great, except if you want to restart the container and retain its state (i.e. not restart a new container from scratch, but restart the one which just crashed/stopped).

    In that case, you need some trickery, i.e. save the $ID somewhere and invoke "docker start $ID" instead of "docker run". Not very pretty.

    However, since we have volumes, I'm willing to adopt this bold stance: "If you want your containers to persist some state across restarts/crashes, then you have to use volumes!"
    It will require a tiny bit of extra work, because if you want to run e.g. a MySQL database (and retain its data), you will have to explicitly bind a volume to it.
    But that makes sense: you're no longer starting a random, anonymous, "once-I'm-gone-I-cease-to-exist" container;
    you're starting *the* specific database to hold such and such data, and you certainly want to know where the data lives
    (or at least, you will sleep better at night knowing that it's not some anonymous volume waiting to be garbage collected without notice).

    Then everything becomes easy: "docker run -d" + "docker wait", voilà.
    This covers use case #1 (auto-restart stuff when it crashes) and #2 (auto-start stuff at boot), but not #3 (send signals).
    It's already hackable with

    docker inspect + kill $(cat /sys/fs/cgroups/whatever/lxc/$fullcontainerid/tasks),

    so adding the feature to docker should be fairly easy ("docker signal", or even "docker kill -signal TERM", or even "docker kill -TERM" to be as UNIX-y as possible?)

    I would personally advocate against a "signal proxy", because it will never work with SIGSTOP and SIGKILL.

    My 2c,
</code></pre>