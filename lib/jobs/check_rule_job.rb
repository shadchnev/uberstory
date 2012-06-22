class CheckRuleJob < Struct.new(:klass, :event, :payload)
  
  def perform
    Rules.const_get(klass).evaluate(event, payload)
  end
  
end