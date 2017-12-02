app_root = File.expand_path("../..", __FILE__)

# Normally `web_concurrency` equals CPU cores
web_concurrency = ENV.fetch("WEB_CONCURRENCY") { 1 }
threads_min_count = ENV.fetch("RAILS_MIN_THREADS") { 1 }
threads_max_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }

pidfile "#{app_root}/tmp/pids/puma.pid"
state_path "#{app_root}/tmp/pids/puma.state"
environment ENV.fetch("RAILS_ENV") { "development" }

port        ENV.fetch("PORT") { 3000 }
# You can use sock to control puma as well
# bind "unix://#{app_root}/tmp/sockets/puma.sock"
# activate_control_app "unix://#{app_root}/tmp/sockets/pumactl.sock"

# If you don't want the process printing output infos, you can set `daeminze` to `true`
# daemonize true

stdout_redirect "#{app_root}/log/puma_access.log", "#{app_root}/log/puma_error.log", true
workers web_concurrency
threads threads_min_count, threads_max_count

# Use the `preload_app!` method when specifying a `workers` number.
# This directive tells Puma to first boot the application and load code
# before forking the application. This takes advantage of Copy On Write
# process behavior so workers use less memory. If you use this option
# you need to make sure to reconnect any threads in the `on_worker_boot`
# block.
preload_app!

# The code in the `on_worker_boot` will be called if you are using
# clustered mode by specifying a number of `workers`. After each worker
# process is booted, this block will be run. If you are using the `preload_app!`
# option, you will want to use this block to reconnect to any threads
# or connections that may have been created at application boot, as Ruby
# cannot share connections between processes.
on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end

# If you are preloading your application and using Active Record, it's
# recommended that you close any connections to the database before workers
# are forked to prevent connection leakage.
before_fork do
  ActiveRecord::Base.connection_pool.disconnect!
end

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart
