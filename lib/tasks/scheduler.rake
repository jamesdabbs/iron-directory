namespace :sync do
  def monitor
    begin
      yield
    rescue => e
      puts "Rake task error: #{e}"
      Slack::Mail.new.attach_error(e).deliver_later
      Rollbar.error e
      exit 1
    end
  end

  desc "Called by the Heroku scheduler to sync the Slack team"
  task :slack => :environment do
    monitor do
      SyncSlack.new(token: Figaro.env.tiy_slack_token!).run!
    end
  end

  desc "Pull staff, campus and cohort data from TIYO"
  task :tiyo => :environment do
    monitor do
      TiyoScraper.new(
        email:    Figaro.env.tiyo_email!,
        password: Figaro.env.tiyo_password!
      ).run!
    end
  end
end
