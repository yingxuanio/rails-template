require 'mina/rails'
require 'mina/git'

set :domain, 'xxx'
set :deploy_to, '/data/www/myapp'
# TODO: 修改App仓库地址
set :repository,  'git@git.yingxuan.io:yingxuan/myapp'
set :branch, 'master'
set :user, 'root'
set :shared_dirs, fetch(:shared_dirs, []).push('log', 'public/uploads', 'node_modules')
set :shared_files, fetch(:shared_files, []).push('config/database.yml', 'config/application.yml')

task :setup do
  command %[mkdir -p "#{fetch(:shared_path)}/tmp/sockets"]
  command %[chmod g+rx,u+rwx "#{fetch(:shared_path)}/tmp/sockets"]

  command %[mkdir -p "#{fetch(:shared_path)}/tmp/pids"]
  command %[chmod g+rx,u+rwx "#{fetch(:shared_path)}/tmp/pids"]

  command %[mkdir -p "#{fetch(:shared_path)}/log"]
  command %[chmod g+rx,u+rwx "#{fetch(:shared_path)}/log"]

  command %[mkdir -p "#{fetch(:shared_path)}/public/uploads"]
  command %[chmod g+rx,u+rwx "#{fetch(:shared_path)}/public/uploads"]

  command %[mkdir -p "#{fetch(:shared_path)}/node_modules"]
  command %[chmod g+rx,u+rwx "#{fetch(:shared_path)}/node_modules"]

  command %[mkdir -p "#{fetch(:shared_path)}/config"]
  command %[chmod g+rx,u+rwx "#{fetch(:shared_path)}/config"]

  command %[touch "#{fetch(:shared_path)}/config/application.yml"]
  command %[echo "-----> Be sure to edit '#{fetch(:shared_path)}/config/application.yml'"]

  command %[touch "#{fetch(:shared_path)}/config/database.yml"]
  command %[echo "-----> Be sure to edit '#{fetch(:shared_path)}/config/database.yml'"]
end


desc "Deploys the current version to the server."
task :deploy do
  deploy do
    invoke :'git:clone'

    on :launch do
      # command  %[echo "-----> Building docker container."]
      # command %[docker-compose -f docker-compose.prod.yml build]
      # command  %[echo "-----> Stopping docker container."]
      # command %[docker stop $(docker ps -qa)]
      # command %[docker rm $(docker ps -qa)]
      invoke :'docker:stop'
      command  %[echo "-----> Migrate data."]
      command %[docker-compose -f docker-compose.prod.yml run --rm app rake db:migrate]
      command  %[echo "-----> Starting containers."]
      command %[docker-compose -f docker-compose.prod.yml up -d]
    end
  end
end

namespace :docker do
  desc "Start docker container"
  task :start do
    command "cd #{fetch(:current_path)}"
    command %[echo "----------------->"]
  end

  task :create_db do
    command "cd #{fetch(:current_path)}"
    command "docker-compose -f docker-compose.prod.yml run --rm app rake db:create"
  end

  task :migrate do
    command "cd #{fetch(:current_path)}"
    command "docker-compose -f docker-compose.prod.yml run --rm app rake db:migrate"
  end

  task :seed do
    command "cd #{fetch(:current_path)}"
    command "docker-compose -f docker-compose.prod.yml run --rm app rake db:seed"
  end

  task :precompile do
    command "cd #{fetch(:current_path)}"
    command "docker-compose -f docker-compose.prod.yml run --rm app rake assets:precompile"
  end

  desc "Stop docker container"
  task :stop do
    command "cd #{fetch(:current_path)}"
    command "docker-compose -f docker-compose.prod.yml stop"
  end

  desc "Restart docker container app"
  task :restart do
    command "docker-compose -f docker-compose.prod.yml restart"
  end

  desc "Rebuild docker image if nesseccery"
  task :rebuild do
    command "docker-compose -f docker-compose.prod.yml build"
  end

  desc "Remove all stop container"
  task :clean_containers do
    command "docker rm $(sudo docker ps -a -q)"
  end

  task :status do
    command "cd #{fetch(:current_path)}"
    command "docker-compose -f docker-compose.prod.yml ps"
  end
end

task :logs do
  command "cd #{fetch(:current_path)}"
  command "tail -f log/production.log"
end

task :sidekiq_logs do
  command "cd #{fetch(:current_path)}"
  command "tail -f log/sidekiq.log"
end

task :puma_logs do
  command "cd #{fetch(:current_path)}"
  command "tail -f log/puma_error.log"
end