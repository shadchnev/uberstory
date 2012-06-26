class GamificationJob < Struct.new(:event, :payload)
  
  def perform
    Rules::Rule.filter(event, payload).each do |rule|
      Delayed::Job.enqueue CheckRuleJob.new(rule, event, payload)
    end
  end
  
end