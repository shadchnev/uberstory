class Story < ActiveRecord::Base
  
  has_many :lines
  has_many :users, :through => :lines, :uniq => true
  
  accepts_nested_attributes_for :lines, :allow_destroy => true
  attr_accessible :lines_attributes
  
  def user
    lines.first.user unless lines.empty?
  end
  
  def involves?(user)
    !((user.friends.map{|f| f.uid } + [user.uid]) & users.map{|u| u.uid}).empty?
  end
  
  def last_line_by?(user)
    lines.last.user.id == user.id
  end
  
  def notify_all_users_except(current_user)
    (users - [current_user]).each do |user|
      graph.put_connections(user.uid, "apprequests", :message => "Someone added a line to your story on UberTales!")
    end
  end
  
  def graph
    return @graph if @graph
    @oauth= Koala::Facebook::OAuth.new(Rails.configuration.facebook_app_id, Rails.configuration.facebook_app_secret)    
    @graph = Koala::Facebook::API.new(@oauth.get_app_access_token)
  end
  
  
end
