---
tags:
- devops
date: '2013-10-22'
title: OpsWorks vs Chef-Server
---



A couple of days ago I was tasked to get a running MongoDB cluster, that configures itself with AWS OpsWorks.

## Requirements:

  - create EBS volumes
  - discover other nodes with this recipe in run-list
  - create MongoDB replica set or join an existing one

The cookbook from [Edelight](https://github.com/edelight/chef-mongodb) provides most of it, and I created a fork with changes from Parse.com for EBS-Volumes creation here:

  - https://github.com/devopsbox/chef-mongodb/tree/ec2.

It works nicely with Chef-Server. Shouldn't be that hard to rewrite it for OpsWorks, right?


After spending two days on it, __I basically gave up__.


### Light Problems:

  - private ssh key for my custom cookbooks repo is stored in plaintext
  - no real possibility to use Librarian/Berkshelf, you have everything in one repository
  - only one repository for custom chef cookbooks allowed
  - anything interesting requires you to use custom cookbooks
  - feedback in the web UI is rather slow
  - `opsworks-agent-cli run_command update_custom_cookbooks` did not work, until I have run it from the Web UI, took me a while to figure it out
  - changing JSON data for the whole [Stack](http://docs.aws.amazon.com/opsworks/latest/userguide/workingstacks.html) was not reflected on running instances, checked with `opsworks-agent-cli get_json`
  - even after having rebootet them, the data was just not there...


### Heavy problems:

  - no possibility to have encrypted/secured data bags
  - no search available
  - the json, that represents the whole [Stack](http://docs.aws.amazon.com/opsworks/latest/userguide/workingstacks.html), does not contain all the meta- information about chef configuration on that instances. That was all I could get:

<pre><code class="ruby">
> node['opsworks']['layers']['mongodb']['instances'].first
=> ["doughnut",
{"region"=>"eu-west-1",
"status"=>"online",
"private_dns_name"=>"ip-10-34-130-XXX.eu-west-1.compute.internal",
"created_at"=>"2013-10-22T11:55:31+00:00",
"elastic_ip"=>nil,
"booted_at"=>"2013-10-22T12:06:35+00:00",
"aws_instance_id"=>"i-a8055XXX",
"instance_type"=>"m1.medium",
"private_ip"=>"10.34.130.XXX",
"availability_zone"=>"eu-west-1a",
"id"=>"9769861c-ae1f-473a-a37d-0462934515da",
"ip"=>"54.247.56.XXX",
"backends"=>4,
"public_dns_name"=>"ec2-54-247-56-XXX.eu-west-1.compute.amazonaws.com"}]

</code></pre>


  - you have to rewrite plenty of cookbooks, that use advanced Chef-Server capabilities, like **search**, **databags** etc.


I did like thinking in:

  - Stacks
  - Layers
  - Applications
  - time/load-based Instancess
  - integrated Monitoring
  - Permission Management


But overall the limitation are too limiting. Maybe next time.
