module StoriesHelper
  
  def garbage(original)
    original.gsub(/\w/) { ('a'..'z').to_a[rand(26)] }
  end
  
  def can_add_new_line(user, story)
    story.writable_by user
  end
  
  def banter
    home_banter = [
      "Hey there Shakespeare!",
      "Hey #{current_user.first_name}! Feeling creative today?",
      "Once upon a time, #{current_user.first_name} started writing a story"
      ]
    home_banter[rand(home_banter.length)]
  end
  
  def extra_users(story, mentioned_users_number)
    return if story.users.count == 2
    extra_friends = story.users - [current_user] - [current_user.friends]
    return extra_friends.first.first_name if extra_friends.length == 1
    return "#{extra_friends.count - mentioned_users_number} others"
  end
  
  def friends_to_invite_names(story)    
    friends_to_mention = story.users & current_user.friends
    friends_not_to_mention = story.users - [current_user] - friends_to_mention
    names_to_mention = friends_to_mention.take(2)
    names = names_to_mention.map{|u| u.first_name }.join(", ")
    names = [names, extra_users(story, names_to_mention.size)].compact.join(" and ")
    names
  end
  
    
end
