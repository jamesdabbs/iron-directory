class SlackTeam < ActiveRecord::Base
  has_many :members, class_name: "Yardigan"

  validates_presence_of :slack_id, :slack_data, :name
  validates_uniqueness_of :name

  def self.by_name domain, team_name
    where("slack_data->>'domain'=?", domain).where(name: team_name).first
  end

  def self.staff
    by_name("theironyard", "The Iron Yard") || for_token(Figaro.env.tiy_slack_token!)
  end

  def self.for_token token
    response = Slack::Client.new(token: token).team_info
    raise unless response["ok"]

    team = where(slack_id: response["team"]["id"]).first_or_initialize
    team.update! \
      name:       response["team"]["name"],
      slack_data: response["team"]

    team
  end

  def domain
    slack_data.fetch "domain"
  end

  def image size
    slack_data.fetch("icon")["image_#{size}"]
  end
end
