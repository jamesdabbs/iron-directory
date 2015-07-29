class TeamsController < ApplicationController
  def index
    @teams = SlackTeam.all
  end

  def show
    @team = SlackTeam.find params[:id]
    @members = @team.members.active.
      order("slack_data->'profile'->>'last_name'").
      includes(:campus, latest_course: :topic)
  end

  def staff
    # ¯\_(ツ)_/¯
    params[:id] = SlackTeam.staff.id
    show
    render :show
  end

  # Quick-and-dirty data entry. These should probably be
  #   replaced with a more usable view.
  def edit
    require_admin!
    @team = SlackTeam.find params[:id]
    @members = @team.members.active.
      order("slack_data->'profile'->>'last_name'")
    @campuses = Campus.all
    @courses  = Course.all.includes :topic
  end
  def update
    require_admin!
    UpdateTeam.new(params[:id]).run! \
      campuses: params[:campus],
      courses:  params[:course]
    redirect_to :back, notice: "Updated"
  end

  def sync
    SyncSlack.new(token: Figaro.env.tiy_slack_token!).run!
    redirect_to :back, notice: "Slack data syncronized"
  end
end
