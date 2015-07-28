class User < ActiveRecord::Base
  devise :rememberable, :trackable, :omniauthable,
    omniauth_providers: [:google_oauth2, :slack]

  has_many :yardigans

  validates :email, presence: true, uniqueness: true

  def self.create_from_google_auth auth
    user = where(email: auth.info.email).first_or_initialize
    user.update google_auth: auth.to_h

    Yardigan.where(email: user.email).update_all user_id: user.id
    user
  end

  def can_sync? team
    membership = team.members.find_by_user_id id
    membership && membership.slack_token
  end
end
