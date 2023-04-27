# My Blog

This is my blog engine. You can find my blog at [christopher-astfalk.de](https://christopher-astfalk.de/).
This Project is not intended to host your own blog. I only build it for me.

I want it to be compatible to the [IndieWeb](https://indieweb.org/).
But this blog is mostly to learn _Ruby on Rails_.

Required:

* Ruby version:
  * Usually the newest.
  * Currently v3.1.1.
* System dependencies
  * MacOS or Linux
  * PostgreSQL
  * Redis
* Configuration
  * For production follow the instructions from Go Rails to [Deploy Ruby On Rails on Ubuntu](https://gorails.com/deploy/ubuntu/20.04)
* How to run the test suite
  * It only uses the standard Rails configuration.
* Services (job queues, cache servers, search engines, etc.)
  * Job Queues are done by [GoodJob](https://github.com/bensheldon/good_job#readme)
* Deployment instructions
  * [Install Capistrano](https://gorails.com/deploy/ubuntu/20.04#capistrano)
  * Add your ssh keys.
  * `cap production deploy` or `bundler exec cap production deploy`
