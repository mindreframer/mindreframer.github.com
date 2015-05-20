---
date: '2015-05-20'
title: MemSQL Community Edition 4.0 free unlimited capacity
slug: memsql-community-edition-unlimited
tags:
- databases
- devops
- scalability
---


### MemSQL Launches Community Edition: World’s Fastest In-Memory Database Now Available to All
  - http://www.memsql.com/releases/memsql-4/


### Links:
  - http://blog.memsql.com/high-speed-counters/
  - http://docs.memsql.com/latest/admin/high_availability/ - HA details
  - http://docs.memsql.com/latest/setup/setup_cloud/ - Setup in Cloud
  - https://github.com/memsql

### People:
  - https://twitter.com/NikitaShamgunov



### Videos:
  - https://www.youtube.com/watch?v=FF6Sb4LLDso - MemSQL 4 Community Edition
  - https://vimeo.com/gomemsql
  - https://vimeo.com/89430711 - Strata Santa Clara 2014 MemSQL CPXi Speaking Session
  - https://vimeo.com/105708657 - Webinar On-Demand: NoSQL vs NewSQL
  - https://www.youtube.com/watch?v=Lf0qgt_G2-s - MemSQL - Real Time Big Data in a Distributed SQL System (21.10.2013)
  - https://www.youtube.com/watch?v=MWo5rY06RTw - Moving Beyond Mongo Webinar HD (01.05.2015)
  - https://www.youtube.com/watch?v=QhlqDmJHLK0 - Solving Big Data Challenges with In Memory Technology HD (28.04.2015)
  - https://www.youtube.com/watch?v=5_0rG5GhHNE - Bringing OLAP Fully Online: Analyze Changing Datasets in MemSQL and Spark with Pinterest Demo (08.05.2015)


<!--more-->


### User stories
  - http://insidebigdata.com/2014/03/28/memsql-eliminates-etl-delivering-real-time-advantage/ - MemSQL Delivers Advantage for Real-Time Ad Bidding
  - http://www.memsql.com/case-studies/


### Discussion on HN
  - https://news.ycombinator.com/item?id=9577663

  Some comments:

    I have been an enterprise user and had the luxury of using the 4 beta for the last month or so. I run a cluster of 18 machines with 192 cores and 540GB of RAM.
    Impressions:
    memSQL is remarkably stable. I actually have one machine running the old memSQL 1.0 beta that has not rebooted in months. 4.0 has similarly stable. The only problems happen when you run too many other processes on the aggregators (which is really just me being stupid).
    Speed is great and the wire compliance with mySQL makes it very easy to develop for. To be honest, the "keeping the data in memory" part isn't the best part, it is the query compiling. It is incredibly fast. Often a query that takes 30sec to 1min to execute will compile down to fractions of a second. It is very cool to watch and never gets old.
    We are looking to literally move all of our internal stuff to memSQL community edition while keeping our customer tools on enterprise.
    reply
