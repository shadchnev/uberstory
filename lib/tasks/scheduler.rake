desc "This task is called by the Heroku scheduler add-on"
task :update_badges_and_scores => :production do
  User.all.each do |user|
    payload = {:user_id => user.id}
    DelayedJob::enqueue GamificationJob.new('timer', payload)
  end
end