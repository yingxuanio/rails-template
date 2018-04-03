def remove_gem(*names)
  names.each do |name|
    gsub_file 'Gemfile', /gem '#{name}'\n/, ''
  end
end

def remove_comment_of_gem
  gsub_file('Gemfile', /^\s*#.*$\n/, '')
end

def get_remote(src, dest = nil)
  dest ||= src
  repo = 'https://raw.githubusercontent.com/yingxuanio/rails-template/master/files/'
  remote_file = repo + src
  remove_file dest
  get(remote_file, dest)
end

docker_mode = yes?("是否启用『Docker模式』创建Rails项目？否则将使用『正常模式』。(y/n)")
if docker_mode
  say "启用Docker模式进行安装……"
else
  say "启用正常模式进行安装……"
  say "请确认本地是否已经安装PostgreSQL、redis、NodeJS等依赖，如未安装将有可能失败。"
end

remove_comment_of_gem
# gitignore
get_remote('gitignore', '.gitignore')

say "更新 config/applicatoin.rb"
environment 'config.generators.assets = false'
environment 'config.generators.helper = false'
environment 'config.generators { |g| g.test_framework :rspec }'
environment "config.time_zone = 'Beijing'"
environment "config.i18n.available_locales = [:en, :'zh-CN']"
environment "config.i18n.default_locale = :'zh-CN'"

if docker_mode
  environment "config.cache_store = :redis_store, ENV['CACHE_URL'],{ namespace: '#{app_name}::cache' }"
end

if docker_mode
  # Copy Dockerfile and docker-compose to manage docker containers
  get_remote 'Dockerfile'
  get_remote 'Dockerfile.prod'
  get_remote 'docker-compose.yml'
  get_remote 'docker-compose.prod.yml'
  gsub_file 'docker-compose.yml', /myapp/, "#{app_name}"
  gsub_file 'docker-compose.prod.yml', /myapp/, "#{app_name}"
end

# postgresql
say 'Applying postgresql...'
if docker_mode
  remove_gem('sqlite3')
end
gem 'pg'
get_remote('config/database.yml.example', 'config/database.yml')


# environment variables set
say 'Applying figaro...'
gem 'figaro'

# 下载并更新application.yml
get_remote('config/application.yml.example', 'config/application.yml')
gsub_file 'config/application.yml', /myapp/, "#{app_name}"
gsub_file 'config/application.yml', /db-server/, docker_mode ? "postgres" : "localhost:3000"
gsub_file 'config/application.yml', /redis-server/, docker_mode ? "redis" : "localhost:3000"

get_remote('config/spring.rb')

after_bundle do
  say "Stop spring if exsit"
  run "spring stop"
end

# jquery, bootstrap needed
say 'Applying jquery...'
gem 'jquery-rails'
inject_into_file 'app/assets/javascripts/application.js', after: "//= require rails-ujs\n" do "//= require jquery\n" end

# bootstrap sass
say 'Applying bootstrap3...'
gem 'bootstrap-sass'
remove_file 'app/assets/stylesheets/application.css'
get_remote('application.scss', 'app/assets/stylesheets/application.scss')
inject_into_file 'app/assets/javascripts/application.js', after: "//= require jquery\n" do "//= require bootstrap-sprockets\n" end

say 'Applying simple_form...'
gem 'simple_form', '~> 3.5.0'

after_bundle do
  generate 'simple_form:install', '--bootstrap'
end

say 'Applying font-awesome & slim & high_voltage...'
gem 'font-awesome-sass'
gem 'slim-rails'
gem 'high_voltage', '~> 3.0.0'
remove_file('app/views/layouts/application.html.erb')
get_remote('application.html.slim', 'app/views/layouts/application.html.slim')
gsub_file 'app/views/layouts/application.html.slim', /myapp/, "#{app_name}"
get_remote('favicon.ico', 'app/assets/images/favicon.ico')

# initialize files
# uploader directory
# application.yml
say 'Applying carrierwave & upyun...'
gem 'carrierwave'
gem 'carrierwave-qiniu', '~> 1.1.5'
gem 'carrierwave-i18n'
get_remote('config/initializers/carrierwave.rb')
get_remote('image_uploader.rb', 'app/uploaders/image_uploader.rb')

# initialize files
# say 'Applying status page...'
# gem 'status-page'
# get_remote('config/initializers/status_page.rb')

say "Applying browser_warrior..."
gem 'browser_warrior'

say 'Applying redis & sidekiq...'
gem 'redis-rails'
gem 'redis-namespace'
gem 'sidekiq'
get_remote('config/initializers/sidekiq.rb')
get_remote('config/sidekiq.yml')
get_remote('config/routes.rb')

say 'Applying kaminari & rails-i18n...'
gem 'kaminari'
gem 'kaminari-i18n'
gem 'rails-i18n', '~> 5.1'

after_bundle do
  generate 'kaminari:config'
  generate 'kaminari:views', 'bootstrap3'
end

use_devise = yes?("是否安装『Devise』？将安装devise (y/n)")
if use_devise
  gem "devise"
  gem 'devise-i18n'
end
use_activeadmin = yes?("是否安装『ActiveAdmin』？将安装active_admin, draper, devise及active_admin_setting (y/n)")
if use_activeadmin
  unless use_devise
    gem "devise"
    gem 'devise-i18n'
    generate "devise:install"
    generate "devise:views"
  end
  gem "activeadmin"
  gem "activeadmin_addons"
  gem 'draper'
  gem "activeadmin_settings_cached"
  after_bundle do
    generate "active_admin:install"
    generate "settings:install"
    generate "active_admin:settings Setting"
  end
end

say '添加Sentry错误监控'
gem "sentry-raven"
get_remote('config/initializers/sentry.rb', 'config/initializers/sentry.rb')

say 'Applying mina & its plugins...'
gem_group :development do
  gem 'mina', '~> 1.2.2', require: false
  gem 'mina-puma', '~> 1.1.0', require: false
  gem 'mina-multistage', '~> 1.0.3', require: false
  gem 'mina-sidekiq', '~> 1.0.3', require: false
  gem 'mina-logs', '~> 1.1.0', require: false
end

say 'Applying basic application config...'
if docker_mode
  get_remote('config/deploy.docker.rb', 'config/deploy.rb')
else
  get_remote('config/deploy.rb')
end
gsub_file 'config/deploy.rb', /\/data\/www\/myapp/, "/data/www/#{app_name}"
get_remote('config/puma.rb')
gsub_file 'config/puma.rb', /\/data\/www\/myapp\/shared/, "/data/www/#{app_name}/shared"
get_remote('config/deploy/production.rb')
gsub_file 'config/deploy/production.rb', /\/data\/www\/myapp/, "/data/www/#{app_name}"
get_remote('config/nginx.conf.example')
gsub_file 'config/nginx.conf.example', /myapp/, "#{app_name}"
get_remote('config/nginx.ssl.conf.example')
gsub_file 'config/nginx.ssl.conf.example', /myapp/, "#{app_name}"
get_remote('config/logrotate.conf.example')
gsub_file 'config/logrotate.conf.example', /myapp/, "#{app_name}"

get_remote('config/monit.conf.example')
gsub_file 'config/monit.conf.example', /myapp/, "#{app_name}"

get_remote('config/backup.rb.example')
gsub_file 'config/backup.rb.example', /myapp/, "#{app_name}"

say 'Applying rspec test framework...'
gem_group :development, :test do
  gem 'rspec-rails'
  gem 'factory_bot_rails'
end
gem_group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'launchy'
  gem 'selenium-webdriver'
end

get_remote 'README.md'
gsub_file 'README.md', /myapp/, "#{app_name}"
# `ack` is a really quick tool for searching code
get_remote 'ackrc', '.ackrc'

gsub_file 'Gemfile', /rubygems.org/, "gems.ruby-china.org"

after_bundle do
  command = docker_mode ? "docker-compose up" : "rails s"
  say "You should edit `application.yml` first."
  say "Build successfully! `cd #{app_name}` and use `#{command}` to start your Rails app."
end
