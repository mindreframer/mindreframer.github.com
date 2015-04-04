---
date: '2013-01-12'
title: Architecture - Drawing Lines?
tags:
- architecture
---


I'm not the first to chime in about Uncle Bob's Lost Years presentations:

- [Robert C. Martin - Clean Architecture](http://vimeo.com/43612849)
- [Keynote: Architecture the Lost Years by Robert Martin - YouTube](http://confreaks.com/videos/759-rubymidwest2011-keynote-architecture-the-lost-years)


His ideas (maybe not originally his) lure you in with loud promices about clean architecture... This got me thinking... Yeah, I'm easily seduced by *cleanness*. Sigh...


## Here some ideas worth thinking about:

<pre>
  <code class="nohighlight">
    - Test are not for QA Team, good tests guide YOU
      and allow you to _rapidly_ and _radically_ refactor your code
    - If you're afraid to change something, you're dominated by your creation
    - Good architecture allows deferring decisions
    - Is your application build around a database?
    - Is your application build around a framework?
  </code>
</pre>



## Some more:
<pre>
  <code class="nohighlight">
  - Rails is a web delivery mechanism
  - It's a minor implementation detail (WOW)
  - It should be easy to change your framework
  - It should be easy to change your database
  - It should be easy to change your cache store
  - It should be easy to change your background queue
  - It should be easy to change your services
  </code>
</pre>

## Some implications:
<pre>
  <code class="nohighlight">
  - your business logic can live in a lib/gem/dll/jar/etc
  - your business logic does not depend on concrete implementations
  - tests for your business logic are damn fast
  - you're not afraid to change it, since it is coverred by tests
  - it has no notion of HTTP-ness in it!
  - divorce the WEB! ))
  - run use-cases without the web-server!
  - delivery(e.g. Web Framework) is a plugin to your Application
  </code>
</pre>

## Objects with Roles:
<pre>
  <code class="nohighlight">
  - Entities:
    - have Application independent business rules
  - Boundaries
    - just the Interface(-s) to communicate to/from UseCases
    - nothing special in Ruby, just method names
  - Interactors (UseCases):
    - have Application specific business rules
    - could have a names like: DeleteUserAction, CreateOrderAction, CheckoutAction, etc
  - Presenter:
    - massages the ResponseModel into a viewable structure (ViewModel) (formatting, booleans for checkboxes, etc)
    - can be easily tested - shove in a ResponseModel, check the returned ViewModel
  - ViewModel:
    - is rendered by the View
  - View:
    - dumb renderer
    - can be easily tested - shove in a ViewModel, check the returned HTML
  - Request/Response Models
    - pure data structures, easily created, follow a simple protocol
  </code>
</pre>


#### Request/Response Model

[Presentation][presentation]

{{< post_image src="controller_interactor.png" >}}



#### DB and Web Framework irrelevant yet

[Presentation][presentation] (43:00)

{{< post_image src="delivery_db_behind_lines.png" >}}



#### ResponseModel-Presenter-ViewModel-View

[Presentation][presentation] (48:30)

{{< post_image src="model_view_presenter.png" >}}



#### Console Delivery

[Presentation][presentation] (50:50)

{{< post_image src="console_delivery.png" >}}


____________
#### Summary

Divorce your database will be really hard.... Can't really imagine it in a real complex application without beeing major PITA to use. But I might be wrong. Isolate yourself from Rails - yes, you should do it.

[presentation]: http://vimeo.com/43612849
