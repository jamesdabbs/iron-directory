class TeamsController < ApplicationController
  def index
    @teams = SlackTeam.all
  end

  def show
    @team = SlackTeam.find params[:id]
    @members = @team.members.active.
      order("slack_data->'profile'->>'last_name'").
      includes(:campus)
  end

  def staff
    redirect_to team_path SlackTeam.staff
  end

  # Quick-and-dirty data entry. These should probably be
  #   replaced with a more usable view.
  def edit
    require_admin!
    @team = SlackTeam.find params[:id]
    @members = @team.members.active.
      order("slack_data->'profile'->>'last_name'").
      includes(:campus)
    @campuses = Campus.all
  end
  def update
    require_admin!
    team = SlackTeam.find params[:id]
    team.members.each do |member|
      updated = params[:campus][member.id.to_s]
      if updated.present? && member.campus_id.to_s != updated.to_s
        member.update campus_id: updated
      end
    end
    redirect_to :back, notice: "Updated"
  end

  def sync
    SyncSlack.new(token: Figaro.env.tiy_slack_token!).run!
    redirect_to :back, notice: "Slack data syncronized"
  end
end
