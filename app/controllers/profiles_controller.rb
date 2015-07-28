class ProfilesController < ApplicationController
  def show
    @user     = current_user
    @yardigan = @user.yardigans.first
  end
end
