desc "This task is called by the Heroku scheduler add-on"
task :update_badges_and_scores => :environmentw do
  User.all.reject{|u| u.no_data? }.each do |user|
    payload = {:user_id => user.id}
    Delayed::Job.enqueue GamificationJob.new('timer', payload)
  end
end