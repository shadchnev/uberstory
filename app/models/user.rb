class User < ActiveRecord::Base
  # attr_accessible :title, :body
  
  has_many :lines
  attr_writer :token
  
  def self.graph(token)
    Koala::Facebook::API.new(token)    
  end
  
  def self.find_by_token(token)
    begin
      profile = graph(token).get_object("me")
    rescue # token expired for whatever reason
      return nil
    end
    User.find_by_uid(profile["id"])
  end
  
  def graph
    @graph ||= User.graph(@token)
  end
  
  # cache it
  def friends
    graph.get_object("me/friends").slice(0,10)
  end
  
  def self.find_or_create_by_fb_auth(auth)    
    user = User.find_or_create_by_uid(auth[:uid])
    user.first_name = auth[:info][:first_name]
    user.last_name = auth[:info][:last_name]
    user.email = auth[:info][:email]
    user.profile_url = auth[:info][:urls][:Facebook]
    user.image = auth[:info][:image]
    user.save
    user    
  end
  
end
