StatusPage.configure do
  # Cache check status result 10 seconds
  self.interval = 10
  # Use service
  self.use :database
  self.use :cache
  self.use :redis, url: ENV["CACHE_URL"]
  self.use :sidekiq
end
