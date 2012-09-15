Twitter.configure do |config|
  config.consumer_key = ENV['OMNIAUTH_PROVIDER_KEY']
  config.consumer_secret = ENV['OMNIAUTH_PROVIDER_SECRET']
end