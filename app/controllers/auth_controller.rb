class AuthController < Devise::OmniauthCallbacksController
  skip_before_action :authenticate_user!, only: [:login, :send_ios_login_email]
  skip_before_action :verify_authenticity_token, only: [:send_ios_login_email]

  def login
  end

  def logout
    sign_out
    redirect_to new_user_session_path, notice: "Signed out"
  end

  def send_ios_login_email
    user = User.find_by_email! "#{params[:email]}@theironyard.com"
    AuthMailer.ios_login(user).deliver_later
    head :ok
  end

  def login_on_ios
    redirect_to "irondirectory://login/#{params[:api_key]}"
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

  def failure
    redirect_to new_user_session_path, flash: { error: "OAuth signin failed - #{failure_message}" }
  end

private

  def auth
    request.env["omniauth.auth"]
  end
end
