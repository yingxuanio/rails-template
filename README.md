# rails-template

**rails-template has supported the newest rails( 5.1 ) setup**

A best & newest & fastest rails template for chinese senior rails developer.

It's a best starting for your new rails project.

An example built with rails-template: https://github.com/80percent/rails-template-example

## How to use

Install dependencies:

* postgresql

    `$ brew install postgresql`

    Ensure you have already initialized a user with username: `postgres` and password: `postgres`( e.g. `$ createuser -d postgres` )

* rails 5

    Update `ruby` up to 2.2 or higher, and install `rails 5.1`

    `$ ruby -v` ( output should be 2.2.x or 2.3.x or 2.4.x )

    `$ gem sources --add https://gems.ruby-china.org/ --remove https://rubygems.org/` (optional)

    `$ gem install rails`

    `$ rails -v` ( output should be rails 5.1.x )

Then,

1. Add `gems.ruby-china.org` to your bundle mirrors (optional)

    `$ bundle config mirror.https://rubygems.org https://gems.ruby-china.org`

2. Create your own rails app applying `rails-template`

    `$ rails new myapp -m https://raw.github.com/80percent/rails-template/master/composer.rb`

## Using Docker

By using Docker, you don't need to install any apps and configure environment other than Docker itself.

If you need to Create a new app, you should first build a local docker image:

```
docker build https://github.com/yingxuanio/rails-template.git#master:files -t rails-myapp
```

You can run it to create a new rails app with rails-template composer!

```
# OSX/Windows users will want to remove --­­user "$(id -­u):$(id -­g)"
docker run -it --rm --user "$(id -u):$(id -g)" \
  -v "$PWD":/app -w /app rails-myapp rails new --skip-bundle myapp -m https://raw.githubusercontent.com/yingxuanio/rails-template/master/composer.rb
```

## What we do

`rails-template` apply lots of good components for you to make development damn quick.

1. we use `Ruby on Rails 5`, `ActionCable` and `Turbolinks` features are opened by default.

2. `Bootstrap3` and `font-awesome` are integrated to make your products UI easily, it aslo has some example pages for you to quickly start.

3. `carriewave` and `carriewave-upyun` are integrated.

4. `mina` and its plugins are the best & simplest deployment tools in the world for rails app.

5. `slim`, `rspec`, `high_voltage` and so on.

Other gems integrated in rails-template are worth learning seriously.

## Integrated mainly technology stack

* Ruby on Rails 5
* bootstrap 3
* font-awesome
* figaro
* postgres
* slim
* simple_form
* high_voltage
* carriewave & upyun
* sidekiq
* kaminari
* mina
* puma
* lograge

## Deployment document

* [How to deploy to ubuntu 14.04 with rails-template step by step(zh-CN)](https://github.com/80percent/rails-template/wiki/how-to-deploy-rails-to-ubuntu1404-with-rails-template)

## Projects that using `rails-template`

Welcome to pull request to update this if you choose `rails-template` for your new rails app.

* [八十二十](https://80post.com)
* [单麦 - 单品电商平台](https://80danmai.com)
* etc...

## Thanks

[80percent team](https://www.80percent.io)

## LICENSE

MIT
