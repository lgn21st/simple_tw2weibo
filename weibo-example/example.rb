%w(rubygems bundler).each { |dependency| require dependency }
Bundler.setup
%w(sinatra haml oauth sass json weibo).each { |dependency| require dependency }
enable :sessions
Weibo::Config.api_key = "2808780302"
Weibo::Config.api_secret = "aeb798a256521a7af014b8829b134fcc"

get '/' do
  puts
  puts request.env.inspect
  puts
  if session[:atoken]
    redirect "/friends_timeline"
  end
  haml :index
end

get "/friends_timeline" do
  oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
  oauth.authorize_from_access(session[:atoken], session[:asecret])
  @timeline = Weibo::Base.new(oauth).friends_timeline
  haml :index
end

get "/friends_timeline.json" do
  content_type :json
  oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
  oauth.authorize_from_access(session[:atoken], session[:asecret])
  Weibo::Base.new(oauth).friends_timeline.to_json
end

post '/update' do
  oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
  oauth.authorize_from_access(session[:atoken], session[:asecret])
  Weibo::Base.new(oauth).update(params[:update])
  redirect "/friends_timeline"
end

get '/connect' do
  oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
  request_token = oauth.consumer.get_request_token
  session[:rtoken], session[:rsecret] = request_token.token, request_token.secret
  redirect "#{request_token.authorize_url}&oauth_callback=http://#{request.env["HTTP_HOST"]}/callback"
end

get '/callback' do
  oauth = Weibo::OAuth.new(Weibo::Config.api_key, Weibo::Config.api_secret)
  oauth.authorize_from_request(session[:rtoken], session[:rsecret], params[:oauth_verifier])
  session[:rtoken], session[:rsecret] = nil, nil
  session[:atoken], session[:asecret] = oauth.access_token.token, oauth.access_token.secret
  redirect "/"
end

get '/logout' do
  session[:atoken], session[:asecret] = nil, nil
  redirect "/"
end

get '/screen.css' do
  content_type 'text/css'
  sass :screen
end
