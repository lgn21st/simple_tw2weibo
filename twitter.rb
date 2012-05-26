require 'bundler'
require 'bundler/setup'
require 'yajl'
require 'tweetstream'

TweetStream.configure do |config|
  config.consumer_key = 'hWKCtD8QZ6UlT5S8n9V6Q'
  config.consumer_secret = '32sCDi5WfoFggYzeZ3hhTGSZiewhc7VX1Rdquj5O8Y'
  config.oauth_token = '160549840-m1lGeRSiLxsl7hy5pH2fQfZkszyTuzbt0fKoQeXZ'
  config.oauth_token_secret = 'INWf3R2VSMwFgouY8GpfO9AMouvfXPAofxRDtK4Akxc'
  config.auth_method = :oauth
  config.parser   = :yajl
end

client = TweetStream::Client.new

client.on_error do |message|
  puts message
end

client.on_direct_message do |direct_message|
  puts direct_message.text
end

client.on_timeline_status  do |status|
  puts status.text
end

client.userstream
