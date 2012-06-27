class GamificationJob < Struct.new(:event, :payload)
  
  def perform
    Rules::Rule.filter(event, payload).each do |rule|
      # Delayed::Job.enqueue CheckRuleJob.new(rule, event, payload)
      CheckRuleJob.new(rule, event, payload).perform
    end
  end
  
end