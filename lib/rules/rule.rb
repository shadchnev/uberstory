module Rules
  class Rule
  
    def self.filter(event, payload)
      all.select{|r| Rules.const_get(r).apply_to? event, payload}
    end
    
    def self.apply_to?(event, payload)
      event == activator
    end
    
    def self.activator
      raise "This method (activator) must be overloaded"
    end
  
    def self.all
      Rules.constants - [:Rule]
    end
    
    def self.add_score(score, event, payload)
      Score.create!(:value => score, :event => event, :target_id => payload[:target_id], :user_id => payload[:user_id])
    end
    
    def self.add_badge(badge, event, payload)
      Badge.create!(:name => badge, :event => event, :target_id => payload[:target_id], :user_id => payload[:user_id])
    end
    
  end
end