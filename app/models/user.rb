class User < ActiveRecord::Base
  
  has_many :usermoods
  
  has_many :identities
 
  def self.create_with_omniauth(auth)
  	binding.pry
  	find_by(name: auth['info']['name']) || create(name: auth['info']['name'])
  end

end
