class Story < ActiveRecord::Base
  
  has_many :lines, :dependent => :destroy
  has_many :users, :through => :lines, :uniq => true
  
  accepts_nested_attributes_for :lines, :allow_destroy => true
  attr_accessible :lines_attributes
  
  validate :last_line_by_a_new_user
  validate :story_is_of_correct_length
  
  after_initialize :set_defaults
  
  DEFAULT_MAX_LENGTH = 10
  
  def set_defaults
    self.max_length ||= DEFAULT_MAX_LENGTH
  end
  
  def abandoned?
    updated_at < Time.now - 1.month
  end
  
  def story_is_of_correct_length
    errors.add(:lines, "Sorry, this story is getting too long") if lines.length > max_length
  end
  
  def last_line_by_a_new_user
    return if lines.size < 2
    if lines.last.user.id == lines[lines.size-2].user.id
      errors.add(:lines, "Sorry, you cannot add two lines in a row")
    end
  end
  
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
    # return unless Rails.env.production?
    (users - [current_user]).each do |user|
      # skip those with invitations!
      requests = current_user.graph.get_connections(user.uid, "apprequests")
      next unless requests.empty?
      graph.put_connections(user.uid, "apprequests", {:data => {:story_id => self.id}.to_json, :message => "#{lines.last.user.first_name || "Someone"} added a line to your story on UberTales!"})
    end
  end
  handle_asynchronously :notify_all_users_except
  
  def graph
    return @graph if @graph
    @oauth = Koala::Facebook::OAuth.new(Rails.configuration.facebook_app_id, Rails.configuration.facebook_app_secret)    
    @graph = Koala::Facebook::API.new(@oauth.get_app_access_token)
  end
  
  def finished?
    lines.length >= max_length
  end
  
  def writable_by(user)
    !finished? && involves?(user) && !last_line_by?(user)
  end
  
end
