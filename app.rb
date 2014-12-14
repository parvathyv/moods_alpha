require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'omniauth-github'
require 'omniauth-google-oauth2'

require_relative 'config/application'

Dir['app/**/*.rb'].each { |file| require_relative file }

helpers do
  def current_user
    
    user_id = session[:user_id]
    
    @current_user ||= User.find(user_id) if user_id.present?
  end

  def signed_in?
    current_user.present?
  end
end

def set_current_user(user)

  session[:user_id] = user.id
end

def authenticate!
  unless signed_in?
    flash[:notice] = 'You need to sign in if you want to do that!'
    redirect '/'
end

end

get '/' do
  binding.pry
  
  erb :index
end 

get '/moods' do
  #authenticate!
  @all_user_moods = Usermood.all.map{|userobj| [userobj.comments]}
  @arr = []
  @current_time = Time.now()
  all_user_colors = Usermood.all.map{|userobj| userobj.color}
  @arr = all_user_colors.map{|color| [color, all_user_colors.count(color)]}
 
  @arr.unshift(['Colors','Count']).uniq!
   
  erb :index
end 


post '/moods' do
  
 
  color = params[:red] || params[:blue] || params[:green] || params[:purple]
  
  comments = 'I feel ' + params[:comments]
  mood_type = params[:happy] || params[:sad] || params[:meh] || params[:ft] || params[:crazy] || params[:zen]
  @meetup  = Usermood.create(user_id: current_user, color: color, mood_type: mood_type, comments: comments)
  redirect '/moods'

end  





get '/auth/:provider/callback' do
  auth = env['omniauth.auth']

  
  user = User.create_with_omniauth(auth)
  exists_user = User.find_by(name: auth['info']['name'])
  binding.pry
  userid = exists_user.id if exists_user

  identity = Identity.find_with_omniauth(auth) || Identity.create_with_omniauth(auth, userid)
  
 
  set_current_user(user)
  flash[:notice] = "You're now signed in as #{user.name}!"

  redirect '/moods'
end




get '/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "You have been signed out."

  redirect '/'
end

get '/example_protected_page' do
  authenticate!
end
