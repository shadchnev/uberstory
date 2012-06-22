module Rules
  
  class TumbleweedBadge < Rule
    
    ABANDONED_THRESHOLD = 3
    BADGE = "Tumbleweed"
    
    def self.activator
      'timer'
    end
    
    def self.apply_to?(event, payload)
      return false unless super(event, payload)
      user = User.find payload[:user_id]
      user.stories.count{|s| s.abandoned? } >= ABANDONED_THRESHOLD
    end
    
    def self.evaluate(event, payload)
      user = User.find payload[:user_id]
      return if Badge.find_by_user_id_and_name(user.id, BADGE)
      return unless apply_to?(event, payload)     
      add_badge(BADGE, event, payload)
    end
    
  end
  
end