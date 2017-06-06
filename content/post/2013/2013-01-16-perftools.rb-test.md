---
date: '2013-01-16'
title: Testing perftoos.rb
tags:
- performance
---


<pre><code class="language-shell">
$ gem install perftools.rb
# now run the tests
$ CPUPROFILE=profiled RUBYOPT="-r`gem which perftools | tail -1`" the_command_to_run_tests
# now create the pdf with results
$ pprof.rb --pdf profiled > profiled.pdf
</code></pre>


### Possible errors

<pre><code class="language-shell">
sh: dot: command not found
sh: ps2pdf: command not found
</code></pre>

Fix on OSX by installing `graphviz` and `ghostscript`:

<pre><code class="language-shell">
brew install graphviz
brew install ghostscript
</code></pre>
