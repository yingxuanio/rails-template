# rails-template

**rails-template has supported the newest rails( 5.1 ) setup**

A best & newest & fastest rails template for chinese senior rails developer.

It's a best starting for your new rails project.

An example built with rails-template: https://github.com/80percent/rails-template-example

## 正常使用

### 安装Rails的应用依赖

* 安装`postgresql`数据库

```bash
$ brew install postgresql
```

确保你创建了用户`postgres`，并设置密码为`postgres`( e.g. `$ createuser -d postgres` )

* 安装 Rails 5

更新 `ruby` 到 2.2 或更高版本，并安装 `rails 5.1`

```
$ ruby -v
```

为Gem设置中国镜像，加速Gem的安装和更新速度。

```
$ gem sources --add https://gems.ruby-china.org/ --remove https://rubygems.org/
```

```
$ gem install rails --no-ri --no-rdoc
$ rails -v
```

添加 `gems.ruby-china.org` 到默认的 bundler 镜像源配置。

```
$ bundle config mirror.https://rubygems.org https://gems.ruby-china.org
```

通过 `rails-template` 创建一个新的Rails应用。

```
$ rails new myapp -m https://git.io/vbmQA

```

## 使用 Docker

通过使用Docker的方式启动Rails，除了安装Docker本身之外，你什么应用或环境都不需要配置了。

### 安装Docker

> Pending

### 创建新的Rails应用

一个命令就可以直接创建新的Rails应用：

> 你可以将下文中出现的`myapp`替换成你的应用名称

#### A 如果你用的是`MacOS`或者`Windows`：

```
$ docker run -it --rm -v "$PWD":/app -w /app ccr.ccs.tencentyun.com/yingxuan/rails-base:1.1.1 \
  bash -c "gem install rails --no-ri --no-rdoc && rails new myapp -T -m https://git.io/vbmQA"
```

#### B 如果你使用的是`Ubuntu`或其他Linux发行版本:

```
$ docker run -it --rm --user "$(id -u):$(id -g)" -v "$PWD":/app -w /app ccr.ccs.tencentyun.com/yingxuan/rails-base:1.1.1 \
  bash -c "gem install rails --no-ri --no-rdoc && rails new myapp -T -m https://git.io/vbmQA"
```

安装好了之后，只需要：

```
$ cd myapp && docker-compose up
```

即可直接开启应用。

## 生产环境（Production）

```
$ docker-compose run app bash -c "bundle install --deployment && bundle exec rake assets:precompile"
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
