class User < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :stories, :through => :lines
  has_many :lines
  attr_writer :token
  
  has_and_belongs_to_many :cached_friends, :class_name => "User", :join_table => "users_friends", :uniq => true, :association_foreign_key => "friend_id"
  has_and_belongs_to_many :friend_of, :class_name => "User", :join_table => "users_friends", :uniq => true, :association_foreign_key => "user_id", :foreign_key => "friend_id"
  
  attr_accessible :uid, :first_name, :last_name
    
  def graph
    @graph ||= Koala::Facebook::API.new(@token)
  end
  
  def refresh_data
    about_me = graph.get_object("me")
    self.first_name = about_me["first_name"]
    self.last_name = about_me["last_name"]
    self.email = about_me["email"]
    self.profile_url = about_me["link"]
    self.image = "https://graph.facebook.com/#{about_me["username"]}/picture"
  end
  
  def no_data?
    !email || !image || !profile_url
  end
  
  def friends_and_myself
    friends + [self]
  end
  
  def friends
    return cached_friends unless cached_friends.empty?
    graph.get_object("me/friends").each do |f|
      user = User.find_or_create_by_uid(f["id"])      
      user.first_name, user.last_name = f["name"].split(" ", 2) if user.new_record?
      self.cached_friends << user
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
