class User < ActiveRecord::Base
  # attr_accessible :title, :body
  has_many :stories, :through => :lines
  has_many :lines, :include => [:story => :lines]
  has_many :scores
  has_many :badges
  # attr_writer :token
  
  has_and_belongs_to_many :cached_friends, :class_name => "User", :join_table => "users_friends", :uniq => true, :association_foreign_key => "friend_id", :include => [:scores, {:stories => [{:lines => :user}, :users]}]
  has_and_belongs_to_many :friend_of, :class_name => "User", :join_table => "users_friends", :uniq => true, :association_foreign_key => "user_id", :foreign_key => "friend_id"
  
  attr_accessible :uid, :first_name, :last_name

   NUM_STORIES_TO_SHOW = 20

  def stories_by_friends
    @stories_by_friends ||= friends.map{|f| f.stories}.flatten.uniq
  end

  def stories_by_friends_and_myself
    @stories_by_friends_and_myself ||= (stories_by_friends + own_stories).uniq
  end

  def top_stories
    (Story.all(:include => [:lines, :users]) - stories_by_friends_and_myself).select{|s| s.finished? }.take(NUM_STORIES_TO_SHOW) # popular means the number of likes but we don't have that yet    
  end

  def own_stories    
    lines.select{|l| l.story.lines.first == l}.map(&:story).select{|s| s.finished? }
  end

  def friends_stories
    stories_by_friends.select {|s| s.lines.first.user != self && s.finished? }
  end

  def in_play_stories
    stories_by_friends_and_myself.reject{|s| s.finished? }.sort_by{|s| s.created_at}.reverse
  end
    
  def graph
    @graph ||= Koala::Facebook::API.new(token)
  end
  
  def score
    scores.inject(0) {|sum, score| sum += score.value }
  end
  
  def refresh_data
    about_me = graph.get_object("me")
    self.first_name = about_me["first_name"]
    self.last_name = about_me["last_name"]
    self.email = about_me["email"]
    # self.profile_url = about_me["link"]
    # self.image = "https://graph.facebook.com/#{about_me["id"]}/picture"
  end
  
  def delete_request(request)
    graph.delete_object("#{request}_#{self.uid}")
  end
  handle_asynchronously :delete_request
  
  def no_data?
    email.blank? || image.blank? || profile_url.blank?
  end
  
  def friends_and_myself
    friends + [self]
  end

  def image
    "https://graph.facebook.com/#{uid}/picture"
  end

  def profile_url
    "https://www.facebook.com/#{uid}"
  end
  
  def friends
    return cached_friends unless cached_friends.empty?
    graph.get_object("me/friends").each do |f|
      puts f.inspect
      user = User.find_or_create_by_uid(f["id"])      
      user.first_name, user.last_name = f["name"].split(" ", 2) #if user.new_record?
      user.save
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
  
  def as_json(options={})
    defaults = {:only => [:id, :first_name, :last_name, :image, :email]}.merge options
    super defaults
  end
  
end
