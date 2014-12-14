class Identity < ActiveRecord::Base
  belongs_to :user
  
  def self.find_with_omniauth(auth)
   
    find_by(uid: auth['uid'], provider: auth['provider'])
  end

  def self.create_with_omniauth(auth, user_id)
   
    create(uid: auth['uid'], provider: auth['provider'],user_id: user_id)
  end
  
end
