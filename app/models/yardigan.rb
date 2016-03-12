class Yardigan < ActiveRecord::Base
  belongs_to :slack_team
  belongs_to :user
  belongs_to :campus

  validates :email, presence: true, uniqueness: true
  validates :tiyo_id, presence: true, uniqueness: true

  has_many :yardigan_cohorts
  has_many :cohorts, through: :yardigan_cohorts

  scope :active, -> { where "slack_data->>'deleted' = 'false' AND slack_data->>'is_restricted' = 'false' AND slack_data->>'is_ultra_restricted' = 'false'" }

  def attach_cohort new_cohort
    return if cohorts.include? new_cohort
    cohorts << new_cohort

    if new_cohort.current?
      update! campus: new_cohort.campus
    end
  end

  def current_cohort
    now = Time.now
    cohorts.
      select { |c| c.start_on && c.end_on && now < c.end_on }.
      max_by { |c| c.start_on }
  end

  def name
    self[:name] || profile.fetch("real_name_normalized")
  end

  def profile
    slack_data.fetch "profile"
  end

  def first_name
    profile["first_name"]
  end

  def last_name
    profile["last_name"]
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
