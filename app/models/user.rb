class User < ActiveRecord::Base
  # attr_accessible :title, :body
  
  has_many :lines
  attr_writer :token
  
  has_and_belongs_to_many :cached_friends, :class_name => "User", :join_table => "users_friends", :uniq => true, :association_foreign_key => "friend_id"
  
  attr_accessible :uid, :first_name, :last_name
    
  # def self.find_by_token(token)
  #   begin
  #     profile = graph(token).get_object("me")
  #   rescue # token expired for whatever reason
  #     return nil
  #   end
  #   User.find_by_uid(profile["id"])
  # end
  
  def graph
    raise "The token is not supplied" if @token.blank?
    puts "Using token #{@token} to access FB Graph"
    (@graph ||= Koala::Facebook::API.new(@token)).tap{|v| puts "graph object: #{v.inspect}"}    
  end
  
  # cache it
  def friends
    return cached_friends unless cached_friends.empty?
    graph.get_object("me/friends").each do |f|
      first_name, last_name = f["name"].split(" ", 2) if f["name"]
      friend = User.create(:uid => f["id"], :first_name => first_name, :last_name => last_name)
      self.cached_friends << friend
    end
    cached_friends
  end
  
  def name
    "#{first_name} #{last_name}"
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
