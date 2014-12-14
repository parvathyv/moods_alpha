require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'omniauth-github'
require 'omniauth-google-oauth2'
require 'json'

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

def get_mood_type(color)

  color_mood_map = {
    "red" => "angry" ,
    "orange" =>     "happy",
    "blue"  => "sad"  ,
    "crazy eyes" => "purple",
    "gray"=> "meh",
    "olive" => "zen"
    
  }

  color_mood_map[color]

end








get '/' do
  
  
  erb :index
end 

get '/moods' do
  #authenticate!
  name = ''
  @all_users = User.all.map{|userobj| userobj.name.upcase}
  
  @all_users.each{|x| name = params[x].split.map{|x| x.capitalize}.join(' ') if params[x]}

  if name != ''

    @find_user = User.find_by(name: name) 
  
    @all_user_moods = @find_user.usermoods.map{|obj| [obj.comments]}
    colors_json = @find_user.usermoods.map{|userobj| userobj.color}
 
  else

    @all_user_moods = Usermood.all.map{|userobj| [userobj.comments]}
    colors_json = Usermood.all.map{|userobj| userobj.color}
  end  

  @arr = []
  
  
  if params[:root]
    @root =  params[:root] 
  else
    @root = 'I feel'
  end    
 
  @arr = colors_json.map{|color| [color, colors_json.count(color)]}
   
 
  @arr.unshift(['Colors','Count']).uniq!
   

  erb :index
end 


post '/moods' do
  
 
  color = params[:red] || params[:blue] || params[:green] || params[:purple] || params[:orange] || params[:gray]
  
  comments = 'I feel ' + params[:comments]
  mood_type = get_mood_type(color)
  current_user_id = session[:user_id]
  
  @meetup  = Usermood.create(user_id: current_user_id, color: color, mood_type: mood_type, comments: comments)
  redirect '/moods'

end  





get '/auth/:provider/callback' do
  auth = env['omniauth.auth']

  
  user = User.create_with_omniauth(auth)
  exists_user = User.find_by(name: auth['info']['name'])
 
  userid = exists_user.id if exists_user

  identity = Identity.find_with_omniauth(auth) || Identity.create_with_omniauth(auth, userid)
  
 
  set_current_user(user)
  flash[:notice] = "You're now signed in as #{user.name}!"

  redirect '/moods'
end




get '/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "You have been signed out."

  redirect '/moods'
end

get '/example_protected_page' do
  authenticate!
end
