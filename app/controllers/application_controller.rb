class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  rescue_from StandardError do |e|
    Slack::Mail.new(username: "Ironbot", channel: "@james").attach_error(e).deliver_later
    raise e
  end

private

  def require_admin!
    unless current_user.admin?
      redirect_to :back, notice: "You must be an admin to do that."
    end
  end
end
