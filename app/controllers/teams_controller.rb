class TeamsController < ApplicationController
  def index
    @teams = SlackTeam.all
  end

  def show
    @team = SlackTeam.find params[:id]
    @members = @team.members.active.
      order("slack_data->'profile'->>'last_name'")
  end

  def staff
    redirect_to team_path SlackTeam.staff
  end

  def sync
    SyncSlack.new(token: Figaro.env.tiy_slack_token!).run!
    redirect_to :back, notice: "Slack data syncronized"
  end
end
