class SyncSlack
  attr_reader :client

  def initialize token:
    @token  = token
    @client = Slack::Client.new token: @token
  end

  def run!
    # TODO: this is inefficient, but good enough for now
    members.each do |member|
      id    = member.fetch "id"
      email = member.fetch("profile").fetch "email"

      y = team.members.where(slack_id: id).first_or_initialize
      y.update! \
        user:       User.find_by_email(email),
        slack_data: member.to_h,
        email:      email
    end

    self
  end

  def team
    @_team ||= SlackTeam.for_token(@token)
  end

private

  def members
    return @_members if @_members

    response = client.users_list
    raise unless response["ok"]

    @_members = response["members"]
  end
end
