class SyncSlack
  attr_reader :client

  def initialize token:
    @token  = token
    @client = Slack::Client.new token: @token
  end

  def run!
    # TODO: this is inefficient, but good enough for now
    members.each do |member|
      next if member["is_bot"]
      slack_id = member.fetch "id"
      email = member.fetch("profile").fetch "email"

      next unless email.present?

      y = Yardigan.where(email: email).first_or_initialize
      y.update! \
        user:       User.find_by_email(email),
        slack_id:   slack_id,
        slack_data: member.to_h
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
