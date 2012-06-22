class GamificationJob < Struct.new(:event, :payload)
  
  def perform
    Rule.filter(event, payload).each do |rule|
      DelayedJob::enqueue CheckRuleJob.new(rule, event, payload)
    end
  end
  
end