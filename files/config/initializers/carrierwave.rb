CarrierWave.configure do |config|
  config.storage              = :qiniu
  config.qiniu_access_key     = ENV['QINIU_ACCESS_KEY']
  config.qiniu_secret_key     = ENV['QINIU_SECRET_KEY']
  config.qiniu_bucket         = ENV['QINIU_BUCKET']
  config.qiniu_bucket_domain  = ENV['QINIU_BUCKET_DOMAIN']
  config.qiniu_protocol       = ENV['QINIU_PROTOCOL']
  # config.qiniu_up_host        = 'http://up.qiniug.com' #七牛上传海外服务器,国内使用可以不要这行配置
end
