class ProfilesController < ApplicationController
  def show
    @user     = current_user
    @yardigan = @user.yardigans.first
  end

  def reset_api_key
    current_user.reset_api_key!
    redirect_to :back, notice: "API Key Updated"
  end
end
