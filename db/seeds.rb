# Campuses and topics from fixtures
def fixtures name
  YAML.load_file Rails.root.join "test", "fixtures", "#{name}.yml"
end

fixtures(:campuses).each do |_, campus|
  Campus.
    where(name: campus["name"]).
    create_with(aliases: campus["aliases"]).
    first_or_create!
end
fixtures(:topics).each do |_, topic|
  Topic.
    where(title: topic["title"]).
    create_with(aliases: topic["aliases"]).
    first_or_create!
end

# TIY Team from Slack
SyncSlack.new(token: Figaro.env.tiy_slack_token!).run!
puts "Populated #{Yardigan.count} yardigans from Slack"
