configure :development do
  require 'dotenv'
  Dotenv.load

  require 'sinatra/reloader'
  require 'pry'
  require 'sprockets/railtie'

  also_reload 'app/**/*.rb'
end



configure do
  enable :sessions
  set :session_secret, ENV['SESSION_SECRET']

  set :views, 'app/views'

  use OmniAuth::Builder do
    provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET'],
      scope: 'user:email'
   
   provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"],
    scope: 'email' 
  end
  


end
