# rails-template

帮助快速初始化搭建一个具备现代架构、常见Gem集成的Rails应用。

## 方式一：正常使用

正常使用指的是在本地环境下运行Rails，需要准备好Ruby环境、Rails及PG数据库等Rails依赖的环境软件，否则将无法正常运行。

### 安装Rails的应用依赖

以下是一个简要的安装教程：

#### 安装`postgresql`数据库

```bash
$ brew install postgresql
```

确保你创建了用户`postgres`，并设置密码为`postgres`( e.g. `$ createuser -d postgres` )

#### 安装 Rails 5

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

### 开始使用

通过 `rails-template` 创建一个新的Rails应用。

```
$ rails new myapp -m https://git.io/vbmQA

```

## 方式二：使用 Docker

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

> 这个命令做了什么？
-  `-it`指的是进入交互模式，由于rails新建的模板中有几处需要你输入结果的地方；
- `--rm`则是指在运行相应的命令后删除容器；
- `-v "$PWD":/app`将当前目录映射到docker容器的`/app`目录，由于我们的命令在该目录下执行，最终`rails new`所新建的目录将会出现在当前目录。

安装好了之后，只需要：

```
$ cd myapp && docker-compose up
```

即可直接开启应用。

### 在生产环境（Production）运行

通过rails-template生成的项目，自带了用于部署生产环境使用的docker配置文件，可以一键以应用的Production配置运行。

```
$ docker-compose run app bash -c "bundle install --deployment && bundle exec rake assets:precompile"
```

## 创建的Rails所包含的内容：

1. 使用 `Ruby on Rails 5`, `ActionCable` 和 `Turbolinks` 默认开启。

2. `Bootstrap3` 和 `font-awesome` 集成在内。

3. `carriewave` 和 `carriewave-upyun` 集成在内。

4. `mina` 用于自动化部署

5. `slim`, `rspec`, `high_voltage` 等等常见标配级别的Gem已经添加在内。

## 主要内容物：

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
