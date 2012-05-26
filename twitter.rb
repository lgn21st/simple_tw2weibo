require 'bundler'
require 'bundler/setup'
require 'yajl'
require 'tweetstream'

require 'oauth'
require 'weibo'

Weibo::Config.api_key = "2808780302"
Weibo::Config.api_secret = "aeb798a256521a7af014b8829b134fcc"

module Weibo
  class Request
      def parse(response)
        MultiJson.load(response.body)
      end
  end
end

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
  oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
  oauth.authorize_from_access("b11d5127ab3626726b9c5522f73e4fd0", "7c799f8c06e838685f7f81e04080324e")
  Weibo::Base.new(oauth).update(status.text)
  puts status.text
end

client.userstream
