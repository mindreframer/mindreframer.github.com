---
date: '2013-10-09'
title: 'x509: failed to load system roots and no roots provided'
tags:
- tips
---


While playing today with **"github.com/prometheus/client_golang"**, I have encountered that strange error:

`x509: failed to load system roots and no roots provided`




<% code_block 'shell' do %>
$ gom install
>installing github.com/prometheus/client_golang/prometheus
>package code.google.com/p/goprotobuf/proto: Get https://code.google.com/p/goprotobuf/source/checkout?repo=: x509: failed to load system roots and no roots provided
gom:  exit status 1
<% end %>




After a solid 30 minutes of googling,  that answer really helped:


http://comments.gmane.org/gmane.comp.lang.go.general/108420
<blockquote>

  1. Are you using homebrew ? If yes, then you need to rebuild your Go
  installation with the --with-cgo flag. Why homebrew defaults to
  disabling cgo is beyond my comprehension.

  2. go env CGO_ENABLED should report the value of 1, any other values
  are incorrect. Cgo is required to use TLS on OS X as the ssl root
  certificates are kept inside the Apple Keychain software, only
  accessible via C.

</blockquote>

## Solution:

    $ brew uninstall go
    $ brew install go  --with-cgo
    $ gom install
    > installing github.com/prometheus/client_golang/prometheus

    # Done!

