class User < ActiveRecord::Base
  devise :rememberable, :trackable, :omniauthable,
    omniauth_providers: [:google_oauth2, :slack]

  has_many :yardigans

  validates :email, presence: true, uniqueness: true

  before_create do |u|
    u.api_key = User.generate_api_key
  end

  def self.create_from_google_auth auth
    user = where(email: auth.info.email).first_or_initialize
    user.update \
      google_auth: auth.to_h,
      api_key:     generate_api_key

    Yardigan.where(email: user.email).update_all user_id: user.id
    user
  end

  def self.generate_api_key
    loop do
      key = SecureRandom.uuid
      return key unless exists?(api_key: key)
    end
  end

  def reset_api_key!
    update api_key: self.class.generate_api_key
    AuthMailer.ios_login(self).deliver_later
  end

  def ios_login_link
    "irondirectory://login/#{api_key}"
  end
end
