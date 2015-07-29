class AuthController < Devise::OmniauthCallbacksController
  skip_before_action :authenticate_user!, only: [:login]

  def login
  end

  def logout
    sign_out
    redirect_to new_user_session_path, notice: "Signed out"
  end

  def google_oauth2
    if auth.info.email.end_with? "@theironyard.com"
      user = User.create_from_google_auth auth
      sign_in user
      redirect_to root_path, notice: "Signed in from Google"
    else
      redirect_to new_user_session_path,
        flash: { error: "Please sign in with a `@ironyard.com` address." }
    end
  end

  def slack
    token = auth.credentials.token
    sync  = SyncSlack.new(token: token).run!

    membership = sync.team.members.where(user: current_user).first_or_initialize
    slack_auth.update! slack_auth: auth.to_h

    redirect_to profile_path, notice: "Authenticated with Slack"
  end

private

  def auth
    request.env["omniauth.auth"]
  end
end
