desc "Called by the Heroku scheduler to sync the Slack team"
task :sync_slack => :environment do
  SyncSlack.new(token: Figaro.env.tiy_slack_token!).run!
end
