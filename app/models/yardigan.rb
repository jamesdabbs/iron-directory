class Yardigan < ActiveRecord::Base
  belongs_to :slack_team
  belongs_to :user
  belongs_to :campus
  belongs_to :latest_course, class_name: "Course"

  validates_presence_of :slack_team, :slack_id, :slack_data, :email

  scope :active, -> { where "slack_data->>'deleted' = 'false' AND slack_data->>'is_restricted' = 'false' AND slack_data->>'is_ultra_restricted' = 'false'" }

  def profile
    slack_data.fetch "profile"
  end

  def first_name
    profile["first_name"]
  end

  def last_name
    profile["last_name"]
  end

  def name
    profile.fetch "real_name_normalized"
  end

  def title
    profile["title"]
  end

  def slack_username
    slack_data.fetch "name"
  end

  def skype_username
    profile["skype"]
  end

  def phone_number
    raw = profile["phone"]
    return "" unless raw
    raw = raw.gsub /\D/, ''
    if raw.length == 10
      "(#{raw[0..2]}) #{raw[3..5]}-#{raw[6..9]}"
    else
      profile["phone"]
    end
  end

  def deleted?
    slack_data["deleted"]
  end

  def avatars
    profile.select { |k,_| k.start_with? "image_" }
  end

  def remote_profile_path
    "https://#{slack_team.domain}.slack.com/account/profile"
  end
end
