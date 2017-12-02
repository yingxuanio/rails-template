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

docker_mode = yes?("是否启用『Docker模式』创建Rails项目？否则将使用『本地模式』。(y/n)")
if docker_mode
  say "启用Docker模式进行安装……"
else
  say "启用本地模式进行安装……"
  say "请确认本地是否已经安装PostgreSQL、redis、NodeJS等依赖，如未安装将有可能失败。"
end

remove_comment_of_gem
# gitignore
get_remote('gitignore', '.gitignore')

say "updating config/applicatoin.rb"
environment 'config.generators.assets = false'
environment 'config.generators.helper = false'
environment 'config.generators { |g| g.test_framework :rspec }'
environment "config.time_zone = 'Beijing'"
environment "config.i18n.available_locales = [:en, :'zh-CN']"
environment "config.i18n.default_locale = :'zh-CN'"
environment "config.lograge.enabled = true"
environment "config.cache_store = :redis_store, ENV['CACHE_URL'],{ namespace: '#{app_name}::cache' }"

if docker_mode
  # Copy Dockerfile and docker-compose to manage docker containers
  get_remote 'Dockerfile'
  get_remote 'docker-compose.yml'
end

# postgresql
say 'Applying postgresql...'
remove_gem('sqlite3')
gem 'pg'
get_remote('config/database.yml.example', 'config/database.yml')


# environment variables set
say 'Applying figaro...'
gem 'figaro'
get_remote('config/application.yml.example', 'config/application.yml')

if docker_mode
  dir = ask("Specify the location to store database data: (e.g: /data/#{app_name}/db or ~/projects/docker-data/#{app_name}/db)")
  if dir.blank?
    say "The location can't be Blank! Will set to '~/projects/docker-data', please remember to modify later!"
  else
    gsub_file 'config/docker-compose.yml', /~\/projects\/docker-data/, "#{dir}"
  end
else
  # host = ask("请输入PostgreSQL数据库host地址（无需输入端口）：(localhost)") || "localhost"
  # port = ask("请输入PostgreSQL数据库访问端口：(5432)") || "5432"
  # username = ask("请输入PostgreSQL数据库用户名：(postgres)") || "postgres"
  # password = ask("请输入PostgreSQL数据库密码：(postgres)") || "postgres"
  # gsub_file 'config/application.yml', /@postgres/, "@#{host}"
  # gsub_file 'config/application.yml', /5432/, "#{port}"
  # gsub_file 'config/application.yml', /yingxuan_devs/, "@#{username}"
  # gsub_file 'config/application.yml', /yingxuanApp/, "@#{password}"

  # host = ask("请输入Redis数据库host地址（无需输入端口）：(localhost)") || "localhost"
  # port = ask("请输入Redis数据库访问端口：(6379)") || "6379"
  # gsub_file 'config/application.yml', /\/\/redis/, "\/\/#{host}"
  # gsub_file 'config/application.yml', /6379/, "#{port}"
end

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
get_remote('home_controller.rb', 'app/controllers/home_controller.rb')
get_remote('index.html.slim', 'app/views/home/index.html.slim')
get_remote('about.html.slim', 'app/views/pages/about.html.slim')
remove_file('app/views/layouts/application.html.erb')
get_remote('application.html.slim', 'app/views/layouts/application.html.slim')
gsub_file 'app/views/layouts/application.html.slim', /myapp/, "#{app_name}"
get_remote('favicon.ico', 'app/assets/images/favicon.ico')

say 'Applying action cable config...'
inject_into_file 'config/environments/production.rb', after: "# Mount Action Cable outside main process or domain\n" do <<-EOF
  config.action_cable.allowed_request_origins = [ "\#{ENV['PROTOCOL']}://\#{ENV['DOMAIN']}" ]
EOF
end

# initialize files
# uploader directory
# application.yml
say 'Applying carrierwave & upyun...'
gem 'carrierwave'
gem 'carrierwave-upyun'
get_remote('config/initializers/carrierwave.rb')
get_remote('image_uploader.rb', 'app/uploaders/image_uploader.rb')

# initialize files
say 'Applying status page...'
gem 'status-page'
get_remote('config/initializers/status_page.rb')

say "Applying browser_warrior..."
gem 'browser_warrior'
after_bundle do
  generate 'browser_warrior:install'
end

say 'Applying redis & sidekiq...'
gem 'redis-namespace'
gem 'sidekiq'
get_remote('config/initializers/sidekiq.rb')
get_remote('config/routes.rb')

say 'Applying kaminari & rails-i18n...'
gem 'kaminari', '~> 1.0.1'
gem 'rails-i18n', '~> 5.0.3'
after_bundle do
  generate 'kaminari:config'
  generate 'kaminari:views', 'bootstrap3'
end

say 'Applying mina & its plugins...'
gem 'mina', '~> 1.2.2', require: false
gem 'mina-puma', '~> 1.1.0', require: false
gem 'mina-multistage', '~> 1.0.3', require: false
gem 'mina-sidekiq', '~> 1.0.3', require: false
gem 'mina-logs', '~> 1.1.0', require: false
get_remote('config/deploy.rb')
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

say 'Applying lograge & basic application config...'
gem 'lograge'

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
  say "Please edit `application.yml` first"
  say "Build successfully! `cd #{app_name}` and use `docker-compose up` to start your rails app..."
end
