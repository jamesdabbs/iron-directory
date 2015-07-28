class User < ActiveRecord::Base
  devise :rememberable, :trackable, :omniauthable,
    omniauth_providers: [:google_oauth2, :slack]

  has_many :yardigans

  validates :email, presence: true, uniqueness: true

  def self.create_from_google_auth auth
    user = where(email: auth.info.email).first_or_initialize
    user.update \
      google_auth: auth.to_h,
      api_key:     generate_api_key

    Yardigan.where(email: user.email).update_all user_id: user.id
    user
  end

  def self.generate_api_key
    begin
      key = SecureRandom.uuid
    end while exists?(api_key: key)
    key
  end
end
