---
date: '2014-02-27'
title: Agent forwarding + Capistrano + UTF-8 ENV settings problems
tags:
- devops
---


Today I have spent a couple of hours trying to figure out, why my agent forwarding for Capistrano was not working. I have already

    ## added my ssh key with
    $ ssh-add

    ## adjusted  ~/.ssh/config
    Host *.the-domain-to-deploy.com
      ForwardAgent yes

    # configured capistrano in config/deploy.rb
    set :ssh_options, { :forward_agent => true }


Still no luck...

    Host key verification failed.
    fatal: The remote end hung up unexpectedly


Even that post was not helping: http://dchua.com/2013/08/29/properly-using-ssh-agent-forwarding-in-capistrano/.


But... My colleages had hit the same problem before and the solution is:

**set ALL YOUR LC_* ENV VARIABLES!**


The last missing bit : in your .bashrc/.zshrc/.whateverrc

    export LC_CTYPE=UTF-8
    export LC_ALL=en_US.UTF-8
    export LANG=en_US.UTF-8
    export LANGUAGE=en_US.UTF-8

  Thanks a lot!
