---
date: '2013-01-24'
title: How to test tricky nginx rewrite rules - Part II
tags:
- devops
---


[A possible solution to Part I]({{< relref "post/2013/2013-01-23-how-to-test-tricky-nginx-rewrite-rules.md" >}})


Take a look here:

<pre>
  <code class="nohighlight">
  https://github.com/dawanda/nginx_rules_tests
  </code>
</pre>

With a couple commands you get the complete working environment (after you have installed [Vagrant]):


<pre>
  <code class="lang-bash">
    $ git clone git://github.com/dawanda/nginx_rules_tests.git
    $ cd nginx_rules_tests

    # start vagrant + run puppet
    $ vagrant up

    # ssh into your VM
    $ vagrant ssh

    # run the tests, they shall pass
    $ nginx_tests
  </code>
</pre>



### Here you can see it in action:

<iframe border='0' height='432' id='shelr_record_5102f4d6966080054900005c' scrolling='no' src='http://shelr.tv/records/5102f4d6966080054900005c/embed' style='border: 0' width='815'>

</iframe>

Here the nginx config we want to test, it is still very short yet.

{{< code type="nginx" >}}
  ## dawanda subdomain tests
  server {
    listen 80;
    # match wildchar subdomains and main domain
    server_name *.dawanda.com;
    server_name dawanda.com;
    location / {
      # store subdomain in a variable
      if ($http_host ~ (.*)\.dawanda\.com) {
        set $subdomain $1;
      }

      # default language should be german
      set $current_language 'de';
      if ($subdomain = 'en'){ set $current_language $subdomain; }
      if ($subdomain = 'fr'){ set $current_language $subdomain; }
      if ($subdomain = 'pl'){ set $current_language $subdomain; }
      if ($subdomain = 'nl'){ set $current_language $subdomain; }
      if ($subdomain = 'es'){ set $current_language $subdomain; }
      if ($subdomain = 'it'){ set $current_language $subdomain; }

      # we return a permanent (301) redirect for www
      if ($subdomain = 'www'){
        rewrite  ^/(.*)$  http://dawanda.com/$1  permanent;
        break;
      }

      # nginx has no AND for IFs, have to use $subdomain_could_be_shop to simulate that...
      # oh, on explicit matches, must be a shop subdomain
      if ($subdomain != $current_language){
        set $subdomain_could_be_shop  "1";
      }

      # also check, if we requested with subdomain
      if ($subdomain != ''){
        set $subdomain_could_be_shop  "${subdomain_could_be_shop}1";
      }

      # not a lang subdomain + we have an actual subdomain
      if ($subdomain_could_be_shop = '11'){
        rewrite  ^/(.*)$  http://de.dawanda.com/shop/$subdomain  permanent;
        break;
      }

      # this is the important part, this will land in env['REQUEST_URI']
      proxy_set_header Host $current_language.dawanda.com:9292;

      # you can proxy-pass to anything on that machine.
      proxy_pass http://dawanda.com:9292;
    }
  }

{{< /code  >}}


Basically, we check, if the subdomain is one of the supported languages or _www_, if not, we assume, it is a user subdomain (looks good on your business card) and transparently proxy the request with correct URL to our app-servers.

We want to make sure that:

   - lang subdomains work
   - we have default 'de' lang subdomain
   - 'www' is redirected to 'de' subdomain
   - everything else is redirected to http://de.dawanda.com/shop/SOME_SHOP_SUBDOMAIN
   - we don't mangle the URL-path and URL-params with our logic in nginx


Let's look at our tests:
{{< code type="ruby" >}}

  describe "subdomains" do
    describe "lang" do
      LANGUAGES.each do |lng|
        it "passes language #{lng} through" do
          check_request_uri("#{lng}.dawanda.com").must_equal "#{lng}.dawanda.com/"
        end
      end

      it "defaults to 'de' lang" do
        check_request_uri("dawanda.com").must_equal "de.dawanda.com/"
      end
    end

    describe "shop subdomains" do
      it "works" do
        make_request("meko.dawanda.com").must_match "301 Moved"
        make_request_for_headers("meko.dawanda.com").must_match "de.dawanda.com/shop/meko"
      end
    end

    describe "www is redirected" do
      it "works" do
        make_request("www.dawanda.com/shop/Meko/first").must_match "301 Moved"
      end
    end
  end

  describe "path" do
    it "is left untouched" do
      check_request_uri("de.dawanda.com/shop/Meko/first").must_equal "de.dawanda.com/shop/Meko/first"
    end
  end

  describe "params" do
    it "is left untouched" do
      check_request_uri("de.dawanda.com/shop/Meko/first?a=1").must_equal "de.dawanda.com/shop/Meko/first?a=1"
    end
  end
{{< /code >}}


Isn't it readable Ruby code, we all love to read and understand?

Let's look at the helper-methods:


<pre><code class="ruby">
  def make_request(url)
    r = `curl -s '#{url}'`
    JSON.parse(r) rescue r
  end

  def make_request_for_headers(url)
    r = `curl -s --head '#{url}'`
  end

  def check_request_uri(url)
    r = make_request(url)
    remove_port(r["REQUEST_URI"].gsub("http://", ''))
  end

  def remove_port(url)
    url.gsub(/\:9292/, '')
  end
</code></pre>


And now, the trick - we just return the request environment (well, the parts, that we want to test) as JSON-String from a Sinatra App (could be just plain Rack).


<pre><code class="ruby">
require 'sinatra/base'
require 'json'

class EnvApp < Sinatra::Base

  get '*' do
    #  ["REQUEST_PATH", "REQUEST_URI", "REQUEST_METHOD", "REQUEST_PATH", "PATH_INFO"]
    keys =  (request.env.keys.grep(/REQ/) + request.env.keys.grep(/PATH/))
    r = {}
    keys.each {|k| r[k] = request.env[k]}
    JSON.unparse(r)
  end
end

</code></pre>

Since we're using Dnsmasq, requests to all domains + subdomains you have configured, would arrive at this app, on the port, you're listening on (I kept the default 9292-Sinatra port, but it's up to you).


This solution is by far not perfect. You're testing only rewrite rules. And you have to listen on the ports, that you're proxying to. But since you've automated everything until now, there is little holding you from automating the rest... Just don't make it too complicated. And if your configs contain really weird stuff, take a step back and rethink it... Maybe it's worth skipping. Just sayin'.

What do you think, is this approach helpful for your [Nginx] setup? Please give me some feedback!



**To read about Puppet modules used here, please click here. -->**  [More on Puppet Modules]({{< relref "post/2013-01-25-the-perfect-puppet-setup-for-vagrant.md" >}})


[Nginx]: http://wiki.nginx.org/Main
[Dnsmasq]: http://www.thekelleys.org.uk/dnsmasq/doc.html
[Vagrant]: http://vagrantup.com
[Puppet]:  http://puppetlabs.com/
[Chef]: http://www.opscode.com/chef/
