---
date: '2013-01-30'
title: Playing With Tokudb
tags:
- devops
- database
---



I've decided to take a look at [Tokudb] and see, how easy it is to use and administer. Since it's much better to have your stuff being repeatable and easily shareable, we're gonna use [Puppet] and [Vagrant] for this.

The layout is based on my article

[The Perfect Puppet Setup For Vagrant]({{< relref "post/2013-01-25-the-perfect-puppet-setup-for-vagrant.md" >}})-article.


``https://github.com/mindreframer/vagrant-tokudb-puppet/``



<iframe border='0' height='418' id='shelr_record_510953719660805f8d000042' scrolling='no' src='http://shelr.tv/records/510953719660805f8d000042/embed' style='border: 0' width='815'></iframe>

Let's dive deeper into a slightly more complext module for [Puppet]:

<pre><code class="puppet">
class tokudb{
  class{"tokudb::params": }
    -> class{"tokudb::users":}
    -> class{"tokudb::download":}
    -> class{"tokudb::packages":}
    -> class{"tokudb::configs":}
    -> class{"tokudb::initialize":}
    -> class{"tokudb::service":}
}

class tokudb::users{
  user { 'mysql':
    ensure => 'present',
    uid    => $tokudb::params::user_id,
  }
  -> group { "mysql":
    ensure  => "present",
    gid     => $tokudb::params::user_id,
  }
}

class tokudb::download{
  $filepath = $tokudb::params::download_file
  $fullpath = $tokudb::params::fullpath

  file{"/vagrant":
    ensure => directory
  }
  -> exec{"download tokudb":
    command => "curl $tokudb::params::download_url > /vagrant/$filepath",
    unless  =>  "test -e /vagrant/$filepath"
  }
  -> exec{"decompress tokudb":
    command => "tar xvfz /vagrant/$filepath",
    cwd     => "/usr/local",
    unless  => "test -e $tokudb::params::base_dir"
  }
  -> file{$tokudb::params::base_dir:
    ensure  => link,
    target  => "/usr/local/$fullpath",
  }
  -> exec{"adjust filerights tokudb":
    command => "chown -R mysql:mysql $tokudb::params::base_dir"
  }
}

class tokudb::packages{
  package{$tokudb::params::packagenames: ensure => installed}
}

class tokudb::configs{
  file{"/etc/init.d/mysql":
    content => template("tokudb/mysql.server.erb"),
    mode    => 0755,
  }

  file{"/etc/mysql":
    ensure => directory
  }
  -> file{"/etc/mysql/my.cnf":
    content => template("tokudb/my.cnf.erb"),
  }
  -> file{$tokudb::params::data_dir:
    ensure => directory,
    owner => 'mysql', group => 'mysql'
  }
}

class tokudb::initialize{
  $check_file = "$tokudb::params::base_dir/.installed"
  exec{"init mysql":
    command => "echo 1 && cd $tokudb::params::base_dir && ./scripts/mysql_install_db --user=mysql && touch $check_file",
    unless  => "test -e $check_file"
  }
}

class tokudb::service{
  service{"mysql":
    ensure    => running,
    subscribe => Class["tokudb::configs"]
  }
}

</code></pre>



Let's discuss some attributes, that this script exposes:

- It is composed of **small** classes with **descriptive** names

- the wiring up for **dependencies** happens in the **main class**, e.g. on a highlevel. We don't  use `require`  for smaller folders, files, packages, etc.

- it has no external dependencies (except relying on `Curl` being installed)

- we use absolute variables, like `$tokudb::params::download_file`, that means the configuration happens in `params.pp` class. The `tokudb`- class does not care, where those params came from: hardcoded, `Hiera`, CSV, with logic conditions, etc
- the order of methods is optimized for reading, it tells us a story.

- it is sequential, since people are much better at following simple 1-2-3-steps instructions, like:

- Prepare params first,  then create users, download stuff, install packages, now please create configuration files, now would be a good moment to initialize our database, ah, and since we're prepared everything, be so nice and start the process!

<pre><code class="puppet">
class tokudb{
  class{"tokudb::params": }
    -> class{"tokudb::users":}
    -> class{"tokudb::download":}
    -> class{"tokudb::packages":}
    -> class{"tokudb::configs":}
    -> class{"tokudb::initialize":}
    -> class{"tokudb::service":}
}

</code></pre>


- It's  making liberal usage of `Exec`-resource for [Puppet], that is officially not the best practice, but it's much-much faster and more flexible, than writing your own Puppet Ruby-Code for Resources
- that includes:
   - managing file rights for bigger folders ( puppet would try to store the file attributes for every file in the hierarchy and check it on every run, don't do it)
   - testing the outcome of an Exec, I don't like the `creates => 'blah'` attribute, Unix with 'test -condition evaluation utility' is more flexible
- it's idempotent, means it won't download files twice, initialize database twice, so every `Exec` Resource should have an `unless`-attribute
- it makes heavy use of `->` (ordering arrow)-Operator ([Relationshiops in Puppet](http://docs.puppetlabs.com/puppet/2.7/reference/lang_relationships.html)), e.g.

<pre><code class="puppet">
class tokudb::download{
  $filepath = $tokudb::params::download_file
  $fullpath = $tokudb::params::fullpath

  file{"/vagrant":
    ensure => directory
  }
  -> exec{"download tokudb":
    command => "curl $tokudb::params::download_url > /vagrant/$filepath",
    unless  =>  "test -e /vagrant/$filepath"
  }
  -> exec{"decompress tokudb":
    command => "echo 1 && cd /usr/local && tar xvfz /vagrant/$filepath",
    unless  => "test -e $tokudb::params::base_dir"
  }
  -> file{$tokudb::params::base_dir:
    ensure  => link,
    target  => "/usr/local/$fullpath",
  }
  -> exec{"adjust filerights tokudb":
    command => "chown -R mysql:mysql $tokudb::params::base_dir"
  }
}

</code></pre>


 - for operations, that produce no easily checkable output (like the database initialization), I'm just `touch`-ing a file after success and skip the operation, if it is already present

<pre><code class="puppet">
class tokudb::initialize{
  $check_file = "$tokudb::params::base_dir/.installed"
  exec{"init mysql":
    command => "echo 1 && cd $tokudb::params::base_dir && scripts/mysql_install_db --user=mysql && touch $check_file",
    unless  => "test -e $check_file"
  }
}

</code></pre>


 - for operations, that require changing into a directory, we use the `cwd`-attribute of the `Exec` Resource. Sometimes,  for no obvious reasoms, it won't work. Just prepending your command with "cd /some/directory && ..." will also fail, because puppet checks for binary presence, and `cd` is not a binary... So, I employ the `echo`-hack: "echo 1 && cd /some/dir && ...". Looks stupid, but works. If you have any better suggestions, pls tell me!


<div class="page-divider"></div>

 I'm quite happy with the outcome, it's comprehensible, shareable and future-proof, since we extacted the params, that might change from system-to-system or in future.

 Go ahead and play with it, see, if you like it!

[Tokudb]: http://www.tokutek.com/products/tokudb-for-mysql/
[Vagrant]: http://vagrantup.com
[Puppet]: http://puppetlabs.com
