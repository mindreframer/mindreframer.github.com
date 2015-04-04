---
date: '2013-01-25'
title: The Perfect Puppet Setup For Vagrant
tags:
- devops
---


To get the complete picture about the modules here, please take a look at the article
[Testing Tricky Nginx Rewrite Rules]({{< relref "post/2013-01-23-how-to-test-tricky-nginx-rewrite-rules.md" >}})



So, you're ready to jump in and start automating your server infractructure with some server provisioning software. Let's try [Puppet].


I will present you the solution and later discuss, why it's done this way.


**Vagrantfile**: we specify puppet provisioner in Vagrantfile.
We keep the configs in `puppet`  folder with two subfolders: `manifests` and `modules`

<pre><code class="puppet">
config.vm.provision :puppet do |puppet|
  puppet.manifests_path = "puppet/manifests"
  puppet.manifest_file  = "base.pp"
  puppet.module_path    = "puppet/modules"
end
</code></pre>


**puppet/manifests/base.pp**: despite being quite short, it contains a bunch of Puppet best practices.


<pre><code class="puppet">
# this is the entry point for puppet client
# setup some basic stuff here

# puppet group
group { "puppet":
  ensure => "present",
}

# the default path for puppet to look for executables
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

# the default file attributes
File { owner => 0, group => 0, mode => 0644 }

# we define run-stages, so we can prepare the system
# to have basic requirements installed
# http://docs.puppetlabs.com/puppet/2.7/reference/lang_run_stages.html

# first stage should do general OS updating/upgrading
stage { 'first': }

# last stage should cleanup/ do something unusual
stage { 'last': }

# declare dependancies
Stage['first'] -> Stage['main'] -> Stage['last']

# just some packages
package{"tmux": ensure => installed}
package{"curl": ensure => installed}

# a helper script to run puppet
file{"/usr/local/bin/runpuppet":
  content => "sudo puppet apply -vv  --modulepath=/tmp/vagrant-puppet/modules-0/ /tmp/vagrant-puppet/manifests/base.pp\n",
  mode    => 0755
}

# a helper script to run nginx tests
# runs puppet + runs the unit tests
file{"/usr/local/bin/nginx_tests":
  content => "
    cd /vagrant/nginx_tests && \
    runpuppet && \
    sudo /etc/init.d/nginx restart && \
    sudo /etc/init.d/dnsmasq restart && \
    ruby nginx_test.rb",
  mode    => 0755
}

# brings the system up-to-date after importing it with Vagrant
# runs only once after booting (checks /tmp/apt-get-update existence)
class update_aptget{
  exec{"apt-get update && touch /tmp/apt-get-updated":
    unless => "test -e /tmp/apt-get-updated"
  }
}

# run apt-get update before anything else runs
class {'update_aptget':
  stage => first,
}

class{'nginx':}
class{"rewriter_test":}

# install dnsmasq as last, because it does something to
# the network and installing after dnsmasq would not work
# for a couple seconds.
class {'dnsmasq':
  stage => last,
}

</code></pre>


[Dnsmasq]


<pre><code class="puppet">
# we use dnsmasq to allow wildchar testing for subdomains
# /etc/hosts is too limited
class dnsmasq{
  # include classes + declare dependencies in one step
  class{"dnsmasq::packages":}
    -> class{"dnsmasq::configs":}
    -> class{"dnsmasq::service":}
}


class dnsmasq::packages{
  package{"dnsmasq": ensure => installed}
}

class dnsmasq::configs{
  # all requests to (*.)dawanda.com will go to 127.0.0.1
  file{"/etc/dnsmasq.d/my_local":
    content => "address=/dawanda.com/127.0.0.1\n",
  }
}

class dnsmasq::service{
  service{"dnsmasq":
    ensure    => running,
    subscribe => Class["dnsmasq::configs"]
  }
}

</code></pre>

[Nginx]


<pre><code class="puppet">
class nginx{
  include nginx::packages
  include nginx::configs
  include nginx::service
  Class['nginx::packages'] -> Class['nginx::configs']-> Class['nginx::service']
}

class nginx::packages{
  package { "nginx":
    ensure => installed,
  }
}

class nginx::configs{
  file{"/etc/nginx/nginx.conf":
    content => template("nginx/nginx.conf.erb")
  }
}

class nginx::service{
  service{"nginx":
    ensure    => running,
    subscribe => Class["nginx::configs"]
  }
}

</code></pre>


The layout for those modules is applicable to nearly every software, you might encounter:


<pre><code class="puppet">
[1] You install packages  + install dependencies + download stuff
[2] You modify the configuration files or the downloaded software, create init scripts, folders, etc.
[3] You start your software, and subscribe to changes in config class

</code></pre>

To see a more complex real example, check my
[Playing With Tokudb]({{< relref "post/2013-01-30-playing-with-tokudb.md" >}})-article.


[Nginx]: http://wiki.nginx.org/Main
[Dnsmasq]: http://www.thekelleys.org.uk/dnsmasq/doc.html
[Puppet]: http://puppetlabs.com
